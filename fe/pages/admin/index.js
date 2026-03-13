import React, { useState, useEffect } from 'react';
import { Row, Col, Card, Typography, message as antdMessage, Skeleton } from 'antd';
import {
  DollarOutlined,
  ShoppingCartOutlined,
  UserOutlined,
} from '@ant-design/icons';
import { fetchUserCount, fetchOrderStats } from '../../services/api';

const { Title } = Typography;

/* ── Decorative SVG Revenue Chart (shape only, no data labels) ── */
function RevenueChart() {
  return (
    <svg viewBox="0 0 700 200" style={{ width: '100%', height: 180 }} preserveAspectRatio="none">
      <defs>
        <linearGradient id="revGrad" x1="0" y1="0" x2="0" y2="1">
          <stop offset="0%" stopColor="#17a2b8" stopOpacity="0.35" />
          <stop offset="100%" stopColor="#17a2b8" stopOpacity="0.02" />
        </linearGradient>
        <linearGradient id="ordGrad" x1="0" y1="0" x2="0" y2="1">
          <stop offset="0%" stopColor="#b2d8e0" stopOpacity="0.25" />
          <stop offset="100%" stopColor="#b2d8e0" stopOpacity="0.01" />
        </linearGradient>
      </defs>
      <path
        d="M 0,105 C 50,105 50,62 100,62 C 150,62 150,118 200,118 C 250,118 250,145 300,145 C 350,145 350,162 400,162 C 450,162 450,135 500,135 C 550,135 550,80 600,80 C 650,80 650,72 700,72 L 700,200 L 0,200 Z"
        fill="url(#revGrad)"
      />
      <path
        d="M 0,105 C 50,105 50,62 100,62 C 150,62 150,118 200,118 C 250,118 250,145 300,145 C 350,145 350,162 400,162 C 450,162 450,135 500,135 C 550,135 550,80 600,80 C 650,80 650,72 700,72"
        fill="none" stroke="#17a2b8" strokeWidth="2.5"
      />
      <path
        d="M 0,142 C 50,142 50,120 100,120 C 150,120 150,150 200,150 C 250,150 250,162 300,162 C 350,162 350,170 400,170 C 450,170 450,158 500,158 C 550,158 550,135 600,135 C 650,135 650,128 700,128 L 700,200 L 0,200 Z"
        fill="url(#ordGrad)"
      />
      <path
        d="M 0,142 C 50,142 50,120 100,120 C 150,120 150,150 200,150 C 250,150 250,162 300,162 C 350,162 350,170 400,170 C 450,170 450,158 500,158 C 550,158 550,135 600,135 C 650,135 650,128 700,128"
        fill="none" stroke="#b2d8e0" strokeWidth="2" strokeDasharray="6,4"
      />
    </svg>
  );
}

/* ── Gauge using real revenue vs target ── */
function GaugeChart({ percent }) {
  const r = 78, cx = 120, cy = 100;
  const arcLen = Math.PI * r;
  const filled = (percent / 100) * arcLen;
  return (
    <svg viewBox="0 0 240 112" style={{ width: '100%', maxWidth: 240, display: 'block', margin: '0 auto' }}>
      <path d={`M ${cx - r},${cy} A ${r},${r} 0 0,1 ${cx + r},${cy}`}
        fill="none" stroke="#e4f3f7" strokeWidth="16" strokeLinecap="round" />
      <path d={`M ${cx - r},${cy} A ${r},${r} 0 0,1 ${cx + r},${cy}`}
        fill="none" stroke="#17a2b8" strokeWidth="16" strokeLinecap="round"
        strokeDasharray={`${filled} ${arcLen}`} />
      <text x={cx} y={cy - 10} textAnchor="middle" fontSize="28" fontWeight="700" fill="#2d3436">{percent}%</text>
    </svg>
  );
}

/* ── Order Status Breakdown as a donut (real data) ── */
function StatusDonut({ byStatus }) {
  const STATUS_COLORS = {
    PENDING: '#f59e0b', CONFIRMED: '#17a2b8', PROCESSING: '#0984e3',
    SHIPPED: '#6c5ce7', DELIVERED: '#00b894', CANCELLED: '#ff6b6b',
  };
  const entries = Object.entries(byStatus || {});
  const total = entries.reduce((s, [, v]) => s + v, 0);
  if (!total) return <div style={{ textAlign: 'center', color: '#ccc', padding: 40 }}>No data</div>;

  const cx = 90, cy = 90, r = 68, ir = 44;
  let angle = -Math.PI / 2;
  const paths = entries.map(([status, count]) => {
    const pct = count / total;
    const start = angle;
    const delta = pct * 2 * Math.PI;
    angle += delta;
    const end = angle;
    const la = delta > Math.PI ? 1 : 0;
    const x1 = cx + r * Math.cos(start), y1 = cy + r * Math.sin(start);
    const x2 = cx + r * Math.cos(end), y2 = cy + r * Math.sin(end);
    const ix1 = cx + ir * Math.cos(start), iy1 = cy + ir * Math.sin(start);
    const ix2 = cx + ir * Math.cos(end), iy2 = cy + ir * Math.sin(end);
    return (
      <path key={status}
        d={`M ${x1},${y1} A ${r},${r} 0 ${la},1 ${x2},${y2} L ${ix2},${iy2} A ${ir},${ir} 0 ${la},0 ${ix1},${iy1} Z`}
        fill={STATUS_COLORS[status] || '#ccc'} />
    );
  });

  return (
    <svg viewBox="0 0 180 180" style={{ width: 180, height: 180 }}>
      {paths}
      <text x={cx} y={cy - 8} textAnchor="middle" fontSize="9" fill="#aaa">TOTAL ORDERS</text>
      <text x={cx} y={cy + 8} textAnchor="middle" fontSize="13" fontWeight="700" fill="#2d3436">{total.toLocaleString()}</text>
    </svg>
  );
}

const STATUS_CONFIG = {
  PENDING:    { color: '#f59e0b', icon: '⏳' },
  CONFIRMED:  { color: '#17a2b8', icon: '✅' },
  PROCESSING: { color: '#0984e3', icon: '⚙️' },
  SHIPPED:    { color: '#6c5ce7', icon: '🚚' },
  DELIVERED:  { color: '#00b894', icon: '📦' },
  CANCELLED:  { color: '#ff6b6b', icon: '❌' },
};

/* ── Dashboard Page ───────────────────────────────────────────── */
export default function AdminDashboard() {
  const [users, setUsers] = useState(0);
  const [orders, setOrders] = useState({ totalOrders: 0, totalRevenue: 0, byStatus: {} });
  const [loading, setLoading] = useState(true);
  const [msgApi, msgHolder] = antdMessage.useMessage();

  useEffect(() => {
    Promise.all([
      fetchUserCount().then(c => setUsers(c)).catch(() => setUsers(0)),
      fetchOrderStats().then(d => setOrders(d)).catch(() => setOrders({ totalOrders: 0, totalRevenue: 0, byStatus: {} })),
    ]).finally(() => setLoading(false));
  }, []);

  // Target = 1.6x current revenue (dynamic, not hardcoded)
  const revenueTarget = Math.round((orders.totalRevenue || 0) * 1.6) || 1;
  const targetPct = orders.totalRevenue
    ? Math.min(Math.round((orders.totalRevenue / revenueTarget) * 100), 100)
    : 0;

  return (
    <div className="ezmart-dash">
      {msgHolder}

      <Title level={2} className="ezmart-page-title">Dashboard</Title>

      {/* ── Row 1: 3 Stat Cards ── */}
      <Row gutter={[20, 20]} style={{ marginBottom: 20 }}>
        <Col xs={24} md={8}>
          <Card className="ez-stat-card" variant="borderless">
            {loading ? <Skeleton active paragraph={{ rows: 2 }} /> : (
              <div className="ez-stat-inner">
                <div>
                  <div className="ez-stat-label">Total Revenue</div>
                  <div className="ez-stat-value">${orders.totalRevenue.toLocaleString()}</div>
                </div>
                <div className="ez-stat-icon-wrap teal"><DollarOutlined /></div>
              </div>
            )}
          </Card>
        </Col>
        <Col xs={24} md={8}>
          <Card className="ez-stat-card" variant="borderless">
            {loading ? <Skeleton active paragraph={{ rows: 2 }} /> : (
              <div className="ez-stat-inner">
                <div>
                  <div className="ez-stat-label">Total Orders</div>
                  <div className="ez-stat-value">{orders.totalOrders.toLocaleString()}</div>
                </div>
                <div className="ez-stat-icon-wrap blue"><ShoppingCartOutlined /></div>
              </div>
            )}
          </Card>
        </Col>
        <Col xs={24} md={8}>
          <Card className="ez-stat-card" variant="borderless">
            {loading ? <Skeleton active paragraph={{ rows: 2 }} /> : (
              <div className="ez-stat-inner">
                <div>
                  <div className="ez-stat-label">Total Users</div>
                  <div className="ez-stat-value">{users.toLocaleString()}</div>
                </div>
                <div className="ez-stat-icon-wrap outline"><UserOutlined /></div>
              </div>
            )}
          </Card>
        </Col>
      </Row>

      {/* ── Row 2: Revenue Analytics + Monthly Target ── */}
      <Row gutter={[20, 20]} style={{ marginBottom: 20 }}>
        <Col xs={24} lg={16}>
          <Card
            className="ez-chart-card"
            variant="borderless"
            title={<span className="ez-chart-title">Revenue Analytics</span>}
          >
            <RevenueChart />
            <div className="ez-chart-legend">
              <span className="ez-legend-dot teal" /> Revenue
              <span className="ez-legend-dot gray" style={{ marginLeft: 16 }} /> Order
            </div>
          </Card>
        </Col>
        <Col xs={24} lg={8}>
          <Card className="ez-chart-card" variant="borderless" title={<span className="ez-chart-title">Revenue vs Target</span>}>
            {loading ? <Skeleton active paragraph={{ rows: 3 }} /> : (
              <>
                <div style={{ marginTop: 8 }}>
                  <GaugeChart percent={targetPct} />
                </div>
                <div className="ez-target-stats">
                  <div>
                    <div className="ez-target-stat-label teal">TARGET</div>
                    <div className="ez-target-stat-val">${revenueTarget.toLocaleString()}</div>
                  </div>
                  <div>
                    <div className="ez-target-stat-label blue">REVENUE</div>
                    <div className="ez-target-stat-val">${(orders.totalRevenue || 0).toLocaleString()}</div>
                  </div>
                </div>
              </>
            )}
          </Card>
        </Col>
      </Row>

      {/* ── Row 3: Order Status Breakdown ── */}
      <Row gutter={[20, 20]}>
        <Col xs={24} lg={8}>
          <Card className="ez-chart-card" variant="borderless" title={<span className="ez-chart-title">Order Status</span>}>
            {loading ? <Skeleton active paragraph={{ rows: 4 }} /> : (
              <div style={{ display: 'flex', justifyContent: 'center', marginBottom: 12 }}>
                <StatusDonut byStatus={orders.byStatus} />
              </div>
            )}
          </Card>
        </Col>
        <Col xs={24} lg={16}>
          <Card className="ez-chart-card" variant="borderless" title={<span className="ez-chart-title">Orders by Status</span>}>
            {loading ? <Skeleton active paragraph={{ rows: 4 }} /> : (
              <Row gutter={[12, 12]}>
                {Object.entries(orders.byStatus || {}).map(([status, count]) => {
                  const cfg = STATUS_CONFIG[status] || { color: '#aaa', icon: '📋' };
                  return (
                    <Col key={status} xs={12} sm={8}>
                      <div style={{
                        padding: '14px 16px',
                        borderRadius: 12,
                        background: `${cfg.color}12`,
                        border: `1px solid ${cfg.color}30`,
                        textAlign: 'center',
                      }}>
                        <div style={{ fontSize: 22, marginBottom: 4 }}>{cfg.icon}</div>
                        <div style={{ fontSize: 11, fontWeight: 700, color: cfg.color, textTransform: 'uppercase', letterSpacing: 0.5, marginBottom: 4 }}>{status}</div>
                        <div style={{ fontSize: 24, fontWeight: 800, color: cfg.color }}>{count}</div>
                      </div>
                    </Col>
                  );
                })}
              </Row>
            )}
          </Card>
        </Col>
      </Row>
    </div>
  );
}