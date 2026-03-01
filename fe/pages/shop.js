import React, { useState } from 'react';
import Link from 'next/link';
import { Rate } from 'antd';
import { HeartOutlined, HeartFilled, ShoppingCartOutlined, AppstoreOutlined, UnorderedListOutlined, SearchOutlined } from '@ant-design/icons';
import { useCart } from '../hooks/useCart';

/* ─────────────────────────── DATA ─────────────────────────── */

const CATEGORIES = [
    { id: 'playsets', label: 'Playsets' },
    { id: 'control', label: 'Control Toys' },
    { id: 'edu', label: 'Educational Toys', active: true },
    { id: 'eco', label: 'Eco-Friendly Toys' },
    { id: 'stuffed', label: 'Stuffed Toys' },
    { id: 'type1', label: 'Type 1' },
    { id: 'type2', label: 'Type 2' },
];

const POPULAR = [
    { name: 'Magna etiam tempar orci', price: 39.00, img: '🐭', rating: 5 },
    { name: 'Tortor at auctor', price: 39.00, img: '🌈', rating: 4 },
    { name: 'Hape scoot-around', price: 39.00, img: '🚲', rating: 5 },
];

const ALL_PRODUCTS = [
    { id: 1, name: 'Blocks shape-sorting Toy', price: 33.00, oldPrice: null, rating: 5, img: '🧱', badge: null },
    { id: 2, name: 'Set wooden farm fruit Toys', price: 29.00, oldPrice: 29.00, rating: 4.5, img: '🌽', badge: 'SALE' },
    { id: 3, name: 'Montessori Dinosaur Puzzle', price: 39.00, oldPrice: null, rating: 2, img: '🦕', badge: null },
    { id: 4, name: 'Magna etiam tempar orci', price: 29.00, oldPrice: 38.00, rating: 0, img: '📚', badge: 'SALE' },
    { id: 5, name: 'Wooden sorting Toys', price: 39.00, oldPrice: null, rating: 4, img: '🔷', badge: null },
    { id: 6, name: 'Magna etiam tempar orci', price: 29.00, oldPrice: 30.00, rating: 5, img: '🎮', badge: 'SALE' },
    { id: 7, name: 'Magna etiam tempar orci', price: 29.00, oldPrice: 30.00, rating: 0, img: '🎵', badge: 'SALE' },
    { id: 8, name: 'Magna etiam tempar orci', price: 39.00, oldPrice: null, rating: 3.5, img: '🎀', badge: null },
    { id: 9, name: 'Magna etiam tempar orci', price: 29.00, oldPrice: 35.00, rating: 4.5, img: '🐴', badge: 'SALE' },
];

const SORT_OPTIONS = ['Default sorting', 'Price: Low to High', 'Price: High to Low', 'Newest', 'Rating'];
const TOTAL_RESULTS = 24;

/* ─────────────────────────── PRODUCT CARD ─────────────────── */

function ShopProductCard({ product, onAdd }) {
    const [wished, setWished] = useState(false);
    return (
        <div className="shop-prod-card">
            {product.badge && <span className="shop-badge sale">{product.badge}</span>}
            <button className="shop-wish-btn" onClick={() => setWished(w => !w)}>
                {wished ? <HeartFilled style={{ color: '#ff4d4f' }} /> : <HeartOutlined />}
            </button>
            <button className="shop-cart-btn-icon" aria-label="Add to cart" onClick={() => onAdd(product)}><ShoppingCartOutlined /></button>
            <div className="shop-prod-img">{product.img}</div>
            <div className="shop-prod-info">
                <p className="shop-prod-name">{product.name}</p>
                <div className="shop-prod-price-row">
                    <span className="shop-prod-price">${product.price.toFixed(2)}</span>
                    {product.oldPrice && product.oldPrice !== product.price && (
                        <span className="shop-prod-old">${product.oldPrice.toFixed(2)}</span>
                    )}
                </div>
                <Rate disabled defaultValue={product.rating} allowHalf style={{ fontSize: 12, color: '#fab400' }} />
            </div>
        </div>
    );
}

/* ─────────────────────────── PAGE ─────────────────────────── */

export default function ShopPage() {
    const [activeCat, setActiveCat] = useState('edu');
    const [priceRange, setPriceRange] = useState([20, 200]);
    const [viewMode, setViewMode] = useState('grid'); // 'grid' | 'list'
    const [sortBy, setSortBy] = useState('Default sorting');
    const [page, setPage] = useState(1);
    const [searchVal, setSearchVal] = useState('');
    const { addToCart } = useCart();
    const PAGES = Math.ceil(TOTAL_RESULTS / 9);
    const startResult = (page - 1) * 9 + 1;
    const endResult = Math.min(page * 9, TOTAL_RESULTS);

    return (
        <div className="shop-page">

            {/* ── TOP BAR ── */}
            <div className="shop-topbar">
                <div className="shop-topbar-inner">
                    <span className="shop-topbar-msg">🚚 Free free shipping with over $150</span>
                    <div className="shop-topbar-actions">
                        <Link href="/login"><span className="shop-topbar-link">Login</span></Link>
                        <span className="shop-topbar-sep">|</span>
                        <Link href="/register"><span className="shop-topbar-link">Register</span></Link>
                    </div>
                </div>
            </div>

            {/* ── BREADCRUMB ── */}
            <div className="shop-breadcrumb">
                <div className="shop-breadcrumb-inner">
                    <Link href="/" className="bc-home">Home</Link>
                    <span className="bc-sep"> / </span>
                    <span className="bc-current">Products</span>
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
                    </div>

                    {/* Categories */}
                    <div className="sidebar-block">
                        <h4 className="sidebar-block-title">Product categories</h4>
                        <ul className="sidebar-cats">
                            {CATEGORIES.map(cat => (
                                <li key={cat.id}>
                                    <button
                                        className={`sidebar-cat-btn${activeCat === cat.id ? ' active' : ''}`}
                                        onClick={() => setActiveCat(cat.id)}
                                    >
                                        <span className="cat-plus">{activeCat === cat.id ? '−' : '+'}</span>
                                        {cat.label}
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

                    {/* Popular products */}
                    <div className="sidebar-block">
                        <h4 className="sidebar-block-title">Popular products</h4>
                        <ul className="popular-list">
                            {POPULAR.map((p, i) => (
                                <li key={i} className="popular-item">
                                    <div className="popular-img">{p.img}</div>
                                    <div className="popular-info">
                                        <p className="popular-name">{p.name}</p>
                                        <span className="popular-price">${p.price.toFixed(2)}</span>
                                        <Rate disabled defaultValue={p.rating} allowHalf style={{ fontSize: 11, color: '#fab400' }} />
                                    </div>
                                </li>
                            ))}
                        </ul>
                    </div>
                </aside>

                {/* ── MAIN CONTENT ── */}
                <main className="shop-main">
                    {/* Heading row */}
                    <div className="shop-heading-row">
                        <h1 className="shop-title">Educational Toys</h1>
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
                                onChange={e => setSortBy(e.target.value)}
                            >
                                {SORT_OPTIONS.map(o => <option key={o}>{o}</option>)}
                            </select>
                        </div>
                        <div className="shop-result-count">
                            Showing {startResult}-{endResult} of {TOTAL_RESULTS} results
                        </div>
                    </div>

                    {/* Product grid */}
                    <div className={`shop-grid${viewMode === 'list' ? ' list-view' : ''}`}>
                        {ALL_PRODUCTS.map(p => <ShopProductCard key={p.id} product={p} onAdd={addToCart} />)}
                    </div>

                    {/* Pagination */}
                    <div className="shop-pagination">
                        <button
                            className="pag-btn pag-arrow"
                            onClick={() => setPage(p => Math.max(1, p - 1))}
                            disabled={page === 1}
                        >‹</button>
                        {Array.from({ length: PAGES }, (_, i) => i + 1).map(n => (
                            <button
                                key={n}
                                className={`pag-btn${page === n ? ' active' : ''}`}
                                onClick={() => setPage(n)}
                            >{n}</button>
                        ))}
                        <button
                            className="pag-btn pag-arrow"
                            onClick={() => setPage(p => Math.min(PAGES, p + 1))}
                            disabled={page === PAGES}
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
