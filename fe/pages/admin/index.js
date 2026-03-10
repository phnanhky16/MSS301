import React, { useState, useEffect } from 'react';
import { Row, Col, Card, Typography, message as antdMessage, Button, Skeleton } from 'antd';
import {
  UserOutlined,
  ShoppingCartOutlined,
  DollarOutlined,
  TagOutlined,
  AppstoreOutlined,
  ArrowUpOutlined,
  ArrowDownOutlined,
  ThunderboltOutlined,
  RiseOutlined,
} from '@ant-design/icons';
import { fetchUserCount, fetchOrderStats } from '../../services/api';
import { useRouter } from 'next/router';

const { Title, Text, Paragraph } = Typography;

export default function AdminDashboard() {
  const router = useRouter();
  const [users, setUsers] = useState(0);
  const [orders, setOrders] = useState({ totalOrders: 0, totalRevenue: 0, byStatus: {} });
  const [loading, setLoading] = useState(true);
  const [greeting, setGreeting] = useState('Hello');
  const [adminName, setAdminName] = useState('Admin');
  const [msgApi, msgHolder] = antdMessage.useMessage();

  useEffect(() => {
    // Compute greeting client-side only to avoid hydration mismatch
    const hour = new Date().getHours();
    setGreeting(hour < 12 ? 'Good Morning' : hour < 18 ? 'Good Afternoon' : 'Good Evening');

    try {
      const info = JSON.parse(localStorage.getItem('userInfo'));
      setAdminName(info?.name || info?.fullName || 'Admin');
    } catch (_) { }

    Promise.all([
      fetchUserCount()
        .then(count => setUsers(count))
        .catch(() => { msgApi.error('Failed to load user count'); setUsers(0); }),
      fetchOrderStats()
        .then(data => setOrders(data))
        .catch(() => { msgApi.error('Failed to load order stats'); setOrders({ totalOrders:0, totalRevenue:0, byStatus:{}}); }),
    ]).finally(() => setLoading(false));
  }, []);

  // Status color/icon mapping
  const statusConfig = {
    PENDING: { color: '#e17055', bg: 'rgba(253, 203, 110, 0.12)', icon: '⏳' },
    CONFIRMED: { color: '#6c5ce7', bg: 'rgba(108, 92, 231, 0.08)', icon: '✅' },
    PROCESSING: { color: '#0984e3', bg: 'rgba(116, 185, 255, 0.1)', icon: '⚙️' },
    SHIPPED: { color: '#00b894', bg: 'rgba(0, 206, 201, 0.1)', icon: '🚚' },
    DELIVERED: { color: '#00b894', bg: 'rgba(0, 184, 148, 0.12)', icon: '📦' },
    CANCELLED: { color: '#ff7675', bg: 'rgba(255, 118, 117, 0.1)', icon: '❌' },
  };

  return (
    <div>
      {msgHolder}
      {/* ── Dashboard Header ── */}
      <div className="admin-dash-header">
        <Title className="admin-dash-title" level={2}>
          {greeting}, {adminName}! 👋
        </Title>
        <Paragraph className="admin-dash-subtitle">
          Here's what's happening with your store today.
        </Paragraph>
      </div>

      {/* ── Main Stat Cards ── */}
      <Row gutter={[20, 20]} className="admin-stat-row">
        {/* Users */}
        <Col xs={24} sm={12} lg={6}>
          <Card className="admin-stat-card accent" variant="borderless">
            {loading ? <Skeleton active paragraph={{ rows: 1 }} /> : (
              <div style={{ display: 'flex', alignItems: 'flex-start', gap: 16 }}>
                <div className="admin-stat-icon accent">
                  <UserOutlined />
                </div>
                <div className="admin-stat-info">
                  <div className="admin-stat-label">Total Users</div>
                  <div className="admin-stat-value">{users.toLocaleString()}</div>
                  <div className="admin-stat-change up">
                    <ArrowUpOutlined /> Active
                  </div>
                </div>
              </div>
            )}
          </Card>
        </Col>

        {/* Orders */}
        <Col xs={24} sm={12} lg={6}>
          <Card className="admin-stat-card success" variant="borderless">
            {loading ? <Skeleton active paragraph={{ rows: 1 }} /> : (
              <div style={{ display: 'flex', alignItems: 'flex-start', gap: 16 }}>
                <div className="admin-stat-icon success">
                  <ShoppingCartOutlined />
                </div>
                <div className="admin-stat-info">
                  <div className="admin-stat-label">Total Orders</div>
                  <div className="admin-stat-value">{orders.totalOrders.toLocaleString()}</div>
                  <div className="admin-stat-change up">
                    <RiseOutlined /> Growing
                  </div>
                </div>
              </div>
            )}
          </Card>
        </Col>

        {/* Revenue */}
        <Col xs={24} sm={12} lg={6}>
          <Card className="admin-stat-card warning" variant="borderless">
            {loading ? <Skeleton active paragraph={{ rows: 1 }} /> : (
              <div style={{ display: 'flex', alignItems: 'flex-start', gap: 16 }}>
                <div className="admin-stat-icon warning">
                  <DollarOutlined />
                </div>
                <div className="admin-stat-info">
                  <div className="admin-stat-label">Total Revenue</div>
                  <div className="admin-stat-value">
                    ${orders.totalRevenue.toLocaleString('en-US', { minimumFractionDigits: 0, maximumFractionDigits: 0 })}
                  </div>
                  <div className="admin-stat-change up">
                    <ArrowUpOutlined /> Revenue
                  </div>
                </div>
              </div>
            )}
          </Card>
        </Col>

        {/* Status Overview */}
        <Col xs={24} sm={12} lg={6}>
          <Card className="admin-stat-card info" variant="borderless">
            {loading ? <Skeleton active paragraph={{ rows: 1 }} /> : (
              <div style={{ display: 'flex', alignItems: 'flex-start', gap: 16 }}>
                <div className="admin-stat-icon info">
                  <ThunderboltOutlined />
                </div>
                <div className="admin-stat-info">
                  <div className="admin-stat-label">Pending</div>
                  <div className="admin-stat-value">
                    {orders.byStatus?.PENDING || 0}
                  </div>
                  <div className="admin-stat-change down">
                    ⏳ Needs attention
                  </div>
                </div>
              </div>
            )}
          </Card>
        </Col>
      </Row>

      {/* ── Order Status Breakdown ── */}
      {orders.byStatus && Object.keys(orders.byStatus).length > 0 && (
        <Row gutter={[16, 16]} className="admin-status-row">
          {Object.entries(orders.byStatus).map(([status, cnt], idx) => {
            const config = statusConfig[status] || { color: '#636e72', bg: 'rgba(0,0,0,0.04)', icon: '📋' };
            return (
              <Col key={status} xs={12} sm={8} md={6} lg={4}>
                <Card
                  className="admin-status-card"
                  variant="borderless"
                  style={{ animationDelay: `${idx * 0.06}s` }}
                >
                  <div style={{ fontSize: 28, marginBottom: 8 }}>{config.icon}</div>
                  <div className={`admin-status-badge ${status}`}>{status}</div>
                  <div className="admin-status-count" style={{ color: config.color }}>{cnt}</div>
                </Card>
              </Col>
            );
          })}
        </Row>
      )}

      {/* ── Welcome / Quick Actions ── */}
      <Row gutter={[20, 20]}>
        <Col xs={24} lg={16}>
          <Card className="admin-welcome-card" variant="borderless">
            <div className="admin-welcome-title">
              🚀 Quick Actions
            </div>
            <div className="admin-welcome-desc">
              Jump right into managing your store. Use these shortcuts to access the most common tasks.
            </div>
            <div className="admin-quick-actions">
              <Button
                className="admin-quick-btn"
                icon={<ShoppingCartOutlined />}
                onClick={() => router.push('/admin/orders')}
              >
                View Orders
              </Button>
              <Button
                className="admin-quick-btn"
                icon={<AppstoreOutlined />}
                onClick={() => router.push('/admin/products')}
              >
                Manage Products
              </Button>
              <Button
                className="admin-quick-btn"
                icon={<AppstoreOutlined />}
                onClick={() => router.push('/admin/stores')}
              >
                Manage Stores
              </Button>
              <Button
                className="admin-quick-btn"
                icon={<AppstoreOutlined />}
                onClick={() => router.push('/admin/inventory')}
              >
                Store Inventory
              </Button>
              <Button
                className="admin-quick-btn"
                icon={<AppstoreOutlined />}
                onClick={() => router.push('/admin/warehouse-inventory')}
              >
                Warehouse Inventory
              </Button>
              <Button
                className="admin-quick-btn"
                icon={<TagOutlined />}
                onClick={() => router.push('/admin/coupons')}
              >
                Create Coupon
              </Button>
              <Button
                className="admin-quick-btn"
                icon={<UserOutlined />}
                onClick={() => router.push('/admin/users')}
              >
                Manage Users
              </Button>
            </div>
          </Card>
        </Col>

        <Col xs={24} lg={8}>
          <Card
            bordered={false}
            style={{
              borderRadius: 16,
              background: 'linear-gradient(135deg, #0e3d4a, #0a2e38)',
              color: '#fff',
              height: '100%',
              position: 'relative',
              overflow: 'hidden',
            }}
          >
            <div style={{ position: 'relative', zIndex: 1 }}>
              <div style={{ fontSize: 40, marginBottom: 12 }}>📊</div>
              <div style={{ fontSize: 18, fontWeight: 700, marginBottom: 8 }}>Store Performance</div>
              <div style={{ fontSize: 14, color: 'rgba(255,255,255,0.7)', lineHeight: 1.6 }}>
                Your store is running smoothly.
                <br />
                <span style={{ color: '#1ca8c8', fontWeight: 600 }}>
                  {orders.totalOrders} orders
                </span>{' '}
                processed so far.
              </div>
              <div style={{
                marginTop: 16,
                padding: '10px 16px',
                background: 'rgba(255,255,255,0.08)',
                borderRadius: 12,
                display: 'inline-flex',
                alignItems: 'center',
                gap: 8,
                fontSize: 13,
                color: 'rgba(255,255,255,0.9)'
              }}>
                <span style={{ color: '#4dd9e8' }}>●</span> All systems operational
              </div>
            </div>
            {/* Decorative circle */}
            <div style={{
              position: 'absolute',
              top: -40, right: -40,
              width: 160, height: 160,
              borderRadius: '50%',
              background: 'radial-gradient(circle, rgba(28, 168, 200, 0.25) 0%, transparent 70%)',
            }} />
          </Card>
        </Col>
      </Row>
    </div>
  );
}