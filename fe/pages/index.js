import React, { useState, useEffect } from 'react';
import { useRouter } from 'next/router';
import { Rate, Tag, message } from 'antd';
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
} from '@ant-design/icons';
import { useCart } from '../hooks/useCart';
import { extractOAuth2Params, handleOAuth2Callback } from '../services/oauth';

/* ─────────────────────────── DATA ─────────────────────────── */

const CATEGORIES = [
  { id: 'all', icon: '🧸', label: 'Puzzles' },
  { id: 'outdoor', icon: '🚲', label: 'Outdoor Toy' },
  { id: 'edu', icon: '📚', label: 'Educational Toy' },
  { id: 'light', icon: '🪀', label: 'Low-Weight Toy' },
  { id: 'motor', icon: '🏎️', label: 'Motor Toy' },
];

const PRODUCTS = [
  { id: 1, name: 'Dinosaur Assembling Toy', price: 12.99, oldPrice: 16.99, rating: 4.5, reviews: 120, badge: 'NEW', img: '🦕' },
  { id: 2, name: 'Magical Unicorn Plush', price: 18.50, oldPrice: null, rating: 4.8, reviews: 87, badge: 'SALE', img: '🦄' },
  { id: 3, name: 'Finger Paint Art Kit', price: 9.99, oldPrice: 14.99, rating: 4.3, reviews: 204, badge: 'NEW', img: '🎨' },
  { id: 4, name: 'Stacking Rainbow Tower', price: 11.99, oldPrice: null, rating: 4.7, reviews: 165, badge: null, img: '🌈' },
  { id: 5, name: 'RC Police Car Set', price: 24.99, oldPrice: 32.99, rating: 4.6, reviews: 98, badge: 'SALE', img: '🚓' },
  { id: 6, name: 'Pull-Along Puppy Dog', price: 13.49, oldPrice: null, rating: 4.4, reviews: 73, badge: null, img: '🐶' },
  { id: 7, name: 'Balance Bike Wooden 12"', price: 39.99, oldPrice: 49.99, rating: 4.9, reviews: 312, badge: 'NEW', img: '🚲' },
  { id: 8, name: 'Abacus Learning Frame', price: 8.75, oldPrice: null, rating: 4.5, reviews: 56, badge: null, img: '🧮' },
];

const LOVED = [
  { id: 1, name: 'RC Police Car Set', price: 24.99, rating: 4.6, img: '🚓', badge: 'NEW' },
  { id: 2, name: 'Magical Unicorn Plush', price: 18.50, rating: 4.8, img: '🦄', badge: 'SALE' },
  { id: 3, name: 'Finger Paint Art Kit', price: 9.99, rating: 4.3, img: '🎨', badge: 'NEW' },
  { id: 4, name: 'Stacking Rainbow Tower', price: 11.99, rating: 4.7, img: '🌈', badge: null },
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

/* ─────────────────────────── SUB-COMPONENTS ─────────────────────────── */

function ProductCard({ product, compact = false, onAdd }) {
  const [wished, setWished] = useState(false);
  return (
    <div className={`prod-card ${compact ? 'compact' : ''}`}>
      {product.badge && (
        <span className={`prod-badge ${product.badge.toLowerCase()}`}>{product.badge}</span>
      )}
      <button className="wish-btn" onClick={() => setWished(w => !w)} aria-label="Wishlist">
        {wished ? <HeartFilled style={{ color: '#ff4d4f' }} /> : <HeartOutlined />}
      </button>
      <div className="prod-img">{product.img}</div>
      <div className="prod-info">
        <p className="prod-name">{product.name}</p>
        <div className="prod-price-row">
          <span className="prod-price">${product.price.toFixed(2)}</span>
          {product.oldPrice && <span className="prod-old-price">${product.oldPrice.toFixed(2)}</span>}
        </div>
        <div className="prod-rating">
          <Rate disabled defaultValue={product.rating} allowHalf style={{ fontSize: 12, color: '#fab400' }} />
          {product.reviews && <span className="prod-reviews">({product.reviews})</span>}
        </div>
        <button className="add-to-cart-btn" onClick={() => onAdd(product)}>
          <ShoppingCartOutlined /> Add to cart
        </button>
      </div>
    </div >
  );
}

/* ─────────────────────────── PAGE ─────────────────────────── */

export default function Home() {
  const router = useRouter();
  const [messageApi, contextHolder] = message.useMessage();
  const [activeCategory, setActiveCategory] = useState('all');
  const [testimIdx, setTestimIdx] = useState(0);
  const { addToCart } = useCart();

  // Handle OAuth2 callback (Google login redirect with token)
  useEffect(() => {
    const { token, error } = extractOAuth2Params(router.query);
    
    if (token || error) {
      const result = handleOAuth2Callback(token, error);
      
      if (result.success) {
        messageApi.success(result.message);
        // Clean URL by removing token param
        router.replace('/', undefined, { shallow: true });
        // Force Layout to re-render and show avatar
        window.dispatchEvent(new Event('storage'));
      } else {
        messageApi.error(result.message);
        router.replace('/', undefined, { shallow: true });
      }
    }
  }, [router.query]);

  const visibleTestim = TESTIMONIALS.slice(testimIdx, testimIdx + 2);

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
          <h1 className="hero-title">Play, learn,<br />& grow!</h1>
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

      {/* ── 3. TOP PICKS ── */}
      <section className="section">
        <h2 className="section-title">Top picks for your little ones</h2>
        <div className="section-tabs">
          <button className="tab active">Best seller</button>
          <button className="tab">New seller</button>
          <button className="tab">On sale</button>
        </div>
        <div className="products-grid">
          {PRODUCTS.map(p => <ProductCard key={p.id} product={p} onAdd={addToCart} />)}
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

      {/* ── 5. CUSTOMER LOVES ── */}
      <section className="section">
        <h2 className="section-title">Customer Loves</h2>
        <p className="section-sub">Regular loves</p>
        <div className="products-grid loved-grid">
          {LOVED.map(p => <ProductCard key={p.id} product={p} onAdd={addToCart} />)}
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
            <p className="feature-sub">On orders over $50</p>
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
      { /* close fragment */ }
    </>
  );
}