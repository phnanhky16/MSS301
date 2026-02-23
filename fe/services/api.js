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

export function fetchCoupons(page = 0, size = 10) {
  return request(`/coupons?page=${page}&size=${size}`);
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

export function fetchUsers(page = 0, size = 10) {
  return request(`/users?page=${page}&size=${size}`);
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
