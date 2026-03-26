import React, { useState, useEffect } from 'react';
import AdminLayout from '../../components/AdminLayout';
import { Table, Tag, Button, Space, Typography, Card, Input, Breadcrumb } from 'antd';
import { HomeOutlined, SearchOutlined, EyeOutlined, EditOutlined, PlusOutlined } from '@ant-design/icons';
import { fetchWarehouses } from '../../services/api';
import Link from 'next/link';

const { Title, Text } = Typography;

export default function WarehouseList() {
    const [warehouses, setWarehouses] = useState([]);
    const [loading, setLoading] = useState(true);
    const [searchText, setSearchText] = useState('');

    useEffect(() => {
        loadWarehouses();
    }, []);

    const loadWarehouses = async () => {
        setLoading(true);
        try {
            const res = await fetchWarehouses();
            setWarehouses(res || []);
        } catch (err) {
            console.error("Failed to load warehouses", err);
        } finally {
            setLoading(false);
        }
    };

    const columns = [
        {
            title: 'Code',
            dataIndex: 'warehouseCode',
            key: 'warehouseCode',
            render: code => <Tag color="blue">{code}</Tag>
        },
        {
            title: 'Name',
            dataIndex: 'warehouseName',
            key: 'warehouseName',
            render: (text, record) => (
                <Link href={`/warehouse/${record.warehouseId}`}>
                    <Text strong>{text}</Text>
                </Link>
            )
        },
        {
            title: 'Location',
            dataIndex: 'city',
            key: 'city',
            render: (city, record) => `${city}${record.district ? ', ' + record.district : ''}`
        },
        {
            title: 'Type',
            dataIndex: 'warehouseType',
            key: 'warehouseType',
            render: type => <Tag>{type || 'GENERAL'}</Tag>
        },
        {
            title: 'Capacity',
            dataIndex: 'capacity',
            key: 'capacity',
            render: cap => cap ? `${cap.toLocaleString()} units` : 'N/A'
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
        },
        {
            title: 'Action',
            key: 'action',
            render: (_, record) => (
                <Space size="middle">
                    <Link href={`/warehouse/${record.warehouseId}`}>
                        <Button icon={<EyeOutlined />} type="primary" size="small">Inventory</Button>
                    </Link>
                </Space>
            ),
        },
    ];

    const filteredData = warehouses.filter(w => 
        (w.warehouseName?.toLowerCase() || '').includes(searchText.toLowerCase()) || 
        (w.warehouseCode?.toLowerCase() || '').includes(searchText.toLowerCase())
    );

    return (
        <AdminLayout>
            <div style={{ padding: '24px' }}>
                <Breadcrumb 
                    items={[
                        { title: <Link href="/warehouse/dashboard">Dashboard</Link> },
                        { title: 'Warehouses' }
                    ]} 
                    style={{ marginBottom: '16px' }}
                />
                
                <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '24px' }}>
                    <Title level={2} style={{ margin: 0 }}>Warehouses Management</Title>
                </div>

                <Card>
                    <Input
                        placeholder="Search by name or code..."
                        prefix={<SearchOutlined />}
                        style={{ width: 300, marginBottom: '24px' }}
                        onChange={e => setSearchText(e.target.value)}
                    />
                    <Table 
                        columns={columns} 
                        dataSource={filteredData} 
                        loading={loading}
                        rowKey="warehouseId"
                    />
                </Card>
            </div>
        </AdminLayout>
    );
}
