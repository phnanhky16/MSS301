import React, { useState, useEffect } from 'react';
import Head from 'next/head';
import { Layout as AntLayout, Menu, Button, Tooltip } from 'antd';
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

const { Header, Sider, Content, Footer } = AntLayout;

// ── Page title mapping ────────────────────────────────────────
const pageTitles = {
  dashboard: 'Dashboard',
  orders: 'Orders Management',
  products: 'Products Management',
  coupons: 'Coupons Management',
  users: 'Users Management',
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

  // Active menu key

  // Active menu key
  const selected = router.pathname.startsWith('/admin/coupons')
    ? 'coupons'
    : router.pathname.startsWith('/admin/orders')
      ? 'orders'
      : router.pathname.startsWith('/admin/products')
        ? 'products'
        : router.pathname.startsWith('/admin/users')
          ? 'users'
          : router.pathname.startsWith('/admin/stores')
            ? 'stores'
            : router.pathname.startsWith('/admin/warehouses')
              ? 'warehouses'
              : router.pathname.startsWith('/admin/inventory')
                ? 'stores' // inventory could reuse store icon
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
        {/* font stylesheet moved to _document.js per Next.js warning */}
      </Head>

      <AntLayout className="admin-layout" style={{ fontFamily: "'Inter', -apple-system, sans-serif" }}>
        {/* ── Sidebar ── */}
        <Sider
          collapsible
          collapsed={collapsed}
          onCollapse={setCollapsed}
          width={260}
          collapsedWidth={80}
          className="admin-sidebar"
          breakpoint="lg"
        >
          {/* Logo */}
          <div className="admin-sidebar-logo">
            <img src="/images.jpg" alt="KidFavor" className="admin-sidebar-logo-icon" />
            {!collapsed && (
              <div className="admin-sidebar-logo-text">
                <span className="admin-sidebar-logo-title">KidFavor</span>
                <span className="admin-sidebar-logo-sub">Admin Panel</span>
              </div>
            )}
          </div>

          {/* Navigation */}
          <Menu
            theme="dark"
            selectedKeys={[selected]}
            mode="inline"
            items={[
              {
                key: 'dashboard',
                icon: <DashboardOutlined />,
                label: <Link href="/admin">Dashboard</Link>,
              },
              {
                key: 'orders',
                icon: <ShoppingCartOutlined />,
                label: <Link href="/admin/orders">Orders</Link>,
              },
              {
                key: 'products',
                icon: <AppstoreOutlined />,
                label: <Link href="/admin/products">Products</Link>,
              },
              {
                key: 'coupons',
                icon: <TagOutlined />,
                label: <Link href="/admin/coupons">Coupons</Link>,
              },
              {
                key: 'users',
                icon: <UserOutlined />,
                label: <Link href="/admin/users">Users</Link>,
              },
              {
                key: 'stores',
                icon: <AppstoreOutlined />,
                label: <Link href="/admin/stores">Stores</Link>,
              },
              {
                key: 'warehouses',
                icon: <AppstoreOutlined />,
                label: <Link href="/admin/warehouses">Warehouses</Link>,
              },
              {
                key: 'warehouse-inventory',
                icon: <AppstoreOutlined />,
                label: <Link href="/admin/warehouse-inventory">Inventory</Link>,
              },
            ]}
          />
        </Sider>

        {/* ── Main Area ── */}
        <AntLayout>
          {/* Header */}
          <Header className="admin-header">
            <div className="admin-header-left">
              <div>
                <div className="admin-header-title">
                  {pageTitles[selected] || 'Dashboard'}
                </div>
                <div className="admin-header-breadcrumb">
                  Admin / {pageTitles[selected] || 'Dashboard'}
                </div>
              </div>
            </div>

            <div className="admin-header-right">
              {loggedIn ? (
                <>
                  <Tooltip title="Notifications">
                    <Button
                      type="text"
                      shape="circle"
                      icon={<BellOutlined style={{ fontSize: 18 }} />}
                      style={{ color: '#636e72' }}
                    />
                  </Tooltip>

                  <div className="admin-header-user">
                    <div className="admin-header-avatar">{initials}</div>
                    <div>
                      <div className="admin-header-name">{displayName}</div>
                      <div className="admin-header-role">
                        {profile?.role || 'Administrator'}
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