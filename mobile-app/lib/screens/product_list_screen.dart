import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../services/api_service.dart';
import '../services/wishlist_service.dart';
import '../services/cart_service.dart';
import '../services/auth_service.dart';
import '../models/product.dart';
import '../models/category.dart';
import '../models/brand.dart';
import 'product_detail_screen.dart';
import 'profile_screen.dart';

// Design tokens
const _kPrimary = Color(0xFF0DB9F2);
const _kAccentCyan = Color(0xFF22D3EE);
const _kAccentLime = Color(0xFFBEF264);
const _kBgLight = Color(0xFFF5F8F8);
const _kTextPrimary = Color(0xFF0F172A);
const _kTextSecondary = Color(0xFF64748B);
const _kShadow = Color(0x140D0D0D);

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final _currencyFormat = NumberFormat.decimalPattern('vi_VN');
  final _searchController = TextEditingController();

  List<Product> _products = [];
  List<Category> _categories = [];
  bool _isLoading = true;
  String _searchKeyword = '';
  int? _selectedCategoryId;
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  // ── Data loading ──────────────────────────────────────────────────────────

  Future<void> _loadData() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    final cartService = Provider.of<CartService>(context, listen: false);
    final wishlistService = Provider.of<WishlistService>(context, listen: false);

    if (authService.currentUser != null) {
      await cartService.fetchCart(authService.currentUser!.id);
    }
    await wishlistService.fetchWishlist();
    await _loadCategories();
    await _fetchProducts();
  }

  Future<void> _loadCategories() async {
    try {
      final response = await ApiService.get('/product-service/categories');
      if (response['success'] == true && response['data'] != null) {
        final List<dynamic> data = response['data'];
        setState(() {
          _categories = data.map((j) => Category.fromJson(j)).toList();
        });
      }
    } catch (e) {
      debugPrint('Load categories error: $e');
    }
  }

  Future<void> _fetchProducts({String? keyword, int? categoryId}) async {
    if (_isLoading) setState(() {});

    try {
      String url = '/product-service/products?page=0&size=50&status=ACTIVE';
      if (keyword != null && keyword.isNotEmpty) url += '&keyword=$keyword';
      if (categoryId != null) url += '&categoryId=$categoryId';

      final response = await ApiService.get(url);

      if (response['success'] == true && response['data'] != null) {
        final Map<String, dynamic> pageData = response['data'];
        final List<dynamic> content = pageData['content'] ?? [];
        setState(() {
          _products = content.map((j) => Product.fromJson(j)).toList();
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      debugPrint('Fetch products error: $e');
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Connection error. Please try again.'),
            backgroundColor: Colors.orange.shade600,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  void _onSearchChanged(String value) {
    _searchKeyword = value;
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 400), () {
      _fetchProducts(
        keyword: value.isNotEmpty ? value : null,
        categoryId: _selectedCategoryId,
      );
    });
  }

  void _onCategorySelected(int? categoryId) {
    setState(() => _selectedCategoryId = categoryId);
    _fetchProducts(
      keyword: _searchKeyword.isNotEmpty ? _searchKeyword : null,
      categoryId: categoryId,
    );
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kBgLight,
      body: Column(
        children: [
          _Header(
            searchController: _searchController,
            onSearchChanged: _onSearchChanged,
            onSearchCleared: () {
              _searchController.clear();
              _onSearchChanged('');
            },
          ),
          _FilterChips(
            categories: _categories,
            selectedCategoryId: _selectedCategoryId,
            onChanged: _onCategorySelected,
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator(color: _kPrimary))
                : RefreshIndicator(
                    color: _kPrimary,
                    onRefresh: () => _fetchProducts(
                      keyword: _searchKeyword.isNotEmpty ? _searchKeyword : null,
                      categoryId: _selectedCategoryId,
                    ),
                    child: _products.isEmpty
                        ? _EmptyState(hasQuery: _searchKeyword.isNotEmpty)
                        : _ProductGrid(
                            products: _products,
                            currencyFormat: _currencyFormat,
                          ),
                  ),
          ),
        ],
      ),
      bottomNavigationBar: _BottomNav(),
    );
  }
}

// ─── Header ────────────────────────────────────────────────────────────────

class _Header extends StatelessWidget {
  const _Header({
    required this.searchController,
    required this.onSearchChanged,
    required this.onSearchCleared,
  });

  final TextEditingController searchController;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onSearchCleared;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.85),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 12)],
        ),
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
        child: Column(
          children: [
            Row(
              children: [
                _CircleButton(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.arrow_back, size: 20, color: _kTextPrimary),
                ),
                Expanded(
                  child: Center(
                    child: ShaderMask(
                      shaderCallback: (b) => const LinearGradient(
                        colors: [_kPrimary, _kAccentCyan],
                      ).createShader(b),
                      child: const Text(
                        'All Products',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: -0.3,
                        ),
                      ),
                    ),
                  ),
                ),
                Consumer<CartService>(
                  builder: (context, cart, _) => GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/cart'),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topRight,
                              end: Alignment.bottomLeft,
                              colors: [_kAccentCyan, _kPrimary],
                            ),
                            shape: BoxShape.circle,
                            boxShadow: [BoxShadow(color: Color(0x4422D3EE), blurRadius: 12, offset: Offset(0, 4))],
                          ),
                          child: const Icon(Icons.shopping_bag_outlined, color: Colors.white, size: 20),
                        ),
                        if (cart.itemCount > 0)
                          Positioned(
                            top: -4,
                            right: -4,
                            child: Container(
                              width: 18,
                              height: 18,
                              decoration: BoxDecoration(
                                color: _kAccentLime,
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 2),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                '${cart.itemCount}',
                                style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: _kTextPrimary),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 12, offset: const Offset(0, 2))],
              ),
              child: TextField(
                controller: searchController,
                onChanged: onSearchChanged,
                style: const TextStyle(fontSize: 14, color: _kTextPrimary),
                decoration: InputDecoration(
                  hintText: 'Search products...',
                  hintStyle: const TextStyle(color: _kTextSecondary, fontSize: 14),
                  prefixIcon: const Icon(Icons.search, color: _kTextSecondary, size: 22),
                  suffixIcon: searchController.text.isNotEmpty
                      ? GestureDetector(
                          onTap: onSearchCleared,
                          child: const Icon(Icons.clear, color: _kPrimary, size: 20),
                        )
                      : const Icon(Icons.tune, color: _kTextSecondary, size: 20),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Filter chips (dynamic from API) ──────────────────────────────────────

class _FilterChips extends StatelessWidget {
  const _FilterChips({
    required this.categories,
    required this.selectedCategoryId,
    required this.onChanged,
  });

  final List<Category> categories;
  final int? selectedCategoryId;
  final ValueChanged<int?> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 54,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: categories.isEmpty ? 1 : categories.length + 1,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final isAllChip = i == 0;
          final active = isAllChip ? selectedCategoryId == null : categories[i - 1].id == selectedCategoryId;
          final label = isAllChip ? 'All' : categories[i - 1].name;
          final catId = isAllChip ? null : categories[i - 1].id;

          return GestureDetector(
            onTap: () => onChanged(catId),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                gradient: active ? const LinearGradient(colors: [_kPrimary, _kAccentCyan]) : null,
                color: active ? null : Colors.white,
                borderRadius: BorderRadius.circular(999),
                border: active ? null : Border.all(color: const Color(0xFFE2E8F0)),
                boxShadow: active ? const [BoxShadow(color: Color(0x4A0DB9F2), blurRadius: 10, offset: Offset(0, 4))] : null,
              ),
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: active ? FontWeight.w600 : FontWeight.w500,
                  color: active ? Colors.white : _kTextSecondary,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ─── Product grid ──────────────────────────────────────────────────────────

class _ProductGrid extends StatelessWidget {
  const _ProductGrid({required this.products, required this.currencyFormat});
  final List<Product> products;
  final NumberFormat currencyFormat;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 32),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
        childAspectRatio: 0.56,
      ),
      itemCount: products.length,
      itemBuilder: (_, i) => _ProductCard(product: products[i], currencyFormat: currencyFormat),
    );
  }
}

// ─── Product card ──────────────────────────────────────────────────────────

class _ProductCard extends StatelessWidget {
  const _ProductCard({required this.product, required this.currencyFormat});
  final Product product;
  final NumberFormat currencyFormat;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => ProductDetailScreen(product: product)),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: const [BoxShadow(color: _kShadow, blurRadius: 25, offset: Offset(0, 10))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image area
            Expanded(
              flex: 5,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                    child: SizedBox.expand(
                      child: product.imageUrl != null
                          ? Image.network(product.imageUrl!, fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => const _ImagePlaceholder())
                          : const _ImagePlaceholder(),
                    ),
                  ),
                  // Wishlist button
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Consumer<WishlistService>(
                      builder: (_, wishlist, __) => GestureDetector(
                        onTap: () => wishlist.toggleWishlist(product),
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 5, offset: const Offset(0, 2))],
                          ),
                          child: Icon(
                            wishlist.isWishlisted(product.id)
                                ? Icons.favorite
                                : Icons.favorite_border,
                            size: 16,
                            color: wishlist.isWishlisted(product.id)
                                ? Colors.redAccent
                                : Colors.grey[400],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Info area
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: _kTextPrimary, height: 1.2),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      product.categoryName ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 11, color: _kTextSecondary, fontWeight: FontWeight.w500),
                    ),
                    const Spacer(),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            '${currencyFormat.format(product.price)} d',
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: _kTextPrimary),
                          ),
                        ),
                        Consumer2<CartService, AuthService>(
                          builder: (ctx, cart, auth, _) => GestureDetector(
                            onTap: () async {
                              final uid = auth.currentUser?.id;
                              if (uid != null) {
                                final ok = await cart.addToCart(uid, product.id, 1);
                                if (ok && ctx.mounted) {
                                  ScaffoldMessenger.of(ctx).showSnackBar(
                                    const SnackBar(
                                      content: Text('Added to cart'),
                                      duration: Duration(seconds: 1),
                                      backgroundColor: _kPrimary,
                                    ),
                                  );
                                }
                              }
                            },
                            child: Container(
                              width: 36,
                              height: 36,
                              decoration: const BoxDecoration(
                                color: Color(0xFF1EB5D9),
                                shape: BoxShape.circle,
                                boxShadow: [BoxShadow(color: Color(0x441EB5D9), blurRadius: 8, offset: Offset(0, 4))],
                              ),
                              child: const Icon(Icons.add, color: Colors.white, size: 20),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Helpers ───────────────────────────────────────────────────────────────

class _ImagePlaceholder extends StatelessWidget {
  const _ImagePlaceholder();
  @override
  Widget build(BuildContext context) => Container(
        color: _kBgLight,
        child: const Center(child: Icon(Icons.toys_outlined, size: 40, color: Color(0xFF94A3B8))),
      );
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.hasQuery});
  final bool hasQuery;
  @override
  Widget build(BuildContext context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text(
              hasQuery ? 'No products found' : 'No products available',
              style: const TextStyle(color: _kTextSecondary, fontSize: 16),
            ),
          ],
        ),
      );
}

class _CircleButton extends StatelessWidget {
  const _CircleButton({required this.onTap, required this.child});
  final VoidCallback onTap;
  final Widget child;
  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 8, offset: const Offset(0, 2))],
          ),
          child: Center(child: child),
        ),
      );
}

// ─── Bottom navigation ─────────────────────────────────────────────────────

class _BottomNav extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.92),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: const [BoxShadow(color: Color(0x0D000000), blurRadius: 20, offset: Offset(0, -5))],
        border: Border(top: BorderSide(color: Colors.grey.withOpacity(0.15))),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _NavItem(icon: Icons.storefront_rounded, label: 'Shop', isActive: true, onTap: () {}),
              _NavItem(icon: Icons.explore_outlined, label: 'Discover', isActive: false, onTap: () {}),
              _NavItem(
                icon: Icons.shopping_cart_outlined,
                label: 'Cart',
                isActive: false,
                onTap: () => Navigator.pushNamed(context, '/cart'),
              ),
              _NavItem(
                icon: Icons.person_outline,
                label: 'Profile',
                isActive: false,
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen())),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({required this.icon, required this.label, required this.isActive, required this.onTap});
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: isActive ? _kPrimary.withOpacity(0.1) : Colors.transparent,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: isActive ? _kPrimary : _kTextSecondary, size: 24),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
              color: isActive ? _kPrimary : _kTextSecondary,
            ),
          ),
        ],
      ),
    );
  }
}