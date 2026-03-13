import React, { useState, useEffect } from 'react';
import { Row, Col, Card, Typography, message as antdMessage, Skeleton } from 'antd';
import {
  ArrowUpOutlined,
  ArrowDownOutlined,
  DollarOutlined,
  ShoppingCartOutlined,
  EyeOutlined,
} from '@ant-design/icons';
import { fetchUserCount, fetchOrderStats } from '../../services/api';

const { Title } = Typography;

/* ── Inline SVG Charts ────────────────────────────────────────── */

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
      {/* Revenue filled area */}
      <path
        d="M 0,105 C 50,105 50,62 100,62 C 150,62 150,118 200,118 C 250,118 250,145 300,145 C 350,145 350,162 400,162 C 450,162 450,135 500,135 C 550,135 550,80 600,80 C 650,80 650,72 700,72 L 700,200 L 0,200 Z"
        fill="url(#revGrad)"
      />
      <path
        d="M 0,105 C 50,105 50,62 100,62 C 150,62 150,118 200,118 C 250,118 250,145 300,145 C 350,145 350,162 400,162 C 450,162 450,135 500,135 C 550,135 550,80 600,80 C 650,80 650,72 700,72"
        fill="none" stroke="#17a2b8" strokeWidth="2.5"
      />
      {/* Order filled area (lower, dashed) */}
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
      <text x={cx} y={cy - 14} textAnchor="middle" fontSize="28" fontWeight="700" fill="#2d3436">{percent}%</text>
      <text x={cx} y={cy + 4} textAnchor="middle" fontSize="10" fill="#00b894">+8.82% from last month</text>
    </svg>
  );
}

function DonutChart({ segments }) {
  const cx = 90, cy = 90, r = 68, ir = 44;
  let angle = -Math.PI / 2;
  const paths = segments.map(seg => {
    const start = angle;
    const delta = (seg.pct / 100) * 2 * Math.PI;
    angle += delta;
    const end = angle;
    const la = delta > Math.PI ? 1 : 0;
    const x1 = cx + r * Math.cos(start), y1 = cy + r * Math.sin(start);
    const x2 = cx + r * Math.cos(end), y2 = cy + r * Math.sin(end);
    const ix1 = cx + ir * Math.cos(start), iy1 = cy + ir * Math.sin(start);
    const ix2 = cx + ir * Math.cos(end), iy2 = cy + ir * Math.sin(end);
    return (
      <path key={seg.label}
        d={`M ${x1},${y1} A ${r},${r} 0 ${la},1 ${x2},${y2} L ${ix2},${iy2} A ${ir},${ir} 0 ${la},0 ${ix1},${iy1} Z`}
        fill={seg.color} />
    );
  });
  return (
    <svg viewBox="0 0 180 180" style={{ width: 180, height: 180 }}>
      {paths}
      <text x={cx} y={cy - 8} textAnchor="middle" fontSize="9" fill="#aaa">TOTAL SALES</text>
      <text x={cx} y={cy + 8} textAnchor="middle" fontSize="13" fontWeight="700" fill="#2d3436">$3,400,000</text>
    </svg>
  );
}

function ConversionBars({ bars }) {
  const maxV = Math.max(...bars.map(b => b.value));
  const bw = 58, gap = 24, h = 130;
  const totalW = bars.length * (bw + gap) - gap;
  return (
    <svg viewBox={`0 0 ${totalW} ${h + 58}`} style={{ width: '100%', height: 195 }}>
      {bars.map((bar, i) => {
        const bh = (bar.value / maxV) * h;
        const x = i * (bw + gap);
        const y = h - bh;
        return (
          <g key={bar.label}>
            <rect x={x} y={y} width={bw} height={bh} rx="6" fill={bar.color} />
            <text x={x + bw / 2} y={h + 14} textAnchor="middle" fontSize="8.5" fill="#888">{bar.shortLabel}</text>
            <text x={x + bw / 2} y={h + 28} textAnchor="middle" fontSize="10" fontWeight="600" fill="#2d3436">{bar.value.toLocaleString()}</text>
            <text x={x + bw / 2} y={h + 42} textAnchor="middle" fontSize="9" fill={bar.change > 0 ? '#00b894' : '#ff7675'}>
              {bar.change > 0 ? '+' : ''}{bar.change}%
            </text>
          </g>
        );
      })}
    </svg>
  );
}

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

  const revenueTarget = Math.max(Math.round((orders.totalRevenue || 0) * 1.6), 800000);
  const targetPct = orders.totalRevenue
    ? Math.min(Math.round((orders.totalRevenue / revenueTarget) * 100), 100)
    : 85;

  const conversionBars = [
    { shortLabel: 'Product Views', value: 25000, change: 9, color: '#cce9f0' },
    { shortLabel: 'Add to Cart', value: 12000, change: 8, color: '#99d4e6' },
    { shortLabel: 'Checkout', value: 8500, change: 4, color: '#55bcd6' },
    { shortLabel: 'Purchased', value: 6200, change: -3, color: '#17a2b8' },
    { shortLabel: 'Abandoned', value: 3000, change: -8, color: '#0d7d92' },
  ];

  const donutSegments = [
    { label: 'Electronics', pct: 35, color: '#17a2b8', sales: '$1,200,000' },
    { label: 'Fashion', pct: 28, color: '#e07b39', sales: '$950,000' },
    { label: 'Home & Kitchen', pct: 22, color: '#dde8ec', sales: '$750,000' },
    { label: 'Other', pct: 15, color: '#f0f8fa', sales: '' },
  ];

  const countryBars = [
    { name: 'United States', pct: 36 },
    { name: 'United Kingdom', pct: 24 },
    { name: 'Indonesia', pct: 17.5 },
    { name: 'Russia', pct: 15 },
  ];

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
                  <div className="ez-stat-label">Total Sales</div>
                  <div className="ez-stat-value">${orders.totalRevenue.toLocaleString()}</div>
                  <div className="ez-stat-change up">
                    <ArrowUpOutlined /> +3.34% <span className="ez-vs">vs last week</span>
                  </div>
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
                  <div className="ez-stat-change down">
                    <ArrowDownOutlined /> -2.89% <span className="ez-vs">vs last week</span>
                  </div>
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
                  <div className="ez-stat-change up">
                    <ArrowUpOutlined /> +8.02% <span className="ez-vs">vs last week</span>
                  </div>
                </div>
                <div className="ez-stat-icon-wrap outline"><EyeOutlined /></div>
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
            extra={<span className="ez-period-badge">Last 8 Days ▾</span>}
          >
            <RevenueChart />
            <div className="ez-chart-legend">
              <span className="ez-legend-dot teal" /> Revenue
              <span className="ez-legend-dot gray" style={{ marginLeft: 16 }} /> Order
            </div>
          </Card>
        </Col>
        <Col xs={24} lg={8}>
          <Card className="ez-chart-card" variant="borderless" title={<span className="ez-chart-title">Monthly Target</span>}>
            <div style={{ marginTop: 8 }}>
              <GaugeChart percent={targetPct} />
            </div>
            <div style={{ textAlign: 'center', marginTop: 10 }}>
              <div className="ez-target-label">Great Progress! 🎉</div>
              <div className="ez-target-desc">
                Our achievement increased by{' '}
                <b style={{ color: '#17a2b8' }}>${Math.round((orders.totalRevenue || 0) * 0.4).toLocaleString()}</b>,
                let's reach 100% next month.
              </div>
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
          </Card>
        </Col>
      </Row>

      {/* ── Row 3: Active User + Conversion Rate + Top Categories ── */}
      <Row gutter={[20, 20]}>
        <Col xs={24} lg={8}>
          <Card className="ez-chart-card" variant="borderless" title={<span className="ez-chart-title">Active User</span>}>
            <div className="ez-stat-value" style={{ fontSize: 28 }}>{users.toLocaleString()}</div>
            <div style={{ fontSize: 12, color: '#aaa', marginBottom: 6 }}>Users</div>
            <span className="ez-badge-green">+8.02% from last month</span>
            <div style={{ marginTop: 16 }}>
              {countryBars.map(b => (
                <div key={b.name} style={{ marginBottom: 12 }}>
                  <div className="ez-country-row">
                    <span>{b.name}</span>
                    <span className="ez-country-pct">{b.pct}%</span>
                  </div>
                  <div className="ez-progress-bg">
                    <div className="ez-progress-fill" style={{ width: `${b.pct}%` }} />
                  </div>
                </div>
              ))}
            </div>
          </Card>
        </Col>
        <Col xs={24} lg={8}>
          <Card
            className="ez-chart-card"
            variant="borderless"
            title={<span className="ez-chart-title">Conversion Rate</span>}
            extra={<span className="ez-period-badge">This Week ▾</span>}
          >
            <ConversionBars bars={conversionBars} />
          </Card>
        </Col>
        <Col xs={24} lg={8}>
          <Card
            className="ez-chart-card"
            variant="borderless"
            title={<span className="ez-chart-title">Top Categories</span>}
            extra={<span className="ez-see-all">See All</span>}
          >
            <div style={{ display: 'flex', justifyContent: 'center', marginBottom: 12 }}>
              <DonutChart segments={donutSegments} />
            </div>
            {donutSegments.slice(0, 3).map(s => (
              <div key={s.label} className="ez-cat-row">
                <div className="ez-cat-left">
                  <div className="ez-cat-dot" style={{ background: s.color }} />
                  <span>{s.label}</span>
                </div>
                <span className="ez-cat-val">{s.sales}</span>
              </div>
            ))}
          </Card>
        </Col>
      </Row>
    </div>
  );
}