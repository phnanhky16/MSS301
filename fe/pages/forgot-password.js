import { useEffect, useState } from 'react';
import { Card, Typography, Form, Input, Button, message, Divider } from 'antd';
import { MailOutlined, SafetyOutlined } from '@ant-design/icons';
import { useRouter } from 'next/router';
import { requestPasswordResetOtp, verifyPasswordResetOtp } from '../services/auth';

const { Title, Text } = Typography;

export default function ForgotPassword() {
  const router = useRouter();
  const [form] = Form.useForm();
  const [msgApi, msgHolder] = message.useMessage();
  const [step, setStep] = useState(1);
  const [loading, setLoading] = useState(false);
  const [email, setEmail] = useState('');

  useEffect(() => {
    document.documentElement.classList.add('login-page');
    return () => {
      document.documentElement.classList.remove('login-page');
    };
  }, []);

  const handleSendCode = async values => {
    setLoading(true);
    try {
      const normalizedEmail = values.email.trim().toLowerCase();
      await requestPasswordResetOtp(normalizedEmail);
      setEmail(normalizedEmail);
      setStep(2);
      msgApi.success('Ma xac thuc da duoc gui ve Gmail cua ban');
    } catch (err) {
      msgApi.error(parseError(err, 'Khong the gui ma xac thuc'));
    } finally {
      setLoading(false);
    }
  };

  const handleVerifyCode = async values => {
    setLoading(true);
    try {
      await verifyPasswordResetOtp(email, values.verificationCode.trim());
      msgApi.success('Xac thuc thanh cong. Link dat lai mat khau da duoc gui vao mail');
      setStep(3);
    } catch (err) {
      msgApi.error(parseError(err, 'Ma xac thuc khong hop le hoac da het han'));
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
            <Title level={2} className="login-title">Forgot password</Title>

            {step === 1 && (
              <>
                <Text type="secondary">Nhap email dang ky de nhan ma xac thuc.</Text>
                <Divider />
                <Form form={form} layout="vertical" onFinish={handleSendCode}>
                  <Form.Item
                    label="Email"
                    name="email"
                    rules={[
                      { required: true, message: 'Vui long nhap email' },
                      { type: 'email', message: 'Email khong dung dinh dang' },
                    ]}
                  >
                    <Input placeholder="you@example.com" prefix={<MailOutlined />} />
                  </Form.Item>
                  <Form.Item>
                    <Button type="primary" htmlType="submit" block loading={loading}>
                      Gui ma xac thuc
                    </Button>
                  </Form.Item>
                </Form>
              </>
            )}

            {step === 2 && (
              <>
                <Text type="secondary">
                  Ma OTP da gui den <strong>{email}</strong>. Nhap ma de xac thuc email truoc khi nhan link reset.
                </Text>
                <Divider />
                <Form layout="vertical" onFinish={handleVerifyCode}>
                  <Form.Item
                    label="Ma xac thuc (6 so)"
                    name="verificationCode"
                    rules={[
                      { required: true, message: 'Vui long nhap ma xac thuc' },
                      { pattern: /^\d{6}$/, message: 'Ma phai gom dung 6 chu so' },
                    ]}
                  >
                    <Input maxLength={6} placeholder="123456" prefix={<SafetyOutlined />} />
                  </Form.Item>
                  <Form.Item>
                    <Button type="primary" htmlType="submit" block loading={loading}>
                      Xac thuc Gmail
                    </Button>
                  </Form.Item>
                  <Button
                    type="link"
                    block
                    onClick={() => {
                      form.resetFields();
                      setStep(1);
                    }}
                  >
                    Gui lai ma moi
                  </Button>
                </Form>
              </>
            )}

            {step === 3 && (
              <>
                <Text>
                  Email cua ban da duoc xac thuc. Hay kiem tra Gmail de nhan link dat lai mat khau (hieu luc 10 phut).
                </Text>
                <Divider />
                <Button type="primary" block onClick={() => router.push('/login')}>
                  Quay lai dang nhap
                </Button>
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
