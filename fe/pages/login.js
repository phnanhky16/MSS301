import { useEffect } from 'react';
import { Form, Input, Button, Typography, message, Card } from 'antd';
import { ArrowRightOutlined } from '@ant-design/icons';
import { useRouter } from 'next/router';

import { login } from '../services/auth';

const { Title } = Typography;

export default function Login() {
  const router = useRouter();

  // Add a class to <html> so we can scope full-viewport background CSS
  // to the login page only, then clean it up when navigating away.
  useEffect(() => {
    document.documentElement.classList.add('login-page');
    return () => {
      document.documentElement.classList.remove('login-page');
    };
  }, []);

  const onFinish = values => {
    login(values.username, values.password)
      .then(data => {
        console.debug('login success payload', data);
        if (data && data.accessToken) {
          router.push('/admin');
        } else {
          message.error('Login succeeded but no token received');
        }
      })
      .catch(err => {
        let text = 'Login failed';
        try {
          const parsed = JSON.parse(err.message);
          if (parsed && parsed.message) text = parsed.message;
        } catch (_) { }
        message.error(text);
        console.error('login error', err);
      });
  };

  return (
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
  );
}