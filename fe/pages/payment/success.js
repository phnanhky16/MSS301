import React, { useEffect, useState } from 'react';
import { useRouter } from 'next/router';
import { Result, Button, Card, Descriptions, Spin, Typography } from 'antd';
import { CheckCircleOutlined, ShoppingOutlined, HomeOutlined } from '@ant-design/icons';
import { request } from '../../services/api';

const { Text } = Typography;

export default function PaymentSuccessPage() {
    const router = useRouter();
    const { orderNumber } = router.query;
    const [paymentInfo, setPaymentInfo] = useState(null);
    const [loading, setLoading] = useState(true);

    useEffect(() => {
        if (!orderNumber) return;
        request(`/payments/${orderNumber}`)
            .then(data => setPaymentInfo(data))
            .catch(() => { })
            .finally(() => setLoading(false));
    }, [orderNumber]);

    if (loading && orderNumber) {
        return (
            <div style={{ display: 'flex', justifyContent: 'center', alignItems: 'center', minHeight: '60vh' }}>
                <Spin size="large" tip="Đang xác nhận thanh toán..." />
            </div>
        );
    }

    return (
        <div style={{ maxWidth: 600, margin: '60px auto', padding: '0 20px' }}>
            <Card style={{ borderRadius: 16, boxShadow: '0 4px 24px rgba(0,0,0,0.08)' }}>
                <Result
                    icon={<CheckCircleOutlined style={{ color: '#52c41a' }} />}
                    status="success"
                    title="Thanh toán thành công! 🎉"
                    subTitle={
                        orderNumber
                            ? `Đơn hàng ${orderNumber} đã được thanh toán.`
                            : 'Cảm ơn bạn đã thanh toán.'
                    }
                    extra={[
                        <Button
                            type="primary"
                            key="shop"
                            size="large"
                            icon={<ShoppingOutlined />}
                            onClick={() => router.push('/shop')}
                            style={{ background: '#1ca8c8', borderColor: '#1ca8c8' }}
                        >
                            Tiếp tục mua sắm
                        </Button>,
                        <Button key="home" size="large" icon={<HomeOutlined />} onClick={() => router.push('/')}>
                            Về trang chủ
                        </Button>,
                    ]}
                />

                {paymentInfo && (
                    <Descriptions bordered size="small" column={1} style={{ marginTop: 16 }}>
                        <Descriptions.Item label="Mã đơn hàng">{paymentInfo.orderNumber}</Descriptions.Item>
                        <Descriptions.Item label="Số tiền">
                            <Text strong style={{ color: '#52c41a' }}>
                                {paymentInfo.amount?.toLocaleString('vi-VN')} ₫
                            </Text>
                        </Descriptions.Item>
                        <Descriptions.Item label="Trạng thái">
                            <Text strong style={{ color: '#52c41a' }}>
                                {paymentInfo.status === 'PAID' ? '✅ Đã thanh toán' : paymentInfo.status}
                            </Text>
                        </Descriptions.Item>
                        {paymentInfo.transactionReference && (
                            <Descriptions.Item label="Mã giao dịch">{paymentInfo.transactionReference}</Descriptions.Item>
                        )}
                    </Descriptions>
                )}
            </Card>
        </div>
    );
}
