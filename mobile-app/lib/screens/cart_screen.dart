import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../services/cart_service.dart';
import '../services/wishlist_service.dart';
import '../models/cart.dart';
import 'package:intl/intl.dart';
import 'home_screen.dart';
import 'wishlist_screen.dart';
import 'profile_screen.dart';
import 'product_detail_screen.dart';
import 'checkout_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final _currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');

  @override
  void initState() {
    super.initState();
    _loadCart();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _loadCart() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    final cartService = Provider.of<CartService>(context, listen: false);

    if (authService.currentUser != null) {
      await cartService.fetchCart(authService.currentUser!.id);
    }
  }

  Future<void> _updateQuantity(int productId, int currentQty, int delta) async {
    final authService = Provider.of<AuthService>(context, listen: false);
    final cartService = Provider.of<CartService>(context, listen: false);
    if (authService.currentUser == null) return;
    final newQty = currentQty + delta;
    // If dropping to 0, remove the item entirely
    if (newQty < 1) {
      await _removeItem(productId);
      return;
    }
    final success = await cartService.updateCartItem(
      authService.currentUser!.id,
      productId,
      newQty,
    );
    if (!success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Không thể cập nhật số lượng'),
          backgroundColor: Colors.redAccent,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _clearCart() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    final cartService = Provider.of<CartService>(context, listen: false);
    if (authService.currentUser == null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Xóa giỏ hàng'),
        content:
            const Text('Bạn có chắc muốn xóa toàn bộ sản phẩm trong giỏ hàng?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Xóa tất cả'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;
    final success = await cartService.clearCart(authService.currentUser!.id);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              success ? 'Đã xóa toàn bộ giỏ hàng' : 'Xóa giỏ hàng thất bại'),
          backgroundColor: success ? const Color(0xFF1EB5D9) : Colors.redAccent,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _removeItem(int productId) async {
    final authService = Provider.of<AuthService>(context, listen: false);
    final cartService = Provider.of<CartService>(context, listen: false);
    if (authService.currentUser == null) return;
    final success = await cartService.removeFromCart(
      authService.currentUser!.id,
      productId,
    );
    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Đã xóa sản phẩm khỏi giỏ hàng'),
          duration: Duration(seconds: 2),
          backgroundColor: Color(0xFF1EB5D9),
        ),
      );
    }
  }

  double get _shipping => 30000.0;

  @override
  Widget build(BuildContext context) {
    return Consumer<CartService>(
      builder: (context, cartService, child) {
        final items = cartService.cart?.items ?? [];
        final subtotal = cartService.totalPrice;
        final total = subtotal + _shipping;

        return Scaffold(
          backgroundColor: const Color(0xFFF8F9FA),
          body: SafeArea(
            child: Column(
              children: [
                // Header
                Container(
                  color: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back, size: 20),
                          onPressed: () => Navigator.pop(context),
                          padding: EdgeInsets.zero,
                          color: const Color(0xFF64748B),
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Giỏ hàng của tôi',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1A1A1A),
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${items.length} sản phẩm',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF94A3B8),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.06),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.delete_outline, size: 20),
                          onPressed: _clearCart,
                          padding: EdgeInsets.zero,
                          color: const Color(0xFF1EB5D9),
                          tooltip: 'Xóa tất cả',
                        ),
                      ),
                    ],
                  ),
                ),

                // Cart Items List
                Expanded(
                  child: cartService.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : items.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.shopping_cart_outlined,
                                    size: 80,
                                    color: Colors.grey[300],
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Giỏ hàng trống',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.all(16),
                              itemCount: items.length,
                              itemBuilder: (context, index) {
                                final item = items[index];
                                return _buildCartItem(item);
                              },
                            ),
                ),

                // Summary & Checkout
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 30,
                        offset: const Offset(0, -10),
                      ),
                    ],
                  ),
                  child: SafeArea(
                    top: false,
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Total
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Tổng cộng',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1A1A1A),
                                ),
                              ),
                              Text(
                                _currencyFormat.format(total),
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF1EB5D9),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),

                          // Checkout Button
                          Container(
                            width: double.infinity,
                            height: 56,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                                  Color(0xFF1EB5D9), // Cyan
                                  Color(0xFF00CED1), // Light cyan
                                ],
                              ),
                              borderRadius: BorderRadius.circular(28),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      const Color(0xFF1EB5D9).withOpacity(0.3),
                                  blurRadius: 20,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => CheckoutScreen(
                                        cartItems: items,
                                        cartTotal: subtotal,
                                      ),
                                    ),
                                  );
                                },
                                borderRadius: BorderRadius.circular(28),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Text(
                                      'Thanh toán',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Icon(
                                      Icons.arrow_forward,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: _buildBottomNavigationBar(),
        );
      },
    );
  }

  Widget _buildCartItem(CartItem item) {
    return GestureDetector(
      onTap: () {
        if (item.product != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ProductDetailScreen(
                product: item.product,
                fromCart: true,
              ),
            ),
          );
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 25,
              offset: const Offset(0, 10),
              spreadRadius: 1,
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: const Color(0xFFF5F7FA),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  item.product?.imageUrl ?? '',
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: const Color(0xFFF5F7FA),
                      child: const Center(
                        child: Icon(
                          Icons.toys,
                          size: 40,
                          color: Color(0xFFBDBDBD),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(width: 16),

            // Product Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.product?.name ?? 'Sản phẩm',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1A1A1A),
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => _removeItem(item.productId),
                        icon: const Icon(Icons.delete_outline),
                        color: const Color(0xFF94A3B8),
                        iconSize: 20,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(
                          minWidth: 32,
                          minHeight: 32,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Price and Quantity
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _currencyFormat.format(item.product?.price ?? 0),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E88E5),
                        ),
                      ),

                      // Quantity Controls
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F7FA),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () => _updateQuantity(
                                  item.productId, item.quantity, -1),
                              child: Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.remove,
                                  size: 16,
                                  color: Color(0xFF1A1A1A),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                '${item.quantity}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1A1A1A),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () => _updateQuantity(
                                  item.productId, item.quantity, 1),
                              child: Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.add,
                                  size: 16,
                                  color: Color(0xFF1A1A1A),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.store, 'Shop', false, () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                );
              }),
              _buildNavItem(Icons.favorite_border, 'Wishlist', false, () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const WishlistScreen()),
                );
              },
                  badge: Consumer<WishlistService>(
                    builder: (_, wishlist, __) => wishlist.count > 0
                        ? _buildNavBadge(
                            '${wishlist.count}',
                            badgeColor: Colors.redAccent,
                            textColor: Colors.white,
                          )
                        : const SizedBox.shrink(),
                  )),
              _buildNavItem(Icons.shopping_cart, 'Cart', true, () {},
                  badge: Consumer<CartService>(
                    builder: (_, cart, __) => cart.itemCount > 0
                        ? _buildNavBadge('${cart.itemCount}')
                        : const SizedBox.shrink(),
                  )),
              _buildNavItem(Icons.person_outline, 'Profile', false, () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ProfileScreen()),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavBadge(String text,
      {Color badgeColor = const Color(0xFFBEF264),
      Color textColor = const Color(0xFF0F172A)}) {
    return Positioned(
      top: -4,
      right: -4,
      child: Container(
        width: 16,
        height: 16,
        decoration: BoxDecoration(
          color: badgeColor,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 1.5),
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(
            fontSize: 8,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
      IconData icon, String label, bool isActive, VoidCallback onTap,
      {Widget? badge}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Icon(
                icon,
                color: isActive ? const Color(0xFF1EB5D9) : Colors.grey[600],
                size: 26,
              ),
              if (badge != null) badge,
            ],
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isActive ? const Color(0xFF1EB5D9) : Colors.grey[600],
              fontSize: 12,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
