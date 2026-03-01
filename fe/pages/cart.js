import React from 'react';
import Link from 'next/link';
import { Table, Button, InputNumber, Empty } from 'antd';
import { DeleteOutlined, ShoppingCartOutlined } from '@ant-design/icons';
import { useCart } from '../hooks/useCart';

export default function CartPage() {
    const { cart, addToCart, clearCart, getCartCount } = useCart();

    // Handle quantity change (this is a bit simplified since useCart only has addToCart)
    // For a real app, you'd want a setQuantity function in useCart.
    // I'll add a simple "updateQuantity" to useCart if needed, but for now let's just show.

    const columns = [
        {
            title: 'Product',
            dataIndex: 'name',
            key: 'name',
            render: (text, record) => (
                <div style={{ display: 'flex', alignItems: 'center', gap: '12px' }}>
                    <div style={{ fontSize: '24px', background: '#f5f5f5', padding: '8px', borderRadius: '8px' }}>
                        {record.img}
                    </div>
                    <span style={{ fontWeight: 600 }}>{text}</span>
                </div>
            ),
        },
        {
            title: 'Price',
            dataIndex: 'price',
            key: 'price',
            render: (price) => `$${price.toFixed(2)}`,
        },
        {
            title: 'Quantity',
            dataIndex: 'quantity',
            key: 'quantity',
            render: (qty, record) => (
                <span style={{ fontWeight: 600 }}>{qty}</span>
            ),
        },
        {
            title: 'Subtotal',
            key: 'subtotal',
            render: (_, record) => `$${(record.price * record.quantity).toFixed(2)}`,
        },
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
                                Total: ${total.toFixed(2)}
                            </div>
                            <Button type="primary" size="large" style={{ background: '#1ca8c8', borderColor: '#1ca8c8', padding: '0 40px' }}>
                                Checkout
                            </Button>
                        </div>
                    </div>
                </>
            )}
        </div>
    );
}
