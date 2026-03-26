import React, { useState, useEffect } from 'react';
import { useRouter } from 'next/router';
import AdminLayout from '../../components/AdminLayout';
import { 
    Table, Tag, Button, Space, Typography, Card, 
    Input, Breadcrumb, Statistic, Row, Col, 
    InputNumber, message, Modal, Tooltip
} from 'antd';
import { 
    ArrowLeftOutlined, 
    SearchOutlined, 
    ReloadOutlined, 
    SwapOutlined,
    SaveOutlined,
    WarningOutlined,
    AppstoreOutlined
} from '@ant-design/icons';
import { 
    fetchWarehouseById, 
    fetchWarehouseProducts, 
    updateWarehouseProductStock 
} from '../../services/api';
import Link from 'next/link';
import TransferModal from '../../components/warehouse/TransferModal';

const { Title, Text } = Typography;

export default function WarehouseDetail() {
    const router = useRouter();
    const { id } = router.query;
    
    const [warehouse, setWarehouse] = useState(null);
    const [products, setProducts] = useState([]);
    const [loading, setLoading] = useState(true);
    const [searchText, setSearchText] = useState('');
    const [editingProduct, setEditingProduct] = useState(null);
    const [newQuantity, setNewQuantity] = useState(0);
    const [transferModalVisible, setTransferModalVisible] = useState(false);
    const [selectedProduct, setSelectedProduct] = useState(null);

    useEffect(() => {
        if (id) {
            loadData();
        }
    }, [id]);

    const loadData = async () => {
        setLoading(true);
        try {
            const [wRes, pRes] = await Promise.all([
                fetchWarehouseById(id),
                fetchWarehouseProducts(id)
            ]);
            setWarehouse(wRes);
            setProducts(pRes || []);
        } catch (err) {
            message.error("Failed to load warehouse data");
        } finally {
            setLoading(false);
        }
    };

    const handleUpdateStock = async (record) => {
        try {
            await updateWarehouseProductStock(id, record.productId, { 
                productId: record.productId,
                quantity: newQuantity 
            });
            message.success("Stock updated successfully");
            setEditingProduct(null);
            loadData();
        } catch (err) {
            message.error("Failed to update stock");
        }
    };

    const columns = [
        {
            title: 'Product ID',
            dataIndex: 'productId',
            key: 'productId',
        },
        {
            title: 'Product Name',
            dataIndex: 'productName',
            key: 'productName',
            render: (text) => <Text strong>{text}</Text>
        },
        {
            title: 'Location',
            dataIndex: 'locationCode',
            key: 'locationCode',
            render: loc => loc ? <Tag color="gray">{loc}</Tag> : '-'
        },
        {
            title: 'Quantity',
            dataIndex: 'quantity',
            key: 'quantity',
            render: (qty, record) => {
                const isEditing = editingProduct === record.productId;
                const isLow = qty < record.minStockLevel;
                
                if (isEditing) {
                    return (
                        <Space>
                            <InputNumber 
                                min={0} 
                                value={newQuantity} 
                                onChange={setNewQuantity}
                                style={{ width: 80 }}
                            />
                            <Button 
                                type="primary" 
                                size="small" 
                                icon={<SaveOutlined />}
                                onClick={() => handleUpdateStock(record)}
                            />
                            <Button 
                                size="small" 
                                onClick={() => setEditingProduct(null)}
                            >
                                Cancel
                            </Button>
                        </Space>
                    );
                }
                
                return (
                    <Space>
                        <Text style={{ color: isLow ? '#cf1322' : 'inherit' }}>
                            {qty.toLocaleString()}
                        </Text>
                        {isLow && (
                            <Tooltip title="Stock level below minimum">
                                <WarningOutlined style={{ color: '#cf1322' }} />
                            </Tooltip>
                        )}
                        <Button 
                            type="link" 
                            size="small" 
                            onClick={() => {
                                setEditingProduct(record.productId);
                                setNewQuantity(qty);
                            }}
                        >
                            Update
                        </Button>
                    </Space>
                );
            }
        },
        {
            title: 'Min/Max',
            key: 'levels',
            render: (_, record) => (
                <Text type="secondary" style={{ fontSize: '12px' }}>
                    {record.minStockLevel || 0} / {record.maxStockLevel || '∞'}
                </Text>
            )
        },
        {
            title: 'Action',
            key: 'action',
            render: (_, record) => (
                <Space size="middle">
                    <Button 
                        icon={<SwapOutlined />} 
                        onClick={() => {
                            setSelectedProduct(record);
                            setTransferModalVisible(true);
                        }}
                    >
                        Transfer
                    </Button>
                </Space>
            ),
        },
    ];

    const filteredData = products.filter(p => 
        (p.productName?.toLowerCase() || '').includes(searchText.toLowerCase()) || 
        (p.productId?.toString() || '').includes(searchText)
    );

    return (
        <AdminLayout>
            <div style={{ padding: '24px' }}>
                <Breadcrumb 
                    items={[
                        { title: <Link href="/warehouse/dashboard">Dashboard</Link> },
                        { title: <Link href="/warehouse/list">Warehouses</Link> },
                        { title: warehouse?.warehouseName || 'Details' }
                    ]} 
                    style={{ marginBottom: '16px' }}
                />

                <Row gutter={[16, 16]} align="middle" style={{ marginBottom: '24px' }}>
                    <Col flex="auto">
                        <Space align="center">
                            <Link href="/warehouse/list">
                                <Button icon={<ArrowLeftOutlined />} shape="circle" />
                            </Link>
                            <Title level={2} style={{ margin: 0 }}>
                                {warehouse?.warehouseName}
                                <Tag color="blue" style={{ marginLeft: '12px' }}>{warehouse?.warehouseCode}</Tag>
                            </Title>
                        </Space>
                    </Col>
                    <Col>
                        <Button 
                            icon={<ReloadOutlined />} 
                            onClick={loadData}
                            loading={loading}
                        >
                            Refresh
                        </Button>
                    </Col>
                </Row>

                <Row gutter={[16, 16]} style={{ marginBottom: '24px' }}>
                    <Col xs={24} sm={12} lg={6}>
                        <Card size="small">
                            <Statistic 
                                title="Total Products" 
                                value={products.length} 
                                prefix={<AppstoreOutlined />}
                            />
                        </Card>
                    </Col>
                    <Col xs={24} sm={12} lg={6}>
                        <Card size="small">
                            <Statistic 
                                title="Low Stock Items" 
                                value={products.filter(p => p.quantity < p.minStockLevel).length} 
                                valueStyle={{ color: '#cf1322' }}
                                prefix={<WarningOutlined />}
                            />
                        </Card>
                    </Col>
                </Row>

                <Card>
                    <div style={{ display: 'flex', justifyContent: 'space-between', marginBottom: '16px' }}>
                        <Input
                            placeholder="Search by product name or ID..."
                            prefix={<SearchOutlined />}
                            style={{ width: 350 }}
                            onChange={e => setSearchText(e.target.value)}
                        />
                    </div>
                    
                    <Table 
                        columns={columns} 
                        dataSource={filteredData} 
                        loading={loading}
                        rowKey="productId"
                        pagination={{ pageSize: 15 }}
                    />
                </Card>

                <TransferModal 
                    open={transferModalVisible}
                    onCancel={() => setTransferModalVisible(false)}
                    onSuccess={loadData}
                    product={selectedProduct}
                    fromWarehouseId={parseInt(id)}
                />
            </div>
        </AdminLayout>
    );
}
