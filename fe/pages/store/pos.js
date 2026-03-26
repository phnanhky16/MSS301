'use client';
import { useState, useEffect, useCallback } from 'react';
import Head from 'next/head';
import {
  Layout, Button, Select, Input, Badge, Modal, Spin, message,
  Divider, Empty, Tag, Avatar, Tooltip, Space,
} from 'antd';
import {
  ShoppingCartOutlined, SearchOutlined, PlusOutlined, MinusOutlined,
  DeleteOutlined, CheckCircleOutlined, TagOutlined, LogoutOutlined,
  ReloadOutlined,
} from '@ant-design/icons';
import { useRouter } from 'next/router';
import { logout, getCurrentUser } from '../../services/auth';
import {
  fetchActiveStores, fetchInStockProducts, fetchProducts,
  createOrder, updateOrderStatus, validateCoupon,
} from '../../services/api';

const { Sider, Content, Header } = Layout;

const formatVND = (n) =>
  new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(n || 0);

export default function POSDashboard() {
  const router = useRouter();
  const [profile, setProfile] = useState(null);
  const [stores, setStores] = useState([]);
  const [selectedStore, setSelectedStore] = useState(null);
  const [products, setProducts] = useState([]);
  const [filteredProducts, setFilteredProducts] = useState([]);
  const [search, setSearch] = useState('');
  const [cart, setCart] = useState([]);
  const [couponCode, setCouponCode] = useState('');
  const [couponDiscount, setCouponDiscount] = useState(0);
  const [couponError, setCouponError] = useState('');
  const [loadingProducts, setLoadingProducts] = useState(false);
  const [reloadKey, setReloadKey] = useState(0); // force-refresh inventory when store selection is unchanged
  const [checkoutLoading, setCheckoutLoading] = useState(false);
  const [receiptVisible, setReceiptVisible] = useState(false);
  const [lastOrder, setLastOrder] = useState(null);

  // Auth guard
  useEffect(() => {
    const user = getCurrentUser();
    setProfile(user);
    if (!user) { router.push('/login'); return; }
    if (user.role !== 'STAFF_FOR_STORE' && user.role !== 'ADMIN') {
      router.push('/');
    }
  }, []);

  // Load stores
  useEffect(() => {
    fetchActiveStores()
      .then(data => {
        const list = Array.isArray(data) ? data : (data?.data ?? []);
        setStores(list);
        if (list.length === 1) setSelectedStore(list[0].storeId);
      })
      .catch(() => message.error('Không thể tải danh sách cửa hàng'));
  }, []);

  // Load products when store selected or refresh requested
  useEffect(() => {
    if (!selectedStore) { setProducts([]); setFilteredProducts([]); return; }
    setLoadingProducts(true);
    // Fetch in-stock items at the store, then enrich with product details
    Promise.all([
      fetchInStockProducts(selectedStore),
      fetchProducts(0, 200, { status: 'ACTIVE' }),
    ])
      .then(([inventory, prodPage]) => {
        const invList = Array.isArray(inventory) ? inventory : (inventory?.data ?? []);
        const prodList = Array.isArray(prodPage) ? prodPage : (prodPage?.content ?? prodPage?.data ?? []);
        // Merge: add product details (image, price) into inventory record
        const enriched = invList.map(inv => {
          const prod = prodList.find(p => p.id === (inv.productId ?? inv.product?.id));
          return {
            productId: inv.productId ?? inv.product?.id,
            productName: inv.productName || prod?.name || `Product #${inv.productId}`,
            quantity: inv.quantity,
            price: prod?.onSale && prod?.salePrice ? prod.salePrice : (prod?.price ?? 0),
            image: prod?.imageUrl ?? null,
            status: inv.status,
          };
        }).filter(p => p.quantity > 0);
        setProducts(enriched);
        setFilteredProducts(enriched);
      })
      .catch(() => message.error('Không thể tải sản phẩm'))
      .finally(() => setLoadingProducts(false));
  }, [selectedStore, reloadKey]);

  // Client-side product search
  useEffect(() => {
    if (!search.trim()) { setFilteredProducts(products); return; }
    const q = search.toLowerCase();
    setFilteredProducts(products.filter(p => p.productName.toLowerCase().includes(q)));
  }, [search, products]);

  // Cart helpers
  const addToCart = (product) => {
    setCart(prev => {
      const existing = prev.find(c => c.productId === product.productId);
      if (existing) {
        if (existing.qty >= product.quantity) {
          message.warning('Tồn kho không đủ');
          return prev;
        }
        return prev.map(c => c.productId === product.productId ? { ...c, qty: c.qty + 1 } : c);
      }
      return [...prev, { ...product, qty: 1 }];
    });
  };

  const changeQty = (productId, qty) => {
    const prod = products.find(p => p.productId === productId);
    if (qty < 1) { removeFromCart(productId); return; }
    if (prod && qty > prod.quantity) { message.warning('Tồn kho không đủ'); return; }
    setCart(prev => prev.map(c => c.productId === productId ? { ...c, qty } : c));
  };

  const removeFromCart = (productId) => setCart(prev => prev.filter(c => c.productId !== productId));

  const subtotal = cart.reduce((sum, c) => sum + c.price * c.qty, 0);
  const total = Math.max(0, subtotal - couponDiscount);

  // Coupon
  const applyCoupon = async () => {
    if (!couponCode.trim()) return;
    setCouponError('');
    try {
      const res = await validateCoupon(couponCode.trim());
      const data = res?.data ?? res;
      // Calculate discount: fixed or percentage
      let disc = 0;
      if (data?.discountType === 'PERCENTAGE') {
        disc = subtotal * (data.discountValue / 100);
        if (data.maxDiscount) disc = Math.min(disc, data.maxDiscount);
      } else if (data?.discountType === 'FIXED') {
        disc = data.discountValue ?? 0;
      }
      setCouponDiscount(disc);
      message.success(`Đã áp dụng mã giảm giá: -${formatVND(disc)}`);
    } catch {
      setCouponError('Mã không hợp lệ hoặc đã hết hạn');
      setCouponDiscount(0);
    }
  };

  const removeCoupon = () => { setCouponCode(''); setCouponDiscount(0); setCouponError(''); };

  // Checkout
  const handleCheckout = async () => {
    if (cart.length === 0) { message.warning('Giỏ hàng trống'); return; }
    if (!selectedStore) { message.warning('Vui lòng chọn cửa hàng'); return; }
    setCheckoutLoading(true);
    try {
      const orderPayload = {
        userId: profile?.id ?? profile?.sub,
        storeId: selectedStore,
        items: cart.map(c => ({ productId: c.productId, quantity: c.qty })),
        couponCode: couponCode.trim() || undefined,
        notes: 'POS — Bán tại quầy',
      };
      const res = await createOrder(orderPayload);
      const order = res?.data ?? res;
      // Immediately mark as COMPLETED for in-store sale
      await updateOrderStatus(order.id, 'DELIVERED');
      setLastOrder({ ...order, total });
      setReceiptVisible(true);
      setCart([]);
      setCouponCode('');
      setCouponDiscount(0);
      message.success(`✅ Đơn #${order.orderNumber} đã hoàn tất!`);
    } catch (e) {
      message.error('Thanh toán thất bại: ' + (e?.message ?? 'Lỗi không xác định'));
    } finally {
      setCheckoutLoading(false);
    }
  };

  const currentStoreName = stores.find(s => s.storeId === selectedStore)?.storeName ?? '—';

  return (
    <>
      <Head>
        <title>POS Bán hàng — KidFavor</title>
        <style>{`
          * { box-sizing: border-box; }
          body { margin: 0; font-family: 'Inter', sans-serif; background: #f0f2f5; }
          .pos-layout { height: 100vh; display: flex; flex-direction: column; }
          .pos-header {
            display: flex; align-items: center; justify-content: space-between;
            background: linear-gradient(135deg, #1a1a2e 0%, #16213e 50%, #0f3460 100%);
            padding: 0 24px; height: 60px; flex-shrink: 0;
          }
          .pos-header-logo { color: #fff; font-size: 20px; font-weight: 700; letter-spacing: 1px; }
          .pos-header-store { color: #a0c4ff; font-size: 13px; }
          .pos-body { display: flex; flex: 1; overflow: hidden; }
          .pos-left { flex: 1; display: flex; flex-direction: column; overflow: hidden; background: #f8f9fa; }
          .pos-toolbar { padding: 12px 16px; display: flex; gap: 10px; background: #fff; border-bottom: 1px solid #e8e8e8; }
          .pos-grid { flex: 1; overflow-y: auto; padding: 16px; display: grid; grid-template-columns: repeat(auto-fill, minmax(155px, 1fr)); gap: 12px; align-content: start; }
          .pos-card {
            background: #fff; border-radius: 12px; overflow: hidden; cursor: pointer;
            border: 2px solid transparent; transition: all 0.18s; box-shadow: 0 2px 8px rgba(0,0,0,0.06);
          }
          .pos-card:hover { border-color: #0f3460; transform: translateY(-2px); box-shadow: 0 6px 20px rgba(15,52,96,0.15); }
          .pos-card-img {
            width: 100%; height: 120px; background: #f0f2f5;
            display: flex; align-items: center; justify-content: center;
            font-size: 40px; border-bottom: 1px solid #f0f0f0;
          }
          .pos-card-img img { width: 100%; height: 100%; object-fit: cover; display: block; }
          .pos-card-body { padding: 8px 10px 10px; min-height: 64px; }
          .pos-card-name { font-size: 12px; font-weight: 600; color: #1a1a2e; line-height: 1.3; margin-bottom: 4px; }
          .pos-card-price { color: #e63946; font-size: 13px; font-weight: 700; }
          .pos-card-stock { font-size: 11px; color: #6c757d; }
          .pos-right { width: 340px; display: flex; flex-direction: column; background: #fff; border-left: 1px solid #e8e8e8; flex-shrink: 0; }
          .pos-cart-header { padding: 14px 16px; background: #1a1a2e; color: #fff; font-size: 15px; font-weight: 700; display: flex; justify-content: space-between; align-items: center; }
          .pos-cart-items { flex: 1; overflow-y: auto; padding: 8px; }
          .pos-cart-item { display: flex; align-items: center; gap: 8px; padding: 8px 6px; border-radius: 8px; border-bottom: 1px solid #f0f0f0; }
          .pos-cart-item-name { flex: 1; font-size: 12px; font-weight: 600; color: #1a1a2e; }
          .pos-cart-item-price { font-size: 11px; color: #e63946; font-weight: 700; text-align: right; }
          .pos-cart-footer { padding: 12px 14px; border-top: 1px solid #e8e8e8; }
          .pos-total-row { display: flex; justify-content: space-between; margin-bottom: 6px; font-size: 13px; }
          .pos-grand-total { font-size: 18px; font-weight: 800; color: #1a1a2e; }
          .pos-checkout-btn { width: 100%; height: 48px; font-size: 16px; font-weight: 700; border-radius: 10px; background: linear-gradient(135deg, #e63946, #c1121f); border: none; color: #fff; }
          .receipt-line { display: flex; justify-content: space-between; margin: 4px 0; font-size: 13px; }
        `}</style>
      </Head>

      <div className="pos-layout">
        {/* ── Header ── */}
        <div className="pos-header">
          <div>
            <div className="pos-header-logo">🏪 KidFavor POS</div>
            <div className="pos-header-store">{currentStoreName}</div>
          </div>
          <div style={{ display: 'flex', gap: 8, alignItems: 'center' }}>
            <span style={{ color: '#a0c4ff', fontSize: 13 }}>{profile?.fullName || profile?.name || 'Nhân viên'}</span>
            <Button size="small" icon={<LogoutOutlined />} onClick={async () => { await logout(); router.push('/login'); }} style={{ background: 'rgba(255,255,255,0.1)', border: 'none', color: '#fff' }}>Đăng xuất</Button>
          </div>
        </div>

        <div className="pos-body">
          {/* ── Product Area ── */}
          <div className="pos-left">
            {/* Toolbar */}
            <div className="pos-toolbar">
              <Select
                placeholder="Chọn cửa hàng"
                value={selectedStore}
                onChange={setSelectedStore}
                style={{ width: 220 }}
                showSearch
                optionFilterProp="label"
                options={stores.map(s => ({ value: s.storeId, label: s.storeName }))}
              />
              <Input
                prefix={<SearchOutlined />}
                placeholder="Tìm sản phẩm..."
                value={search}
                onChange={e => setSearch(e.target.value)}
                style={{ flex: 1, borderRadius: 8 }}
              />
              <Tooltip title="Làm mới">
                <Button icon={<ReloadOutlined />} onClick={() => setReloadKey(k => k + 1)} />
              </Tooltip>
            </div>

            {/* Product grid */}
            <div className="pos-grid">
              {loadingProducts ? (
                <div style={{ gridColumn: '1/-1', display: 'flex', justifyContent: 'center', padding: 60 }}>
                  <Spin size="large" />
                </div>
              ) : filteredProducts.length === 0 ? (
                <div style={{ gridColumn: '1/-1', padding: 60 }}>
                  <Empty description={selectedStore ? 'Không có sản phẩm tồn kho' : 'Vui lòng chọn cửa hàng'} />
                </div>
              ) : filteredProducts.map(prod => (
                <div key={prod.productId} className="pos-card" onClick={() => addToCart(prod)}>
                  <div className="pos-card-img">
                    {prod.image ? (
                      <img
                        src={prod.image}
                        alt={prod.productName}
                        onError={e => { e.target.style.display='none'; e.target.nextSibling.style.display='flex'; }}
                      />
                    ) : null}
                    <span style={{ display: prod.image ? 'none' : 'flex' }}>🧸</span>
                  </div>
                  <div className="pos-card-body">
                    <div className="pos-card-name" title={prod.productName}>{prod.productName}</div>
                    <div className="pos-card-price">{formatVND(prod.price)}</div>
                    <div className="pos-card-stock">Tồn: {prod.quantity}</div>
                  </div>
                </div>
              ))}
            </div>
          </div>

          {/* ── Cart ── */}
          <div className="pos-right">
            <div className="pos-cart-header">
              <span><ShoppingCartOutlined /> Hóa đơn</span>
              <Badge count={cart.reduce((s, c) => s + c.qty, 0)} style={{ background: '#e63946' }} />
            </div>

            <div className="pos-cart-items">
              {cart.length === 0 ? (
                <Empty style={{ marginTop: 40 }} description="Chưa có sản phẩm" />
              ) : cart.map(item => (
                <div key={item.productId} className="pos-cart-item">
                  <Avatar size={32} style={{ background: '#e9ecef', color: '#555', fontSize: 16 }}>🧸</Avatar>
                  <div style={{ flex: 1, minWidth: 0 }}>
                    <div className="pos-cart-item-name" style={{ overflow: 'hidden', textOverflow: 'ellipsis', whiteSpace: 'nowrap' }} title={item.productName}>{item.productName}</div>
                    <div className="pos-cart-item-price">{formatVND(item.price * item.qty)}</div>
                  </div>
                  <div style={{ display: 'flex', alignItems: 'center', gap: 3 }}>
                    <Button size="small" icon={<MinusOutlined />} onClick={() => changeQty(item.productId, item.qty - 1)} style={{ width: 22, height: 22, padding: 0, minWidth: 0, borderRadius: 4 }} />
                    <span style={{ width: 22, textAlign: 'center', fontSize: 12, fontWeight: 700 }}>{item.qty}</span>
                    <Button size="small" icon={<PlusOutlined />} onClick={() => changeQty(item.productId, item.qty + 1)} style={{ width: 22, height: 22, padding: 0, minWidth: 0, borderRadius: 4 }} />
                    <Button size="small" danger icon={<DeleteOutlined />} onClick={() => removeFromCart(item.productId)} style={{ width: 22, height: 22, padding: 0, minWidth: 0, borderRadius: 4, marginLeft: 2 }} />
                  </div>
                </div>
              ))}
            </div>

            <div className="pos-cart-footer">
              {/* Coupon */}
              <div style={{ marginBottom: 10 }}>
                {couponDiscount > 0 ? (
                  <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', background: '#f6ffed', border: '1px solid #b7eb8f', borderRadius: 8, padding: '6px 10px' }}>
                    <span style={{ fontSize: 12 }}><TagOutlined style={{ color: '#52c41a' }} /> {couponCode} <span style={{ color: '#52c41a', fontWeight: 700 }}>-{formatVND(couponDiscount)}</span></span>
                    <Button type="text" size="small" danger onClick={removeCoupon}>✕</Button>
                  </div>
                ) : (
                  <Space.Compact style={{ width: '100%' }}>
                    <Input
                      value={couponCode}
                      onChange={e => { setCouponCode(e.target.value); setCouponError(''); }}
                      placeholder="Mã giảm giá"
                      onPressEnter={applyCoupon}
                      status={couponError ? 'error' : ''}
                    />
                    <Button onClick={applyCoupon} type="primary" style={{ background: '#0f3460', borderColor: '#0f3460' }}>Áp dụng</Button>
                  </Space.Compact>
                )}
                {couponError && <div style={{ color: '#ff4d4f', fontSize: 11, marginTop: 4 }}>{couponError}</div>}
              </div>

              <Divider style={{ margin: '8px 0' }} />
              <div className="pos-total-row"><span>Tạm tính</span><span>{formatVND(subtotal)}</span></div>
              {couponDiscount > 0 && <div className="pos-total-row" style={{ color: '#52c41a' }}><span>Giảm giá</span><span>-{formatVND(couponDiscount)}</span></div>}
              <div className="pos-total-row" style={{ marginBottom: 14 }}>
                <span className="pos-grand-total">Tổng cộng</span>
                <span className="pos-grand-total" style={{ color: '#e63946' }}>{formatVND(total)}</span>
              </div>

              <Button
                className="pos-checkout-btn"
                icon={<CheckCircleOutlined />}
                loading={checkoutLoading}
                disabled={cart.length === 0}
                onClick={handleCheckout}
              >
                Thanh toán
              </Button>

              {cart.length > 0 && (
                <Button block onClick={() => setCart([])} style={{ marginTop: 8, borderRadius: 8 }} danger>
                  Xóa hết
                </Button>
              )}
            </div>
          </div>
        </div>
      </div>

      {/* ── Receipt Modal ── */}
      <Modal
        title={<span style={{ color: '#1a1a2e' }}>🧾 Hóa đơn thanh toán</span>}
        open={receiptVisible}
        footer={[
          <Button key="print" onClick={() => window.print()}>In hóa đơn</Button>,
          <Button key="ok" type="primary" style={{ background: '#0f3460' }} onClick={() => setReceiptVisible(false)}>Đóng</Button>,
        ]}
        onCancel={() => setReceiptVisible(false)}
      >
        {lastOrder && (
          <div style={{ fontFamily: 'monospace', fontSize: 13 }}>
            <div style={{ textAlign: 'center', marginBottom: 16 }}>
              <div style={{ fontSize: 18, fontWeight: 700 }}>KidFavor — {currentStoreName}</div>
              <div style={{ color: '#888' }}>Đơn hàng #{lastOrder.orderNumber}</div>
              <Tag color="green" icon={<CheckCircleOutlined />} style={{ marginTop: 6 }}>Đã hoàn tất</Tag>
            </div>
            <Divider />
            {(lastOrder.items ?? cart).map((item, i) => (
              <div key={i} className="receipt-line">
                <span>{item.productName ?? item.name} × {item.quantity ?? item.qty}</span>
                <span>{formatVND((item.unitPrice ?? item.price) * (item.quantity ?? item.qty))}</span>
              </div>
            ))}
            <Divider />
            <div className="receipt-line" style={{ fontWeight: 700, fontSize: 15 }}>
              <span>Tổng cộng</span><span style={{ color: '#e63946' }}>{formatVND(lastOrder.total)}</span>
            </div>
          </div>
        )}
      </Modal>
    </>
  );
}
