import React, { createContext, useContext, useState, useEffect } from 'react';
import Cookies from 'js-cookie';

const CartContext = createContext();

export function CartProvider({ children }) {
    const [cart, setCart] = useState([]);

    // Load cart from cookies on mount
    useEffect(() => {
        const savedCart = Cookies.get('cart');
        if (savedCart) {
            try {
                setCart(JSON.parse(savedCart));
            } catch (e) {
                console.error('Failed to parse cart cookie', e);
            }
        }
    }, []);

    const addToCart = (product) => {
        setCart(prevCart => {
            const newCart = [...prevCart];
            const existingIndex = newCart.findIndex(item => item.id === product.id);

            if (existingIndex > -1) {
                newCart[existingIndex] = {
                    ...newCart[existingIndex],
                    quantity: newCart[existingIndex].quantity + 1
                };
            } else {
                newCart.push({ ...product, quantity: 1 });
            }

            Cookies.set('cart', JSON.stringify(newCart), { expires: 7 });
            return newCart;
        });
    };

    const getCartCount = () => {
        return cart.reduce((total, item) => total + item.quantity, 0);
    };

    const clearCart = () => {
        setCart([]);
        Cookies.remove('cart');
    };

    return (
        <CartContext.Provider value={{ cart, addToCart, getCartCount, clearCart }}>
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
