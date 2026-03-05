import React, { useState, useEffect } from 'react';
import { useRouter } from 'next/router';
import {
    Form, Input, Button, Select, Steps, Divider,
    Card, Typography, Row, Col, Table, Tag, message, Spin, Space
} from 'antd';
import {
    ShoppingCartOutlined, EnvironmentOutlined,
    CheckCircleOutlined, CreditCardOutlined, ArrowLeftOutlined
} from '@ant-design/icons';
import { useCart } from '../hooks/useCart';
import { fetchProvinces, fetchDistricts, fetchWards, request } from '../services/api';
import Link from 'next/link';

const { Title, Text } = Typography;
const { Option } = Select;
const { Step } = Steps;

export default function CheckoutPage() {
    const router = useRouter();
    const { cart, clearCart } = useCart();
    const [form] = Form.useForm();

    // ── Address data ──────────────────────────────────────────
    const [provinces, setProvinces] = useState([]);
    const [districts, setDistricts] = useState([]);
    const [wards, setWards] = useState([]);

    // ── Selection state ───────────────────────────────────────
    const [selectedProvince, setSelectedProvince] = useState(null);
    const [selectedDistrict, setSelectedDistrict] = useState(null);
    const [selectedProvinceName, setSelectedProvinceName] = useState('');
    const [selectedDistrictName, setSelectedDistrictName] = useState('');
    const [selectedWardName, setSelectedWardName] = useState('');

    // ── Loading states ────────────────────────────────────────
    const [loadingProvinces, setLoadingProvinces] = useState(true);
    const [loadingDistricts, setLoadingDistricts] = useState(false);
    const [loadingWards, setLoadingWards] = useState(false);
    const [submitting, setSubmitting] = useState(false);
    const [currentStep, setCurrentStep] = useState(0);

    // ── Load provinces on mount ───────────────────────────────
    useEffect(() => {
        fetchProvinces()
            .then(setProvinces)
            .catch(() => message.error('Không thể tải danh sách tỉnh/thành'))
            .finally(() => setLoadingProvinces(false));
    }, []);

    // ── Province change handler ───────────────────────────────
    const handleProvinceChange = async (provinceId, option) => {
        setSelectedProvince(provinceId);
        setSelectedProvinceName(option.children);
        setDistricts([]);
        setWards([]);
        form.setFieldsValue({ district: undefined, ward: undefined });
        setLoadingDistricts(true);
        try {
            const data = await fetchDistricts(provinceId);
            setDistricts(data);
        } catch {
            message.error('Không thể tải danh sách quận/huyện');
        } finally {
            setLoadingDistricts(false);
        }
    };

    // ── District change handler ───────────────────────────────
    const handleDistrictChange = async (districtId, option) => {
        setSelectedDistrict(districtId);
        setSelectedDistrictName(option.children);
        setWards([]);
        form.setFieldsValue({ ward: undefined });
        setLoadingWards(true);
        try {
            const data = await fetchWards(districtId);
            setWards(data);
        } catch {
            message.error('Không thể tải danh sách phường/xã');
        } finally {
            setLoadingWards(false);
        }
    };

    // ── Ward change handler ───────────────────────────────────
    const handleWardChange = (_, option) => {
        setSelectedWardName(option.children);
    };

    // ── Order total ───────────────────────────────────────────
    const total = cart.reduce((acc, item) => acc + item.price * item.quantity, 0);

    // ── Submit ────────────────────────────────────────────────
    const handleSubmit = async (values) => {
        if (cart.length === 0) {
            message.warning('Giỏ hàng của bạn đang trống!');
            return;
        }
        setSubmitting(true);
        try {
            const shippingAddress = [
                values.streetAddress,
                selectedWardName,
                selectedDistrictName,
                selectedProvinceName
            ].filter(Boolean).join(', ');

            const orderPayload = {
                shippingAddress,
                recipientName: values.fullName,
                recipientPhone: values.phone,
                note: values.note || '',
                items: cart.map(item => ({
                    productId: item.id,
                    productName: item.name,
                    quantity: item.quantity,
                    price: item.price,
                })),
                totalAmount: total,
            };

            await request('/orders', {
                method: 'POST',
                body: JSON.stringify(orderPayload),
            });

            clearCart();
            setCurrentStep(2);
            message.success('🎉 Đặt hàng thành công!');
        } catch (err) {
            message.error('Đặt hàng thất bại: ' + err.message);
        } finally {
            setSubmitting(false);
        }
    };

    // ── Cart summary columns ──────────────────────────────────
    const cartColumns = [
        {
            title: 'Sản phẩm',
            dataIndex: 'name',
            key: 'name',
            render: (name, record) => (
                <div style={{ display: 'flex', alignItems: 'center', gap: 8 }}>
                    <div style={{ fontSize: 20, background: '#f5f5f5', padding: '4px 8px', borderRadius: 6 }}>
                        {record.img || '🧸'}
                    </div>
                    <Text strong style={{ fontSize: 13 }}>{name}</Text>
                </div>
            ),
        },
        {
            title: 'SL',
            dataIndex: 'quantity',
            key: 'qty',
            width: 50,
            align: 'center',
            render: qty => <Tag color="blue">x{qty}</Tag>,
        },
        {
            title: 'Thành tiền',
            key: 'subtotal',
            align: 'right',
            render: (_, r) => (
                <Text strong style={{ color: '#1ca8c8' }}>
                    ${(r.price * r.quantity).toFixed(2)}
                </Text>
            ),
        },
    ];

    // ── Success screen ────────────────────────────────────────
    if (currentStep === 2) {
        return (
            <div style={styles.successWrapper}>
                <div style={styles.successCard}>
                    <CheckCircleOutlined style={{ fontSize: 72, color: '#52c41a', marginBottom: 16 }} />
                    <Title level={2}>Đặt hàng thành công! 🎉</Title>
                    <Text type="secondary" style={{ fontSize: 16 }}>
                        Cảm ơn bạn đã mua sắm tại Rainbow Toddler. Chúng tôi sẽ xử lý đơn hàng của bạn sớm nhất có thể.
                    </Text>
                    <div style={{ marginTop: 32, display: 'flex', gap: 12, justifyContent: 'center' }}>
                        <Button
                            type="primary"
                            size="large"
                            style={styles.primaryBtn}
                            onClick={() => router.push('/shop')}
                        >
                            Tiếp tục mua sắm
                        </Button>
                        <Button size="large" onClick={() => router.push('/')}>
                            Về trang chủ
                        </Button>
                    </div>
                </div>
            </div>
        );
    }

    return (
        <div style={styles.page}>
            {/* ── Header ── */}
            <div style={styles.header}>
                <Link href="/cart">
                    <Button icon={<ArrowLeftOutlined />} type="text" style={{ marginRight: 12 }}>
                        Quay lại giỏ hàng
                    </Button>
                </Link>
                <Title level={2} style={{ margin: 0 }}>
                    <CreditCardOutlined style={{ marginRight: 8, color: '#1ca8c8' }} />
                    Thanh toán
                </Title>
            </div>

            {/* ── Steps ── */}
            <Steps current={currentStep} style={{ marginBottom: 32 }} onChange={setCurrentStep}>
                <Step title="Giỏ hàng" icon={<ShoppingCartOutlined />} />
                <Step title="Thông tin giao hàng" icon={<EnvironmentOutlined />} />
                <Step title="Hoàn tất" icon={<CheckCircleOutlined />} />
            </Steps>

            <Row gutter={[24, 24]}>
                {/* ────── LEFT: Address Form ────── */}
                <Col xs={24} lg={14}>
                    <Card title={<span><EnvironmentOutlined style={{ color: '#1ca8c8', marginRight: 8 }} />Thông tin giao hàng</span>} style={styles.card}>
                        <Form
                            form={form}
                            layout="vertical"
                            onFinish={handleSubmit}
                            requiredMark="optional"
                        >
                            {/* Full name */}
                            <Form.Item
                                label="Họ và tên người nhận"
                                name="fullName"
                                rules={[{ required: true, message: 'Vui lòng nhập họ tên' }]}
                            >
                                <Input size="large" placeholder="Nguyễn Văn A" />
                            </Form.Item>

                            {/* Phone */}
                            <Form.Item label="Số điện thoại" style={{ marginBottom: 0 }}>
                                <Space.Compact style={{ width: '100%' }}>
                                    <Input
                                        size="large"
                                        style={{ width: 72, textAlign: 'center', flexShrink: 0, color: '#595959', background: '#fafafa', cursor: 'default' }}
                                        value="+84"
                                        readOnly
                                        tabIndex={-1}
                                    />
                                    <Form.Item
                                        name="phone"
                                        noStyle
                                        rules={[
                                            { required: true, message: 'Vui lòng nhập số điện thoại' },
                                            { pattern: /^[0-9]{9,12}$/, message: 'Số điện thoại không hợp lệ' }
                                        ]}
                                    >
                                        <Input size="large" placeholder="0912 345 678" style={{ flex: 1 }} />
                                    </Form.Item>
                                </Space.Compact>
                            </Form.Item>

                            <Divider style={{ margin: '12px 0' }}>
                                <Text type="secondary" style={{ fontSize: 12 }}>Địa chỉ nhận hàng</Text>
                            </Divider>

                            {/* Province */}
                            <Form.Item
                                label="Tỉnh / Thành phố"
                                name="province"
                                rules={[{ required: true, message: 'Vui lòng chọn tỉnh/thành' }]}
                            >
                                <Select
                                    size="large"
                                    placeholder={loadingProvinces ? 'Đang tải...' : 'Chọn Tỉnh / Thành phố'}
                                    loading={loadingProvinces}
                                    showSearch
                                    filterOption={(input, option) =>
                                        option.children.toLowerCase().includes(input.toLowerCase())
                                    }
                                    onChange={handleProvinceChange}
                                    notFoundContent={loadingProvinces ? <Spin size="small" /> : 'Không tìm thấy'}
                                >
                                    {provinces.map(p => (
                                        <Option key={p.id} value={p.id}>{p.name}</Option>
                                    ))}
                                </Select>
                            </Form.Item>
                            <Form.Item
                                label="Quận / Huyện"
                                name="district"
                                rules={[{ required: true, message: 'Vui lòng chọn quận/huyện' }]}
                            >
                                <Select
                                    size="large"
                                    placeholder={
                                        !selectedProvince
                                            ? 'Chọn tỉnh/thành trước'
                                            : loadingDistricts
                                                ? 'Đang tải...'
                                                : 'Chọn Quận / Huyện'
                                    }
                                    disabled={!selectedProvince}
                                    loading={loadingDistricts}
                                    showSearch
                                    filterOption={(input, option) =>
                                        option.children.toLowerCase().includes(input.toLowerCase())
                                    }
                                    onChange={handleDistrictChange}
                                    notFoundContent={loadingDistricts ? <Spin size="small" /> : 'Không tìm thấy'}
                                >
                                    {districts.map(d => (
                                        <Option key={d.id} value={d.id}>{d.name}</Option>
                                    ))}
                                </Select>
                            </Form.Item>

                            {/* Ward */}
                            <Form.Item
                                label="Phường / Xã"
                                name="ward"
                                rules={[{ required: true, message: 'Vui lòng chọn phường/xã' }]}
                            >
                                <Select
                                    size="large"
                                    placeholder={
                                        !selectedDistrict
                                            ? 'Chọn quận/huyện trước'
                                            : loadingWards
                                                ? 'Đang tải...'
                                                : 'Chọn Phường / Xã'
                                    }
                                    disabled={!selectedDistrict || (wards.length === 0 && !loadingWards)}
                                    loading={loadingWards}
                                    showSearch
                                    filterOption={(input, option) =>
                                        option.children.toLowerCase().includes(input.toLowerCase())
                                    }
                                    onChange={handleWardChange}
                                    notFoundContent={loadingWards ? <Spin size="small" /> : 'Không tìm thấy'}
                                >
                                    {wards.map(w => (
                                        <Option key={w.id} value={w.id}>{w.name}</Option>
                                    ))}
                                </Select>
                            </Form.Item>

                            {/* Street address */}
                            <Form.Item
                                label="Số nhà / Tên đường"
                                name="streetAddress"
                                rules={[{ required: true, message: 'Vui lòng nhập địa chỉ cụ thể' }]}
                            >
                                <Input size="large" placeholder="123 Đường Nguyễn Huệ" />
                            </Form.Item>

                            {/* Note */}
                            <Form.Item label="Ghi chú (tùy chọn)" name="note">
                                <Input.TextArea
                                    rows={3}
                                    placeholder="Giao hàng giờ hành chính, gọi trước khi giao..."
                                />
                            </Form.Item>

                            <Button
                                type="primary"
                                size="large"
                                htmlType="submit"
                                loading={submitting}
                                block
                                style={styles.primaryBtn}
                                icon={<CheckCircleOutlined />}
                            >
                                {submitting ? 'Đang đặt hàng...' : 'Xác nhận đặt hàng'}
                            </Button>
                        </Form>
                    </Card>
                </Col>

                {/* ────── RIGHT: Order Summary ────── */}
                <Col xs={24} lg={10}>
                    <Card
                        title={<span><ShoppingCartOutlined style={{ color: '#1ca8c8', marginRight: 8 }} />Tóm tắt đơn hàng</span>}
                        style={{ ...styles.card, position: 'sticky', top: 24 }}
                    >
                        {cart.length === 0 ? (
                            <div style={{ textAlign: 'center', padding: '24px 0' }}>
                                <Text type="secondary">Giỏ hàng trống</Text>
                                <br />
                                <Link href="/shop">
                                    <Button type="link">Đi mua sắm ngay</Button>
                                </Link>
                            </div>
                        ) : (
                            <>
                                <Table
                                    dataSource={cart}
                                    columns={cartColumns}
                                    pagination={false}
                                    rowKey="id"
                                    size="small"
                                    style={{ marginBottom: 16 }}
                                />
                                <Divider style={{ margin: '12px 0' }} />

                                <div style={styles.summaryRow}>
                                    <Text type="secondary">Tạm tính:</Text>
                                    <Text>${total.toFixed(2)}</Text>
                                </div>
                                <div style={styles.summaryRow}>
                                    <Text type="secondary">Phí giao hàng:</Text>
                                    <Tag color="green">Miễn phí</Tag>
                                </div>
                                <Divider style={{ margin: '12px 0' }} />
                                <div style={{ ...styles.summaryRow, marginTop: 4 }}>
                                    <Text strong style={{ fontSize: 16 }}>Tổng cộng:</Text>
                                    <Text strong style={{ fontSize: 20, color: '#1ca8c8' }}>
                                        ${total.toFixed(2)}
                                    </Text>
                                </div>

                                {/* Address preview */}
                                {selectedProvinceName && (
                                    <div style={styles.addressPreview}>
                                        <Text type="secondary" style={{ fontSize: 12 }}>
                                            <EnvironmentOutlined style={{ marginRight: 4 }} />
                                            Giao đến: {[selectedWardName, selectedDistrictName, selectedProvinceName].filter(Boolean).join(', ')}
                                        </Text>
                                    </div>
                                )}
                            </>
                        )}
                    </Card>
                </Col>
            </Row>
        </div>
    );
}

// ── Inline styles ─────────────────────────────────────────────────────────────

const styles = {
    page: {
        maxWidth: 1100,
        margin: '0 auto',
        padding: '32px 20px 60px',
    },
    header: {
        display: 'flex',
        alignItems: 'center',
        marginBottom: 24,
    },
    card: {
        borderRadius: 12,
        boxShadow: '0 2px 12px rgba(0,0,0,0.06)',
    },
    primaryBtn: {
        background: '#1ca8c8',
        borderColor: '#1ca8c8',
        height: 48,
        fontSize: 16,
        fontWeight: 600,
    },
    summaryRow: {
        display: 'flex',
        justifyContent: 'space-between',
        alignItems: 'center',
        marginBottom: 8,
    },
    addressPreview: {
        marginTop: 16,
        padding: '10px 12px',
        background: '#f0fafb',
        borderRadius: 8,
        border: '1px dashed #1ca8c8',
    },
    successWrapper: {
        minHeight: '80vh',
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'center',
        padding: '40px 20px',
    },
    successCard: {
        textAlign: 'center',
        maxWidth: 520,
        padding: '48px 32px',
        background: '#fff',
        borderRadius: 16,
        boxShadow: '0 4px 24px rgba(0,0,0,0.1)',
    },
};
