import { useEffect, useState } from 'react';
import { Form, Input, Button, Typography, message, Card, Divider } from 'antd';
import { ArrowRightOutlined, GoogleOutlined } from '@ant-design/icons';
import { useRouter } from 'next/router';
import Script from 'next/script';

import { login } from '../services/auth';
import { initiateGoogleLogin, handleOAuth2Callback, decodeJWT } from '../services/oauth';

const { Title } = Typography;

export default function Login() {
  const router = useRouter();
  const [msgApi, msgHolder] = message.useMessage();

  // Add a class to <html> so we can scope full-viewport background CSS
  // to the login page only, then clean it up when navigating away.
  useEffect(() => {
    document.documentElement.classList.add('login-page');
    return () => {
      document.documentElement.classList.remove('login-page');
    };
  }, []);

  // Handle tokens and error from URL after OAuth2 redirect
  // Backend OAuth2 flow: User clicks Google button → Backend handles OAuth2 → 
  // Backend redirects here with ?token=JWT_TOKEN or ?error=ERROR_MESSAGE
  useEffect(() => {
    const { token, error } = router.query;

    const result = handleOAuth2Callback(token, error);
    
    if (result.success === true) {
      msgApi.success(result.message);
      // after OAuth success we stored userInfo already; route by role
      const stored = localStorage.getItem('userInfo');
      try {
        const info = stored ? JSON.parse(stored) : null;
        if (info && info.role && info.role.toUpperCase() === 'ADMIN') {
          router.push('/admin');
        } else {
          router.push('/');
        }
      } catch (_) {
        router.push('/');
      }
    } else if (result.success === false) {
      msgApi.error(`Login failed: ${result.message}`);
    }
  }, [router.query]);

  const handleGoogleLogin = () => {
    // Simply call the helper function - it handles everything
    initiateGoogleLogin();
  };


  const onFinish = values => {
    login(values.username, values.password)
      .then(data => {
        console.debug('login success payload', data);
        if (data && data.accessToken) {
          // decode once so we can route correctly and cache a little info
          let info = null;
          try {
            info = decodeJWT(data.accessToken);
            if (info) {
              localStorage.setItem('userInfo', JSON.stringify({
                userId: info.userId,
                email: info.email,
                role: info.role,
                name: info.sub || info.email.split('@')[0]
              }));
            }
          } catch (_) {
            // ignore decode errors
          }

          // notify other components (e.g. Layout) that auth state changed
          // `storage` event normally fires only in other windows, so dispatch
          // manually so the Layout hook re-checks the token/userInfo.
          window.dispatchEvent(new Event('storage'));

          // route depending on user role
          if (info && info.role && info.role.toUpperCase() === 'ADMIN') {
            router.push('/admin');
          } else {
            router.push('/');
          }
        } else {
          msgApi.error('Login succeeded but no token received');
        }
      })
      .catch(err => {
        let text = 'Login failed';
        try {
          const parsed = JSON.parse(err.message);
          if (parsed && parsed.message) text = parsed.message;
        } catch (_) { }
        msgApi.error(text);
        console.error('login error', err);
      });
  };

  return (
    <>
      {msgHolder}
      <div className="login-wrapper">
      {/* Right side is transparent — background image shows through */}
      <div className="login-right" />
      <div className="login-left">
        <Card variant="bordered" className="login-card">
          <div className="login-welcome">Welcome back !!!</div>
          <Title level={2} className="login-title">
            Sign in
          </Title>
          <Form name="login" onFinish={onFinish} layout="vertical">
            <Form.Item
              name="username"
              label="Email"
              rules={[{ required: true, message: 'Please input your email!' }]}
            >
              <Input placeholder="you@example.com" />
            </Form.Item>
            <Form.Item
              name="password"
              label="Password"
              rules={[{ required: true, message: 'Please input your password!' }]}
            >
              <Input.Password placeholder="••••••••" />
            </Form.Item>
            <Form.Item>
              <Button type="primary" htmlType="submit" block icon={<ArrowRightOutlined />}>
                Sign in
              </Button>
            </Form.Item>

            <Divider plain>Or</Divider>

            <Form.Item>
              <Button
                icon={<GoogleOutlined />}
                block
                size="large"
                onClick={handleGoogleLogin}
              >
                Sign in with Google
              </Button>
            </Form.Item>

            <div className="login-links">
              <a href="/forgot-password">Forgot Password?</a>
            </div>
            <div className="login-links signup">
              <span>Don't have an account? </span>
              <a href="/signup">Sign up</a>
            </div>
          </Form>
        </Card>
      </div>
      </div>
    </>
  );
}