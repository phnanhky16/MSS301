/**
 * Google OAuth2 Helper Functions
 * 
 * Flow:
 * 1. User clicks "Login with Google" button
 * 2. Frontend redirects to backend OAuth2 endpoint
 * 3. Backend handles entire OAuth2 flow with Google
 * 4. Backend creates/updates user and generates JWT
 * 5. Backend redirects back to frontend with token in URL
 * 6. Frontend extracts token and stores it
 */

/**
 * Get the OAuth2 base URL from environment
 */
export function getOAuth2BaseUrl() {
  const apiBaseUrl = process.env.NEXT_PUBLIC_API_BASE_URL || 'http://localhost:8080/api';
  return apiBaseUrl.replace('/api', ''); // Remove /api suffix to get base URL
}

/**
 * Initiate Google OAuth2 login
 * Redirects user to backend which handles the OAuth2 flow
 */
export function initiateGoogleLogin() {
  const baseUrl = getOAuth2BaseUrl();
  window.location.href = `${baseUrl}/oauth2/authorization/google`;
}

/**
 * Extract token from URL query params (after OAuth2 redirect)
 * Returns { token, error }
 */
export function extractOAuth2Params(queryParams) {
  return {
    token: queryParams.token || null,
    error: queryParams.error || null,
  };
}

/**
 * Decode JWT token to get user info
 * Returns decoded payload or null if invalid
 */
export function decodeJWT(token) {
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
  } catch (error) {
    console.error('Failed to decode JWT:', error);
    return null;
  }
}

/**
 * Get user info from stored token
 */
export function getUserFromToken() {
  const token = localStorage.getItem('accessToken');
  if (!token) return null;
  return decodeJWT(token);
}

/**
 * Handle OAuth2 callback
 * Stores token and returns success/error status
 */
export function handleOAuth2Callback(token, error) {
  if (token) {
    localStorage.setItem('accessToken', token);
    
    // Decode and store user info
    const userInfo = decodeJWT(token);
    if (userInfo) {
      localStorage.setItem('userInfo', JSON.stringify({
        userId: userInfo.userId,
        email: userInfo.email,
        role: userInfo.role,
        name: userInfo.sub || userInfo.email.split('@')[0]
      }));
    }

    // Trigger app-wide auth listeners in the same tab.
    window.dispatchEvent(new Event('storage'));
    window.dispatchEvent(new Event('auth-changed'));
    
    return { success: true, message: 'Signed in with Google successfully!' };
  } else if (error) {
    return { success: false, message: error.replace(/_/g, ' ') };
  }
  return { success: false, message: 'Unknown error occurred' };
}
