import React, { useState, useEffect } from 'react';
import { Layout as AntLayout, Menu } from 'antd';
import Link from 'next/link';
import { useRouter } from 'next/router';
import { logout } from '../services/auth';

const { Header, Content, Footer } = AntLayout;

export default function Layout({ children }) {
  const router = useRouter();
  const [loggedIn, setLoggedIn] = useState(false);

  // check token presence on mount and when storage changes
  useEffect(() => {
    const check = () => setLoggedIn(!!localStorage.getItem('accessToken'));
    check();
    window.addEventListener('storage', check);
    return () => window.removeEventListener('storage', check);
  }, []);
  return (
    <AntLayout className="layout" style={{ minHeight: '100vh' }}>
      <Header>
        <div className="logo" />
        <Menu theme="dark" mode="horizontal" defaultSelectedKeys={['home']}>
          <Menu.Item key="home">
            <Link href="/">Home</Link>
          </Menu.Item>
          {loggedIn ? (
            <Menu.Item key="logout" onClick={async () => {
                await logout();
                router.push('/login');
              }}
            >
              Logout
            </Menu.Item>
          ) : (
            <Menu.Item key="login">
              <Link href="/login">Login</Link>
            </Menu.Item>
          )}
        </Menu>
      </Header>
      <Content style={{ padding: '0 50px', marginTop: '24px' }}>
        {children}
      </Content>
      <Footer style={{ textAlign: 'center' }}>KidFavor ©2026</Footer>
    </AntLayout>
  );
}