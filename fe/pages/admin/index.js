import { Typography, Row, Col, Statistic, Card, message } from 'antd';
import { useState, useEffect } from 'react';
import { fetchUserCount, fetchOrderStats } from '../../services/api';

const { Title, Paragraph } = Typography;

export default function AdminDashboard() {
  const [users, setUsers] = useState(0);
  const [orders, setOrders] = useState({ totalOrders: 0, totalRevenue: 0, byStatus: {} });

  useEffect(() => {
    fetchUserCount()
      .then(count => setUsers(count))
      .catch(() => message.error('Failed to load user count'));
    fetchOrderStats()
      .then(data => setOrders(data))
      .catch(() => message.error('Failed to load order stats'));
  }, []);
  return (
    <div>
      <Title level={2}>Admin Dashboard</Title>
      <Row gutter={16} style={{ marginBottom: 16 }}>
        <Col span={8}>
          <Card>
            <Statistic title="Total Users" value={users} />
          </Card>
        </Col>
        <Col span={8}>
          <Card>
            <Statistic title="Total Orders" value={orders.totalOrders} />
          </Card>
        </Col>
        <Col span={8}>
          <Card>
            <Statistic title="Total Revenue" value={orders.totalRevenue} precision={2} prefix="$" />
          </Card>
        </Col>
      </Row>
      <Row gutter={16}>
        {orders.byStatus && Object.entries(orders.byStatus).map(([status, cnt]) => (
          <Col key={status} span={6} style={{ marginBottom: 8 }}>
            <Card>
              <Statistic title={`Orders ${status}`} value={cnt} />
            </Card>
          </Col>
        ))}
      </Row>
      <Paragraph>Use the sidebar to navigate the admin sections.</Paragraph>
    </div>
  );
}