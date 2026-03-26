import React from 'react';
import { useRouter } from 'next/router';
import { Result, Button, Card } from 'antd';
import { ShoppingOutlined, HomeOutlined, ReloadOutlined } from '@ant-design/icons';

export default function PaymentCancelPage() {
    const router = useRouter();
    const { orderNumber } = router.query;

    return (
        <div style={{ maxWidth: 600, margin: '60px auto', padding: '0 20px' }}>
            <Card style={{ borderRadius: 16, boxShadow: '0 4px 24px rgba(0,0,0,0.08)' }}>
                <Result
                    status="warning"
                    title="Thanh toán đã bị huỷ"
                    subTitle={
                        orderNumber
                            ? `Đơn hàng ${orderNumber} chưa được thanh toán. Bạn có thể thử lại bất cứ lúc nào.`
                            : 'Bạn đã huỷ thanh toán. Đơn hàng vẫn được lưu và bạn có thể thanh toán sau.'
                    }
                    extra={[
                        <Button
                            type="primary"
                            key="retry"
                            size="large"
                            icon={<ReloadOutlined />}
                            onClick={() => router.push('/cart')}
                            style={{ background: '#1ca8c8', borderColor: '#1ca8c8' }}
                        >
                            Quay lại giỏ hàng
                        </Button>,
                        <Button key="shop" size="large" icon={<ShoppingOutlined />} onClick={() => router.push('/shop')}>
                            Tiếp tục mua sắm
                        </Button>,
                        <Button key="home" icon={<HomeOutlined />} onClick={() => router.push('/')}>
                            Về trang chủ
                        </Button>,
                    ]}
                />
            </Card>
        </div>
    );
}
