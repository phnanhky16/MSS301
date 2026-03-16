import { useEffect, useMemo, useState } from 'react';
import { Card, Typography, Form, Input, Button, message, Divider } from 'antd';
import { LockOutlined } from '@ant-design/icons';
import { useRouter } from 'next/router';
import { confirmPasswordReset } from '../services/auth';

const { Title, Text } = Typography;

export default function ResetPassword() {
  const router = useRouter();
  const [msgApi, msgHolder] = message.useMessage();
  const [loading, setLoading] = useState(false);

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

  const handleSubmit = async values => {
    if (!token) {
      msgApi.error('Link reset khong hop le');
      return;
    }

    setLoading(true);
    try {
      await confirmPasswordReset(token, values.newPassword, values.confirmPassword);
      msgApi.success('Dat lai mat khau thanh cong. Dang chuyen ve trang dang nhap...');
      setTimeout(() => router.push('/login'), 1500);
    } catch (err) {
      msgApi.error(parseError(err, 'Khong the dat lai mat khau. Link co the da het han'));
    } finally {
      setLoading(false);
    }
  };

  return (
    <>
      {msgHolder}
      <div className="login-wrapper">
        <div className="login-right" />
        <div className="login-left">
          <Card className="login-card" variant="bordered">
            <Title level={2} className="login-title">Reset password</Title>
            {!token ? (
              <>
                <Text type="danger">Link reset khong hop le hoac thieu token.</Text>
                <Divider />
                <Button type="primary" block onClick={() => router.push('/forgot-password')}>
                  Quay lai quen mat khau
                </Button>
              </>
            ) : (
              <Form layout="vertical" onFinish={handleSubmit}>
                <Form.Item
                  label="Mat khau moi"
                  name="newPassword"
                  rules={[
                    { required: true, message: 'Vui long nhap mat khau moi' },
                    { min: 6, message: 'Mat khau toi thieu 6 ky tu' },
                  ]}
                >
                  <Input.Password prefix={<LockOutlined />} placeholder="Nhap mat khau moi" />
                </Form.Item>
                <Form.Item
                  label="Xac nhan mat khau moi"
                  name="confirmPassword"
                  dependencies={['newPassword']}
                  rules={[
                    { required: true, message: 'Vui long xac nhan mat khau moi' },
                    ({ getFieldValue }) => ({
                      validator(_, value) {
                        if (!value || getFieldValue('newPassword') === value) {
                          return Promise.resolve();
                        }
                        return Promise.reject(new Error('Mat khau xac nhan khong khop'));
                      },
                    }),
                  ]}
                >
                  <Input.Password prefix={<LockOutlined />} placeholder="Nhap lai mat khau moi" />
                </Form.Item>
                <Form.Item>
                  <Button type="primary" htmlType="submit" block loading={loading}>
                    Dat lai mat khau
                  </Button>
                </Form.Item>
              </Form>
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
