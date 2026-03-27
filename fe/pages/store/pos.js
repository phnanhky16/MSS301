'use client';
import { useState, useEffect } from 'react';
import Head from 'next/head';
import {
  Layout, Button, Select, Input, Badge, Modal, Spin, message, Pagination,
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
  fetchActiveStores, fetchInStockProducts,
  createOrder, updateOrderStatus, validateCoupon,
} from '../../services/api';

const { Sider, Content, Header } = Layout;

const formatVND = (n) =>
  new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(n || 0);

const normalizeRole = (role) => {
  if (!role) return '';
  const value = String(role).toUpperCase();
  return value.startsWith('ROLE_') ? value.slice(5) : value;
};

const getUserSession = () => {
  const tokenUser = getCurrentUser();
  let storedUser = null;

  try {
    const raw = localStorage.getItem('userInfo');
    storedUser = raw ? JSON.parse(raw) : null;
  } catch (_) {
    storedUser = null;
  }

  if (!tokenUser && !storedUser) return null;
  const merged = { ...(storedUser || {}), ...(tokenUser || {}) };
  return { ...merged, role: normalizeRole(merged.role) };
};

const resolveUserId = (user) => {
  if (!user) return null;
  return user.userId ?? user.id ?? null;
};

const pickFirst = (obj, keys, fallback = undefined) => {
  if (!obj || !Array.isArray(keys)) return fallback;
  for (const key of keys) {
    const value = obj?.[key];
    if (value !== undefined && value !== null && value !== '') {
      return value;
    }
  }
  return fallback;
};

const parseNumberSafe = (value, fallback = 0) => {
  const n = Number(value);
  return Number.isFinite(n) ? n : fallback;
};

export default function POSDashboard() {
  const router = useRouter();
  const [msgApi, msgHolder] = message.useMessage();
  const [profile, setProfile] = useState(null);
  const [stores, setStores] = useState([]);
  const [selectedStore, setSelectedStore] = useState(null);
  const [products, setProducts] = useState([]);
  const [filteredProducts, setFilteredProducts] = useState([]);
  const [search, setSearch] = useState('');
  const [page, setPage] = useState(1);
  const pageSize = 12;
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
    const user = getUserSession();
    setProfile(user);
    if (!user) { router.push('/login'); return; }
    if (user.role !== 'STAFF_FOR_STORE' && user.role !== 'ADMIN') {
      router.push('/');
    }
  }, [router]);

  // Load stores
  useEffect(() => {
    fetchActiveStores()
      .then(data => {
        const list = Array.isArray(data) ? data : (data?.data ?? []);
        setStores(list);
        if (list.length === 1) setSelectedStore(list[0].storeId);
      })
      .catch(() => msgApi.error('Không thể tải danh sách cửa hàng'));
  }, [msgApi]);

  // Load products when store selected or refresh requested
  useEffect(() => {
    if (!selectedStore) { setProducts([]); setFilteredProducts([]); return; }
    setLoadingProducts(true);
    fetchInStockProducts(selectedStore)
      .then((inventory) => {
        const invList = Array.isArray(inventory) ? inventory : (inventory?.data ?? []);

        const mapped = invList.map((inv, index) => {
          const productId = parseNumberSafe(pickFirst(inv, ['productId', 'product_id', 'id'], inv.product?.id), 0);
          const quantity = parseNumberSafe(pickFirst(inv, ['quantity', 'stock', 'availableQuantity'], 0), 0);
          const productName =
            pickFirst(inv, ['productName', 'name', 'product_name'], null)
            || inv.product?.name
            || `SP #${productId || index + 1}`;
          const price = parseNumberSafe(
            pickFirst(inv, ['salePrice', 'price', 'sellingPrice', 'unitPrice', 'sale_price', 'selling_price'],
              inv.product?.salePrice
              ?? inv.product?.price
              ?? inv.product?.sellingPrice
              ?? inv.product?.unitPrice
              ?? 0)
          , 0);
          const image =
            pickFirst(inv, ['imageUrl', 'imageURL', 'image', 'thumbnail', 'image_url'], null)
            || inv.product?.imageUrl
            || null;

          return {
            productId: productId || `inv-${index}`,
            productName,
            quantity: Number.isFinite(quantity) ? quantity : 0,
            price: Number.isFinite(price) ? price : 0,
            image,
            status: inv.status,
          };
        }).filter(p => p.quantity > 0);

        setProducts(mapped);
        setFilteredProducts(mapped);
        setPage(1);
      })
      .catch(() => msgApi.error('Không thể tải sản phẩm'))
      .finally(() => setLoadingProducts(false));
  }, [selectedStore, reloadKey, msgApi]);

  // Client-side product search
  useEffect(() => {
    if (!search.trim()) { setFilteredProducts(products); return; }
    const q = search.toLowerCase();
    setFilteredProducts(products.filter(p => p.productName.toLowerCase().includes(q)));
    setPage(1);
  }, [search, products]);

  // Cart helpers
  const addToCart = (product) => {
    setCart(prev => {
      const existing = prev.find(c => c.productId === product.productId);
      if (existing) {
        if (existing.qty >= product.quantity) {
          msgApi.warning('Tồn kho không đủ');
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
    if (prod && qty > prod.quantity) { msgApi.warning('Tồn kho không đủ'); return; }
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
      msgApi.success(`Đã áp dụng mã giảm giá: -${formatVND(disc)}`);
    } catch {
      setCouponError('Mã không hợp lệ hoặc đã hết hạn');
      setCouponDiscount(0);
    }
  };

  const removeCoupon = () => { setCouponCode(''); setCouponDiscount(0); setCouponError(''); };

  // Checkout
  const handleCheckout = async () => {
    if (cart.length === 0) { msgApi.warning('Giỏ hàng trống'); return; }
    if (!selectedStore) { msgApi.warning('Vui lòng chọn cửa hàng'); return; }
    const userId = resolveUserId(profile);
    if (!userId) {
      msgApi.error('Không xác định được nhân viên đăng nhập, vui lòng đăng nhập lại');
      return;
    }
    setCheckoutLoading(true);
    try {
      const orderPayload = {
        userId,
        storeId: selectedStore,
        items: cart.map(c => ({ productId: c.productId, quantity: c.qty })),
        couponCode: couponCode.trim().toUpperCase() || undefined,
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
      msgApi.success(`✅ Đơn #${order.orderNumber ?? order.id} đã hoàn tất!`);
    } catch (e) {
      msgApi.error('Thanh toán thất bại: ' + (e?.message ?? 'Lỗi không xác định'));
    } finally {
      setCheckoutLoading(false);
    }
  };

  const currentStoreName = stores.find(s => s.storeId === selectedStore)?.storeName ?? '—';
  const start = (page - 1) * pageSize;
  const pagedProducts = filteredProducts.slice(start, start + pageSize);

  return (
    <>
      {msgHolder}
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
          .pos-grid { flex: 1; overflow-y: auto; padding: 16px; align-content: start; }
          .pos-shop-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(180px, 1fr));
            gap: 14px;
          }
          .pos-shop-card {
            background: #fff;
            border: 1.5px solid #e9ecef;
            border-radius: 12px;
            padding: 10px;
            cursor: pointer;
            display: flex;
            flex-direction: column;
            gap: 8px;
            min-height: 250px;
            position: relative;
            transition: box-shadow 0.2s, transform 0.2s;
          }
          .pos-shop-card:hover {
            box-shadow: 0 8px 24px rgba(0, 0, 0, 0.08);
            transform: translateY(-2px);
          }
          .pos-shop-add {
            position: absolute;
            right: 10px;
            top: 10px;
            width: 30px;
            height: 30px;
            border: none;
            border-radius: 50%;
            background: #1ca8c8;
            color: #fff;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
          }
          .pos-shop-image {
            height: 130px;
            border-radius: 10px;
            background: #f3f5f7;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 40px;
            overflow: hidden;
          }
          .pos-shop-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
          }
          .pos-shop-info {
            display: flex;
            flex-direction: column;
            gap: 6px;
          }
          .pos-shop-name {
            font-size: 13px;
            line-height: 1.35;
            color: #24303f;
            font-weight: 600;
            margin: 0;
            min-height: 34px;
          }
          .pos-shop-price {
            font-size: 15px;
            font-weight: 700;
            color: #1ca8c8;
          }
          .pos-shop-stock {
            font-size: 12px;
            color: #5c6b7a;
          }
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
            <div className="pos-grid pos-shop-grid">
              {loadingProducts ? (
                <div style={{ gridColumn: '1/-1', display: 'flex', justifyContent: 'center', padding: 60 }}>
                  <Spin size="large" />
                </div>
              ) : filteredProducts.length === 0 ? (
                <div style={{ gridColumn: '1/-1', padding: 60 }}>
                  <Empty description={selectedStore ? 'Không có sản phẩm tồn kho' : 'Vui lòng chọn cửa hàng'} />
                </div>
              ) : pagedProducts.map(prod => {
                const displayName = prod.productName || 'Sản phẩm chưa có tên';
                const displayPrice = Number.isFinite(Number(prod.price)) ? Number(prod.price) : 0;
                const displayImage = prod.image;
                const mergedProduct = {
                  ...prod,
                  productName: displayName,
                  price: displayPrice,
                  image: displayImage,
                };

                return (
                <div key={prod.productId} className="pos-shop-card" onClick={() => addToCart(mergedProduct)}>
                  <button
                    className="pos-shop-add"
                    aria-label="Thêm vào hóa đơn"
                    onClick={(e) => {
                      e.stopPropagation();
                      addToCart(mergedProduct);
                    }}
                  >
                    <ShoppingCartOutlined />
                  </button>

                  <div className="pos-shop-image">
                    {displayImage ? (
                      <img
                        src={displayImage}
                        alt={displayName || 'Sản phẩm'}
                        onError={e => { e.target.style.display='none'; e.target.nextSibling.style.display='flex'; }}
                      />
                    ) : null}
                    <span style={{ display: displayImage ? 'none' : 'flex' }}>🧸</span>
                  </div>

                  <div className="pos-shop-info">
                    <p className="pos-shop-name" title={displayName}>
                      {displayName}
                    </p>
                    <span className="pos-shop-price">{formatVND(displayPrice)}</span>
                    <div className="pos-shop-stock">
                      Tồn kho cửa hàng: {Number.isFinite(prod.quantity) ? prod.quantity : 0}
                    </div>
                  </div>
                </div>
              )})}

              {!loadingProducts && filteredProducts.length > pageSize && (
                <div style={{ gridColumn: '1/-1', display: 'flex', justifyContent: 'center', marginTop: 12 }}>
                  <Pagination
                    current={page}
                    pageSize={pageSize}
                    total={filteredProducts.length}
                    showSizeChanger={false}
                    onChange={setPage}
                  />
                </div>
              )}
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
