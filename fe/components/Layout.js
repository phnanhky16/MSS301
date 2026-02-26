import React, { useState, useEffect } from 'react';
import { Layout as AntLayout, Menu, Button } from 'antd';
import Link from 'next/link';
import { useRouter } from 'next/router';
import { logout } from '../services/auth';

const { Header, Content, Footer } = AntLayout;

export default function Layout({ children, isLogin = false }) {
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
        <div style={{ display: 'flex', alignItems: 'center' }}>
          {/**
           * build menu items dynamically so the current route can be
           * reflected in the selected key. we also offer a login link in
           * the menu when the user is not authenticated; the right-hand
           * login/logout button is primarily for convenience.
           */}
          {(() => {
            const activeKey =
              router.pathname === '/' ? 'home' :
                router.pathname === '/login' ? 'login' :
                  '';
            // only show home in the menu; login will be available via the
            // right-hand button which already has active-state styling.
            const items = [{ key: 'home', label: <Link href="/">Home</Link> }];
            return (
              <Menu
                theme="dark"
                mode="horizontal"
                selectedKeys={[activeKey]}
                items={items}
              />
            );
          })()}
          <div style={{ marginLeft: 'auto' }}>
            {loggedIn ? (
              <Button type="link" onClick={async () => {
                await logout();
                router.push('/login');
              }}
                style={{ color: '#fff' }}
              >
                Logout
              </Button>
            ) : (
              <Link href="/login">
                <Button
                  type="link"
                  style={{
                    color: '#fff',
                    /**
                     * when we are already on the login page, give the
                     * button a subtle background to look "active" so the
                     * header feels responsive.
                     */
                    background: router.pathname === '/login' ? 'rgba(255,255,255,0.15)' : undefined
                  }}
                >
                  Login
                </Button>
              </Link>
            )}
          </div>
        </div>
      </Header>
      <Content style={isLogin ? { padding: 0, marginTop: 0 } : { padding: '0 50px', marginTop: '24px' }}>
        {children}
      </Content>
      {!isLogin && <Footer style={{ textAlign: 'center' }}>KidFavor ©2026</Footer>}
    </AntLayout>
  );
}