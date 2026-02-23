import { Typography } from 'antd';

const { Title, Paragraph } = Typography;

export default function AdminDashboard() {
  return (
    <div>
      <Title level={2}>Admin Dashboard</Title>
      <Paragraph>Use the sidebar to navigate the admin sections.</Paragraph>
    </div>
  );
}