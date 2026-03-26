import React, { useState, useEffect } from 'react';
import Link from 'next/link';
import { useRouter } from 'next/router';
import { Rate, Empty, Spin, message } from 'antd';
import {
    HeartOutlined,
    HeartFilled,
    ShoppingCartOutlined,
    AppstoreOutlined,
    UnorderedListOutlined,
    SearchOutlined,
    HistoryOutlined,
    CloseOutlined
} from '@ant-design/icons';
import { useCart } from '../hooks/useCart';
import { fetchProductsSortedByStock, fetchCategories, fetchBrands, fetchProductSuggestions } from '../services/api';
import { formatVnd } from '../utils/currency';

const SORT_MAPPING = {
    'Default sorting': 'name,asc',
    'Price: Low to High': 'price,asc',
    'Price: High to Low': 'price,desc',
    'Newest': 'createdAt,desc',
    'Rating': 'name,asc' // Backend doesn't have rating yet
};

const REVERSE_SORT_MAPPING = Object.fromEntries(
    Object.entries(SORT_MAPPING).map(([k, v]) => [v, k])
);

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
            {(product.status === 'INACTIVE' || product.totalStock <= 0) && <span className="shop-badge sale">OUT OF STOCK</span>}
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
                        onError={(e) => {
                            // log the broken url for debugging; once one fails we show
                            // placeholder for this card only
                            console.warn('product image load failed', e.target.src);
                            setImgErr(true);
                        }}
                    />
                ) : (
                    <span style={{ fontSize: 40 }}>🧸</span>
                )}
            </div>
            <div className="shop-prod-info">
                <p className="shop-prod-name">{product.name}</p>
                <div className="shop-prod-price-row">
                    <span className="shop-prod-price">{formatVnd(product.price)}</span>
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
                    <span className="popular-price">{formatVnd(product.price)}</span>
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
    // sync with query string so that back/forward restore state
    const [searchVal, setSearchVal] = useState('');
    const [suggestions, setSuggestions] = useState([]);
    const [showSuggestions, setShowSuggestions] = useState(false);
    const [history, setHistory] = useState([]);
    const [searchFocused, setSearchFocused] = useState(false);
    const [loading, setLoading] = useState(false);
    const [totalResults, setTotalResults] = useState(0);
    const [totalPages, setTotalPages] = useState(0);
    const { addToCart } = useCart();

    const handleAddToCart = async (product) => {
        const ok = await addToCart(product, 1);
        if (ok) {
            message.success(`Da them ${product.name} vao gio hang`);
            return;
        }
        message.error('Khong the them vao gio hang. Vui long thu lai.');
    };

    const pageSize = 9;

    useEffect(() => {
        if (router.isReady) {
            const categoryId = router.query.cat ? parseInt(router.query.cat) : null;
            setActiveCat(categoryId);

            // Sync page from URL (0-indexed)
            if (router.query.p) {
                setPage(parseInt(router.query.p));
            } else {
                setPage(0);
            }

            // Sync sort from URL
            if (router.query.s && REVERSE_SORT_MAPPING[router.query.s]) {
                setSortBy(REVERSE_SORT_MAPPING[router.query.s]);
            } else {
                setSortBy('Default sorting');
            }

            // sync keyword query param to input; if it's missing clear value
            if (router.query.keyword) {
                setSearchVal(router.query.keyword);
            } else {
                setSearchVal('');
                setShowSuggestions(false);
            }
        }
    }, [router.isReady, router.query.cat, router.query.keyword, router.query.p, router.query.s]);


    // hide suggestion dropdown whenever the route changes (back/forward/etc)
    useEffect(() => {
        setShowSuggestions(false);
        // We removed the aggressive cleanup that was clearing searchVal here
        // as it was interfering with back navigation persistence.
    }, [router.asPath, router.query.keyword]);


    // if the user clicks the "Shop" link in the header we navigate back
    // to `/shop` without any query parameters.  when that happens we want to
    // clear any existing keyword or page state so the list returns to the
    // default "all products" view.  listening on `asPath` gives us the
    // updated URL whenever the router changes.
    useEffect(() => {
        if (router.isReady && router.asPath === '/shop') {
            // preserve keyword if it's still in the URL; only clear when
            // there are literally no query filters at all (user clicked the
            // Shop link from header)
            if (!router.query.keyword) {
                setSearchVal('');
            }
            setActiveCat(null);
            setPage(0);
        }
    }, [router.isReady, router.asPath]);

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
        if (!router.isReady) return;

        // whenever the keyword changes and there was a category filter, clear it
        if (searchVal && searchVal.trim().length > 0 && activeCat !== null) {
            setActiveCat(null);
        }

        const q = { ...router.query };
        let changed = false;

        if (searchVal !== (q.keyword || '')) {
            if (searchVal) q.keyword = searchVal;
            else delete q.keyword;
            changed = true;
        }

        if (page !== (parseInt(q.p) || 0)) {
            if (page > 0) q.p = page;
            else delete q.p;
            changed = true;
        }

        const currentSort = SORT_MAPPING[sortBy];
        if (currentSort !== (q.s || 'name,asc')) {
            if (currentSort && currentSort !== 'name,asc') q.s = currentSort;
            else delete q.s;
            changed = true;
        }

        if (changed) {
            // add a random param to force router change even when keyword is
            // identical; this keeps history entries distinct so back/forward
            // works more predictably
            q.r = Date.now();
            router.replace({ pathname: '/shop', query: q }, undefined, {
                shallow: true
            });
        }
    }, [searchVal, page, sortBy, router.isReady]);


    // fetch autocomplete suggestions when user types.  if we have just
    // applied a suggestion click we want to suppress the follow-up lookup
    // (otherwise the dropdown immediately reopens).  a ref flag allows the
    // click handler to signal the effect to bail out once.

    // --- recent keyword history stored in localStorage -------------
    useEffect(() => {
        // load any existing history on mount
        try {
            const stored = JSON.parse(localStorage.getItem('searchHistory') || '[]');
            if (Array.isArray(stored)) {
                setHistory(stored);
            }
        } catch (_e) {
            // ignore
        }
    }, []);

    const addToHistory = kw => {
        if (!kw || !kw.trim()) return;
        setHistory(prev => {
            const filtered = prev.filter(h => h !== kw);
            const next = [kw, ...filtered].slice(0, 3); // keep at most 3 as requested
            try {
                localStorage.setItem('searchHistory', JSON.stringify(next));
            } catch (_e) { }
            return next;
        });
    };

    const removeFromHistory = kw => {
        setHistory(prev => {
            const next = prev.filter(h => h !== kw);
            try {
                localStorage.setItem('searchHistory', JSON.stringify(next));
            } catch (_e) { }
            return next;
        });
    };
    const ignoreNextFetch = React.useRef(false);
    const focusTimer = React.useRef(null);
    useEffect(() => {
        const timer = setTimeout(async () => {
            if (ignoreNextFetch.current) {
                // consumed the skip flag, do nothing this round
                ignoreNextFetch.current = false;
                return;
            }
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
                    <span className="shop-topbar-msg">🚚 Free shipping with over 500,000 VND</span>
                </div>
            </div>

            {/* ── BREADCRUMB ── */}
            <div className="shop-breadcrumb">
                <div className="shop-breadcrumb-inner">
                    <Link href="/" className="bc-home">Home</Link>
                    <span className="bc-sep"> / </span>
                    {/* Clicking back to the shop page should reset whatever state we were
                        carrying (keyword, category, page).  When the user is already on
                        `/shop` the router won't actually change paths, so our effect that
                        listens on `asPath` never fires.  To handle the "click again"
                        scenario we explicitly clear the state on click. */}
                    <Link
                        href="/shop"
                        className="bc-current"
                        onClick={() => {
                            setSearchVal('');
                            setActiveCat(null);
                            setPage(0);
                        }}
                    >
                        Products
                    </Link>
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
                            onChange={e => { setSearchVal(e.target.value); setPage(0); }}
                            onKeyDown={e => {
                                if (e.key === 'Enter') {
                                    addToHistory(searchVal);
                                    setShowSuggestions(false);
                                }
                            }}
                            onFocus={() => {
                                clearTimeout(focusTimer.current);
                                setSearchFocused(true);
                            }}
                            onBlur={() => {
                                focusTimer.current = setTimeout(() => setSearchFocused(false), 100);
                            }}
                        />
                        <SearchOutlined
                            className="sidebar-search-icon"
                            onClick={() => {
                                addToHistory(searchVal);
                                setShowSuggestions(false);
                            }}
                        />
                        {/* suggestions dropdown */}
                        {showSuggestions && suggestions.length > 0 && (
                            <ul className="autocomplete-dropdown">
                                {suggestions.map(p => (
                                    <li key={p.id} onMouseDown={() => {

                                        // set input value then immediately hide the
                                        // dropdown and clear suggestions. also mark the
                                        // next fetch to be ignored so the effect above
                                        // doesn't pop it right back open.
                                        setSearchVal(p.name);
                                        setShowSuggestions(false);
                                        setSuggestions([]);
                                        ignoreNextFetch.current = true;
                                        setPage(0);
                                        addToHistory(p.name);
                                        // update URL for history/back support
                                        router.push(
                                            {
                                                pathname: '/shop',
                                                query: { ...router.query, keyword: p.name, r: Date.now() }
                                            },
                                            undefined,
                                            { shallow: true }
                                        );
                                    }} className="autocomplete-item">
                                        {p.imageUrl && (
                                            <div className="suggestion-img">
                                                <img src={p.imageUrl} alt={p.name} />
                                            </div>
                                        )}
                                        <div className="suggestion-info">
                                            <span className="suggestion-name">{p.name}</span>
                                            <div className="suggestion-meta">
                                                {p.status === 'INACTIVE' || p.totalStock <= 0 ? (
                                                    <span className="stock-tag out">Hết hàng</span>
                                                ) : p.totalStock <= 5 ? (
                                                    <span className="stock-tag low">Sắp hết hàng ({p.totalStock})</span>
                                                ) : (
                                                    <span className="stock-tag in">Còn hàng</span>
                                                )}
                                            </div>
                                        </div>
                                    </li>
                                ))}
                            </ul>
                        )}
                        {/* recent keywords shown when nothing typed and input focused */}
                        {!searchVal && history.length > 0 && searchFocused && (
                            <ul className="autocomplete-dropdown history">
                                {history.map((h, idx) => (
                                    <li key={idx} className="autocomplete-item history">
                                        <span
                                            className="history-keyword"
                                            onMouseDown={() => {
                                                setSearchVal(h);
                                                setShowSuggestions(false);
                                                setSuggestions([]);
                                                ignoreNextFetch.current = true;
                                                setPage(0);
                                                addToHistory(h);
                                                router.push(
                                                    {
                                                        pathname: '/shop',
                                                        query: { ...router.query, keyword: h, r: Date.now() }
                                                    },
                                                    undefined,
                                                    { shallow: true }
                                                );
                                                // keep focus so dropdown won't immediately hide
                                                setSearchFocused(true);
                                            }}
                                        >
                                            <HistoryOutlined style={{ marginRight: 6, fontSize: 12 }} />
                                            {h}
                                        </span>
                                        <CloseOutlined
                                            className="history-remove"
                                            onMouseDown={e => {
                                                e.stopPropagation();
                                                removeFromHistory(h);
                                            }}
                                        />
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
                                    onClick={() =>
                                        router.push(
                                            { pathname: '/shop', query: { r: Date.now() } },
                                            undefined,
                                            { shallow: true }
                                        )
                                    }
                                >
                                    <span className="cat-plus">{activeCat === null ? '−' : '+'}</span>
                                    All Categories
                                </button>
                            </li>
                            {categories.map(cat => (
                                <li key={cat.id}>
                                    <button
                                        className={`sidebar-cat-btn${activeCat === cat.id ? ' active' : ''}`}
                                        onClick={() =>
                                            router.push(
                                                {
                                                    pathname: '/shop',
                                                    query: { cat: cat.id, r: Date.now() }
                                                },
                                                undefined,
                                                { shallow: true }
                                            )
                                        }
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
                                <span>{formatVnd(priceRange[0])}</span>
                                <span>{formatVnd(priceRange[1])}</span>
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
                            {router.query.keyword
                                ? `Search Results for: "${router.query.keyword}"`
                                : (activeCat ? categories.find(c => c.id === activeCat)?.name : 'All Toys')
                            }
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
                            products.map(p => <ShopProductCard key={p.id} product={p} onAdd={handleAddToCart} />)
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
