import React, { useState, useEffect } from 'react';
import Link from 'next/link';
import { useRouter } from 'next/router';
import { logout } from '../services/auth';
import { getUserFromToken } from '../services/oauth';
import { ShoppingCartOutlined, SearchOutlined, MenuOutlined, UserOutlined, LogoutOutlined } from '@ant-design/icons';
import { useCart } from '../hooks/useCart';

export default function Layout({ children, isLogin = false }) {
  const router = useRouter();
  const [loggedIn, setLoggedIn] = useState(false);
  const [userInfo, setUserInfo] = useState(null);
  const [showUserMenu, setShowUserMenu] = useState(false);
  // keep reference to hide timer so hover into dropdown doesn't close it
  const hideTimer = React.useRef(null);
  const [scrolled, setScrolled] = useState(false);
  const { getCartCount } = useCart();

  useEffect(() => {
    const check = () => {
      const hasToken = !!localStorage.getItem('accessToken');
      setLoggedIn(hasToken);
      if (hasToken) {
        const user = getUserFromToken();
        setUserInfo(user);
      } else {
        setUserInfo(null);
      }
    };
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
            {loggedIn && userInfo ? (
              <div 
                  className="user-menu-wrapper"
                  onMouseEnter={() => {
                    clearTimeout(hideTimer.current);
                    setShowUserMenu(true);
                  }}
                  onMouseLeave={() => {
                    // delay hiding a bit to allow mouse to move into dropdown
                    hideTimer.current = setTimeout(() => setShowUserMenu(false), 150);
                  }}
                >
                <div className="user-avatar">
                  <div className="avatar-circle">
                    {userInfo.email ? userInfo.email.charAt(0).toUpperCase() : 'U'}
                  </div>
                </div>
                {showUserMenu && (
                  <div
                    className="user-dropdown"
                    onMouseEnter={() => {
                      clearTimeout(hideTimer.current);
                      setShowUserMenu(true);
                    }}
                    onMouseLeave={() => setShowUserMenu(false)}
                  >
                    <div className="dropdown-header">
                      <div className="dropdown-avatar">
                        {userInfo.email ? userInfo.email.charAt(0).toUpperCase() : 'U'}
                      </div>
                      <div className="dropdown-user-info">
                        <div className="dropdown-name">{userInfo.name || userInfo.email}</div>
                        <div className="dropdown-email">{userInfo.email}</div>
                        <div className="dropdown-role">{userInfo.role}</div>
                      </div>
                    </div>
                    <div className="dropdown-divider"></div>
                    <button
                      className="dropdown-item logout-item"
                      onClick={async () => {
                        await logout();
                        localStorage.removeItem('userInfo');
                        router.push('/login');
                      }}
                    >
                      <LogoutOutlined />
                      <span>Logout</span>
                    </button>
                  </div>
                )}
              </div>
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