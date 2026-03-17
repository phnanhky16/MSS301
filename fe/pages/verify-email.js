import { useEffect, useMemo, useState } from 'react';
import { Card, Typography, Button, Spin } from 'antd';
import { CheckCircleOutlined, CloseCircleOutlined } from '@ant-design/icons';
import { useRouter } from 'next/router';
import { verifyEmailToken } from '../services/auth';

const { Title, Text } = Typography;

export default function VerifyEmailPage() {
  const router = useRouter();
  const [status, setStatus] = useState('loading');
  const [errorText, setErrorText] = useState('');

  const token = useMemo(() => {
    if (!router.isReady) return '';
    const queryToken = router.query.token;
    return typeof queryToken === 'string' ? queryToken.trim() : '';
  }, [router.isReady, router.query.token]);

  useEffect(() => {
    document.documentElement.classList.add('login-page');
    return () => {
      document.documentElement.classList.remove('login-page');
    };
  }, []);

  useEffect(() => {
    if (!router.isReady) return;

    if (!token) {
      setStatus('error');
      setErrorText('Verification link is invalid');
      return;
    }

    verifyEmailToken(token)
      .then(() => {
        setStatus('success');
      })
      .catch(err => {
        setStatus('error');
        setErrorText(parseError(err, 'Verification failed or link already used'));
      });
  }, [router.isReady, token]);

  return (
    <div className="login-wrapper">
      <div className="login-right" />
      <div className="login-left">
        <Card variant="bordered" className="login-card">
          {status === 'loading' && (
            <div style={{ textAlign: 'center' }}>
              <Spin size="large" />
              <Title level={4} style={{ marginTop: 16 }}>Verifying your email...</Title>
            </div>
          )}

          {status === 'success' && (
            <div style={{ textAlign: 'center' }}>
              <CheckCircleOutlined style={{ fontSize: 44, color: '#52c41a' }} />
              <Title level={3} style={{ marginTop: 12 }}>Email verified successfully</Title>
              <Text>You can now login with your account.</Text>
              <div style={{ marginTop: 20 }}>
                <Button type="primary" onClick={() => router.push('/login')}>Go to login</Button>
              </div>
            </div>
          )}

          {status === 'error' && (
            <div style={{ textAlign: 'center' }}>
              <CloseCircleOutlined style={{ fontSize: 44, color: '#ff4d4f' }} />
              <Title level={3} style={{ marginTop: 12 }}>Email verification failed</Title>
              <Text type="secondary">{errorText}</Text>
              <div style={{ marginTop: 20 }}>
                <Button type="primary" onClick={() => router.push('/signup')}>Back to signup</Button>
              </div>
            </div>
          )}
        </Card>
      </div>
    </div>
  );
}

function parseError(err, fallback) {
  let text = fallback;
  try {
    const parsed = JSON.parse(err.message);
    if (parsed && parsed.message) text = parsed.message;
  } catch (_) {
    if (err && err.message) text = err.message;
  }
  return text;
}
