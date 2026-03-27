import React from 'react';
import Link from 'next/link';
import { useRouter } from 'next/router';
import { Table, Button, InputNumber, Empty } from 'antd';
import { DeleteOutlined, ShoppingCartOutlined } from '@ant-design/icons';
import { useCart } from '../hooks/useCart';
import { formatVnd } from '../utils/currency';

export default function CartPage() {
    const router = useRouter();
    const { cart, updateQuantity, removeFromCart, clearCart, getCartCount } = useCart();

    const columns = [
        {
            title: 'Product',
            dataIndex: 'name',
            key: 'name',
            render: (text, record) => (
                <div style={{ display: 'flex', alignItems: 'center', gap: '12px' }}>
                    <div style={{ fontSize: '24px', background: '#f5f5f5', padding: '8px', borderRadius: '8px' }}>
                        {record.imageUrls && record.imageUrls.length > 0 ? (
                            <img
                                src={record.imageUrls[0]}
                                alt={record.name}
                                style={{ width: 40, height: 40, objectFit: 'cover', borderRadius: 8 }}
                            />
                        ) : (
                            record.img || '🧸'
                        )}
                    </div>
                    <span style={{ fontWeight: 600 }}>{text}</span>
                </div>
            ),
        },
        {
            title: 'Price',
            dataIndex: 'price',
            key: 'price',
            render: (price, record) => (
                <div>
                    {record.onSale && record.originalPrice && (
                        <div style={{ fontSize: '12px', color: '#999', textDecoration: 'line-through' }}>
                            {formatVnd(record.originalPrice)}
                        </div>
                    )}
                    <div style={{ fontSize: '14px', fontWeight: 'bold', color: record.onSale ? '#ff4d4f' : '#000' }}>
                        {formatVnd(price)}
                    </div>
                    {record.onSale && record.originalPrice && (
                        <div style={{ fontSize: '11px', color: '#ff4d4f' }}>
                            -
                            {Math.round(
                                ((record.originalPrice - price) / record.originalPrice) * 100
                            )}
                            %
                        </div>
                    )}
                </div>
            ),
        },
        {
            title: 'Quantity',
            dataIndex: 'quantity',
            key: 'quantity',
            render: (qty, record) => (
                <InputNumber
                    min={1}
                    value={qty}
                    onChange={(value) => updateQuantity(record.id, Number(value || 1))}
                />
            ),
        },
        {
            title: 'Subtotal',
            key: 'subtotal',
            render: (_, record) => formatVnd(record.price * record.quantity),
        },
        {
            title: 'Action',
            key: 'action',
            render: (_, record) => (
                <Button danger type="link" onClick={() => removeFromCart(record.id)}>
                    Remove
                </Button>
            ),
        }
    ];

    const total = cart.reduce((acc, item) => acc + item.price * item.quantity, 0);

    return (
        <div className="cart-page" style={{ maxWidth: '1000px', margin: '40px auto', padding: '0 20px' }}>
            <h1 style={{ fontSize: '32px', fontWeight: 800, marginBottom: '24px' }}>
                <ShoppingCartOutlined /> Your Shopping Cart
            </h1>

            {cart.length === 0 ? (
                <Empty
                    description="Your cart is empty"
                    image={Empty.PRESENTED_IMAGE_SIMPLE}
                >
                    <Link href="/shop">
                        <Button type="primary" size="large" style={{ background: '#1ca8c8', borderColor: '#1ca8c8' }}>
                            Go Shopping
                        </Button>
                    </Link>
                </Empty>
            ) : (
                <>
                    <Table
                        dataSource={cart}
                        columns={columns}
                        pagination={false}
                        rowKey="id"
                        style={{ marginBottom: '24px' }}
                    />

                    <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start', background: '#f9f9f9', padding: '24px', borderRadius: '12px' }}>
                        <div>
                            <Button danger onClick={clearCart} icon={<DeleteOutlined />}>
                                Clear Cart
                            </Button>
                        </div>
                        <div style={{ textAlign: 'right' }}>
                            <div style={{ fontSize: '18px', marginBottom: '8px' }}>
                                Total Items: <strong>{getCartCount()}</strong>
                            </div>
                            <div style={{ fontSize: '24px', fontWeight: 800, color: '#1ca8c8', marginBottom: '24px' }}>
                                Total: {formatVnd(total)}
                            </div>
                            <Button
                                type="primary"
                                size="large"
                                style={{ background: '#1ca8c8', borderColor: '#1ca8c8', padding: '0 40px' }}
                                onClick={() => router.push('/checkout')}
                            >
                                Checkout
                            </Button>
                        </div>
                    </div>
                </>
            )}
        </div>
    );
}
