import React from 'react';
import Head from 'next/head';
import Link from 'next/link';
import { Button, Result, Typography, Space } from 'antd';
import { 
  RocketTwoTone, 
  ReloadOutlined, 
  HomeOutlined, 
  CustomerServiceOutlined 
} from '@ant-design/icons';

const { Title, Text, Paragraph } = Typography;

export default function Maintenance() {
  return (
    <div style={{ 
      minHeight: '100vh', 
      display: 'flex', 
      alignItems: 'center', 
      justifyContent: 'center',
      background: 'linear-gradient(135deg, #f0f7f9 0%, #e0f2f7 100%)',
      padding: '24px'
    }}>
      <Head>
        <title>Service Unreachable | Rainbow Toddler</title>
      </Head>

      <div style={{ 
        maxWidth: 600, 
        width: '100%',
        background: 'rgba(255, 255, 255, 0.8)',
        backdropFilter: 'blur(10px)',
        borderRadius: 32,
        padding: '48px 32px',
        boxShadow: '0 20px 40px rgba(28, 168, 200, 0.1)',
        textAlign: 'center',
        border: '1px solid rgba(255, 255, 255, 0.5)'
      }}>
        <Result
          icon={<RocketTwoTone twoToneColor="#1ca8c8" style={{ fontSize: 120 }} />}
          title={
            <Title level={2} style={{ color: '#2d2d2d', fontWeight: 800, marginBottom: 8 }}>
              Oops! Service is Napping 🧸
            </Title>
          }
          subTitle={
            <Space direction="vertical" size="middle" style={{ width: '100%' }}>
              <Paragraph style={{ fontSize: 18, color: '#555', marginBottom: 0 }}>
                Our toy factory is currently over capacity or undergoing a quick cleanup! 
              </Paragraph>
              <Text type="secondary" style={{ fontSize: 14 }}>
                (Error 503: Service Temporarily Unavailable)
              </Text>
            </Space>
          }
          extra={[
            <div key="actions" style={{ marginTop: 24, display: 'flex', flexDirection: 'column', gap: 16 }}>
              <Button 
                type="primary" 
                size="large" 
                icon={<ReloadOutlined />}
                onClick={() => window.location.reload()}
                style={{ 
                  height: 56, 
                  borderRadius: 16, 
                  fontSize: 18, 
                  fontWeight: 600,
                  background: 'linear-gradient(90deg, #1ca8c8 0%, #178ea9 100%)',
                  border: 'none',
                  boxShadow: '0 8px 16px rgba(28, 168, 200, 0.2)'
                }}
              >
                Try Again
              </Button>
              
              <div style={{ display: 'flex', gap: 12, justifyContent: 'center' }}>
                <Link href="/" passHref>
                  <Button 
                    icon={<HomeOutlined />} 
                    size="large" 
                    style={{ borderRadius: 12, flex: 1 }}
                  >
                    Back Home
                  </Button>
                </Link>
                <Button 
                  icon={<CustomerServiceOutlined />} 
                  size="large" 
                  style={{ borderRadius: 12, flex: 1 }}
                >
                  Contact Us
                </Button>
              </div>
            </div>
          ]}
        />
        
        <div style={{ marginTop: 48, paddingTop: 32, borderTop: '1px solid #eee' }}>
          <Text type="secondary" style={{ fontStyle: 'italic' }}>
            We'll be back in a jiffy. Thanks for your patience! ✨
          </Text>
        </div>
      </div>

      <style jsx global>{`
        @keyframes float {
          0% { transform: translateY(0px); }
          50% { transform: translateY(-10px); }
          100% { transform: translateY(0px); }
        }
        .ant-result-icon {
          animation: float 3s ease-in-out infinite;
          margin-bottom: 32px !important;
        }
      `}</style>
    </div>
  );
}
