import { request } from './api';

export function login(username, password) {
  return request('/auth/login', {
    method: 'POST',
    body: JSON.stringify({ username, password }),
  }).then(res => {
    console.debug('login response', res);
    // store tokens
    const payload = res.data || res;
    if (payload && payload.accessToken) {
      localStorage.setItem('accessToken', payload.accessToken);
    }
    if (payload && payload.refreshToken) {
      localStorage.setItem('refreshToken', payload.refreshToken);
    }
    return payload;
  });
}

export function logout() {
  const token = localStorage.getItem('accessToken');
  // clear tokens immediately so UI state updates even if network stalls
  localStorage.removeItem('accessToken');
  localStorage.removeItem('refreshToken');
  if (token) {
    // return promise so callers can await
    return request('/auth/logout', {
      method: 'POST',
      body: JSON.stringify({ token }),
    }).catch(() => {
      // ignore errors; logout is best-effort
    });
  }
  return Promise.resolve();
}

export function refresh() {
  const refreshToken = localStorage.getItem('refreshToken');
  if (!refreshToken) return Promise.reject('No refresh token');
  return request('/auth/refresh', {
    method: 'POST',
    body: JSON.stringify({ refreshToken }),
  }).then(res => {
    localStorage.setItem('accessToken', res.data.accessToken);
    return res.data;
  });
}

// helper to decode a JWT payload
export function parseJwt(token) {
  if (!token) return null;
  try {
    const base64Url = token.split('.')[1];
    const base64 = base64Url.replace(/-/g, '+').replace(/_/g, '/');
    const jsonPayload = decodeURIComponent(
      atob(base64)
        .split('')
        .map(c => '%' + ('00' + c.charCodeAt(0).toString(16)).slice(-2))
        .join('')
    );
    return JSON.parse(jsonPayload);
  } catch (e) {
    console.warn('Failed to parse JWT', e);
    return null;
  }
}

export function getCurrentUser() {
  const token = localStorage.getItem('accessToken');
  return parseJwt(token);
}

// Real Google OAuth login - sends Google ID token to backend
export function loginWithGoogle(googleIdToken) {
  return request('/auth/google-login', {
    method: 'POST',
    body: JSON.stringify({ idToken: googleIdToken }),
  }).then(res => {
    console.debug('Google login response', res);
    // store tokens
    const payload = res.data || res;
    if (payload && payload.accessToken) {
      localStorage.setItem('accessToken', payload.accessToken);
    }
    if (payload && payload.refreshToken) {
      localStorage.setItem('refreshToken', payload.refreshToken);
    }
    return payload;
  });
}

export function requestPasswordResetOtp(email) {
  return request('/auth/password-reset/request-otp', {
    method: 'POST',
    body: JSON.stringify({ email }),
  });
}

export function verifyPasswordResetOtp(email, verificationCode) {
  return request('/auth/password-reset/verify-otp', {
    method: 'POST',
    body: JSON.stringify({ email, verificationCode }),
  });
}

export function confirmPasswordReset(token, newPassword, confirmPassword) {
  return request('/auth/password-reset/confirm', {
    method: 'POST',
    body: JSON.stringify({ token, newPassword, confirmPassword }),
  });
}

