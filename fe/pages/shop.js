import React, { useState, useEffect } from 'react';
import Link from 'next/link';
import { useRouter } from 'next/router';
import { Rate, Empty, Spin } from 'antd';
import { HeartOutlined, HeartFilled, ShoppingCartOutlined, AppstoreOutlined, UnorderedListOutlined, SearchOutlined } from '@ant-design/icons';
import { useCart } from '../hooks/useCart';
import { fetchProductsSortedByStock, fetchCategories, fetchBrands, fetchProductSuggestions } from '../services/api';

const SORT_MAPPING = {
    'Default sorting': 'name,asc',
    'Price: Low to High': 'price,asc',
    'Price: High to Low': 'price,desc',
    'Newest': 'createdAt,desc',
    'Rating': 'name,asc' // Backend doesn't have rating yet
};

/* ─────────────────────────── PRODUCT CARD ─────────────────── */

function ShopProductCard({ product, onAdd }) {
    const router = useRouter();
    const [wished, setWished] = useState(false);
    const [imgErr, setImgErr] = useState(false);
    const imgUrl = product.imageUrls && product.imageUrls.length > 0 ? product.imageUrls[0] : null;

    const handleCardClick = () => {
        router.push(`/product/${product.id}`);
    };

    return (
        <div className="shop-prod-card" onClick={handleCardClick}>
            {product.status === 'INACTIVE' && <span className="shop-badge sale">OUT OF STOCK</span>}
            <button
                className="shop-wish-btn"
                onClick={(e) => {
                    e.stopPropagation();
                    setWished(w => !w);
                }}
            >
                {wished ? <HeartFilled style={{ color: '#ff4d4f' }} /> : <HeartOutlined />}
            </button>
            <button
                className="shop-cart-btn-icon"
                aria-label="Add to cart"
                onClick={(e) => {
                    e.stopPropagation();
                    onAdd(product);
                }}
            >
                <ShoppingCartOutlined />
            </button>
            <div className="shop-prod-img">
                {imgUrl && !imgErr ? (
                    <img
                        src={imgUrl}
                        alt={product.name}
                        style={{ width: '100%', height: '100%', objectFit: 'cover' }}
                        onError={() => setImgErr(true)}
                    />
                ) : (
                    <span style={{ fontSize: 40 }}>🧸</span>
                )}
            </div>
            <div className="shop-prod-info">
                <p className="shop-prod-name">{product.name}</p>
                <div className="shop-prod-price-row">
                    <span className="shop-prod-price">${product.price ? product.price.toFixed(2) : '0.00'}</span>
                </div>
                {/* Rating is mock as backend doesn't provide it */}
                <Rate disabled defaultValue={5} allowHalf style={{ fontSize: 12, color: '#fab400' }} />
            </div>
        </div>
    );
}

function PopularProductItem({ product }) {
    const [imgErr, setImgErr] = useState(false);
    return (
        <li className="popular-item cursor-pointer">
            <Link href={`/product/${product.id}`} style={{ display: 'flex', alignItems: 'center', gap: 10, width: '100%' }}>
                <div className="popular-img">
                    {product.imageUrls && product.imageUrls.length > 0 && !imgErr ? (
                        <img
                            src={product.imageUrls[0]}
                            alt={product.name}
                            style={{ width: '100%', height: '100%', objectFit: 'cover', borderRadius: 8 }}
                            onError={() => setImgErr(true)}
                        />
                    ) : '🧸'}
                </div>
                <div className="popular-info">
                    <p className="popular-name">{product.name}</p>
                    <span className="popular-price">${product.price ? product.price.toFixed(2) : '0.00'}</span>
                    <Rate disabled defaultValue={5} allowHalf style={{ fontSize: 11, color: '#fab400' }} />
                </div>
            </Link>
        </li>
    );
}

/* ─────────────────────────── PAGE ─────────────────────────── */

export default function ShopPage() {
    const router = useRouter();
    const [products, setProducts] = useState([]);
    const [categories, setCategories] = useState([]);
    const [activeCat, setActiveCat] = useState(null);
    const [priceRange, setPriceRange] = useState([0, 1000]);
    const [viewMode, setViewMode] = useState('grid');
    const [sortBy, setSortBy] = useState('Default sorting');
    const [page, setPage] = useState(0); // 0-indexed for backend
    const [searchVal, setSearchVal] = useState('');
    const [suggestions, setSuggestions] = useState([]);
    const [showSuggestions, setShowSuggestions] = useState(false);
    const [loading, setLoading] = useState(false);
    const [totalResults, setTotalResults] = useState(0);
    const [totalPages, setTotalPages] = useState(0);
    const { addToCart } = useCart();

    const pageSize = 9;

    useEffect(() => {
        if (router.isReady) {
            const categoryId = router.query.cat ? parseInt(router.query.cat) : null;
            setActiveCat(categoryId);
            // Reset page to 0 when category changes (or is reset)
            setPage(0);
        }
    }, [router.isReady, router.query.cat]);

    useEffect(() => {
        const loadCategories = async () => {
            try {
                const cats = await fetchCategories();
                setCategories(cats || []);
            } catch (err) {
                console.error("Failed to load categories", err);
            }
        };
        loadCategories();
    }, []);

    useEffect(() => {
        const loadProducts = async () => {
            setLoading(true);
            try {
                const data = await fetchProductsSortedByStock(page, pageSize, {
                    keyword: searchVal,
                    categoryId: activeCat,
                    sort: SORT_MAPPING[sortBy]
                });
                setProducts(data.content || []);
                setTotalResults(data.totalElements || 0);
                setTotalPages(data.totalPages || 0);
            } catch (err) {
                console.error("Failed to load products", err);
            } finally {
                setLoading(false);
            }
        };
        loadProducts();
    }, [page, activeCat, sortBy, searchVal]);

    // when the user types a keyword we clear any category filter so that the
    // search operates across all products. otherwise a leftover `cat` query
    // parameter (e.g. "All Toys") may restrict results to a parent category
    // and omit matches in subcategories, which is why typing "la" previously
    // returned no results even though suggestions appeared.
    useEffect(() => {
        if (searchVal && searchVal.trim().length > 0 && activeCat !== null) {
            setActiveCat(null);
            // also reset page to first when clearing filter
            setPage(0);
        }
    }, [searchVal]);

    // fetch autocomplete suggestions when user types
    useEffect(() => {
        const timer = setTimeout(async () => {
            if (searchVal && searchVal.trim().length > 0) {
                try {
                    const sug = await fetchProductSuggestions(searchVal);
                    setSuggestions(sug || []);
                    setShowSuggestions(true);
                } catch (e) {
                    console.error('autocomplete error', e);
                }
            } else {
                setSuggestions([]);
                setShowSuggestions(false);
            }
        }, 250);
        return () => clearTimeout(timer);
    }, [searchVal]);

    const startResult = totalResults > 0 ? page * pageSize + 1 : 0;
    const endResult = Math.min((page + 1) * pageSize, totalResults);

    return (
        <div className="shop-page">

            {/* ── TOP BAR ── */}
            <div className="shop-topbar">
                <div className="shop-topbar-inner">
                    <span className="shop-topbar-msg">🚚 Free shipping with over $150</span>
                </div>
            </div>

            {/* ── BREADCRUMB ── */}
            <div className="shop-breadcrumb">
                <div className="shop-breadcrumb-inner">
                    <Link href="/" className="bc-home">Home</Link>
                    <span className="bc-sep"> / </span>
                    <Link href="/shop" className="bc-current">Products</Link>
                </div>
            </div>

            {/* ── MAIN LAYOUT ── */}
            <div className="shop-layout">

                {/* ── SIDEBAR ── */}
                <aside className="shop-sidebar">

                    {/* Search */}
                    <div className="sidebar-search-wrap">
                        <input
                            type="text"
                            placeholder="Search products..."
                            className="sidebar-search"
                            value={searchVal}
                            onChange={e => setSearchVal(e.target.value)}
                        />
                        <SearchOutlined className="sidebar-search-icon" />
                            {/* suggestions dropdown */}
                            {showSuggestions && suggestions.length > 0 && (
                                <ul className="autocomplete-dropdown">
                                    {suggestions.map(p => (
                                        <li key={p.id} onClick={() => {
                                            setSearchVal(p.name);
                                            setShowSuggestions(false);
                                            setPage(0);
                                        }} className="autocomplete-item">
                                            {p.name}
                                        </li>
                                    ))}
                                </ul>
                            )}
                    </div>

                    {/* Categories */}
                    <div className="sidebar-block">
                        <h4 className="sidebar-block-title">Product categories</h4>
                        <ul className="sidebar-cats">
                            <li>
                                <button
                                    className={`sidebar-cat-btn${activeCat === null ? ' active' : ''}`}
                                    onClick={() => router.push('/shop', undefined, { shallow: true })}
                                >
                                    <span className="cat-plus">{activeCat === null ? '−' : '+'}</span>
                                    All Categories
                                </button>
                            </li>
                            {categories.map(cat => (
                                <li key={cat.id}>
                                    <button
                                        className={`sidebar-cat-btn${activeCat === cat.id ? ' active' : ''}`}
                                        onClick={() => router.push(`/shop?cat=${cat.id}`, undefined, { shallow: true })}
                                    >
                                        <span className="cat-plus">{activeCat === cat.id ? '−' : '+'}</span>
                                        {cat.name}
                                    </button>
                                </li>
                            ))}
                        </ul>
                    </div>

                    {/* Price filter */}
                    <div className="sidebar-block">
                        <h4 className="sidebar-block-title">Filter by price</h4>
                        <div className="price-slider-wrap">
                            <input
                                type="range"
                                min={0}
                                max={300}
                                value={priceRange[1]}
                                onChange={e => setPriceRange([priceRange[0], +e.target.value])}
                                className="price-range-input"
                            />
                            <div className="price-range-labels">
                                <span>${priceRange[0]}</span>
                                <span>${priceRange[1]}</span>
                            </div>
                            <button className="price-apply-btn">Apply</button>
                        </div>
                    </div>

                    {/* Popular products (Mocked for now) */}
                    <div className="sidebar-block">
                        <h4 className="sidebar-block-title">Popular products</h4>
                        <ul className="popular-list">
                            {products.slice(0, 3).map((p, i) => (
                                <PopularProductItem key={i} product={p} />
                            ))}
                        </ul>
                    </div>
                </aside>

                {/* ── MAIN CONTENT ── */}
                <main className="shop-main">
                    {/* Heading row */}
                    <div className="shop-heading-row">
                        <h1 className="shop-title">
                            {activeCat ? categories.find(c => c.id === activeCat)?.name : 'All Toys'}
                        </h1>
                    </div>

                    {/* Toolbar */}
                    <div className="shop-toolbar">
                        <div className="shop-toolbar-left">
                            <button
                                className={`view-btn${viewMode === 'grid' ? ' active' : ''}`}
                                onClick={() => setViewMode('grid')}
                                aria-label="Grid view"
                            ><AppstoreOutlined /></button>
                            <button
                                className={`view-btn${viewMode === 'list' ? ' active' : ''}`}
                                onClick={() => setViewMode('list')}
                                aria-label="List view"
                            ><UnorderedListOutlined /></button>
                            <select
                                className="shop-sort-select"
                                value={sortBy}
                                onChange={e => { setSortBy(e.target.value); setPage(0); }}
                            >
                                {Object.keys(SORT_MAPPING).map(o => <option key={o}>{o}</option>)}
                            </select>
                        </div>
                        <div className="shop-result-count">
                            Showing {startResult}-{endResult} of {totalResults} results
                        </div>
                    </div>

                    {/* Product grid */}
                    <div className={`shop-grid${viewMode === 'list' ? ' list-view' : ''}`}>
                        {loading ? (
                            <div style={{ textAlign: 'center', width: '100%', padding: '50px' }}>
                                <Spin size="large" />
                                <div style={{ marginTop: 12, color: '#999' }}>Loading products...</div>
                            </div>
                        ) : products.length > 0 ? (
                            products.map(p => <ShopProductCard key={p.id} product={p} onAdd={addToCart} />)
                        ) : (
                            <div style={{ textAlign: 'center', width: '100%', padding: '50px' }}>
                                <Empty description="No products found" />
                            </div>
                        )}
                    </div>

                    {/* Pagination */}
                    <div className="shop-pagination">
                        <button
                            className="pag-btn pag-arrow"
                            onClick={() => setPage(p => Math.max(0, p - 1))}
                            disabled={page === 0}
                        >‹</button>
                        {Array.from({ length: totalPages }, (_, i) => i).map(n => (
                            <button
                                key={n}
                                className={`pag-btn${page === n ? ' active' : ''}`}
                                onClick={() => setPage(n)}
                            >{n + 1}</button>
                        ))}
                        <button
                            className="pag-btn pag-arrow"
                            onClick={() => setPage(p => Math.min(totalPages - 1, p + 1))}
                            disabled={page >= totalPages - 1}
                        >›</button>
                    </div>
                </main>
            </div>

            {/* ── FOOTER ── */}
            <footer className="shop-footer">
                <div className="shop-footer-inner">
                    <div className="shop-footer-brand">
                        <div className="shop-footer-logo">
                            <span>🧸</span>
                            <div>
                                <div className="sf-logo-main">rainbow</div>
                                <div className="sf-logo-sub">rattles</div>
                            </div>
                        </div>
                        <p className="sf-desc">Nunc consequat interdum varius sit amet mattis.</p>
                        <div className="sf-socials">
                            <a href="#" aria-label="Instagram">📸</a>
                            <a href="#" aria-label="Twitter">🐦</a>
                            <a href="#" aria-label="Facebook">📘</a>
                            <a href="#" aria-label="Pinterest">📌</a>
                        </div>
                    </div>
                    <div className="shop-footer-col">
                        <h5>My account</h5>
                        <ul>
                            <li><a href="#">Track my order</a></li>
                            <li><a href="#">Terms of use</a></li>
                            <li><a href="#">Wishlist</a></li>
                            <li><a href="#">Submit Your feedback</a></li>
                        </ul>
                    </div>
                    <div className="shop-footer-col">
                        <h5>Customer service</h5>
                        <ul>
                            <li>Monday to Friday</li>
                            <li>10am - 6pm (NewYork time)</li>
                            <li><a href="tel:123-456-7868">Call us: 123-456-7868</a></li>
                            <li><a href="mailto:info@example.com">Email us: info@example.com</a></li>
                        </ul>
                    </div>
                    <div className="shop-footer-deco">
                        <span className="footer-horse">🪀</span>
                    </div>
                </div>
                <div className="shop-footer-bottom">
                    © 2026 KidFavor. All rights reserved.
                </div>
            </footer>
        </div>
    );
}
