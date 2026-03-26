import React, { useState, useEffect } from 'react';
import AdminLayout from '../../components/AdminLayout';
import { Card, Row, Col, Statistic, Table, Tag, Typography, Spin, Empty } from 'antd';
import { 
    HomeOutlined, 
    AppstoreOutlined, 
    AlertOutlined, 
    CheckCircleOutlined,
    LineChartOutlined
} from '@ant-design/icons';
import { fetchWarehouseStats, fetchWarehouses } from '../../services/api';
import Link from 'next/link';

const { Title, Text } = Typography;

export default function WarehouseDashboard() {
    const [stats, setStats] = useState(null);
    const [warehouses, setWarehouses] = useState([]);
    const [loading, setLoading] = useState(true);

    useEffect(() => {
        const loadData = async () => {
            setLoading(true);
            try {
                const [statsRes, warehousesRes] = await Promise.all([
                    fetchWarehouseStats(),
                    fetchWarehouses()
                ]);
                setStats(statsRes);
                setWarehouses(warehousesRes || []);
            } catch (err) {
                console.error("Failed to load dashboard data", err);
            } finally {
                setLoading(false);
            }
        };
        loadData();
    }, []);

    const columns = [
        {
            title: 'Warehouse Name',
            dataIndex: 'warehouseName',
            key: 'warehouseName',
            render: (text, record) => (
                <Link href={`/warehouse/${record.warehouseId}`}>
                    <Text strong>{text}</Text>
                </Link>
            )
        },
        {
            title: 'Code',
            dataIndex: 'warehouseCode',
            key: 'warehouseCode',
            render: code => <Tag color="blue">{code}</Tag>
        },
        {
            title: 'Location',
            dataIndex: 'city',
            key: 'city',
        },
        {
            title: 'Status',
            dataIndex: 'isActive',
            key: 'isActive',
            render: active => (
                <Tag color={active ? 'green' : 'red'}>
                    {active ? 'ACTIVE' : 'INACTIVE'}
                </Tag>
            )
        }
    ];

    if (loading) return <AdminLayout><div style={{ textAlign: 'center', padding: '100px' }}><Spin size="large" /></div></AdminLayout>;

    return (
        <AdminLayout>
            <div style={{ padding: '24px' }}>
                <Title level={2}>Warehouse Dashboard</Title>
                <Text type="secondary">Overview of all warehouse facilities and inventory levels.</Text>

                <Row gutter={[16, 16]} style={{ marginTop: '24px' }}>
                    <Col xs={24} sm={12} lg={6}>
                        <Card bordered={false} className="stat-card">
                            <Statistic
                                title="Total Warehouses"
                                value={stats?.totalWarehouses || 0}
                                prefix={<HomeOutlined style={{ color: '#1ca8c8' }} />}
                            />
                        </Card>
                    </Col>
                    <Col xs={24} sm={12} lg={6}>
                        <Card bordered={false} className="stat-card">
                            <Statistic
                                title="Active Warehouses"
                                value={stats?.activeWarehouses || 0}
                                prefix={<CheckCircleOutlined style={{ color: '#52c41a' }} />}
                            />
                        </Card>
                    </Col>
                    <Col xs={24} sm={12} lg={6}>
                        <Card bordered={false} className="stat-card">
                            <Statistic
                                title="Total Products"
                                value={stats?.totalProducts || 0}
                                prefix={<AppstoreOutlined style={{ color: '#fab400' }} />}
                            />
                        </Card>
                    </Col>
                    <Col xs={24} sm={12} lg={6}>
                        <Card bordered={false} className="stat-card">
                            <Statistic
                                title="Low Stock Items"
                                value={stats?.lowStockItemsCount || 0}
                                valueStyle={{ color: stats?.lowStockItemsCount > 0 ? '#cf1322' : '#3f8600' }}
                                prefix={<AlertOutlined />}
                            />
                        </Card>
                    </Col>
                </Row>

                <Row gutter={[16, 16]} style={{ marginTop: '24px' }}>
                    <Col span={24}>
                        <Card title={<span><HomeOutlined /> Warehouse Facilities</span>}>
                            <Table 
                                dataSource={warehouses} 
                                columns={columns} 
                                rowKey="warehouseId"
                                pagination={{ pageSize: 5 }}
                            />
                        </Card>
                    </Col>
                </Row>
            </div>
            <style jsx global>{`
                .stat-card {
                    box-shadow: 0 4px 12px rgba(0,0,0,0.05);
                    border-radius: 12px;
                }
            `}</style>
        </AdminLayout>
    );
}
