import React, { useState, useEffect } from 'react';
import { useRouter } from 'next/router';
import { Rate, Tag, message, Spin, Select } from 'antd';
import Link from 'next/link';
import {
  ShoppingCartOutlined,
  HeartOutlined,
  HeartFilled,
  TruckOutlined,
  CustomerServiceOutlined,
  SafetyOutlined,
  StarFilled,
  LeftOutlined,
  RightOutlined,
  FireFilled,
  ThunderboltFilled,
  FilterOutlined,
} from '@ant-design/icons';
import { useCart } from '../hooks/useCart';
import { extractOAuth2Params, handleOAuth2Callback } from '../services/oauth';
import { fetchOnSaleProducts, fetchBestSellerIds, fetchProductsByIds, fetchActiveProducts, fetchBrands } from '../services/api';
import { formatVnd } from '../utils/currency';

/* ─────────────────────────── DATA ─────────────────────────── */

const CATEGORIES = [
  { id: 'all', icon: '🧸', label: 'Puzzles' },
  { id: 'outdoor', icon: '🚲', label: 'Outdoor Toy' },
  { id: 'edu', icon: '📚', label: 'Educational Toy' },
  { id: 'light', icon: '🪀', label: 'Low-Weight Toy' },
  { id: 'motor', icon: '🏎️', label: 'Motor Toy' },
];

const TESTIMONIALS = [
  { name: 'Sarah M.', avatar: '👩', stars: 5, text: 'My kids absolutely love the toys from this store! Great quality and fast delivery. Will definitely shop again!' },
  { name: 'James K.', avatar: '👨', stars: 5, text: 'Amazing selection of educational toys. My daughter is learning so much while having fun. Highly recommend!' },
  { name: 'Emily R.', avatar: '👩‍🦱', stars: 4, text: 'Quality is top-notch and packaging was super safe. The wooden balance bike is our new favorite gift.' },
  { name: 'David L.', avatar: '🧔', stars: 5, text: 'Ordered for my nephew birthday. He was thrilled! Shipping was fast and everything arrived in perfect condition.' },
];

const PHOTOS = [
  { id: 1, alt: 'Kids playing with colorful blocks', color: '#d4eaf7', icon: '🧱' },
  { id: 2, alt: 'Baby with stacking rainbow tower', color: '#f7e4d4', icon: '🌈' },
  { id: 3, alt: 'Children in outdoor play area', color: '#d4f7e4', icon: '🏞️' },
  { id: 4, alt: 'Toddler with wooden puzzle', color: '#f7f4d4', icon: '🧩' },
];

/* ─────────────────────────── HELPERS ─────────────────────────── */

function formatPrice(val) {
  return formatVnd(val);
}

function calcDiscount(original, sale) {
  if (!original || !sale || original <= 0) return 0;
  return Math.round(((original - sale) / original) * 100);
}

/* ─────────────────────────── SUB-COMPONENTS ─────────────────────────── */

function RealProductCard({ product, onAdd, showSaleBadge = false }) {
  const router = useRouter();
  const [wished, setWished] = useState(false);
  const [imgErr, setImgErr] = useState(false);
  const imgUrl = product.imageUrls && product.imageUrls.length > 0 ? product.imageUrls[0] : null;
  const isOnSale = product.onSale && product.salePrice != null;
  const effectivePrice = isOnSale ? product.salePrice : product.price;
  const discount = isOnSale ? calcDiscount(product.price, product.salePrice) : 0;

  return (
    <div className="prod-card real-prod-card" onClick={() => router.push(`/product/${product.id}`)} style={{ cursor: 'pointer' }}>
      {showSaleBadge && isOnSale && discount > 0 && (
        <span className="prod-badge sale">-{discount}%</span>
      )}
      {product._totalSold && (
        <span className="prod-badge bestseller"><FireFilled /> Hot</span>
      )}
      <button className="wish-btn" onClick={(e) => { e.stopPropagation(); setWished(w => !w); }} aria-label="Wishlist">
        {wished ? <HeartFilled style={{ color: '#ff4d4f' }} /> : <HeartOutlined />}
      </button>
      <div className="prod-img">
        {imgUrl && !imgErr ? (
          <img
            src={imgUrl}
            alt={product.name}
            style={{ width: '100%', height: '100%', objectFit: 'cover', borderRadius: 12 }}
            onError={() => setImgErr(true)}
          />
        ) : (
          <span style={{ fontSize: 48 }}>🧸</span>
        )}
      </div>
      <div className="prod-info">
        <p className="prod-name">{product.name}</p>
        <div className="prod-price-row">
          <span className="prod-price">{formatPrice(effectivePrice)}</span>
          {isOnSale && (
            <span className="prod-old-price">{formatPrice(product.price)}</span>
          )}
        </div>
        {product._totalSold && (
          <div style={{ fontSize: 12, color: '#888', marginBottom: 4 }}>
            Đã bán {product._totalSold}
          </div>
        )}
        <Rate disabled defaultValue={5} allowHalf style={{ fontSize: 12, color: '#fab400' }} />
        <button className="add-to-cart-btn" onClick={(e) => {
          e.stopPropagation();
          onAdd({ ...product, price: effectivePrice });
        }}>
          <ShoppingCartOutlined /> Add to cart
        </button>
      </div>
    </div>
  );
}

/* ─────────────────────────── PAGE ─────────────────────────── */

export default function Home() {
  const router = useRouter();
  const [messageApi, contextHolder] = message.useMessage();
  const [activeCategory, setActiveCategory] = useState('all');
  const [testimIdx, setTestimIdx] = useState(0);
  const { addToCart } = useCart();

  // Tab state: 'all' | 'best-seller' | 'on-sale'
  const [activeTab, setActiveTab] = useState('all');

  // API data
  const [allProducts, setAllProducts] = useState([]);
  const [bestSellerProducts, setBestSellerProducts] = useState([]);
  const [onSaleProducts, setOnSaleProducts] = useState([]);
  const [loadingAll, setLoadingAll] = useState(true);
  const [loadingBest, setLoadingBest] = useState(true);
  const [loadingSale, setLoadingSale] = useState(true);

  // Filter state
  const [brands, setBrands] = useState([]);
  const [filterBrand, setFilterBrand] = useState(null);
  const [filterMinPrice, setFilterMinPrice] = useState('');
  const [filterMaxPrice, setFilterMaxPrice] = useState('');
  const [filterRating, setFilterRating] = useState(0); // 0 = all

  // Handle OAuth2 callback (Google login redirect with token)
  useEffect(() => {
    const { token, error } = extractOAuth2Params(router.query);

    if (token || error) {
      const result = handleOAuth2Callback(token, error);

      if (result.success) {
        messageApi.success(result.message);
        router.replace('/', undefined, { shallow: true });
        window.dispatchEvent(new Event('storage'));
      } else {
        messageApi.error(result.message);
        router.replace('/', undefined, { shallow: true });
      }
    }
  }, [router.query]);

  // Fetch brands for filter
  useEffect(() => {
    fetchBrands().catch(() => []).then(data => {
      const list = Array.isArray(data) ? data : (data?.data || []);
      setBrands(list);
    });
  }, []);

  // Fetch all products
  useEffect(() => {
    const loadAll = async () => {
      setLoadingAll(true);
      const res = await fetchActiveProducts(0, 8).catch(() => null);
      if (res) {
        const data = res?.content || res?.data?.content || [];
        setAllProducts(Array.isArray(data) ? data : []);
      }
      setLoadingAll(false);
    };
    loadAll();
  }, []);

  // Fetch best-seller products
  useEffect(() => {
    const loadBestSellers = async () => {
      setLoadingBest(true);
      // Use .catch() to prevent unhandled promise rejection in Next.js dev
      const res = await fetchBestSellerIds(8).catch(() => null);
      if (res) {
        const data = Array.isArray(res) ? res : (res?.data || []);
        if (data.length > 0) {
          const ids = data.map(item => item.productId);
          const prodRes = await fetchProductsByIds(ids).catch(() => null);
          if (prodRes) {
            const products = Array.isArray(prodRes) ? prodRes : (prodRes?.data || []);
            const enriched = products.map(p => {
              const match = data.find(d => d.productId === p.id);
              return { ...p, _totalSold: match ? match.totalSold : null };
            });
            enriched.sort((a, b) => (b._totalSold || 0) - (a._totalSold || 0));
            setBestSellerProducts(enriched);
          }
        }
      }
      setLoadingBest(false);
    };
    loadBestSellers();
  }, []);

  // Fetch on-sale products
  useEffect(() => {
    const loadOnSale = async () => {
      setLoadingSale(true);
      const res = await fetchOnSaleProducts(0, 8).catch(() => null);
      if (res) {
        const data = res?.data || res || {};
        setOnSaleProducts(data.content || data || []);
      }
      setLoadingSale(false);
    };
    loadOnSale();
  }, []);

  const visibleTestim = TESTIMONIALS.slice(testimIdx, testimIdx + 2);

  // Determine which products to show in section 3
  const rawTabProducts = activeTab === 'all' ? allProducts : activeTab === 'best-seller' ? bestSellerProducts : onSaleProducts;
  const tabLoading = activeTab === 'all' ? loadingAll : activeTab === 'best-seller' ? loadingBest : loadingSale;

  // Apply client-side filters
  const tabProducts = rawTabProducts.filter(p => {
    // Brand filter (brand is an object with id/name)
    if (filterBrand && String(p.brand?.id) !== String(filterBrand)) return false;
    // Price filter
    const price = p.onSale && p.salePrice ? p.salePrice : p.price;
    if (filterMinPrice !== '' && price < Number(filterMinPrice)) return false;
    if (filterMaxPrice !== '' && price > Number(filterMaxPrice)) return false;
    // Rating filter (skip if 0 = all)
    if (filterRating > 0 && (p.averageRating || 5) < filterRating) return false;
    return true;
  });

  const hasActiveFilter = filterBrand || filterMinPrice !== '' || filterMaxPrice !== '' || filterRating > 0;

  return (
    <>
      {contextHolder}
      <div className="home-page">

        {/* ── 1. HERO BANNER ── */}
        <section className="hero-section">
          <div className="hero-image-wrap">
            <img src="/hero-baby.png" alt="Baby playing with toy" className="hero-img" />
          </div>
          <div className="hero-text">
            <h1 className="hero-title">Play, learn,<br />&amp; grow!</h1>
            <p className="hero-sub">Crafting smiles with every toy, made for learning,<br />fun, and growth</p>
            <Link href="/shop">
              <button className="hero-btn">Shop now</button>
            </Link>
          </div>
        </section>

        {/* ── 2. CATEGORIES ── */}
        <section className="section cats-section">
          <h2 className="section-title">Find the Perfect Toy</h2>
          <p className="section-sub">Shop by category</p>
          <div className="cats-row">
            {CATEGORIES.map(cat => (
              <button
                key={cat.id}
                className={`cat-btn ${activeCategory === cat.id ? 'active' : ''}`}
                onClick={() => setActiveCategory(cat.id)}
              >
                <span className="cat-icon">{cat.icon}</span>
                <span className="cat-label">{cat.label}</span>
              </button>
            ))}
          </div>
        </section>

        {/* ── 3. TOP PICKS (Best-Sellers & On-Sale) ── */}
        <section className="section">
          <h2 className="section-title">Top picks for your little ones</h2>
          <div className="section-tabs">
            <button className={`tab ${activeTab === 'all' ? 'active' : ''}`} onClick={() => setActiveTab('all')}>
              All products
            </button>
            <button className={`tab ${activeTab === 'best-seller' ? 'active' : ''}`} onClick={() => setActiveTab('best-seller')}>
              <FireFilled style={{ marginRight: 6 }} /> Best seller
            </button>
            <button className={`tab ${activeTab === 'on-sale' ? 'active' : ''}`} onClick={() => setActiveTab('on-sale')}>
              <ThunderboltFilled style={{ marginRight: 6 }} /> On sale
            </button>
          </div>

          {/* Filter bar */}
          <div className="home-filter-bar">
            <div className="home-filter-item">
              <label><FilterOutlined /> Brand</label>
              <select
                className="home-filter-select"
                value={filterBrand || ''}
                onChange={e => setFilterBrand(e.target.value || null)}
              >
                <option value="">All brands</option>
                {brands.map(b => (
                  <option key={b.id} value={b.id}>{b.name}</option>
                ))}
              </select>
            </div>
            <div className="home-filter-item">
              <label>Price</label>
              <div className="home-filter-price-inputs">
                <input
                  type="number"
                  placeholder="Min"
                  className="home-filter-input"
                  value={filterMinPrice}
                  onChange={e => setFilterMinPrice(e.target.value)}
                />
                <span className="home-filter-dash">–</span>
                <input
                  type="number"
                  placeholder="Max"
                  className="home-filter-input"
                  value={filterMaxPrice}
                  onChange={e => setFilterMaxPrice(e.target.value)}
                />
              </div>
            </div>
            <div className="home-filter-item">
              <label><StarFilled style={{ color: '#fab400' }} /> Rating</label>
              <div className="home-filter-stars">
                {[0, 3, 4, 5].map(r => (
                  <button
                    key={r}
                    className={`home-star-btn ${filterRating === r ? 'active' : ''}`}
                    onClick={() => setFilterRating(r)}
                  >
                    {r === 0 ? 'All' : `${r}★+`}
                  </button>
                ))}
              </div>
            </div>
            {hasActiveFilter && (
              <button
                className="home-filter-clear"
                onClick={() => { setFilterBrand(null); setFilterMinPrice(''); setFilterMaxPrice(''); setFilterRating(0); }}
              >
                ✕ Clear
              </button>
            )}
          </div>

          <div className="products-grid">
            {tabLoading ? (
              <div style={{ textAlign: 'center', width: '100%', padding: '40px 0' }}>
                <Spin size="large" />
                <div style={{ marginTop: 10, color: '#999' }}>Loading products...</div>
              </div>
            ) : tabProducts.length > 0 ? (
              tabProducts.map(p => (
                <RealProductCard
                  key={p.id}
                  product={p}
                  onAdd={addToCart}
                  showSaleBadge={activeTab === 'on-sale'}
                />
              ))
            ) : (
              <div style={{ textAlign: 'center', width: '100%', padding: '40px 0', color: '#999' }}>
                {activeTab === 'best-seller'
                  ? 'Chưa có dữ liệu bán hàng. Hãy đặt hàng để xem sản phẩm bán chạy!'
                  : 'Hiện chưa có sản phẩm nào đang giảm giá.'}
              </div>
            )}
          </div>
        </section>

        {/* ── 4. PROMO BANNERS ── */}
        <section className="promo-banners">
          <div className="promo-card cartoon">
            <div className="promo-overlay-text">
              <h3>Discover the<br />Joy of Play</h3>
            </div>
            <img src="/promo-banner1.png" alt="Discover the Joy of Play" />
          </div>
          <div className="promo-card eco">
            <div className="promo-overlay-text right">
              <h3>Eco – Friendly<br />Toy</h3>
              <Link href="/shop">
                <button className="promo-btn">Explore</button>
              </Link>
            </div>
            <img src="/promo-banner2.png" alt="Eco Friendly Toy" />
          </div>
        </section>

        {/* ── 5. ON‑SALE SPOTLIGHT ── */}
        <section className="section">
          <h2 className="section-title">🔥 Đang giảm giá</h2>
          <p className="section-sub">Nhanh tay mua với giá ưu đãi!</p>
          <div className="products-grid loved-grid">
            {loadingSale ? (
              <div style={{ textAlign: 'center', width: '100%', padding: '40px 0' }}>
                <Spin size="large" />
              </div>
            ) : onSaleProducts.length > 0 ? (
              onSaleProducts.slice(0, 4).map(p => (
                <RealProductCard key={p.id} product={p} onAdd={addToCart} showSaleBadge />
              ))
            ) : (
              <div style={{ textAlign: 'center', width: '100%', padding: '40px 0', color: '#999' }}>
                Hiện chưa có sản phẩm nào đang giảm giá.
              </div>
            )}
          </div>
        </section>

        {/* ── 6. TESTIMONIALS ── */}
        <section className="section testimonials-section">
          <h2 className="section-title">Hear from Other Happy Parents</h2>
          <p className="section-sub">Customer reviews</p>
          <div className="testimonials-row">
            <button className="arrow-btn" onClick={() => setTestimIdx(Math.max(0, testimIdx - 1))} disabled={testimIdx === 0}>
              <LeftOutlined />
            </button>
            <div className="testimonials-cards">
              {visibleTestim.map((t, i) => (
                <div key={i} className="testimonial-card">
                  <div className="testim-stars">
                    {Array.from({ length: t.stars }).map((_, si) => <StarFilled key={si} style={{ color: '#fab400' }} />)}
                  </div>
                  <p className="testim-text">"{t.text}"</p>
                  <div className="testim-author">
                    <span className="testim-avatar">{t.avatar}</span>
                    <span className="testim-name">{t.name}</span>
                  </div>
                </div>
              ))}
            </div>
            <button className="arrow-btn" onClick={() => setTestimIdx(Math.min(TESTIMONIALS.length - 2, testimIdx + 1))} disabled={testimIdx >= TESTIMONIALS.length - 2}>
              <RightOutlined />
            </button>
          </div>
        </section>

        {/* ── 7. RECENT PHOTOSHOOTS ── */}
        <section className="section photoshoots-section">
          <h2 className="section-title">Recent photoshoots</h2>
          <p className="section-sub">Little moments</p>
          <div className="photos-grid">
            {PHOTOS.map(ph => (
              <div key={ph.id} className="photo-card" style={{ background: ph.color }}>
                <span className="photo-icon">{ph.icon}</span>
                <p className="photo-alt">{ph.alt}</p>
              </div>
            ))}
          </div>
        </section>

        {/* ── 8. FEATURES ── */}
        <section className="features-section">
          <div className="feature-item">
            <div className="feature-icon-wrap teal">
              <CustomerServiceOutlined />
            </div>
            <div>
              <h4 className="feature-title">Customer Support</h4>
              <p className="feature-sub">Help center always open</p>
            </div>
          </div>
          <div className="feature-divider" />
          <div className="feature-item">
            <div className="feature-icon-wrap yellow">
              <TruckOutlined />
            </div>
            <div>
              <h4 className="feature-title">Free Shipping</h4>
              <p className="feature-sub">On orders over 500,000 VND</p>
            </div>
          </div>
          <div className="feature-divider" />
          <div className="feature-item">
            <div className="feature-icon-wrap green">
              <SafetyOutlined />
            </div>
            <div>
              <h4 className="feature-title">Safe & Secure</h4>
              <p className="feature-sub">Trusted online store</p>
            </div>
          </div>
        </section>

        {/* ── 9. NEWSLETTER ── */}
        <section className="newsletter-section">
          <h2 className="nl-title">Newsletter</h2>
          <p className="nl-sub">Subscribe to get special offers, free giveaways, and once-in-a-lifetime deals.</p>
          <div className="nl-form">
            <input type="email" placeholder="Enter your email" className="nl-input" />
            <button className="nl-btn">Join</button>
          </div>
        </section>

        {/* ── 10. FOOTER ── */}
        <footer className="home-footer">
          <div className="footer-grid">
            <div className="footer-brand">
              <div className="footer-logo">
                <span className="logo-icon">🧸</span>
                <div>
                  <div className="logo-main">rainbow</div>
                  <div className="logo-sub">toddler</div>
                </div>
              </div>
              <p className="footer-desc">Your trusted source for safe, fun, and educational toys for little ones.</p>
              <div className="social-icons">
                <a href="#" aria-label="Facebook">📘</a>
                <a href="#" aria-label="Twitter">🐦</a>
                <a href="#" aria-label="Instagram">📸</a>
                <a href="#" aria-label="YouTube">▶️</a>
              </div>
            </div>
            <div className="footer-col">
              <h5>My store</h5>
              <ul>
                <li><a href="#">Home</a></li>
                <li><a href="#">Shop</a></li>
                <li><a href="#">About us</a></li>
                <li><a href="#">Blogs</a></li>
                <li><a href="#">Contact us</a></li>
              </ul>
            </div>
            <div className="footer-col">
              <h5>Customer Links</h5>
              <ul>
                <li><a href="#">FAQ</a></li>
                <li><a href="#">Track order</a></li>
                <li><a href="#">Return &amp; Refund</a></li>
                <li><a href="#">Cookie Policy</a></li>
                <li><a href="#">Terms of Service</a></li>
              </ul>
            </div>
            <div className="footer-col">
              <h5>Safe Shopping</h5>
              <ul>
                <li><a href="#">Privacy Policy</a></li>
                <li><a href="#">Accessibility</a></li>
                <li><a href="#">Sitemap</a></li>
              </ul>
            </div>
          </div>
          <div className="footer-bottom">
            <span>© 2026 KidFavor. All rights reserved.</span>
          </div>
        </footer>

      </div>
      { /* close fragment */}
    </>
  );
}