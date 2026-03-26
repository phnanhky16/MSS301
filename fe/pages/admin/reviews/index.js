import React, { useState, useEffect, useCallback } from 'react';
import { 
    Table, Tag, Button, Space, Typography, Card, 
    Input, Breadcrumb, Statistic, Row, Col, 
    Rate, message, Modal, Tooltip, Select, 
    Empty, Avatar
} from 'antd';
import { 
    SearchOutlined, 
    ReloadOutlined, 
    MessageOutlined,
    EyeInvisibleOutlined,
    EyeOutlined,
    DeleteOutlined,
    StarFilled,
    WarningOutlined,
    CommentOutlined,
    UserOutlined
} from '@ant-design/icons';
import { 
    fetchAllReviews, 
    replyToReview, 
    toggleReviewVisibility, 
    deleteReview,
    fetchReviewStats 
} from '../../../services/api';
import Link from 'next/link';
import ReviewReplyModal from '../../../components/admin/ReviewReplyModal';

const { Title, Text, Paragraph } = Typography;
const { Option } = Select;

export default function AdminReviewsPage() {
    const [reviews, setReviews] = useState([]);
    const [stats, setStats] = useState(null);
    const [loading, setLoading] = useState(true);
    const [pagination, setPagination] = useState({ current: 1, pageSize: 10, total: 0 });
    const [filters, setFilters] = useState({ rating: null, isHidden: null, userId: '', productId: '' });
    
    // Modal states
    const [modalVisible, setModalVisible] = useState(false);
    const [modalMode, setModalMode] = useState('reply'); // 'reply' or 'moderate'
    const [selectedReview, setSelectedReview] = useState(null);

    const loadData = useCallback(async (page = 1) => {
        setLoading(true);
        try {
            const res = await fetchAllReviews(page - 1, pagination.pageSize, {
                rating: filters.rating,
                isHidden: filters.isHidden,
                userId: filters.userId || null,
                productId: filters.productId || null
            });
            
            // Note: fetchAllReviews returns a Page object from Spring
            setReviews(res.content || []);
            setPagination(prev => ({ 
                ...prev, 
                current: page,
                total: res.totalElements || 0 
            }));

            // Fetch stats separately
            const statsRes = await fetchReviewStats();
            setStats(statsRes);
        } catch (err) {
            console.error(err);
            message.error("Failed to load reviews");
        } finally {
            setLoading(false);
        }
    }, [filters, pagination.pageSize]);

    useEffect(() => {
        loadData();
    }, [loadData]);

    const handleAction = async (reviewId, values) => {
        try {
            if (modalMode === 'reply') {
                await replyToReview(reviewId, values.reply);
            } else {
                // Values contains 'reason', we need to check if we are hiding or showing
                // For simplicity, this modal call is used for hiding.
                await toggleReviewVisibility(reviewId, true, values.reason);
            }
            setModalVisible(false);
            loadData(pagination.current);
        } catch (err) {
            throw err; // Re-throw to be handled by modal's local catch
        }
    };

    const handleDelete = (id) => {
        Modal.confirm({
            title: 'Delete Review',
            content: 'Are you sure you want to permanently delete this review?',
            okText: 'Yes, Delete',
            okType: 'danger',
            cancelText: 'No',
            onOk: async () => {
                try {
                    await deleteReview(id);
                    message.success("Review deleted");
                    loadData(pagination.current);
                } catch (err) {
                    message.error("Delete failed");
                }
            }
        });
    };

    const handleToggleVisibility = async (review) => {
        if (!review.isHidden) {
            // If currently visible, open modal to get reason for hiding
            setSelectedReview(review);
            setModalMode('moderate');
            setModalVisible(true);
        } else {
            // If currently hidden, just show it
            try {
                await toggleReviewVisibility(review.id, false);
                message.success("Review is now visible");
                loadData(pagination.current);
            } catch (err) {
                message.error("Action failed");
            }
        }
    };

    const columns = [
        {
            title: 'User',
            dataIndex: 'user',
            key: 'user',
            render: (user, record) => (
                <Space>
                    <Avatar icon={<UserOutlined />} src={user?.avatarUrl} />
                    <div>
                        <Text strong>{user?.fullName || `ID: ${record.userId}`}</Text>
                        <br />
                        <Text type="secondary" style={{ fontSize: '12px' }}>{user?.email}</Text>
                    </div>
                </Space>
            )
        },
        {
            title: 'Product',
            dataIndex: 'product',
            key: 'product',
            render: (product, record) => (
                <div style={{ maxWidth: 200 }}>
                    <Link href={`/product/${record.productId}`} target="_blank">
                        <Text strong style={{ color: '#1890ff', cursor: 'pointer' }}>
                            {product?.productName || `ID: ${record.productId}`}
                        </Text>
                    </Link>
                    <br />
                    <Rate disabled defaultValue={record.rating} style={{ fontSize: 12 }} />
                </div>
            )
        },
        {
            title: 'Comment',
            dataIndex: 'comment',
            key: 'comment',
            render: (text, record) => (
                <div>
                    <Paragraph ellipsis={{ rows: 2, expandable: true }}>{text}</Paragraph>
                    {record.adminReply && (
                        <div style={{ marginTop: 8, padding: '4px 8px', borderLeft: '2px solid #1890ff', background: '#e6f7ff' }}>
                            <Text type="secondary" style={{ fontSize: '11px' }}>Admin Response:</Text>
                            <Paragraph style={{ margin: 0, fontSize: '12px' }}>{record.adminReply}</Paragraph>
                        </div>
                    )}
                    {record.isHidden && (
                        <Tag color="error" icon={<WarningOutlined />} style={{ marginTop: 8 }}>
                            Hidden: {record.hiddenReason}
                        </Tag>
                    )}
                </div>
            )
        },
        {
            title: 'Created At',
            dataIndex: 'createdAt',
            key: 'createdAt',
            render: date => new Date(date).toLocaleDateString()
        },
        {
            title: 'Status',
            key: 'status',
            render: (_, record) => (
                <Tag color={record.isHidden ? 'error' : 'success'}>
                    {record.isHidden ? 'Hidden' : 'Visible'}
                </Tag>
            )
        },
        {
            title: 'Action',
            key: 'action',
            render: (_, record) => (
                <Space>
                    <Tooltip title="Reply">
                        <Button 
                            icon={<CommentOutlined />} 
                            onClick={() => {
                                setSelectedReview(record);
                                setModalMode('reply');
                                setModalVisible(true);
                            }} 
                        />
                    </Tooltip>
                    <Tooltip title={record.isHidden ? "Make Visible" : "Hide"}>
                        <Button 
                            icon={record.isHidden ? <EyeOutlined /> : <EyeInvisibleOutlined />} 
                            onClick={() => handleToggleVisibility(record)}
                        />
                    </Tooltip>
                    <Tooltip title="Delete">
                        <Button 
                            danger 
                            icon={<DeleteOutlined />} 
                            onClick={() => handleDelete(record.id)}
                        />
                    </Tooltip>
                </Space>
            )
        }
    ];

    return (
            <div style={{ padding: '24px' }}>
                <Breadcrumb 
                    items={[
                        { title: <Link href="/admin/dashboard">Admin</Link> },
                        { title: 'Review Management' }
                    ]} 
                    style={{ marginBottom: '16px' }}
                />

                <Row gutter={[16, 16]} align="middle" style={{ marginBottom: '24px' }}>
                    <Col flex="auto">
                        <Title level={2} style={{ margin: 0 }}>Review & Feedback</Title>
                    </Col>
                    <Col>
                        <Button 
                            icon={<ReloadOutlined />} 
                            onClick={() => loadData(pagination.current)}
                            loading={loading}
                        >
                            Refresh
                        </Button>
                    </Col>
                </Row>

                <Row gutter={[16, 16]} style={{ marginBottom: '24px' }}>
                    <Col xs={24} sm={8}>
                        <Card size="small">
                            <Statistic 
                                title="Total Reviews" 
                                value={stats?.totalReviews || 0} 
                                prefix={<MessageOutlined />}
                            />
                        </Card>
                    </Col>
                    <Col xs={24} sm={8}>
                        <Card size="small">
                            <Statistic 
                                title="Hidden Reviews" 
                                value={stats?.hiddenReviews || 0} 
                                valueStyle={{ color: '#cf1322' }}
                                prefix={<EyeInvisibleOutlined />}
                            />
                        </Card>
                    </Col>
                    <Col xs={24} sm={8}>
                        <Card size="small">
                            <Statistic 
                                title="Overall Balance" 
                                value={4.8} 
                                precision={1}
                                prefix={<StarFilled style={{ color: '#fadb14' }} />}
                                suffix="/ 5"
                            />
                        </Card>
                    </Col>
                </Row>

                <Card>
                    <Row gutter={[16, 16]} style={{ marginBottom: 16 }}>
                        <Col xs={24} sm={12} md={4}>
                            <Select 
                                style={{ width: '100%' }} 
                                placeholder="Rating"
                                allowClear
                                onChange={v => setFilters(f => ({ ...f, rating: v }))}
                            >
                                <Option value={5}>5 Stars</Option>
                                <Option value={4}>4 Stars</Option>
                                <Option value={3}>3 Stars</Option>
                                <Option value={2}>2 Stars</Option>
                                <Option value={1}>1 Star</Option>
                            </Select>
                        </Col>
                        <Col xs={24} sm={12} md={4}>
                            <Select 
                                style={{ width: '100%' }} 
                                placeholder="Visibility"
                                allowClear
                                onChange={v => setFilters(f => ({ ...f, isHidden: v }))}
                            >
                                <Option value={false}>Visible</Option>
                                <Option value={true}>Hidden</Option>
                            </Select>
                        </Col>
                        <Col xs={24} sm={12} md={4}>
                            <Input 
                                placeholder="User ID" 
                                value={filters.userId}
                                onChange={e => setFilters(f => ({ ...f, userId: e.target.value }))}
                                onPressEnter={() => loadData(1)}
                            />
                        </Col>
                        <Col xs={24} sm={12} md={4}>
                            <Input 
                                placeholder="Product ID" 
                                value={filters.productId}
                                onChange={e => setFilters(f => ({ ...f, productId: e.target.value }))}
                                onPressEnter={() => loadData(1)}
                            />
                        </Col>
                        <Col xs={24} sm={24} md={8}>
                            <Button 
                                type="primary" 
                                ghost 
                                icon={<SearchOutlined />} 
                                onClick={() => loadData(1)}
                                style={{ width: '100%' }}
                            >
                                Search
                            </Button>
                        </Col>
                    </Row>

                    <Table 
                        columns={columns} 
                        dataSource={reviews} 
                        loading={loading}
                        rowKey="id"
                        pagination={{
                            ...pagination,
                            onChange: (page) => loadData(page)
                        }}
                    />
                </Card>

                <ReviewReplyModal 
                    open={modalVisible}
                    onCancel={() => setModalVisible(false)}
                    review={selectedReview}
                    mode={modalMode}
                    onSuccess={handleAction}
                />
            </div>
    );
}
