import { Form, Input, Button, Typography, message } from 'antd';
import { useRouter } from 'next/router';

import { login } from '../services/auth';

const { Title } = Typography;

export default function Login() {
  const router = useRouter();

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
        // try to display server message if available
        let text = 'Login failed';
        try {
          const parsed = JSON.parse(err.message);
          if (parsed && parsed.message) text = parsed.message;
        } catch (_) {}
        message.error(text);
        console.error('login error', err);
      });
  };

  return (
    <div style={{ maxWidth: 400, margin: '100px auto' }}>
      <Title level={2}>Login</Title>
      <Form name="login" onFinish={onFinish} layout="vertical">
        <Form.Item
          name="username"
          label="Username"
          rules={[{ required: true, message: 'Please input your username!' }]}
        >
          <Input />
        </Form.Item>
        <Form.Item
          name="password"
          label="Password"
          rules={[{ required: true, message: 'Please input your password!' }]}
        >
          <Input.Password />
        </Form.Item>
        <Form.Item>
          <Button type="primary" htmlType="submit" block>
            Log in
          </Button>
        </Form.Item>
      </Form>
    </div>
  );
}