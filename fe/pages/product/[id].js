import React, { useState, useEffect, useRef } from 'react';
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
    Image as AntImage,
    Carousel,
    Pagination,
    Avatar,
    Space,
    Radio,
    App as AntApp
} from 'antd';
import {
    ShoppingCartOutlined,
    HeartOutlined,
    HeartFilled,
    ArrowLeftOutlined,
    SafetyCertificateOutlined,
    ThunderboltOutlined,
    ReloadOutlined,
    LeftOutlined,
    RightOutlined,
    UserOutlined,
    FilterOutlined,
    EnvironmentOutlined
} from '@ant-design/icons';
import Link from 'next/link';
import Layout from '../../components/Layout';
import { fetchProductById, fetchProductReviews, fetchProductAverageRating, fetchNearestStores } from '../../services/api';
import { useCart } from '../../hooks/useCart';
import dayjs from 'dayjs';

const { Title, Text, Paragraph } = Typography;

export default function ProductDetailPage() {
    const { message } = AntApp.useApp();
    const router = useRouter();
    const { id } = router.query;
    const [product, setProduct] = useState(null);
    const [loading, setLoading] = useState(true);
    const [quantity, setQuantity] = useState(1);
    const [activeImg, setActiveImg] = useState(0);
    const [wished, setWished] = useState(false);
    const { addToCart } = useCart();
    // ref to scrolling panel so we can page-scroll two items at a time
    const scrollContainerRef = useRef(null);
    // computed height used for container so exactly two items are visible
    const [containerHeight, setContainerHeight] = useState(140);

    // Nearest Store Feature States
    const [nearestStores, setNearestStores] = useState(null);
    const [findingLocation, setFindingLocation] = useState(false);

    // Review States
    const [reviews, setReviews] = useState([]);
    const [avgRatingData, setAvgRatingData] = useState({ averageRating: 0, totalReviews: 0 });
    const [reviewPage, setReviewPage] = useState(0);
    const [totalElements, setTotalElements] = useState(0);
    // ratingFilter is either a number 1–5 or an empty string ("all").
    // using `null` here would put `value={null}` on the underlying
    // <input> of the Antd Radio component and React complains about that
    // during render. an empty string avoids the warning.
    const [ratingFilter, setRatingFilter] = useState('');
    const [reviewsLoading, setReviewsLoading] = useState(false);

    useEffect(() => {
        if (!id) return;
        const loadProduct = async () => {
            setLoading(true);
            try {
                const [productData, ratingData] = await Promise.all([
                    fetchProductById(id),
                    fetchProductAverageRating(id)
                ]);
                setProduct(productData);
                setAvgRatingData(ratingData);
            } catch (err) {
                console.error("Failed to load product", err);
                message.error("Failed to load product details");
            } finally {
                setLoading(false);
            }
        };
        loadProduct();
    }, [id]);

    useEffect(() => {
        if (!id) return;
        const loadReviews = async () => {
            setReviewsLoading(true);
            try {
                // convert '' back to null for the API (meaning "no filter")
                const filter = ratingFilter === '' ? null : ratingFilter;
                const data = await fetchProductReviews(id, reviewPage, 5, filter);
                setReviews(data.content || []);
                setTotalElements(data.totalElements || 0);
            } catch (err) {
                console.error("Failed to load reviews", err);
            } finally {
                setReviewsLoading(false);
            }
        };
        loadReviews();
    }, [id, reviewPage, ratingFilter]);

    // when product (and therefore storeStocks) updates, measure item height
    useEffect(() => {
        if (!scrollContainerRef.current) return;
        const sc = scrollContainerRef.current;
        const first = sc.children[0];
        if (first) {
            const style = getComputedStyle(first);
            const itemHeight = first.offsetHeight + parseInt(style.marginBottom);
            // two items plus container padding
            const padding = 8 * 2 + 12 * 2; // vertical + horizontal padding; horizontal only influences width
            setContainerHeight(itemHeight * 2 + 16); // add small fudge for rounding
        }
    }, [product]);

    // the top-level Layout is already provided by _app.js; wrapping
    // ourselves again caused the double‑header flash during the initial
    // render. simply return the page content here and let the app shell
    // render the header/footer once.

    if (loading) {
        return (
            <div className="product-detail-container" style={{ maxWidth: 1200, margin: '40px auto', padding: '0 20px', textAlign: 'center' }}>
                <Spin size="large" />
                <div style={{ marginTop: 16 }}>
                    <Skeleton active aria-label="Loading product details" />
                </div>
            </div>
        );
    }

    if (!product) {
        return (
            <div className="product-detail-container" style={{ maxWidth: 1200, margin: '100px auto', textAlign: 'center' }}>
                <Title level={2}>Product Not Found</Title>
                <Button
                    type="primary"
                    icon={<ArrowLeftOutlined />}
                    onClick={() => router.back()}
                >
                    Back to Shop
                </Button>
            </div>
        );
    }

    const images = product.imageUrls && product.imageUrls.length > 0 ? product.imageUrls : ['/placeholder-toy.png'];

    const handleAddToCart = () => {
        for (let i = 0; i < quantity; i++) {
            addToCart(product);
        }
        message.success(`Added ${quantity} ${product.name} to cart!`);
    };

    const handleFindNearestStore = () => {
        if (!navigator.geolocation) {
            message.error("Geolocation is not supported by your browser");
            return;
        }

        setFindingLocation(true);
        navigator.geolocation.getCurrentPosition(
            async (position) => {
                const { latitude, longitude } = position.coords;
                try {
                    const result = await fetchNearestStores(latitude, longitude, id);
                    if (result && result.length > 0) {
                        setNearestStores(result);
                        message.success(`Tìm thấy ${result.length} cửa hàng gần bạn!`);
                    } else {
                        setNearestStores([]);
                        message.warning("Không tìm thấy cửa hàng nào gần bạn có sản phẩm này.");
                    }
                } catch (err) {
                    console.error("Failed to fetch nearest stores", err);
                    message.error("Có lỗi xảy ra khi tìm cửa hàng gần bạn.");
                } finally {
                    setFindingLocation(false);
                }
            },
            (err) => {
                console.error("Geolocation error", err);
                message.error("Không thể lấy vị trí hiện tại của bạn. Vui lòng cho phép quyền truy cập vị trí.");
                setFindingLocation(false);
            }
        );
    };

    return (
        <div className="product-detail-page" style={{ background: '#fcfcfc', minHeight: '100vh', padding: '20px 0 60px' }}>
            <div className="product-detail-container" style={{ maxWidth: 1280, margin: '0 auto', padding: '0 32px' }}>

                {/* Breadcrumb */}
                <Breadcrumb
                    style={{ marginBottom: 24 }}
                    items={[
                        { title: <Link href="/">Home</Link> },
                        {
                            title: (
                                <a
                                    onClick={(e) => {
                                        e.preventDefault();
                                        router.back();
                                    }}
                                    style={{ cursor: 'pointer' }}
                                >
                                    Shop
                                </a>
                            )
                        },

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
                            width: '100%',
                            aspectRatio: '1/1',
                            display: 'flex',
                            alignItems: 'center',
                            justifyContent: 'center'
                        }}>
                            {images[activeImg] ? (
                                <AntImage
                                    src={images[activeImg]}
                                    alt={product.name}
                                    style={{
                                        width: '100%',
                                        height: '100%',
                                        objectFit: 'contain',
                                        display: 'block'
                                    }}
                                    preview={true}
                                    fallback="data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIxMDAiIGhlaWdodD0iMTAwIiB2aWV3Qm94PSIwIDAgMTAwIDEwMCI+PHRleHQgeD0iNTAiIHk9IjYwIiBmb250LXNpemU9IjUwIiB0ZXh0LWFuY2hvcj0ibWlkZGxlIj7wn6i7PC90ZXh0Pjwvc3ZnPg=="
                                />
                            ) : (
                                <span style={{ fontSize: 100 }}>🧸</span>
                            )}
                            {product.status === 'INACTIVE' && (
                                <Tag color="red" style={{ position: 'absolute', top: 20, left: 20, padding: '4px 12px', fontSize: 14, fontWeight: 700, zIndex: 10 }}>
                                    OUT OF STOCK
                                </Tag>
                            )}

                            {/* Navigation Arrows */}
                            {images.length > 1 && (
                                <>
                                    <Button
                                        shape="circle"
                                        icon={<LeftOutlined />}
                                        onClick={(e) => {
                                            e.stopPropagation();
                                            setActiveImg((prev) => (prev === 0 ? images.length - 1 : prev - 1));
                                        }}
                                        style={{
                                            position: 'absolute',
                                            left: 15,
                                            zIndex: 10,
                                            background: 'rgba(255,255,255,0.8)',
                                            border: 'none',
                                            boxShadow: '0 2px 8px rgba(0,0,0,0.1)'
                                        }}
                                    />
                                    <Button
                                        shape="circle"
                                        icon={<RightOutlined />}
                                        onClick={(e) => {
                                            e.stopPropagation();
                                            setActiveImg((prev) => (prev === images.length - 1 ? 0 : prev + 1));
                                        }}
                                        style={{
                                            position: 'absolute',
                                            right: 15,
                                            zIndex: 10,
                                            background: 'rgba(255,255,255,0.8)',
                                            border: 'none',
                                            boxShadow: '0 2px 8px rgba(0,0,0,0.1)'
                                        }}
                                    />
                                    {/* Image Counter Badge */}
                                    <Tag
                                        style={{
                                            position: 'absolute',
                                            bottom: 15,
                                            right: 15,
                                            margin: 0,
                                            background: 'rgba(0,0,0,0.4)',
                                            color: '#fff',
                                            border: 'none',
                                            borderRadius: 20,
                                            padding: '2px 10px'
                                        }}
                                    >
                                        {activeImg + 1} / {images.length}
                                    </Tag>
                                </>
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

                        {/* Nearest Store Section */}
                        <div style={{ marginTop: 20 }}>
                            <Button 
                                type="dashed" 
                                icon={<EnvironmentOutlined />} 
                                loading={findingLocation}
                                onClick={handleFindNearestStore}
                                block
                                size="large"
                                style={{ borderRadius: 8, borderColor: '#1ca8c8', color: '#1ca8c8' }}
                            >
                                Tìm cửa hàng gần bạn
                            </Button>

                        {nearestStores !== null && (
                            <div style={{ marginTop: 16 }}>
                                {nearestStores.length > 0 ? (
                                    <div style={{ display: 'flex', flexDirection: 'column', gap: 12 }}>
                                        {nearestStores.slice(0, 3).map((s, idx) => (
                                            <div key={idx} style={{ 
                                                padding: 12, 
                                                border: '1px solid #1ca8c8', 
                                                borderRadius: 8, 
                                                background: '#f0fafd',
                                                display: 'flex',
                                                justifyContent: 'space-between',
                                                alignItems: 'center'
                                            }}>
                                                <div>
                                                    <div style={{ fontWeight: 600, color: '#333' }}>{s.storeName}</div>
                                                    <div style={{ fontSize: 12, color: '#555' }}>Còn {s.availableStock} sản phẩm</div>
                                                </div>
                                                <div style={{ textAlign: 'right' }}>
                                                    <Tag color="cyan">Cách {s.distanceKm.toFixed(1)} km</Tag>
                                                </div>
                                            </div>
                                        ))}
                                        {nearestStores.length > 3 && (
                                            <Text type="secondary" style={{ fontSize: 12, textAlign: 'center' }}>
                                                Và {nearestStores.length - 3} cửa hàng khác...
                                            </Text>
                                        )}
                                    </div>
                                ) : (
                                    <Text type="secondary" style={{ display: 'block', textAlign: 'center', marginTop: 10 }}>
                                        Không có cửa hàng nào gần bạn
                                    </Text>
                                )}
                            </div>
                        )}
                    </div>
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
                                <Rate disabled allowHalf value={avgRatingData.averageRating || 0} style={{ fontSize: 14, color: '#fab400' }} />
                                <Text type="secondary">({avgRatingData.averageRating?.toFixed(1) || '0.0'} / 5.0 - {avgRatingData.totalReviews || 0} reviews)</Text>
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
                            {product.totalStock != null && (
                                <>
                                    <Text type="secondary">Total Stock:</Text>
                                    <Text strong>{product.totalStock}</Text>
                                </>
                            )}
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
                                    onChange={val => setQuantity(val == null ? 1 : val)}
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

                        {/* stock-per-store panel: fixed height showing max two entries,
                            scrollable when there are more. mimics demo screenshot.
                            we display basic info since backend only returns name/qty. */}
                        {product.storeStocks && product.storeStocks.length > 0 && (
                            <div style={{ marginTop: 40 }}>
                                <Divider orientation="left"><Title level={3}>Available at</Title></Divider>
                                {/* scroll container: page by two-item heights when wheel used */}
                                <div
                                    ref={scrollContainerRef}
                                    onWheel={e => {
                                        const sc = scrollContainerRef.current;
                                        if (!sc) return;
                                        e.preventDefault();
                                        const children = sc.children;
                                        if (children.length === 0) return;
                                        const first = children[0];
                                        const style = getComputedStyle(first);
                                        const itemHeight = first.offsetHeight + parseInt(style.marginBottom);
                                        const currentIndex = Math.floor(sc.scrollTop / itemHeight);
                                        if (e.deltaY > 0) {
                                            sc.scrollTo({ top: (currentIndex + 2) * itemHeight, behavior: 'smooth' });
                                        } else {
                                            sc.scrollTo({ top: Math.max(0, (currentIndex - 2) * itemHeight), behavior: 'smooth' });
                                        }
                                    }}
                                    style={{
                                        maxHeight: containerHeight,
                                        overflowY: 'auto',
                                        border: '1px solid #f0f0f0',
                                        borderRadius: 8,
                                        padding: '8px 12px',
                                        background: '#fff',
                                        boxSizing: 'border-box'
                                    }}
                                >
                                    {product.storeStocks.map((s, idx) => (
                                        <div
                                            key={idx}
                                            style={{
                                                marginBottom: 12,
                                                padding: 8,
                                                border: '1px solid #e0e0e0',
                                                borderRadius: 6,
                                                background: '#fafafa',
                                                display: 'flex',
                                                flexDirection: 'column',
                                                gap: 4,
                                                fontSize: 14
                                            }}
                                        >
                                            <div style={{ fontWeight: 600, color: '#333' }}>
                                                {s.storeName}
                                            </div>
                                            {s.address && (
                                                <div style={{ fontSize: 12, color: '#555' }}>
                                                    {s.address}{s.city ? `, ${s.city}` : ''}
                                                </div>
                                            )}
                                            <div style={{ fontSize: 13, color: '#1ca8c8' }}>
                                                {s.quantity} có sẵn
                                            </div>
                                        </div>
                                    ))}
                                </div>
                            </div>
                        )}

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

                {/* Additional Details Tabs */}
                <div style={{ marginTop: 80 }}>
                    <Divider orientation="left"><Title level={3}>Details & Specifications</Title></Divider>
                    <div style={{ background: '#fff', padding: 40, borderRadius: 24, border: '1px solid #f0f0f0', marginBottom: 60 }}>
                        <Title level={4}>Safety & Materials</Title>
                        <Paragraph style={{ fontSize: 16 }}>
                            All our toys are made from non-toxic, child-safe materials and meet international safety standards (ASTM, EN71). Recommended for ages 3 and up. {product.description}
                        </Paragraph>
                    </div>

                    <Divider orientation="left"><Title level={3}>Customer Reviews ({avgRatingData.totalReviews || 0})</Title></Divider>
                    <div style={{ background: '#fff', padding: 40, borderRadius: 24, border: '1px solid #f0f0f0' }}>
                        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start', marginBottom: 40, flexWrap: 'wrap', gap: 20 }}>
                            <div style={{ background: '#fcfcfc', padding: '24px 40px', borderRadius: 16, border: '1px solid #f0f0f0', textAlign: 'center' }}>
                                <div style={{ fontSize: 48, fontWeight: 800, color: '#2d2d2d', lineHeight: 1 }}>{avgRatingData.averageRating?.toFixed(1) || '0.0'}</div>
                                <Rate disabled allowHalf value={avgRatingData.averageRating || 0} style={{ margin: '12px 0', fontSize: 20, color: '#fab400' }} />
                                <div style={{ color: '#8c8c8c' }}>Based on {avgRatingData.totalReviews || 0} reviews</div>
                            </div>

                            <div style={{ flex: 1, minWidth: 300 }}>
                                <Text strong style={{ display: 'block', marginBottom: 16 }}><FilterOutlined /> Filter by Rating</Text>
                                <Radio.Group
                                    value={ratingFilter}
                                    onChange={e => {
                                        // store '' when user selects "All"
                                        setRatingFilter(e.target.value || '');
                                        setReviewPage(0);
                                    }}
                                    optionType="button"
                                    buttonStyle="solid"
                                >
                                    <Radio.Button value="">All</Radio.Button>
                                    {[5, 4, 3, 2, 1].map(r => (
                                        <Radio.Button key={r} value={r}>{r} ★</Radio.Button>
                                    ))}
                                </Radio.Group>
                            </div>
                        </div>

                        {reviewsLoading ? (
                            <div style={{ textAlign: 'center', padding: '40px 0' }}><Spin /></div>
                        ) : reviews.length > 0 ? (
                            <div className="reviews-list">
                                {reviews.map((rev, idx) => (
                                    <div key={rev.id || idx} style={{ padding: '24px 0', borderBottom: idx === reviews.length - 1 ? 'none' : '1px solid #f0f0f0' }}>
                                        <div style={{ display: 'flex', gap: 16, marginBottom: 12 }}>
                                            <Avatar icon={<UserOutlined />} style={{ backgroundColor: '#1ca8c8' }} />
                                            <div>
                                                <div style={{ fontWeight: 700, fontSize: 16 }}>{rev.user?.fullName || rev.user?.userName || 'Anonymous User'}</div>
                                                <div style={{ display: 'flex', alignItems: 'center', gap: 12 }}>
                                                    <Rate disabled value={rev.rating} style={{ fontSize: 12, color: '#fab400' }} />
                                                    <Text type="secondary" style={{ fontSize: 12 }}>{dayjs(rev.createdAt).format('DD MMM, YYYY')}</Text>
                                                </div>
                                            </div>
                                        </div>
                                        <Paragraph style={{ fontSize: 15, color: '#595959', margin: 0 }}>
                                            {rev.comment}
                                        </Paragraph>
                                    </div>
                                ))}

                                <div style={{ marginTop: 32, textAlign: 'center' }}>
                                    <Pagination
                                        current={reviewPage + 1}
                                        total={totalElements}
                                        pageSize={5}
                                        onChange={p => setReviewPage(p - 1)}
                                        showSizeChanger={false}
                                    />
                                </div>
                            </div>
                        ) : (
                            <div style={{ textAlign: 'center', padding: '40px 0', color: '#8c8c8c' }}>
                                No reviews found for this criteria.
                            </div>
                        )}
                    </div>
                </div>
            </div>
        </div>
    );
}
