import React, { useState, useEffect } from 'react';
import Head from 'next/head';
import { Layout as AntLayout, Menu, Button, Tooltip, Input } from 'antd';
import Link from 'next/link';
import { useRouter } from 'next/router';
import { logout } from '../services/auth';
import dynamic from 'next/dynamic';

// ── Dynamic icon imports ──────────────────────────────────────
const DashboardOutlined = dynamic(
  () => import('@ant-design/icons').then(m => m.DashboardOutlined),
  { ssr: false }
);
const UserOutlined = dynamic(
  () => import('@ant-design/icons').then(m => m.UserOutlined),
  { ssr: false }
);
const ShoppingCartOutlined = dynamic(
  () => import('@ant-design/icons').then(m => m.ShoppingCartOutlined),
  { ssr: false }
);
const TagOutlined = dynamic(
  () => import('@ant-design/icons').then(m => m.TagOutlined),
  { ssr: false }
);
const AppstoreOutlined = dynamic(
  () => import('@ant-design/icons').then(m => m.AppstoreOutlined),
  { ssr: false }
);
const LogoutOutlined = dynamic(
  () => import('@ant-design/icons').then(m => m.LogoutOutlined),
  { ssr: false }
);
const BellOutlined = dynamic(
  () => import('@ant-design/icons').then(m => m.BellOutlined),
  { ssr: false }
);
const MessageOutlined = dynamic(
  () => import('@ant-design/icons').then(m => m.MessageOutlined),
  { ssr: false }
);
const SearchOutlined = dynamic(
  () => import('@ant-design/icons').then(m => m.SearchOutlined),
  { ssr: false }
);
const BarChartOutlined = dynamic(
  () => import('@ant-design/icons').then(m => m.BarChartOutlined),
  { ssr: false }
);
const PercentageOutlined = dynamic(
  () => import('@ant-design/icons').then(m => m.PercentageOutlined),
  { ssr: false }
);
const SettingOutlined = dynamic(
  () => import('@ant-design/icons').then(m => m.SettingOutlined),
  { ssr: false }
);
const QuestionCircleOutlined = dynamic(
  () => import('@ant-design/icons').then(m => m.QuestionCircleOutlined),
  { ssr: false }
);
const ApiOutlined = dynamic(
  () => import('@ant-design/icons').then(m => m.ApiOutlined),
  { ssr: false }
);

const { Header, Sider, Content, Footer } = AntLayout;

// ── Page title mapping ────────────────────────────────────────
const pageTitles = {
  dashboard: 'Dashboard',
  orders: 'Orders Management',
  products: 'Products Management',
  coupons: 'Coupons Management',
  users: 'Users Management',
  'users-archived': 'Archived Users',
  stores: 'Store Management',
  warehouses: 'Warehouse Management',
  'warehouse-inventory': 'Warehouse Inventory',
};

export default function AdminLayout({ children }) {
  const router = useRouter();
  const [loggedIn, setLoggedIn] = useState(false);
  const [profile, setProfile] = useState(null);
  const [collapsed, setCollapsed] = useState(false);

  useEffect(() => {
    const check = () => setLoggedIn(!!localStorage.getItem('accessToken'));
    check();
    window.addEventListener('storage', check);
    return () => window.removeEventListener('storage', check);
  }, []);

  useEffect(() => {
    if (loggedIn) {
      import('../services/auth').then(mod => {
        setProfile(mod.getCurrentUser());
      });
    } else {
      setProfile(null);
    }
  }, [loggedIn]);

  const selected = router.pathname.startsWith('/admin/coupons')
    ? 'coupons'
    : router.pathname.startsWith('/admin/orders')
      ? 'orders'
      : router.pathname.startsWith('/admin/products')
        ? 'products'
        : router.pathname.startsWith('/admin/users-archived')
          ? 'users-archived'
          : router.pathname.startsWith('/admin/users')
          ? 'users'
          : router.pathname.startsWith('/admin/stores')
            ? 'stores'
            : router.pathname.startsWith('/admin/warehouses')
              ? 'warehouses'
              : router.pathname.startsWith('/admin/inventory')
                ? 'stores'
                : 'dashboard';

  const displayName = profile?.fullName || profile?.name || 'Admin';
  const initials = displayName
    .split(' ')
    .map(w => w[0])
    .join('')
    .toUpperCase()
    .slice(0, 2);

  return (
    <>
      <Head>
        <link rel="icon" href="/images.jpg" />
      </Head>

      <AntLayout className="admin-layout" style={{ fontFamily: "'Inter', -apple-system, sans-serif" }}>
        {/* ── Sidebar ── */}
        <Sider
          collapsible
          collapsed={collapsed}
          onCollapse={setCollapsed}
          width={220}
          collapsedWidth={72}
          className="admin-sidebar"
          breakpoint="lg"
        >
          {/* Logo */}
          <div className="admin-sidebar-logo">
            <div className="admin-sidebar-logo-circle">K</div>
            {!collapsed && (
              <div className="admin-sidebar-logo-text">
                <span className="admin-sidebar-logo-title">KidFavor</span>
              </div>
            )}
          </div>

          {/* Navigation */}
          <div className="admin-sidebar-scroll">
            <Menu
              theme="light"
              selectedKeys={[selected]}
              mode="inline"
              className="admin-sidebar-menu"
              items={[
                {
                  type: 'group',
                  label: collapsed ? '' : 'MENU',
                  children: [
                    { key: 'dashboard', icon: <DashboardOutlined />, label: <Link href="/admin">Dashboard</Link> },
                    { key: 'orders', icon: <ShoppingCartOutlined />, label: <Link href="/admin/orders">Orders</Link> },
                    { key: 'products', icon: <AppstoreOutlined />, label: <Link href="/admin/products">Products</Link> },
                    { key: 'users', icon: <UserOutlined />, label: <Link href="/admin/users">Customers</Link> },
                    { key: 'users-archived', icon: <UserOutlined />, label: <Link href="/admin/users-archived">Archived Users</Link> },
                    { key: 'reports', icon: <BarChartOutlined />, label: <Link href="/admin/warehouses">Reports</Link> },
                    { key: 'coupons', icon: <PercentageOutlined />, label: <Link href="/admin/coupons">Discounts</Link> },
                  ],
                },
                {
                  type: 'group',
                  label: collapsed ? '' : 'SUPPORT',
                  children: [
                    { key: 'stores', icon: <ApiOutlined />, label: <Link href="/admin/stores">Integrations</Link> },
                    { key: 'warehouses', icon: <QuestionCircleOutlined />, label: <Link href="/admin/warehouses">Help</Link> },
                    { key: 'warehouse-inventory', icon: <SettingOutlined />, label: <Link href="/admin/warehouse-inventory">Settings</Link> },
                  ],
                },
              ]}
            />
          </div>


        </Sider>

        {/* ── Main Area ── */}
        <AntLayout>
          {/* Header */}
          <Header className="admin-header">
            <div className="admin-header-left">
              <div className="admin-header-title">
                {pageTitles[selected] || 'Dashboard'}
              </div>
            </div>

            <div className="admin-header-right">
              <Input
                prefix={<SearchOutlined style={{ color: '#bbb' }} />}
                placeholder="Search stock, order, etc"
                className="admin-header-search"
                variant="unstyled"
              />
              {loggedIn ? (
                <>
                  <Tooltip title="Messages">
                    <Button type="text" shape="circle" icon={<MessageOutlined style={{ fontSize: 17 }} />} className="admin-header-icon-btn" />
                  </Tooltip>
                  <Tooltip title="Notifications">
                    <Button type="text" shape="circle" icon={<BellOutlined style={{ fontSize: 17 }} />} className="admin-header-icon-btn" />
                  </Tooltip>

                  <div className="admin-header-user">
                    <div className="admin-header-avatar">{initials}</div>
                    <div>
                      <div className="admin-header-name">{displayName}</div>
                      <div className="admin-header-role">
                        {profile?.role || 'Admin'}
                      </div>
                    </div>
                  </div>

                  <Button
                    className="admin-logout-btn"
                    icon={<LogoutOutlined />}
                    onClick={async () => {
                      await logout();
                      router.push('/login');
                    }}
                  >
                    Logout
                  </Button>
                </>
              ) : (
                <Button
                  type="primary"
                  onClick={() => router.push('/login')}
                  style={{ borderRadius: 10 }}
                >
                  Login
                </Button>
              )}
            </div>
          </Header>

          {/* Content */}
          <Content className="admin-content">{children}</Content>

          {/* Footer */}
          <Footer className="admin-footer">
            <span className="admin-footer-text">
              KidFavor Admin ©2026 — Built with{' '}
              <span className="admin-footer-heart">❤️</span>
            </span>
          </Footer>
        </AntLayout>
      </AntLayout>
    </>
  );
}