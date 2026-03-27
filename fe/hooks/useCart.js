import React, { createContext, useContext, useState, useEffect } from 'react';
import Cookies from 'js-cookie';
import {
    fetchMyCart,
    addCartItem,
    updateCartItemQuantity,
    removeCartItem,
    clearMyCart
} from '../services/api';

const CartContext = createContext();
const CART_COOKIE_KEY = 'cart';
const CART_COOKIE_EXPIRES_DAYS = 7;

function parseJwt(token) {
    if (!token) return null;
    try {
        const payload = token.split('.')[1];
        if (!payload) return null;
        const base64 = payload.replace(/-/g, '+').replace(/_/g, '/');
        const jsonPayload = decodeURIComponent(
            atob(base64)
                .split('')
                .map(c => '%' + ('00' + c.charCodeAt(0).toString(16)).slice(-2))
                .join('')
        );
        return JSON.parse(jsonPayload);
    } catch (_) {
        return null;
    }
}

function normalizeRole(role) {
    if (!role) return '';
    const value = String(role).toUpperCase();
    return value.startsWith('ROLE_') ? value.slice(5) : value;
}

function getAuthContext() {
    if (typeof window === 'undefined') {
        return { token: null, role: '', isCustomer: false, isLoggedIn: false };
    }

    const token = localStorage.getItem('accessToken');
    const decoded = parseJwt(token);
    const role = normalizeRole(decoded?.role);
    return {
        token,
        role,
        isLoggedIn: !!token,
        isCustomer: role === 'CUSTOMER'
    };
}

function loadCookieCart() {
    const savedCart = Cookies.get(CART_COOKIE_KEY);
    if (!savedCart) return [];

    try {
        const parsed = JSON.parse(savedCart);
        return Array.isArray(parsed) ? parsed : [];
    } catch (e) {
        console.error('Failed to parse cart cookie', e);
        Cookies.remove(CART_COOKIE_KEY);
        return [];
    }
}

function saveCookieCart(items) {
    Cookies.set(CART_COOKIE_KEY, JSON.stringify(items), { expires: CART_COOKIE_EXPIRES_DAYS });
}

function mapServerCartItem(item) {
    const product = item?.product || {};
    const productId = Number(item?.productId || product?.id);
    
    // Use effectivePrice from server if available (already includes sale price logic)
    // otherwise calculate it locally
    const serverEffectivePrice = product?.effectivePrice ? Number(product.effectivePrice) : null;
    const isOnSale = product?.onSale && product?.salePrice != null;
    const effectivePrice = serverEffectivePrice !== null 
        ? serverEffectivePrice 
        : (isOnSale ? Number(product?.salePrice || 0) : Number(product?.price || 0));
    
    return {
        id: productId,
        productId,
        name: product?.name || `Product #${productId}`,
        price: effectivePrice,  // Use effective price (sale price if available)
        salePrice: product?.salePrice ? Number(product.salePrice) : null,
        onSale: Boolean(product?.onSale),
        originalPrice: Number(product?.price || 0),  // Keep original price for reference
        imageUrls: Array.isArray(product?.imageUrls) ? product.imageUrls : [],
        img: (Array.isArray(product?.imageUrls) && product.imageUrls.length > 0) ? product.imageUrls[0] : '🧸',
        quantity: Number(item?.quantity || 1),
    };
}

function mapServerCart(cartResponse) {
    const items = Array.isArray(cartResponse?.items) ? cartResponse.items : [];
    return items.map(mapServerCartItem).filter(item => Number.isFinite(item.id));
}

export function CartProvider({ children }) {
    const [cart, setCart] = useState([]);
    const [authState, setAuthState] = useState(getAuthContext());
    const previousAuthRef = React.useRef(authState);
    const syncingRef = React.useRef(false);

    const syncCartWithAuth = async ({ tryMergeCookie } = { tryMergeCookie: false }) => {
        if (syncingRef.current) {
            return;
        }
        syncingRef.current = true;
        try {
            const currentAuth = getAuthContext();
            setAuthState(currentAuth);

            if (!currentAuth.isLoggedIn || !currentAuth.isCustomer) {
                setCart(loadCookieCart());
                return;
            }

            const cookieItems = loadCookieCart();
            let serverCartResponse = await fetchMyCart();
            let serverItems = mapServerCart(serverCartResponse);

            let mergedCookieToServer = false;
            if (tryMergeCookie && cookieItems.length > 0 && serverItems.length === 0) {
                for (const item of cookieItems) {
                    const productId = Number(item?.id || item?.productId);
                    const quantity = Number(item?.quantity || 1);
                    if (!Number.isFinite(productId) || quantity <= 0) {
                        continue;
                    }
                    await addCartItem(productId, quantity);
                }
                serverCartResponse = await fetchMyCart();
                serverItems = mapServerCart(serverCartResponse);
                mergedCookieToServer = true;
            }

            // Only clear guest cart after a verified successful merge.
            if (mergedCookieToServer) {
                Cookies.remove(CART_COOKIE_KEY);
            }
            setCart(serverItems);
        } catch (e) {
            // cart-service can be temporarily unavailable; keep UX alive with cookie cart
            console.warn(`Cart sync fallback to cookie cart: ${e?.message || 'unknown error'}`);
            setCart(loadCookieCart());
        } finally {
            syncingRef.current = false;
        }
    };

    useEffect(() => {
        const handleAuthChange = () => {
            const prev = previousAuthRef.current;
            const next = getAuthContext();
            const justLoggedInCustomer = (!prev.isLoggedIn || !prev.isCustomer) && (next.isLoggedIn && next.isCustomer);
            previousAuthRef.current = next;
            void syncCartWithAuth({ tryMergeCookie: justLoggedInCustomer });
        };

        void syncCartWithAuth({ tryMergeCookie: false });
        window.addEventListener('storage', handleAuthChange);
        window.addEventListener('auth-changed', handleAuthChange);

        return () => {
            window.removeEventListener('storage', handleAuthChange);
            window.removeEventListener('auth-changed', handleAuthChange);
        };
    }, []);

    const addToCart = async (product, quantity = 1) => {
        try {
            const productId = Number(product?.id || product?.productId);
            if (!Number.isFinite(productId)) return false;

            const qtyToAdd = Number(quantity || 1);
            if (!Number.isFinite(qtyToAdd) || qtyToAdd <= 0) return false;

            const currentAuth = getAuthContext();
            if (currentAuth.isLoggedIn && currentAuth.isCustomer) {
                try {
                    await addCartItem(productId, qtyToAdd);
                    await syncCartWithAuth({ tryMergeCookie: false });
                    return true;
                } catch (_) {
                    // Keep shopping uninterrupted if cart-service temporarily fails.
                    setCart(prevCart => {
                        const newCart = [...prevCart];
                        const existingIndex = newCart.findIndex(item => Number(item.id) === productId);

                        if (existingIndex > -1) {
                            newCart[existingIndex] = {
                                ...newCart[existingIndex],
                                quantity: Number(newCart[existingIndex].quantity || 0) + qtyToAdd
                            };
                        } else {
                            newCart.push({
                                id: productId,
                                productId,
                                name: product?.name || `Product #${productId}`,
                                price: Number(product?.price || 0),  // Use price passed from product (may be effectivePrice)
                                salePrice: product?.salePrice ? Number(product.salePrice) : null,
                                onSale: Boolean(product?.onSale),
                                originalPrice: Number(product?.price || 0),
                                imageUrls: product?.imageUrls || [],
                                img: product?.img || '🧸',
                                quantity: qtyToAdd
                            });
                        }

                        saveCookieCart(newCart);
                        return newCart;
                    });
                    return true;
                }
                return false;
            }

            setCart(prevCart => {
                const newCart = [...prevCart];
                const existingIndex = newCart.findIndex(item => Number(item.id) === productId);

                if (existingIndex > -1) {
                    newCart[existingIndex] = {
                        ...newCart[existingIndex],
                        quantity: Number(newCart[existingIndex].quantity || 0) + qtyToAdd
                    };
                } else {
                    newCart.push({
                        id: productId,
                        productId,
                        name: product?.name || `Product #${productId}`,
                        price: Number(product?.price || 0),  // Use price passed from product (may be effectivePrice)
                        salePrice: product?.salePrice ? Number(product.salePrice) : null,
                        onSale: Boolean(product?.onSale),
                        originalPrice: Number(product?.price || 0),
                        imageUrls: product?.imageUrls || [],
                        img: product?.img || '🧸',
                        quantity: qtyToAdd
                    });
                }

                saveCookieCart(newCart);
                return newCart;
            });
            return true;
        } catch (e) {
            console.warn(`addToCart failed: ${e?.message || 'unknown error'}`);
            return false;
        }
    };

    const updateQuantity = async (productId, quantity) => {
        try {
            const normalizedProductId = Number(productId);
            const normalizedQty = Number(quantity);
            if (!Number.isFinite(normalizedProductId) || !Number.isFinite(normalizedQty)) return;

            const currentAuth = getAuthContext();
            if (currentAuth.isLoggedIn && currentAuth.isCustomer) {
                if (normalizedQty <= 0) {
                    await removeCartItem(normalizedProductId);
                } else {
                    await updateCartItemQuantity(normalizedProductId, normalizedQty);
                }
                await syncCartWithAuth({ tryMergeCookie: false });
                return;
            }

            setCart(prevCart => {
                const newCart = prevCart
                    .map(item => Number(item.id) === normalizedProductId
                        ? { ...item, quantity: normalizedQty }
                        : item)
                    .filter(item => Number(item.quantity) > 0);

                saveCookieCart(newCart);
                return newCart;
            });
        } catch (e) {
            console.warn(`updateQuantity failed: ${e?.message || 'unknown error'}`);
        }
    };

    const removeFromCart = async (productId) => {
        try {
            await updateQuantity(productId, 0);
        } catch (e) {
            console.warn(`removeFromCart failed: ${e?.message || 'unknown error'}`);
        }
    };

    const getCartCount = () => {
        return cart.reduce((total, item) => total + Number(item.quantity || 0), 0);
    };

    const clearCart = async () => {
        const currentAuth = getAuthContext();

        if (currentAuth.isLoggedIn && currentAuth.isCustomer) {
            try {
                await clearMyCart();
            } catch (e) {
                console.warn(`clearCart fallback to local clear: ${e?.message || 'unknown error'}`);
            }
        }

        setCart([]);
        Cookies.remove(CART_COOKIE_KEY);
    };

    return (
        <CartContext.Provider
            value={{
                cart,
                addToCart,
                updateQuantity,
                removeFromCart,
                getCartCount,
                clearCart,
                refreshCart: () => {
                    void syncCartWithAuth({ tryMergeCookie: false });
                }
            }}
        >
            {children}
        </CartContext.Provider>
    );
}

export function useCart() {
    const context = useContext(CartContext);
    if (!context) {
        throw new Error('useCart must be used within a CartProvider');
    }
    return context;
}
