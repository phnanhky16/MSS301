import { Typography } from 'antd';
const { Title, Paragraph } = Typography;

export default function Home() {
  return (
    <div style={{ padding: '24px' }}>
      <Title>Welcome to KidFavor</Title>
      <Paragraph>This is the home page of your new Next.js frontend.</Paragraph>
    </div>
  );
}