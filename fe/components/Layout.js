import React, { useState, useEffect } from 'react';
import Link from 'next/link';
import { useRouter } from 'next/router';
import { logout } from '../services/auth';
import { ShoppingCartOutlined, SearchOutlined, MenuOutlined } from '@ant-design/icons';
import { useCart } from '../hooks/useCart';

export default function Layout({ children, isLogin = false }) {
  const router = useRouter();
  const [loggedIn, setLoggedIn] = useState(false);
  const [scrolled, setScrolled] = useState(false);
  const { getCartCount } = useCart();

  useEffect(() => {
    const check = () => setLoggedIn(!!localStorage.getItem('accessToken'));
    check();
    window.addEventListener('storage', check);
    return () => window.removeEventListener('storage', check);
  }, []);

  useEffect(() => {
    const onScroll = () => setScrolled(window.scrollY > 10);
    window.addEventListener('scroll', onScroll);
    return () => window.removeEventListener('scroll', onScroll);
  }, []);

  const isHome = router.pathname === '/';

  return (
    <div className={`site-wrapper${isLogin ? ' login-page' : ''}`}>
      {/* ─── HEADER ─── */}
      <header className={`site-header${scrolled ? ' scrolled' : ''}`}>
        <div className="header-inner">
          {/* Logo */}
          <Link href="/" className="header-logo">
            <span className="logo-bear">🧸</span>
            <div className="logo-text-wrap">
              <span className="logo-rainbow">rainbow</span>
              <span className="logo-toddler">toddler</span>
            </div>
          </Link>

          {/* Nav */}
          <nav className="header-nav">
            {[
              { href: '/', label: 'Home' },
              { href: '/shop', label: 'Shop' },
              { href: '/about', label: 'Blogs' },
              { href: '/toy', label: 'Toy' },
              { href: '/contact', label: 'Contact' },
            ].map(item => (
              <Link
                key={item.href}
                href={item.href}
                className={`nav-link${router.pathname === item.href ? ' active' : ''}`}
              >
                {item.label}
              </Link>
            ))}
          </nav>

          {/* Right actions */}
          <div className="header-actions">
            <button className="hdr-icon-btn" aria-label="Search">
              <SearchOutlined />
            </button>
            <Link href="/cart">
              <button className="hdr-icon-btn cart-btn" aria-label="Cart">
                <ShoppingCartOutlined />
                <span className="cart-badge">{getCartCount()}</span>
              </button>
            </Link>
            {loggedIn ? (
              <button
                className="hdr-login-btn"
                onClick={async () => { await logout(); router.push('/login'); }}
              >
                Logout
              </button>
            ) : (
              <Link href="/login">
                <button className="hdr-login-btn">Login</button>
              </Link>
            )}
          </div>
        </div>
      </header>

      {/* ─── CONTENT ─── */}
      <main className={`site-main${isLogin ? ' no-pad' : ''}`}>
        {children}
      </main>
    </div>
  );
}