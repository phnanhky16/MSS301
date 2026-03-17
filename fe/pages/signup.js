import { useEffect, useState } from 'react';
import { Form, Input, Button, Typography, message, Card, Divider } from 'antd';
import { UserOutlined, MailOutlined, PhoneOutlined, LockOutlined } from '@ant-design/icons';
import { useRouter } from 'next/router';
import { register, resendVerificationLink } from '../services/auth';

const { Title, Text } = Typography;

export default function SignUp() {
  const router = useRouter();
  const [msgApi, msgHolder] = message.useMessage();
  const [registeredEmail, setRegisteredEmail] = useState('');
  const [cooldownSeconds, setCooldownSeconds] = useState(0);
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [isResending, setIsResending] = useState(false);

  useEffect(() => {
    document.documentElement.classList.add('login-page');
    return () => {
      document.documentElement.classList.remove('login-page');
    };
  }, []);

  useEffect(() => {
    if (cooldownSeconds <= 0) return;
    const timer = setInterval(() => {
      setCooldownSeconds(prev => (prev > 0 ? prev - 1 : 0));
    }, 1000);
    return () => clearInterval(timer);
  }, [cooldownSeconds]);

  const onFinish = values => {
    setIsSubmitting(true);
    const normalizedEmail = values.email.trim().toLowerCase();
    register({
      fullName: values.fullName.trim(),
      username: values.username.trim(),
      email: normalizedEmail,
      phone: values.phone ? values.phone.trim() : null,
      password: values.password,
    })
      .then(() => {
        setRegisteredEmail(normalizedEmail);
        setCooldownSeconds(60);
        msgApi.success('Dang ky thanh cong. Vui long vao Gmail de xac thuc tai khoan truoc khi dang nhap');
      })
      .catch(err => {
        msgApi.error(parseError(err, 'Register failed'));
      })
      .finally(() => setIsSubmitting(false));
  };

  const handleResendVerification = () => {
    if (!registeredEmail || cooldownSeconds > 0) {
      return;
    }
    setIsResending(true);
    resendVerificationLink(registeredEmail)
      .then(() => {
        setCooldownSeconds(60);
        msgApi.success('Da gui lai link xac thuc. Link cu da bi huy');
      })
      .catch(err => {
        msgApi.error(parseError(err, 'Khong the gui lai link xac thuc'));
      })
      .finally(() => setIsResending(false));
  };

  return (
    <>
      {msgHolder}
      <div className="login-wrapper">
        <div className="login-right" />
        <div className="login-left">
          <Card variant="bordered" className="login-card">
            <Title level={2} className="login-title">Sign up</Title>
            {!registeredEmail ? (
              <Form name="signup" onFinish={onFinish} layout="vertical">
              <Form.Item
                name="fullName"
                label="Full Name"
                rules={[{ required: true, message: 'Please input your full name!' }]}
              >
                <Input placeholder="Nguyen Van A" prefix={<UserOutlined />} />
              </Form.Item>

              <Form.Item
                name="username"
                label="Username"
                rules={[
                  { required: true, message: 'Please input username!' },
                  { min: 3, message: 'Username must be at least 3 characters' },
                ]}
              >
                <Input placeholder="nguyenvana" prefix={<UserOutlined />} />
              </Form.Item>

              <Form.Item
                name="email"
                label="Email"
                rules={[
                  { required: true, message: 'Please input your email!' },
                  { type: 'email', message: 'Invalid email format' },
                ]}
              >
                <Input placeholder="you@example.com" prefix={<MailOutlined />} />
              </Form.Item>

              <Form.Item
                name="phone"
                label="Phone"
              >
                <Input placeholder="0901234567" prefix={<PhoneOutlined />} />
              </Form.Item>

              <Form.Item
                name="password"
                label="Password"
                rules={[
                  { required: true, message: 'Please input your password!' },
                  { min: 6, message: 'Password must be at least 6 characters' },
                ]}
              >
                <Input.Password placeholder="******" prefix={<LockOutlined />} />
              </Form.Item>

              <Form.Item
                name="confirmPassword"
                label="Confirm Password"
                dependencies={['password']}
                rules={[
                  { required: true, message: 'Please confirm your password!' },
                  ({ getFieldValue }) => ({
                    validator(_, value) {
                      if (!value || getFieldValue('password') === value) {
                        return Promise.resolve();
                      }
                      return Promise.reject(new Error('Confirm password does not match'));
                    },
                  }),
                ]}
              >
                <Input.Password placeholder="******" prefix={<LockOutlined />} />
              </Form.Item>

              <Form.Item>
                <Button type="primary" htmlType="submit" block loading={isSubmitting}>
                  Create account
                </Button>
              </Form.Item>

              <div className="login-links signup">
                <span>Already have an account? </span>
                <a href="/login">Sign in</a>
              </div>
            </Form>
            ) : (
              <>
                <Text>
                  Tai khoan da duoc tao. Ban can xac thuc email truoc khi dang nhap.
                </Text>
                <Divider />
                <Text type="secondary">Email: <strong>{registeredEmail}</strong></Text>
                <div style={{ marginTop: 16 }}>
                  <Button
                    type="primary"
                    block
                    onClick={handleResendVerification}
                    loading={isResending}
                    disabled={cooldownSeconds > 0}
                  >
                    {cooldownSeconds > 0 ? `Resend after ${cooldownSeconds}s` : 'Resend verification link'}
                  </Button>
                </div>
                <div className="login-links signup" style={{ marginTop: 16 }}>
                  <a href="/login">Go to login</a>
                </div>
              </>
            )}
          </Card>
        </div>
      </div>
    </>
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
