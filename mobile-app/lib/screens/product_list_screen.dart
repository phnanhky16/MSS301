import 'dart:async';
import 'dart:math';
import 'dart:ui';
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
import 'wishlist_screen.dart';

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
  final _cartIconKey = GlobalKey();
  final _wishlistNavKey = GlobalKey();

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
    final wishlistService =
        Provider.of<WishlistService>(context, listen: false);

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

  // ── Fly-to-cart ───────────────────────────────────────────────────────────

  Future<void> _onAddToCart(int productId, GlobalKey sourceKey) async {
    final authService = Provider.of<AuthService>(context, listen: false);
    final cartService = Provider.of<CartService>(context, listen: false);
    final uid = authService.currentUser?.id;
    if (uid == null) return;
    // Launch animation immediately for instant visual feedback
    _flyToCart(sourceKey, _cartIconKey);
    final ok = await cartService.addToCart(uid, productId, 1);
    if (!ok && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to add to cart'),
          backgroundColor: Colors.redAccent,
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  void _flyToCart(GlobalKey sourceKey, GlobalKey targetKey) {
    final sourceBox =
        sourceKey.currentContext?.findRenderObject() as RenderBox?;
    final targetBox =
        targetKey.currentContext?.findRenderObject() as RenderBox?;
    if (sourceBox == null || targetBox == null) return;
    final sourcePos =
        sourceBox.localToGlobal(sourceBox.size.center(Offset.zero));
    final targetPos =
        targetBox.localToGlobal(targetBox.size.center(Offset.zero));
    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (_) => _FlyingDot(
        startPos: sourcePos,
        endPos: targetPos,
        onComplete: () => entry.remove(),
      ),
    );
    Overlay.of(context).insert(entry);
  }

  // ── Fly-to-wishlist ──────────────────────────────────────────────────────

  void _onToggleWishlist(Product product, GlobalKey sourceKey) {
    final wishlistService =
        Provider.of<WishlistService>(context, listen: false);
    // Only fly when adding (not removing)
    if (!wishlistService.isWishlisted(product.id)) {
      _flyToWishlist(sourceKey, _wishlistNavKey);
    }
    wishlistService.toggleWishlist(product);
  }

  void _flyToWishlist(GlobalKey sourceKey, GlobalKey targetKey) {
    final sourceBox =
        sourceKey.currentContext?.findRenderObject() as RenderBox?;
    final targetBox =
        targetKey.currentContext?.findRenderObject() as RenderBox?;
    if (sourceBox == null || targetBox == null) return;
    final sourcePos =
        sourceBox.localToGlobal(sourceBox.size.center(Offset.zero));
    final targetPos =
        targetBox.localToGlobal(targetBox.size.center(Offset.zero));
    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (_) => _WishlistFlyingDot(
        startPos: sourcePos,
        endPos: targetPos,
        onComplete: () => entry.remove(),
      ),
    );
    Overlay.of(context).insert(entry);
  }

  // ── Search ────────────────────────────────────────────────────────────────

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
            cartIconKey: _cartIconKey,
          ),
          _FilterChips(
            categories: _categories,
            selectedCategoryId: _selectedCategoryId,
            onChanged: _onCategorySelected,
          ),
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: _kPrimary))
                : RefreshIndicator(
                    color: _kPrimary,
                    onRefresh: () => _fetchProducts(
                      keyword:
                          _searchKeyword.isNotEmpty ? _searchKeyword : null,
                      categoryId: _selectedCategoryId,
                    ),
                    child: _products.isEmpty
                        ? _EmptyState(hasQuery: _searchKeyword.isNotEmpty)
                        : _ProductGrid(
                            products: _products,
                            currencyFormat: _currencyFormat,
                            onAddToCart: _onAddToCart,
                            onToggleWishlist: _onToggleWishlist,
                          ),
                  ),
          ),
        ],
      ),
      bottomNavigationBar: _BottomNav(wishlistNavKey: _wishlistNavKey),
    );
  }
}

// ─── Header ────────────────────────────────────────────────────────────────

class _Header extends StatelessWidget {
  const _Header({
    required this.searchController,
    required this.onSearchChanged,
    required this.onSearchCleared,
    required this.cartIconKey,
  });

  final TextEditingController searchController;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onSearchCleared;
  final GlobalKey cartIconKey;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.85),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 12)
          ],
        ),
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
        child: Column(
          children: [
            Row(
              children: [
                _CircleButton(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.arrow_back,
                      size: 20, color: _kTextPrimary),
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
                          key: cartIconKey,
                          width: 40,
                          height: 40,
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topRight,
                              end: Alignment.bottomLeft,
                              colors: [_kAccentCyan, _kPrimary],
                            ),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                  color: Color(0x4422D3EE),
                                  blurRadius: 12,
                                  offset: Offset(0, 4))
                            ],
                          ),
                          child: const Icon(Icons.shopping_bag_outlined,
                              color: Colors.white, size: 20),
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
                                border:
                                    Border.all(color: Colors.white, width: 2),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                '${cart.itemCount}',
                                style: const TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                    color: _kTextPrimary),
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
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 12,
                      offset: const Offset(0, 2))
                ],
              ),
              child: TextField(
                controller: searchController,
                onChanged: onSearchChanged,
                style: const TextStyle(fontSize: 14, color: _kTextPrimary),
                decoration: InputDecoration(
                  hintText: 'Search products...',
                  hintStyle:
                      const TextStyle(color: _kTextSecondary, fontSize: 14),
                  prefixIcon: const Icon(Icons.search,
                      color: _kTextSecondary, size: 22),
                  suffixIcon: searchController.text.isNotEmpty
                      ? GestureDetector(
                          onTap: onSearchCleared,
                          child: const Icon(Icons.clear,
                              color: _kPrimary, size: 20),
                        )
                      : const Icon(Icons.tune,
                          color: _kTextSecondary, size: 20),
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
          final active = isAllChip
              ? selectedCategoryId == null
              : categories[i - 1].id == selectedCategoryId;
          final label = isAllChip ? 'All' : categories[i - 1].name;
          final catId = isAllChip ? null : categories[i - 1].id;

          return GestureDetector(
            onTap: () => onChanged(catId),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                gradient: active
                    ? const LinearGradient(colors: [_kPrimary, _kAccentCyan])
                    : null,
                color: active ? null : Colors.white,
                borderRadius: BorderRadius.circular(999),
                border:
                    active ? null : Border.all(color: const Color(0xFFE2E8F0)),
                boxShadow: active
                    ? const [
                        BoxShadow(
                            color: Color(0x4A0DB9F2),
                            blurRadius: 10,
                            offset: Offset(0, 4))
                      ]
                    : null,
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
  const _ProductGrid({
    required this.products,
    required this.currencyFormat,
    required this.onAddToCart,
    required this.onToggleWishlist,
  });
  final List<Product> products;
  final NumberFormat currencyFormat;
  final Future<void> Function(int productId, GlobalKey sourceKey) onAddToCart;
  final void Function(Product product, GlobalKey sourceKey) onToggleWishlist;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 32),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.65,
      ),
      itemCount: products.length,
      itemBuilder: (_, i) => _ProductCard(
        product: products[i],
        currencyFormat: currencyFormat,
        onAddToCart: onAddToCart,
        onToggleWishlist: onToggleWishlist,
      ),
    );
  }
}

// ─── Product card ──────────────────────────────────────────────────────────

class _ProductCard extends StatefulWidget {
  const _ProductCard({
    required this.product,
    required this.currencyFormat,
    required this.onAddToCart,
    required this.onToggleWishlist,
  });
  final Product product;
  final NumberFormat currencyFormat;
  final Future<void> Function(int productId, GlobalKey sourceKey) onAddToCart;
  final void Function(Product product, GlobalKey sourceKey) onToggleWishlist;

  @override
  State<_ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<_ProductCard> {
  final _addBtnKey = GlobalKey();
  final _wishlistBtnKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final currencyFormat = widget.currencyFormat;
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => ProductDetailScreen(product: product)),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: const [
            BoxShadow(color: _kShadow, blurRadius: 25, offset: Offset(0, 10))
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image area with square aspect ratio
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: AspectRatio(
                aspectRatio: 1.0,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Stack(
                    children: [
                      SizedBox.expand(
                        child: product.imageUrl != null
                            ? Image.network(product.imageUrl!,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) =>
                                    const _ImagePlaceholder())
                            : const _ImagePlaceholder(),
                      ),
                      // Wishlist button
                      Positioned(
                        top: 8,
                        left: 8,
                        child: Consumer<WishlistService>(
                          builder: (_, wishlist, __) => GestureDetector(
                            onTap: () => widget.onToggleWishlist(
                                product, _wishlistBtnKey),
                            child: Container(
                              key: _wishlistBtnKey,
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 5,
                                      offset: const Offset(0, 2))
                                ],
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
              ),
            ),
            // Info area
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: _kTextPrimary,
                        height: 1.2),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        size: 12,
                        color: Color(0xFFFFC107),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '4.8 (86 đánh giá)',
                        style: TextStyle(
                          fontSize: 11,
                          color: _kTextSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (product.originalPrice != null)
                              Text(
                                '${currencyFormat.format(product.originalPrice)} d',
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey,
                                  decoration: TextDecoration.lineThrough,
                                  height: 1.0,
                                ),
                              ),
                            Text(
                              '${currencyFormat.format(product.price)} d',
                              style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: _kTextPrimary),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: product.stock > 0 
                            ? () => widget.onAddToCart(product.id, _addBtnKey)
                            : null,
                        child: Container(
                          key: _addBtnKey,
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: product.stock > 0 
                                ? const Color(0xFF1EB5D9)
                                : Colors.grey[300],
                            shape: BoxShape.circle,
                            boxShadow: product.stock > 0 ? const [
                              BoxShadow(
                                  color: Color(0x441EB5D9),
                                  blurRadius: 8,
                                  offset: Offset(0, 4))
                            ] : null,
                          ),
                          child: Icon(Icons.add,
                              color: product.stock > 0 ? Colors.white : Colors.grey[500], size: 18),
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
}

// ─── Fly-to-Cart Overlay Animation ────────────────────────────────────────

class _FlyingDot extends StatefulWidget {
  const _FlyingDot({
    required this.startPos,
    required this.endPos,
    required this.onComplete,
  });
  final Offset startPos;
  final Offset endPos;
  final VoidCallback onComplete;

  @override
  State<_FlyingDot> createState() => _FlyingDotState();
}

class _FlyingDotState extends State<_FlyingDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 700));
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut);
    _ctrl.forward().whenComplete(widget.onComplete);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  /// Quadratic Bézier: P(t) = (1-t)²P0 + 2(1-t)t·P1 + t²P2
  /// P1 (control point) sits above the midpoint to form a natural parabolic arc.
  Offset _bezier(double t) {
    final p0 = widget.startPos;
    final p2 = widget.endPos;
    final ctrl = Offset(
      (p0.dx + p2.dx) / 2,
      min(p0.dy, p2.dy) - 130,
    );
    final mt = 1 - t;
    return Offset(
      mt * mt * p0.dx + 2 * mt * t * ctrl.dx + t * t * p2.dx,
      mt * mt * p0.dy + 2 * mt * t * ctrl.dy + t * t * p2.dy,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) {
        final t = _anim.value;
        final pos = _bezier(t);
        final scale = lerpDouble(1.0, 0.2, t)!;
        // Fade out only in the last 25% of the animation
        final opacity = t > 0.75 ? (1.0 - t) / 0.25 : 1.0;
        return Positioned(
          left: pos.dx - 18,
          top: pos.dy - 18,
          child: IgnorePointer(
            child: Opacity(
              opacity: opacity.clamp(0.0, 1.0),
              child: Transform.scale(
                scale: scale,
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [_kAccentCyan, _kPrimary],
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: _kPrimary.withOpacity(0.45),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.shopping_bag_outlined,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// ─── Helpers ───────────────────────────────────────────────────────────────

class _ImagePlaceholder extends StatelessWidget {
  const _ImagePlaceholder();
  @override
  Widget build(BuildContext context) => Container(
        color: _kBgLight,
        child: const Center(
            child:
                Icon(Icons.toys_outlined, size: 40, color: Color(0xFF94A3B8))),
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
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 2))
            ],
          ),
          child: Center(child: child),
        ),
      );
}

// ─── Bottom navigation ─────────────────────────────────────────────────────

class _BottomNav extends StatelessWidget {
  const _BottomNav({required this.wishlistNavKey});
  final GlobalKey wishlistNavKey;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.92),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: const [
          BoxShadow(
              color: Color(0x0D000000), blurRadius: 20, offset: Offset(0, -5))
        ],
        border: Border(top: BorderSide(color: Colors.grey.withOpacity(0.15))),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _NavItem(
                  icon: Icons.storefront_rounded,
                  label: 'Shop',
                  isActive: true,
                  onTap: () {}),
              _NavItem(
                  icon: Icons.favorite_border,
                  label: 'Wishlist',
                  isActive: false,
                  iconKey: wishlistNavKey,
                  badge: Consumer<WishlistService>(
                    builder: (_, wishlist, __) => wishlist.count > 0
                        ? Container(
                            width: 16,
                            height: 16,
                            decoration: const BoxDecoration(
                              color: Colors.redAccent,
                              shape: BoxShape.circle,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              '${wishlist.count}',
                              style: const TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const WishlistScreen()))),
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
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const ProfileScreen())),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
    this.iconKey,
    this.badge,
  });
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;
  final GlobalKey? iconKey;
  final Widget? badge;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              AnimatedContainer(
                key: iconKey,
                duration: const Duration(milliseconds: 200),
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: isActive
                      ? _kPrimary.withOpacity(0.1)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon,
                    color: isActive ? _kPrimary : _kTextSecondary, size: 24),
              ),
              if (badge != null)
                Positioned(
                  top: 4,
                  right: 4,
                  child: badge!,
                ),
            ],
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

// ─── Fly-to-Wishlist Overlay Animation ────────────────────────────────────

class _WishlistFlyingDot extends StatefulWidget {
  const _WishlistFlyingDot({
    required this.startPos,
    required this.endPos,
    required this.onComplete,
  });
  final Offset startPos;
  final Offset endPos;
  final VoidCallback onComplete;

  @override
  State<_WishlistFlyingDot> createState() => _WishlistFlyingDotState();
}

class _WishlistFlyingDotState extends State<_WishlistFlyingDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 700));
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut);
    _ctrl.forward().whenComplete(widget.onComplete);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Offset _bezier(double t) {
    final p0 = widget.startPos;
    final p2 = widget.endPos;
    final ctrl = Offset(
      (p0.dx + p2.dx) / 2,
      min(p0.dy, p2.dy) - 130,
    );
    final mt = 1 - t;
    return Offset(
      mt * mt * p0.dx + 2 * mt * t * ctrl.dx + t * t * p2.dx,
      mt * mt * p0.dy + 2 * mt * t * ctrl.dy + t * t * p2.dy,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) {
        final t = _anim.value;
        final pos = _bezier(t);
        final scale = lerpDouble(1.0, 0.2, t)!;
        final opacity = t > 0.75 ? (1.0 - t) / 0.25 : 1.0;
        return Positioned(
          left: pos.dx - 18,
          top: pos.dy - 18,
          child: IgnorePointer(
            child: Opacity(
              opacity: opacity.clamp(0.0, 1.0),
              child: Transform.scale(
                scale: scale,
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFFFF6B9D), Color(0xFFFF2E63)],
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFFFF2E63).withOpacity(0.45),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.favorite,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
