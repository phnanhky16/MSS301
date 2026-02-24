const API_BASE = process.env.NEXT_PUBLIC_API_BASE_URL || 'http://localhost:8080/api';

export async function request(path, options = {}) {
  // attach token if available
  const headers = {
    'Content-Type': 'application/json',
    ...(options.headers || {}),
  };
  const token = localStorage.getItem('accessToken');
  if (token) {
    headers['Authorization'] = `Bearer ${token}`;
  }
  const res = await fetch(`${API_BASE}${path}`, {
    headers,
    ...options,
  });
  if (!res.ok) {
    const text = await res.text();
    if (typeof console !== 'undefined') {
      console.warn(`api request ${path} returned status ${res.status}`, text);
    }
    if (res.status === 401) {
      // token might be invalid/expired
      localStorage.removeItem('accessToken');
      localStorage.removeItem('refreshToken');
      // redirect to login page (only in browser)
      if (typeof window !== 'undefined') {
        window.location.href = '/login';
      }
    }
    throw new Error(text || res.statusText);
  }
  let json;
  try {
    json = await res.json();
  } catch (e) {
    if (typeof console !== 'undefined') {
      console.error(`api response ${path} parse error`, e);
    }
    throw e;
  }
  // many of our backend endpoints wrap payloads in {status,msg,data,...}
  // unwrapping here keeps callers simpler (they can just use the object
  // returned by the controller). login() handles this itself earlier, but
  // other consumers also benefit.
  return json && json.data !== undefined ? json.data : json;
}

export function fetchCoupons(page = 0, size = 10, filters = {}) {
  const params = new URLSearchParams({ page, size });
  if (filters.code) params.append('code', filters.code);
  if (filters.active !== undefined) params.append('active', filters.active);
  if (filters.discountType) params.append('discountType', filters.discountType);
  return request(`/coupons?${params.toString()}`);
}

// coupon data object should match backend DTO: {code, discountType, discountValue, expiresAt, maxRedemptions, active}
export function createCoupon(data) {
  return request('/coupons', { method: 'POST', body: JSON.stringify(data) });
}

export function updateCoupon(code, data) {
  return request(`/coupons/${code}`, { method: 'PUT', body: JSON.stringify(data) });
}

export function deleteCoupon(code) {
  return request(`/coupons/${code}`, { method: 'DELETE' });
}

// TODO: add other API wrappers (orders, users, etc.)
// fetchOrders with optional filter parameters. Filters are appended
// as query params only when provided. `sort` may be a string like
// "createdAt,desc" or "totalAmount,asc".
export function fetchOrders(page = 0, size = 10, filters = {}) {
  const params = new URLSearchParams({ page, size });
  if (filters.orderNumber) params.append('orderNumber', filters.orderNumber);
  // totals removed from UI, still allowed but harmless
  if (filters.minTotal != null) params.append('minTotal', filters.minTotal);
  if (filters.maxTotal != null) params.append('maxTotal', filters.maxTotal);
  if (filters.date) {
    // expect JS Date or ISO string
    const d = filters.date instanceof Date ? filters.date.toISOString() : filters.date;
    params.append('startDate', d);
    params.append('endDate', d);
  }
  if (filters.status) params.append('status', filters.status);
  if (filters.sort) params.append('sort', filters.sort);
  return request(`/orders?${params.toString()}`);
}

export function fetchProducts(page = 0, size = 10, filters = {}) {
  const params = new URLSearchParams({ page, size });
  if (filters.keyword) params.append('keyword', filters.keyword);
  if (filters.categoryId) params.append('categoryId', filters.categoryId);
  if (filters.brandId) params.append('brandId', filters.brandId);
  if (filters.status) params.append('status', filters.status);
  if (filters.sort) params.append('sort', filters.sort);
  return request(`/products?${params.toString()}`);
}

// convenience helper for public/home pages that should only ever see
// active products. the backend already treats a missing `status` as
// ACTIVE, but making the parameter explicit guards against future
// callers accidentally passing a different value.
export function fetchActiveProducts(page = 0, size = 10, filters = {}) {
  return fetchProducts(page, size, { ...filters, status: 'ACTIVE' });
}

export function fetchCategories() {
  return request('/categories');
}

export function fetchBrands() {
  return request('/brands');
}

export function createProduct(data) {
  return request('/products', { method: 'POST', body: JSON.stringify(data) });
}

export function updateProduct(id, data) {
  return request(`/products/${id}`, { method: 'PUT', body: JSON.stringify(data) });
}

export function deleteProduct(id) {
  return request(`/products/${id}`, { method: 'DELETE' });
}

// change product status (ACTIVE, INACTIVE, DELETED)
export function updateProductStatus(id, data) {
  return request(`/products/${id}/status`, {
    method: 'PUT',
    body: JSON.stringify(data),
  });
}

export function fetchUsers(page = 0, size = 10, filters = {}) {
  const params = new URLSearchParams({ page, size });
  if (filters.keyword) params.append('keyword', filters.keyword);
  if (filters.status !== undefined) params.append('status', filters.status);
  if (filters.role) params.append('role', filters.role);
  return request(`/users?${params.toString()}`);
}

// dashboard helpers
export function fetchUserCount() {
  return request('/users/count');
}

export function fetchOrderStats() {
  return request('/orders/stats');
}

export function deleteUser(id, deleteFlag) {
  // deleteFlag optional boolean to request full delete (otherwise toggles status)
  const suffix = deleteFlag ? '?delete=true' : '';
  return request(`/users/${id}${suffix}`, { method: 'DELETE' });
}

export function fetchOrderById(id) {
  return request(`/orders/${id}`);
}

export function fetchUserById(id) {
  return request(`/users/${id}`);
}
