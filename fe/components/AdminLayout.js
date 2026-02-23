import React, { useState, useEffect } from 'react';
import { Layout as AntLayout, Menu, Button } from 'antd';
import Link from 'next/link';
import { useRouter } from 'next/router';
import { logout } from '../services/auth';
import dynamic from 'next/dynamic';

// dynamically import icon module and grab the specific export; keeps
// initial bundle smaller and avoids Next.js resolving paths that vary by
// library version.
const HomeOutlined = dynamic(
  () => import('@ant-design/icons').then(mod => mod.HomeOutlined),
  { ssr: false }
);
const UserOutlined = dynamic(
  () => import('@ant-design/icons').then(mod => mod.UserOutlined),
  { ssr: false }
);
const ShoppingCartOutlined = dynamic(
  () => import('@ant-design/icons').then(mod => mod.ShoppingCartOutlined),
  { ssr: false }
);
// Use tag icon for coupons navigation
const TagOutlinedDyn = dynamic(
  () => import('@ant-design/icons').then(mod => mod.TagOutlined),
  { ssr: false }
);

const { Header, Sider, Content, Footer } = AntLayout;

export default function AdminLayout({ children }) {
  const router = useRouter();
  const [loggedIn, setLoggedIn] = useState(false);

  useEffect(() => {
    const check = () => setLoggedIn(!!localStorage.getItem('accessToken'));
    check();
    window.addEventListener('storage', check);
    return () => window.removeEventListener('storage', check);
  }, []);
  const selected = router.pathname.startsWith('/admin/coupons')
    ? 'coupons'
    : router.pathname.startsWith('/admin/orders')
    ? 'orders'
    : 'dashboard';

  return (
    <AntLayout style={{ minHeight: '100vh' }}>
      <Sider collapsible>
        <div className="logo" style={{ height: 32, margin: 16, background: 'rgba(255,255,255,0.3)' }} />
        <Menu theme="dark" defaultSelectedKeys={[selected]} mode="inline">
          <Menu.Item key="dashboard" icon={<HomeOutlined />}>
            <Link href="/admin">Dashboard</Link>
          </Menu.Item>
          <Menu.Item key="orders" icon={<ShoppingCartOutlined />}>
            <Link href="/admin/orders">Orders</Link>
          </Menu.Item>
          <Menu.Item key="coupons" icon={<TagOutlinedDyn />}> 
            <Link href="/admin/coupons">Coupons</Link>
          </Menu.Item>
          <Menu.Item key="users" icon={<UserOutlined />}>
            <Link href="/admin/users">Users</Link>
          </Menu.Item>
        </Menu>
      </Sider>
      <AntLayout>
        <Header style={{ background: '#fff', padding: 0, display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
          <span style={{ marginLeft: 16 }}>Admin Panel</span>
          {loggedIn && (
            <Button type="link" onClick={async () => {
              await logout();
              router.push('/login');
            }} style={{ marginRight: 16 }}>
              Logout
            </Button>
          )}
        </Header>
        <Content style={{ margin: '16px' }}>{children}</Content>
        <Footer style={{ textAlign: 'center' }}>KidFavor Admin ©2026</Footer>
      </AntLayout>
    </AntLayout>
  );
}