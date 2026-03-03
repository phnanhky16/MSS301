import React, { useState, useEffect } from 'react';
import { useRouter } from 'next/router';
import {
    Rate,
    Button,
    InputNumber,
    Divider,
    Tag,
    Typography,
    Breadcrumb,
    Skeleton,
    Spin,
    message,
    Image as AntImage,
    Carousel
} from 'antd';
import {
    ShoppingCartOutlined,
    HeartOutlined,
    HeartFilled,
    ArrowLeftOutlined,
    SafetyCertificateOutlined,
    ThunderboltOutlined,
    ReloadOutlined
} from '@ant-design/icons';
import Link from 'next/link';
import Layout from '../../components/Layout';
import { fetchProductById } from '../../services/api';
import { useCart } from '../../hooks/useCart';

const { Title, Text, Paragraph } = Typography;

export default function ProductDetailPage() {
    const router = useRouter();
    const { id } = router.query;
    const [product, setProduct] = useState(null);
    const [loading, setLoading] = useState(true);
    const [quantity, setQuantity] = useState(1);
    const [activeImg, setActiveImg] = useState(0);
    const [wished, setWished] = useState(false);
    const { addToCart } = useCart();

    useEffect(() => {
        if (!id) return;
        const loadProduct = async () => {
            setLoading(true);
            try {
                const data = await fetchProductById(id);
                setProduct(data);
            } catch (err) {
                console.error("Failed to load product", err);
                message.error("Failed to load product details");
            } finally {
                setLoading(false);
            }
        };
        loadProduct();
    }, [id]);

    if (loading) {
        return (
            <Layout>
                <div className="product-detail-container" style={{ maxWidth: 1200, margin: '40px auto', padding: '0 20px', textAlign: 'center' }}>
                    <Spin size="large" />
                    <div style={{ marginTop: 16 }}>
                        <Skeleton active aria-label="Loading product details" />
                    </div>
                </div>
            </Layout>
        );
    }

    if (!product) {
        return (
            <Layout>
                <div className="product-detail-container" style={{ maxWidth: 1200, margin: '100px auto', textAlign: 'center' }}>
                    <Title level={2}>Product Not Found</Title>
                    <Link href="/shop">
                        <Button type="primary" icon={<ArrowLeftOutlined />}>Back to Shop</Button>
                    </Link>
                </div>
            </Layout>
        );
    }

    const images = product.imageUrls && product.imageUrls.length > 0 ? product.imageUrls : ['/placeholder-toy.png'];

    const handleAddToCart = () => {
        for (let i = 0; i < quantity; i++) {
            addToCart(product);
        }
        message.success(`Added ${quantity} ${product.name} to cart!`);
    };

    return (
        <div className="product-detail-page" style={{ background: '#fcfcfc', minHeight: '100vh', padding: '20px 0 60px' }}>
            <div className="product-detail-container" style={{ maxWidth: 1280, margin: '0 auto', padding: '0 32px' }}>

                {/* Breadcrumb */}
                <Breadcrumb
                    style={{ marginBottom: 24 }}
                    items={[
                        { title: <Link href="/">Home</Link> },
                        { title: <Link href="/shop">Shop</Link> },
                        {
                            title: product.category ? (
                                <Link href={`/shop?cat=${product.category.id}`}>
                                    {product.category.name}
                                </Link>
                            ) : 'Product'
                        },
                        { title: product.name }
                    ]}
                />

                <div className="product-main-grid" style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 60, alignItems: 'start' }}>

                    {/* Left: Image Gallery */}
                    <div className="product-gallery">
                        <div className="main-image-wrap" style={{
                            background: '#fff',
                            borderRadius: 24,
                            overflow: 'hidden',
                            border: '1px solid #f0f0f0',
                            boxShadow: '0 8px 32px rgba(0,0,0,0.05)',
                            marginBottom: 20,
                            position: 'relative',
                            minHeight: 400,
                            display: 'flex',
                            alignItems: 'center',
                            justifyContent: 'center'
                        }}>
                            {images[activeImg] ? (
                                <AntImage
                                    src={images[activeImg]}
                                    alt={product.name}
                                    style={{ width: '100%', height: 'auto', display: 'block' }}
                                    preview={true}
                                    fallback="data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIxMDAiIGhlaWdodD0iMTAwIiB2aWV3Qm94PSIwIDAgMTAwIDEwMCI+PHRleHQgeD0iNTAiIHk9IjYwIiBmb250LXNpemU9IjUwIiB0ZXh0LWFuY2hvcj0ibWlkZGxlIj7wn6i7PC90ZXh0Pjwvc3ZnPg=="
                                />
                            ) : (
                                <span style={{ fontSize: 100 }}>🧸</span>
                            )}
                            {product.status === 'INACTIVE' && (
                                <Tag color="red" style={{ position: 'absolute', top: 20, left: 20, padding: '4px 12px', fontSize: 14, fontWeight: 700 }}>
                                    OUT OF STOCK
                                </Tag>
                            )}
                        </div>

                        {/* Thumbnails */}
                        {images.length > 1 && (
                            <div className="thumb-row" style={{ display: 'flex', gap: 12, flexWrap: 'wrap' }}>
                                {images.map((img, idx) => (
                                    <div
                                        key={idx}
                                        onClick={() => setActiveImg(idx)}
                                        style={{
                                            width: 80,
                                            height: 80,
                                            borderRadius: 12,
                                            overflow: 'hidden',
                                            cursor: 'pointer',
                                            border: `2px solid ${activeImg === idx ? '#1ca8c8' : '#f0f0f0'}`,
                                            transition: 'all 0.2s',
                                            opacity: activeImg === idx ? 1 : 0.7,
                                            display: 'flex',
                                            alignItems: 'center',
                                            justifyContent: 'center',
                                            background: '#f9f9f9'
                                        }}
                                    >
                                        <img
                                            src={img}
                                            alt={`thumb-${idx}`}
                                            style={{ width: '100%', height: '100%', objectFit: 'cover' }}
                                            onError={(e) => { e.target.outerHTML = '<span style="font-size: 30px">🧸</span>'; }}
                                        />
                                    </div>
                                ))}
                            </div>
                        )}
                    </div>

                    {/* Right: Product Info */}
                    <div className="product-info-column" style={{ display: 'flex', flexDirection: 'column', gap: 24 }}>
                        <div>
                            <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start' }}>
                                <Tag color="blue" style={{ marginBottom: 12, borderRadius: 4, textTransform: 'uppercase', fontWeight: 600 }}>
                                    {product.category?.name || 'General'}
                                </Tag>
                                <Button
                                    type="text"
                                    icon={wished ? <HeartFilled style={{ color: '#ff4d4f' }} /> : <HeartOutlined />}
                                    onClick={() => setWished(!wished)}
                                    style={{ fontSize: 20 }}
                                />
                            </div>
                            <Title level={1} style={{ margin: '4px 0 12px', fontSize: 42, fontWeight: 800, color: '#2d2d2d' }}>
                                {product.name}
                            </Title>
                            <div style={{ display: 'flex', alignItems: 'center', gap: 12, marginBottom: 16 }}>
                                <Rate disabled defaultValue={5} style={{ fontSize: 14, color: '#fab400' }} />
                                <Text type="secondary">(4.8 / 5.0 - 124 reviews)</Text>
                            </div>
                            <Text style={{ fontSize: 32, fontWeight: 700, color: '#1ca8c8' }}>
                                ${product.price?.toFixed(2)}
                            </Text>
                        </div>

                        <Divider style={{ margin: 0 }} />

                        <div>
                            <Title level={5} style={{ marginBottom: 12 }}>Description</Title>
                            <Paragraph style={{ fontSize: 16, color: '#555', lineHeight: 1.8 }}>
                                {product.description || "No description available for this premium toy."}
                            </Paragraph>
                        </div>

                        <div className="product-meta" style={{ display: 'grid', gridTemplateColumns: 'auto 1fr', gap: '8px 24px', fontSize: 14 }}>
                            <Text type="secondary">Brand:</Text>
                            <Text strong>{product.brand?.name || 'KidFavor'}</Text>
                            <Text type="secondary">Availability:</Text>
                            <Text strong style={{ color: product.status === 'ACTIVE' ? '#52c41a' : '#ff4d4f' }}>
                                {product.status === 'ACTIVE' ? 'In Stock' : 'Out of Stock'}
                            </Text>
                            <Text type="secondary">Product Code:</Text>
                            <Text strong>#KF-{product.id?.toString().padStart(4, '0')}</Text>
                        </div>

                        <Divider style={{ margin: 0 }} />

                        <div className="purchase-section" style={{ display: 'flex', alignItems: 'center', gap: 20 }}>
                            <div style={{ display: 'flex', flexDirection: 'column', gap: 8 }}>
                                <Text type="secondary" style={{ fontSize: 12, fontWeight: 600, textTransform: 'uppercase' }}>Quantity</Text>
                                <InputNumber
                                    min={1}
                                    max={99}
                                    value={quantity}
                                    onChange={setQuantity}
                                    size="large"
                                    style={{ width: 100, borderRadius: 8 }}
                                />
                            </div>
                            <Button
                                type="primary"
                                size="large"
                                icon={<ShoppingCartOutlined />}
                                onClick={handleAddToCart}
                                style={{
                                    height: 54,
                                    flex: 1,
                                    borderRadius: 12,
                                    fontSize: 18,
                                    fontWeight: 700,
                                    background: '#fab400',
                                    borderColor: '#fab400',
                                    color: '#333',
                                    boxShadow: '0 4px 12px rgba(250, 180, 0, 0.3)'
                                }}
                                disabled={product.status !== 'ACTIVE'}
                            >
                                Add to Cart
                            </Button>
                        </div>

                        {/* Trust badges */}
                        <div style={{
                            display: 'grid',
                            gridTemplateColumns: 'repeat(3, 1fr)',
                            gap: 16,
                            marginTop: 20,
                            padding: '16px',
                            background: '#f0fafd',
                            borderRadius: 16
                        }}>
                            <div style={{ textAlign: 'center' }}>
                                <SafetyCertificateOutlined style={{ fontSize: 24, color: '#1ca8c8', marginBottom: 4 }} />
                                <div style={{ fontSize: 11, fontWeight: 600 }}>1 Year Warranty</div>
                            </div>
                            <div style={{ textAlign: 'center' }}>
                                <ReloadOutlined style={{ fontSize: 24, color: '#1ca8c8', marginBottom: 4 }} />
                                <div style={{ fontSize: 11, fontWeight: 600 }}>30 Day Returns</div>
                            </div>
                            <div style={{ textAlign: 'center' }}>
                                <ThunderboltOutlined style={{ fontSize: 24, color: '#1ca8c8', marginBottom: 4 }} />
                                <div style={{ fontSize: 11, fontWeight: 600 }}>Fast Shipping</div>
                            </div>
                        </div>
                    </div>
                </div>

                {/* Additional Details Tabs (Mock) */}
                <div style={{ marginTop: 80 }}>
                    <Divider orientation="left"><Title level={3}>Details & Specifications</Title></Divider>
                    <div style={{ background: '#fff', padding: 40, borderRadius: 24, border: '1px solid #f0f0f0' }}>
                        <Paragraph style={{ fontSize: 16 }}>
                            Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.
                        </Paragraph>
                        <Title level={4}>Safety & Materials</Title>
                        <Paragraph>
                            All our toys are made from non-toxic, child-safe materials and meet international safety standards (ASTM, EN71). Recommended for ages 3 and up.
                        </Paragraph>
                    </div>
                </div>
            </div>
        </div>
    );
}
