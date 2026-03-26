import { useEffect, useState } from 'react';
import { Form, Input, Button, Typography, message, Card, Divider, Alert } from 'antd';
import { ArrowRightOutlined, GoogleOutlined } from '@ant-design/icons';
import { useRouter } from 'next/router';
import Script from 'next/script';

import { login, resendVerificationLink } from '../services/auth';
import { initiateGoogleLogin, handleOAuth2Callback, decodeJWT } from '../services/oauth';

const { Title } = Typography;

export default function Login() {
  const router = useRouter();
  const [msgApi, msgHolder] = message.useMessage();
  const [pendingVerificationEmail, setPendingVerificationEmail] = useState('');
  const [isResendingVerification, setIsResendingVerification] = useState(false);

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
    if (!router.isReady) return; // wait until query is available

    const { token, error } = router.query;

    // Do nothing when there's nothing to process; this prevents showing
    // an error message every time the user refreshes the login page.
    if (!token && !error) {
      return;
    }

    const result = handleOAuth2Callback(token, error);

    if (result.success === true) {
      msgApi.success(result.message);
      // after OAuth success we stored userInfo already; route by role
      const stored = localStorage.getItem('userInfo');
      try {
        const info = stored ? JSON.parse(stored) : null;
        const role = info?.role?.toUpperCase();
        if (role === 'ADMIN') {
          router.push('/admin');
        } else if (role === 'STAFF_FOR_STORE') {
          router.push('/store/pos');
        } else if (role === 'STAFF_FOR_WAREHOUSE') {
          router.push('/warehouse/dashboard');
        } else {
          router.push('/');
        }
      } catch (_) {
        router.push('/');
      }
    } else if (result.success === false) {
      msgApi.error(`Login failed: ${result.message}`);
    }

    // remove the query parameters so that a subsequent F5 doesn't re-trigger
    // the same message.  use shallow replace so we don't run getServerSideProps
    // or unmount the page.
    router.replace('/login', undefined, { shallow: true });
  }, [router.isReady, router.query]);

  const handleGoogleLogin = () => {
    // Simply call the helper function - it handles everything
    initiateGoogleLogin();
  };


  const onFinish = async values => {
    try {
      const data = await login(values.username, values.password);
      console.debug('login success payload', data);
      setPendingVerificationEmail('');

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
        const role = info?.role?.toUpperCase();
        if (role === 'ADMIN') {
          router.push('/admin');
        } else if (role === 'STAFF_FOR_STORE') {
          router.push('/store/pos');
        } else if (role === 'STAFF_FOR_WAREHOUSE') {
          router.push('/warehouse/dashboard');
        } else {
          router.push('/');
        }
      } else {
        msgApi.error('Login succeeded but no token received');
      }
    } catch (err) {
      const text = err?.message || 'Login failed';
      const isNotVerified = text.toLowerCase().includes('email is not verified');

      if (isNotVerified) {
        const input = (values?.username || '').trim().toLowerCase();
        const canResend = /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(input);
        setPendingVerificationEmail(canResend ? input : '');
      } else {
        setPendingVerificationEmail('');
      }

      msgApi.error(text || 'Login failed');
      console.error('login error', err);
    }
  };

  const handleResendVerification = async () => {
    if (!pendingVerificationEmail) {
      msgApi.warning('Please login with email to resend verification link');
      return;
    }

    setIsResendingVerification(true);
    try {
      await resendVerificationLink(pendingVerificationEmail);
      msgApi.success(`Verification link sent to ${pendingVerificationEmail}`);
    } catch (err) {
      msgApi.error(err?.message || 'Cannot resend verification link');
    } finally {
      setIsResendingVerification(false);
    }
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

            {pendingVerificationEmail && (
              <Form.Item>
                <Alert
                  type="warning"
                  showIcon
                  message="Email chưa xác thực"
                  description={
                    <div>
                      <div style={{ marginBottom: 8 }}>
                        Vui lòng xác thực email trước khi đăng nhập: <strong>{pendingVerificationEmail}</strong>
                      </div>
                      <Button size="small" onClick={handleResendVerification} loading={isResendingVerification}>
                        Resend verification link
                      </Button>
                    </div>
                  }
                />
              </Form.Item>
            )}

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