import React, { useState, useEffect } from 'react';
import Head from 'next/head';
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
  const [profile, setProfile] = useState(null);

  useEffect(() => {
    const check = () => setLoggedIn(!!localStorage.getItem('accessToken'));
    check();
    window.addEventListener('storage', check);
    return () => window.removeEventListener('storage', check);
  }, []);

  // whenever login status changes, try to parse JWT for profile info
  useEffect(() => {
    if (loggedIn) {
      import('../services/auth').then(mod => {
        setProfile(mod.getCurrentUser());
      });
    } else {
      setProfile(null);
    }
  }, [loggedIn]);
  // determine which menu item should be highlighted based on the current path
  // note: Next.js router.pathname is the route template (no query string)
  const selected = router.pathname.startsWith('/admin/coupons')
    ? 'coupons'
    : router.pathname.startsWith('/admin/orders')
      ? 'orders'
      : router.pathname.startsWith('/admin/products')
        ? 'products'
        : router.pathname.startsWith('/admin/users')
          ? 'users'
          : 'dashboard';

  return (
    <>
      <Head>
        {/* set favicon explicitly to avoid default /favicon.ico 404 */}
        <link rel="icon" href="/images.jpg" />
      </Head>
      <AntLayout style={{ minHeight: '100vh' }}>
        <Sider collapsible>
          <div className="logo" style={{ height: 48, margin: 16, display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
            {/* use public/images.jpg as application icon; make it larger */}
            <img src="/images.jpg" alt="logo" style={{ height: 48, objectFit: 'contain' }} />
          </div>
          <Menu
            theme="dark"
            defaultSelectedKeys={[selected]}
            mode="inline"
            items={[
              {
                key: 'dashboard',
                icon: <HomeOutlined />,
                label: <Link href="/admin">Dashboard</Link>,
              },
              {
                key: 'orders',
                icon: <ShoppingCartOutlined />,
                label: <Link href="/admin/orders">Orders</Link>,
              },
              {
                key: 'products',
                icon: <ShoppingCartOutlined />,
                label: <Link href="/admin/products">Products</Link>,
              },
              {
                key: 'coupons',
                icon: <TagOutlinedDyn />,
                label: <Link href="/admin/coupons">Coupons</Link>,
              },
              {
                key: 'users',
                icon: <UserOutlined />,
                label: <Link href="/admin/users">Users</Link>,
              },
            ]}
          />
        </Sider>
        <AntLayout>
          <Header style={{ background: '#fff', padding: 0, display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
            <div style={{ display: 'flex', alignItems: 'center', marginLeft: 16 }}>
              <img src="/images.jpg" alt="logo" style={{ height: 32, marginRight: 8, objectFit: 'contain' }} />
              <span>Admin Panel</span>
            </div>
            {loggedIn ? (
              <div style={{ display: 'flex', alignItems: 'center', marginRight: 16 }}>
                <span style={{ marginRight: 12 }}>
                  {profile?.fullName || profile?.name || ''}
                </span>
                <Button
                  type="link"
                  onClick={async () => {
                    await logout();
                    router.push('/login');
                  }}
                >
                  Logout
                </Button>
              </div>
            ) : (
              <Button type="link" onClick={() => router.push('/login')} style={{ marginRight: 16 }}>
                Login
              </Button>
            )}
          </Header>
          <Content style={{ margin: '16px' }}>{children}</Content>
          <Footer style={{ textAlign: 'center' }}>KidFavor Admin ©2026</Footer>
        </AntLayout>
      </AntLayout>
    </>
  );
}