import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../services/wishlist_service.dart';
import '../services/cart_service.dart';
import '../services/auth_service.dart';
import 'package:intl/intl.dart';
import 'profile_screen.dart';
import 'home_screen.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');

  static const _cardColors = [
    Color(0xFFE3F2FD),
    Color(0xFFFCE4EC),
    Color(0xFFFFE0B2),
    Color(0xFFC8E6C9),
    Color(0xFFE1BEE7),
    Color(0xFFFFF9C4),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<WishlistService>(context, listen: false).fetchWishlist();
    });
  }

  Future<void> _removeFromWishlist(Product product) async {
    final wishlistService =
        Provider.of<WishlistService>(context, listen: false);
    await wishlistService.removeFromWishlist(product.id);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Removed from wishlist'),
          duration: Duration(seconds: 2),
          backgroundColor: Color(0xFF1EB5D9),
        ),
      );
    }
  }

  Future<void> _moveAllToCart() async {
    final wishlistService =
        Provider.of<WishlistService>(context, listen: false);
    final cartService = Provider.of<CartService>(context, listen: false);
    final authService = Provider.of<AuthService>(context, listen: false);

    if (wishlistService.products.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Your wishlist is empty'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    final userId = authService.currentUser?.id;
    if (userId == null) return;

    int count = 0;
    // clone list since we'll remove while iterating
    final productsCopy = List<Product>.from(wishlistService.products);
    for (final product in productsCopy) {
      final ok = await cartService.addToCart(userId, product.id, 1);
      if (ok) {
        count++;
        // remove from wishlist asynchronously (ignore failure)
        await wishlistService.removeFromWishlist(product.id);
      }
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$count items moved to cart'),
          duration: const Duration(seconds: 2),
          backgroundColor: const Color(0xFF1EB5D9),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Consumer<WishlistService>(
        builder: (context, wishlistService, _) {
          return SafeArea(
            child: Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 32, 20, 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Back Button
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back, size: 20),
                          onPressed: () => Navigator.pop(context),
                          padding: EdgeInsets.zero,
                          color: Colors.black,
                        ),
                      ),

                      // Title
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'My Wishlist',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1A1A1A),
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${wishlistService.count} items',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF94A3B8),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(width: 40),
                    ],
                  ),
                ),

                // Grid Content
                Expanded(
                  child: wishlistService.isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFF1EB5D9),
                          ),
                        )
                      : wishlistService.products.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.favorite_border,
                                    size: 80,
                                    color: Colors.grey[300],
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Your wishlist is empty',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Add items you love to your wishlist',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[500],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : RefreshIndicator(
                              color: const Color(0xFF1EB5D9),
                              onRefresh: wishlistService.fetchWishlist,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 8),
                                child: GridView.builder(
                                  clipBehavior: Clip.none,
                                  padding: const EdgeInsets.only(bottom: 8),
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 16,
                                    mainAxisSpacing: 20,
                                    childAspectRatio: 0.7,
                                  ),
                                  itemCount: wishlistService.products.length,
                                  itemBuilder: (context, index) {
                                    final product =
                                        wishlistService.products[index];
                                    final bgColor =
                                        _cardColors[index % _cardColors.length];
                                    return _buildWishlistCard(product, bgColor);
                                  },
                                ),
                              ),
                            ),
                ),

                // Move all to Cart button
                if (!wishlistService.isLoading &&
                    wishlistService.products.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
                    child: Container(
                      height: 56,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            Color(0xFF1E88E5),
                            Color(0xFF00ACC1),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF1E88E5).withOpacity(0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: _moveAllToCart,
                          borderRadius: BorderRadius.circular(28),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.shopping_cart,
                                color: Colors.white,
                                size: 24,
                              ),
                              SizedBox(width: 12),
                              Text(
                                'Move all to Cart',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                const SizedBox(height: 8),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
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
              _buildNavItem(Icons.favorite, 'Wishlist', true, () {},
                  badge: Consumer<WishlistService>(
                    builder: (_, wishlist, __) => wishlist.count > 0
                        ? _buildNavBadge(
                            '${wishlist.count}',
                            badgeColor: Colors.redAccent,
                            textColor: Colors.white,
                          )
                        : const SizedBox.shrink(),
                  )),
              _buildNavItem(Icons.shopping_cart_outlined, 'Cart', false, () {
                Navigator.pushNamed(context, '/cart');
              },
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
                color: isActive ? const Color(0xFF27A6D1) : Colors.grey[600],
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

  Widget _buildWishlistCard(Product product, Color bgColor) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 35,
            offset: const Offset(0, 15),
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Container
          Expanded(
            flex: 5,
            child: Container(
              margin: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Stack(
                children: [
                  // Product Image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: product.imageUrl != null
                        ? Image.network(
                            product.imageUrl!,
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: bgColor,
                                child: const Center(
                                  child: Icon(
                                    Icons.toys,
                                    size: 50,
                                    color: Color(0xFFBDBDBD),
                                  ),
                                ),
                              );
                            },
                          )
                        : Container(
                            color: bgColor,
                            child: const Center(
                              child: Icon(
                                Icons.toys,
                                size: 50,
                                color: Color(0xFFBDBDBD),
                              ),
                            ),
                          ),
                  ),

                  // Favorite Button
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: () => _removeFromWishlist(product),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.favorite,
                          color: Color(0xFFEF5350),
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Product Info
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1A1A),
                      letterSpacing: -0.2,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  if (product.originalPrice != null)
                    Text(
                      currencyFormat.format(product.originalPrice),
                      style: const TextStyle(
                        fontSize: 10,
                        color: Colors.grey,
                        decoration: TextDecoration.lineThrough,
                        height: 1.0,
                      ),
                    ),
                  Text(
                    currencyFormat.format(product.price),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
