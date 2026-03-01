import { useEffect, useState } from 'react';
import { Form, Input, Button, Typography, message, Card, Divider } from 'antd';
import { ArrowRightOutlined } from '@ant-design/icons';
import { useRouter } from 'next/router';
import Script from 'next/script';

import { login } from '../services/auth';

const { Title } = Typography;

// Your actual Google Client ID
const GOOGLE_CLIENT_ID = '1054535998093-1330g8fvc2rmfdf8ck732jbuqka0mri7.apps.googleusercontent.com';

export default function Login() {
  const router = useRouter();
  const [googleReady, setGoogleReady] = useState(false);

  // Add a class to <html> so we can scope full-viewport background CSS
  // to the login page only, then clean it up when navigating away.
  useEffect(() => {
    document.documentElement.classList.add('login-page');
    return () => {
      document.documentElement.classList.remove('login-page');
    };
  }, []);

  // Initialize Google Sign-In when library is loaded
  useEffect(() => {
    if (googleReady && window.google) {
      try {
        window.google.accounts.id.initialize({
          client_id: GOOGLE_CLIENT_ID,
          callback: handleGoogleCallback,
          auto_select: false,
          cancel_on_tap_outside: true,
        });

        // Render the REAL Google Sign-In button
        const googleButton = document.getElementById('googleSignInButton');
        if (googleButton && googleButton.children.length === 0) {
          window.google.accounts.id.renderButton(
            googleButton,
            {
              theme: 'outline',
              size: 'large',
              text: 'signin_with',
              width: '100%',
              logo_alignment: 'left',
            }
          );
        }
      } catch (error) {
        console.error('Error initializing Google Sign-In:', error);
      }
    }
  }, [googleReady]);

  // Handle REAL Google Sign-In callback
  const handleGoogleCallback = async (response) => {
    console.log('Real Google Sign-In response received');

    try {
      // Send the REAL Google ID token to your backend
      const res = await fetch('http://localhost:8081/auth/google', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          token: response.credential,
          provider: 'google'
        }),
      });

      const data = await res.json();
      console.log('Backend response:', data);

      if (data.status === 200 && data.data) {
        // Store tokens
        localStorage.setItem('accessToken', data.data.accessToken);
        localStorage.setItem('refreshToken', data.data.refreshToken);

        message.success('Signed in with Google successfully!');

        // Redirect to admin dashboard
        setTimeout(() => {
          router.push('/admin');
        }, 500);
      } else {
        message.error(data.message || 'Google login failed');
      }
    } catch (error) {
      console.error('Google login error:', error);
      message.error('Failed to sign in with Google. Please try again.');
    }
  };

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
    <>
      {/* Load REAL Google Identity Services */}
      <Script
        src="https://accounts.google.com/gsi/client"
        onLoad={() => {
          console.log('Google Identity Services loaded');
          setGoogleReady(true);
        }}
        onError={() => {
          console.error('Failed to load Google Identity Services');
          message.error('Failed to load Google Sign-In');
        }}
        strategy="afterInteractive"
      />

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

              {/* REAL Google Sign-In Button - Rendered by Google */}
              <Form.Item>
                <div
                  id="googleSignInButton"
                  style={{
                    display: 'flex',
                    justifyContent: 'center',
                    minHeight: '40px'
                  }}
                />
                {!googleReady && (
                  <div style={{ textAlign: 'center', color: '#999', fontSize: '12px' }}>
                    Loading Google Sign-In...
                  </div>
                )}
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