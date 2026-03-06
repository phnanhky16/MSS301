import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../services/cart_service.dart';
import '../services/api_service.dart';
import '../models/product.dart';
import '../models/category.dart';
import '../models/brand.dart';
import 'product_detail_screen.dart';
import 'product_list_screen.dart';
import 'category_screen.dart';
import 'profile_screen.dart';
import 'wishlist_screen.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  List<Product> _products = [];
  bool _isLoading = true;
  String _selectedCategory = 'Popular';
  final _decimalFormat = NumberFormat.decimalPattern('vi_VN');

  // Cart animation state
  int _cartCount = 0;
  final GlobalKey _cartKey = GlobalKey();
  AnimationController? _shakeController;
  OverlayEntry? _flyingWidget;

  // Search state - Using ValueNotifier to prevent rebuild
  late TextEditingController _searchController;
  late FocusNode _searchFocusNode;
  late ValueNotifier<String> _searchQueryNotifier;
  late ValueNotifier<List<Product>> _productsNotifier;
  late ValueNotifier<bool> _isLoadingNotifier;
  Timer? _debounceTimer;
  String _searchKeyword = '';

  // Filter state
  List<Category> _categories = [];
  List<Brand> _brands = [];
  int? _selectedCategoryId;
  int? _selectedBrandId;
  double? _minPrice;
  double? _maxPrice;

  @override
  void initState() {
    super.initState();

    // Initialize controllers and ValueNotifiers in initState (Best Practice)
    _searchController = TextEditingController();
    _searchFocusNode = FocusNode();

    // ValueNotifiers to prevent unnecessary rebuilds
    _searchQueryNotifier = ValueNotifier<String>('');
    _productsNotifier = ValueNotifier<List<Product>>([]);
    _isLoadingNotifier = ValueNotifier<bool>(true);

    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _loadData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    _searchQueryNotifier.dispose();
    _productsNotifier.dispose();
    _isLoadingNotifier.dispose();
    _debounceTimer?.cancel();
    _shakeController?.dispose();
    _flyingWidget?.remove();
    super.dispose();
  }

  // Create mock products for testing UI
  List<Product> _createMockProducts() {
    return [
      Product(
        id: 1,
        name: 'Cuddly Bear',
        description: 'Super soft teddy bear perfect for hugging',
        price: 189000,
        stock: 50,
        imageUrl:
            'https://images.unsplash.com/photo-1564859228273-274232fdb516?w=400',
        categoryName: 'Plush Toys',
        brandName: 'ToyWorld',
      ),
      Product(
        id: 2,
        name: 'Cyber Bot Advanced AI',
        description: 'Interactive robot toy with AI features',
        price: 325000,
        stock: 30,
        imageUrl:
            'https://images.unsplash.com/photo-1561144257-e32e8eeb8e1c?w=400',
        categoryName: 'Electronic Toys',
        brandName: 'RoboTech',
      ),
      Product(
        id: 3,
        name: 'Classic Bricks',
        description: 'Build your dream castle with LEGO',
        price: 450000,
        stock: 120,
        imageUrl:
            'https://images.unsplash.com/photo-1587654780291-39c9404d746b?w=400',
        categoryName: 'Building Sets',
        brandName: 'LEGO',
      ),
      Product(
        id: 4,
        name: 'Exploration Map',
        description: 'World map for learning geography',
        price: 99000,
        stock: 15,
        imageUrl:
            'https://images.unsplash.com/photo-1526778548025-fa2f459cd5c1?w=400',
        categoryName: 'Educational',
        brandName: 'EduToys',
      ),
      Product(
        id: 5,
        name: 'Racing Car Set',
        description: 'High-speed racing car with remote control',
        price: 299000,
        stock: 35,
        imageUrl:
            'https://images.unsplash.com/photo-1606664515524-ed2f786a0bd6?w=400',
        categoryName: 'RC Cars',
        brandName: 'SpeedRacer',
      ),
      Product(
        id: 6,
        name: 'Puzzle Challenge',
        description: 'Educational puzzle for brain development',
        price: 159000,
        stock: 45,
        imageUrl:
            'https://images.unsplash.com/photo-1543857778-c4a1a3e0b2eb?w=400',
        categoryName: 'Puzzles',
        brandName: 'BrainToys',
      ),
    ];
  }

  Future<void> _loadData() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    final cartService = Provider.of<CartService>(context, listen: false);

    if (authService.currentUser != null) {
      await cartService.fetchCart(authService.currentUser!.id);
    }

    // Load categories and brands for filter
    await _loadFilters();
    await _fetchProducts();
  }

  Future<void> _loadFilters() async {
    try {
      // Load categories
      final catResponse = await ApiService.get('/product-service/categories');
      if (catResponse['success'] == true && catResponse['data'] != null) {
        final List<dynamic> catData = catResponse['data'];
        setState(() {
          _categories = catData.map((json) => Category.fromJson(json)).toList();
        });
        print('✅ Loaded ${_categories.length} categories');
      }

      // Load brands
      final brandResponse = await ApiService.get('/product-service/brands');
      if (brandResponse['success'] == true && brandResponse['data'] != null) {
        final List<dynamic> brandData = brandResponse['data'];
        setState(() {
          _brands = brandData.map((json) => Brand.fromJson(json)).toList();
        });
        print('✅ Loaded ${_brands.length} brands');
      }
    } catch (e) {
      print('❌ Error loading filters: $e');
    }
  }

  Future<void> _fetchProducts(
      {String? keyword, int? categoryId, int? brandId}) async {
    // Only use setState for initial loading (when showing full screen spinner)
    // For subsequent updates, use ValueNotifier to avoid rebuilding search bar
    if (_isLoading) {
      // Initial load - can use setState safely
      setState(() {});
    }
    _isLoadingNotifier.value = true;

    try {
      // Build API URL with all filters
      String apiUrl = '/product-service/products?page=0&size=50&status=ACTIVE';

      if (keyword != null && keyword.isNotEmpty) {
        apiUrl += '&keyword=$keyword';
        print('🔍 Searching for: $keyword');
      }

      if (categoryId != null) {
        apiUrl += '&categoryId=$categoryId';
        print('🏷️ Filter by category: $categoryId');
      }

      if (brandId != null) {
        apiUrl += '&brandId=$brandId';
        print('🏷️ Filter by brand: $brandId');
      }

      // Call real API with pagination and search
      final response = await ApiService.get(apiUrl);

      print('📦 Products API Response: $response');

      if (response['success'] == true && response['data'] != null) {
        final Map<String, dynamic> pageData = response['data'];
        final List<dynamic> content = pageData['content'] ?? [];

        print('✅ Found ${content.length} products');

        // Update products via ValueNotifier (NO setState)
        final products = content.map((json) => Product.fromJson(json)).toList();
        _productsNotifier.value = products;
        _products = products;

        if (_isLoading) {
          // Initial load complete - use setState to hide loading spinner
          setState(() {
            _isLoading = false;
          });
        }
        _isLoadingNotifier.value = false;
      } else {
        print('⚠️ API returned no data, using mock products');
        // Fallback to mock data if API fails
        final mockProducts = _createMockProducts();
        _productsNotifier.value = mockProducts;
        _products = mockProducts;

        if (_isLoading) {
          setState(() {
            _isLoading = false;
          });
        }
        _isLoadingNotifier.value = false;
      }
    } catch (e) {
      print('❌ Error fetching products: $e');
      // Use mock data as fallback
      final mockProducts = _createMockProducts();
      _productsNotifier.value = mockProducts;
      _products = mockProducts;

      if (_isLoading) {
        setState(() {
          _isLoading = false;
        });
      }
      _isLoadingNotifier.value = false;

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Đang dùng dữ liệu mẫu (Lỗi kết nối backend)'),
            backgroundColor: Colors.orange.shade600,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  void _onSearchChanged(String value) {
    // Update search query via ValueNotifier (NO setState - prevents rebuild)
    _searchQueryNotifier.value = value;
    _searchKeyword = value;

    // Cancel previous timer
    _debounceTimer?.cancel();

    // Create new timer for debouncing API call (wait 400ms after user stops typing)
    _debounceTimer = Timer(const Duration(milliseconds: 400), () {
      // Only call API after user stops typing
      _fetchProducts(
        keyword: value.isNotEmpty ? value : null,
        categoryId: _selectedCategoryId,
        brandId: _selectedBrandId,
      );
    });
  }

  void _clearSearch() {
    _searchController.clear();
    // Update via ValueNotifier (NO setState)
    _searchQueryNotifier.value = '';
    _searchKeyword = '';
    _fetchProducts(
      categoryId: _selectedCategoryId,
      brandId: _selectedBrandId,
    );
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildFilterSheet(),
    );
  }

  Widget _buildFilterSheet() {
    int? tempCategoryId = _selectedCategoryId;
    int? tempBrandId = _selectedBrandId;

    return StatefulBuilder(
      builder: (context, setModalState) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.75,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.grey.shade200),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Bộ lọc sản phẩm',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setModalState(() {
                          tempCategoryId = null;
                          tempBrandId = null;
                        });
                      },
                      child: const Text('Xóa tất cả'),
                    ),
                  ],
                ),
              ),

              // Filter Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Categories
                      const Text(
                        'Danh mục',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _categories.map((category) {
                          final isSelected = tempCategoryId == category.id;
                          return GestureDetector(
                            onTap: () {
                              setModalState(() {
                                tempCategoryId =
                                    isSelected ? null : category.id;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? const Color(0xFF1EB5D9)
                                    : Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: isSelected
                                      ? const Color(0xFF1EB5D9)
                                      : Colors.transparent,
                                ),
                              ),
                              child: Text(
                                category.name,
                                style: TextStyle(
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.black87,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: 24),

                      // Brands
                      const Text(
                        'Thương hiệu',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _brands.map((brand) {
                          final isSelected = tempBrandId == brand.id;
                          return GestureDetector(
                            onTap: () {
                              setModalState(() {
                                tempBrandId = isSelected ? null : brand.id;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? const Color(0xFF1EB5D9)
                                    : Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: isSelected
                                      ? const Color(0xFF1EB5D9)
                                      : Colors.transparent,
                                ),
                              ),
                              child: Text(
                                brand.name,
                                style: TextStyle(
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.black87,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),

              // Apply Button
              Container(
                padding: const EdgeInsets.all(20),
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
                  top: false,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _selectedCategoryId = tempCategoryId;
                        _selectedBrandId = tempBrandId;
                      });
                      Navigator.pop(context);
                      _fetchProducts(
                        keyword: _searchKeyword.isEmpty ? null : _searchKeyword,
                        categoryId: _selectedCategoryId,
                        brandId: _selectedBrandId,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1EB5D9),
                      minimumSize: const Size(double.infinity, 56),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Áp dụng bộ lọc',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final cartService = Provider.of<CartService>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: _fetchProducts,
                child: CustomScrollView(
                  slivers: [
                    // Header
                    SliverToBoxAdapter(
                      child: Container(
                        color: Colors.white,
                        padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Top Row: Avatar | Location | Actions
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // Left: User Avatar
                                const CircleAvatar(
                                  radius: 22,
                                  backgroundColor: Color(0xFFE0E0E0),
                                  backgroundImage:
                                      AssetImage('assets/images/avatar.png'),
                                ),

                                // Center: Location Selector (Prominent)
                                GestureDetector(
                                  onTap: () {
                                    // Show location picker
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 10,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[50],
                                      borderRadius: BorderRadius.circular(25),
                                      border: Border.all(
                                        color: Colors.grey[200]!,
                                        width: 1,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(
                                          Icons.location_on,
                                          size: 18,
                                          color: Color(0xFF1EB5D9),
                                        ),
                                        const SizedBox(width: 6),
                                        const Text(
                                          'Ho Chi Minh City',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF2D2D2D),
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        Icon(
                                          Icons.keyboard_arrow_down,
                                          size: 18,
                                          color: Colors.grey[600],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                // Right: Action Icons (Notification + Cart)
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // Notification Icon
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.06),
                                            blurRadius: 8,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: IconButton(
                                        icon: const Icon(
                                            Icons.notifications_outlined),
                                        onPressed: () {},
                                        iconSize: 22,
                                        color: Colors.grey[700],
                                        padding: const EdgeInsets.all(8),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    // Cart Icon with Badge
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.pushNamed(context, '/cart');
                                      },
                                      child: Container(
                                        key: _cartKey,
                                        width: 44,
                                        height: 44,
                                        alignment: Alignment.center,
                                        clipBehavior: Clip.antiAlias,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black
                                                  .withOpacity(0.06),
                                              blurRadius: 8,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: Stack(
                                          children: [
                                            Center(
                                              child: AnimatedBuilder(
                                                animation: _shakeController!,
                                                builder: (context, child) {
                                                  final shake =
                                                      _shakeController!.value;
                                                  return Transform.translate(
                                                    offset: Offset(
                                                      shake < 0.5
                                                          ? (shake * 20 - 5)
                                                          : ((1 - shake) * 20 -
                                                              5),
                                                      0,
                                                    ),
                                                    child: Icon(
                                                      Icons
                                                          .shopping_bag_outlined,
                                                      size: 22,
                                                      color: Colors.grey[700],
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                            if (_cartCount > 0)
                                              Positioned(
                                                right: 0,
                                                top: 0,
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.all(4),
                                                  decoration:
                                                      const BoxDecoration(
                                                    color: Color(0xFFFF5252),
                                                    shape: BoxShape.circle,
                                                  ),
                                                  constraints:
                                                      const BoxConstraints(
                                                    minWidth: 16,
                                                    minHeight: 16,
                                                  ),
                                                  child: Text(
                                                    '$_cartCount',
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 9,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),

                            // Search Bar - Premium Pill Design
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 14),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(
                                  color:
                                      const Color(0xFF1EB5D9).withOpacity(0.2),
                                  width: 1.5,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 15,
                                    offset: const Offset(0, 5),
                                    spreadRadius: 0,
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.search,
                                    color: Color(0xFF1EB5D9),
                                    size: 24,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: TextField(
                                      controller: _searchController,
                                      focusNode: _searchFocusNode,
                                      onChanged: _onSearchChanged,
                                      decoration: InputDecoration(
                                        hintText: 'Tìm kiếm sản phẩm...',
                                        hintStyle:
                                            TextStyle(color: Colors.grey[500]),
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                  // Use ValueListenableBuilder to update button without rebuilding TextField
                                  ValueListenableBuilder<String>(
                                    valueListenable: _searchQueryNotifier,
                                    builder: (context, searchQuery, child) {
                                      return searchQuery.isNotEmpty
                                          ? GestureDetector(
                                              onTap: _clearSearch,
                                              child: const Icon(
                                                Icons.clear,
                                                color: Color(0xFF1EB5D9),
                                                size: 20,
                                              ),
                                            )
                                          : GestureDetector(
                                              onTap: _showFilterBottomSheet,
                                              child: Stack(
                                                children: [
                                                  const Icon(
                                                    Icons.tune,
                                                    color: Color(0xFF1EB5D9),
                                                    size: 24,
                                                  ),
                                                  if (_selectedCategoryId !=
                                                          null ||
                                                      _selectedBrandId != null)
                                                    Positioned(
                                                      right: 0,
                                                      top: 0,
                                                      child: Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(4),
                                                        decoration:
                                                            const BoxDecoration(
                                                          color:
                                                              Color(0xFFFF5252),
                                                          shape:
                                                              BoxShape.circle,
                                                        ),
                                                        constraints:
                                                            const BoxConstraints(
                                                          minWidth: 8,
                                                          minHeight: 8,
                                                        ),
                                                      ),
                                                    ),
                                                ],
                                              ),
                                            );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Promotion Banner - Mega Sale (hide when searching)
                    if (_searchKeyword.isEmpty)
                      const SliverToBoxAdapter(
                        child: MegaSaleBanner(),
                      ),

                    // Category Chips Section (hide when searching)
                    if (_searchKeyword.isEmpty)
                      SliverToBoxAdapter(
                        child: Container(
                          color: Colors.white,
                          padding: const EdgeInsets.only(
                              left: 20, top: 24, bottom: 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Category Chips - Horizontal Scroll (Dynamic from API)
                              SizedBox(
                                height: 50,
                                child: _categories.isEmpty
                                    ? const Center(
                                        child: CircularProgressIndicator(),
                                      )
                                    : ListView.separated(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: _categories.length + 1,
                                        separatorBuilder: (context, index) =>
                                            const SizedBox(width: 12),
                                        itemBuilder: (context, index) {
                                          if (index == 0) {
                                            // "Tất cả" option to clear filter
                                            return _buildCategoryChip(
                                              null,
                                              _selectedCategoryId == null,
                                            );
                                          }
                                          final category =
                                              _categories[index - 1];
                                          return _buildCategoryChip(
                                            category,
                                            _selectedCategoryId == category.id,
                                          );
                                        },
                                      ),
                              ),
                            ],
                          ),
                        ),
                      ),

                    // Trending Now Header - Premium Design (or Search Results)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 32, 20, 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text(
                                  _searchKeyword.isEmpty ? '🔥' : '🔍',
                                  style: const TextStyle(fontSize: 24),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  _searchKeyword.isEmpty
                                      ? 'Trending Now'
                                      : 'Kết quả tìm kiếm',
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFF2D2D2D),
                                  ),
                                ),
                                if (_searchKeyword.isNotEmpty) ...[
                                  const SizedBox(width: 8),
                                  Text(
                                    '(${_products.length})',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            TextButton(
                              onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const ProductListScreen(),
                                ),
                              ),
                              style: TextButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  Text(
                                    'See All',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Color(0xFF1EB5D9),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(width: 4),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    size: 12,
                                    color: Color(0xFF1EB5D9),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Active Filters chips
                    if (_selectedCategoryId != null || _selectedBrandId != null)
                      SliverToBoxAdapter(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          margin: const EdgeInsets.only(bottom: 16),
                          child: Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              if (_selectedCategoryId != null)
                                _buildActiveFilterChip(
                                  _categories
                                      .firstWhere(
                                          (c) => c.id == _selectedCategoryId)
                                      .name,
                                  () {
                                    setState(() {
                                      _selectedCategoryId = null;
                                    });
                                    _fetchProducts(
                                      keyword: _searchKeyword.isEmpty
                                          ? null
                                          : _searchKeyword,
                                      categoryId: null,
                                      brandId: _selectedBrandId,
                                    );
                                  },
                                ),
                              if (_selectedBrandId != null)
                                _buildActiveFilterChip(
                                  _brands
                                      .firstWhere(
                                          (b) => b.id == _selectedBrandId)
                                      .name,
                                  () {
                                    setState(() {
                                      _selectedBrandId = null;
                                    });
                                    _fetchProducts(
                                      keyword: _searchKeyword.isEmpty
                                          ? null
                                          : _searchKeyword,
                                      categoryId: _selectedCategoryId,
                                      brandId: null,
                                    );
                                  },
                                ),
                            ],
                          ),
                        ),
                      ),

                    // Products Grid - Isolated rebuild with ValueNotifier
                    ProductsGridSliver(
                      productsNotifier: _productsNotifier,
                      searchQueryNotifier: _searchQueryNotifier,
                      decimalFormat: _decimalFormat,
                      onProductTap: (product) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ProductDetailScreen(product: product),
                          ),
                        );
                      },
                      onAddToCart: (product) {
                        _addToCartWithAnimation(product);
                      },
                    ),

                    const SliverToBoxAdapter(
                      child: SizedBox(height: 20),
                    ),
                  ],
                ),
              ),
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
              _buildNavItem(Icons.store, 'Shop', true, () {}),
              _buildNavItem(Icons.favorite_border, 'Wishlist', false, () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const WishlistScreen()),
                );
              }),
              _buildNavItem(Icons.shopping_cart_outlined, 'Cart', false, () {
                Navigator.pushNamed(context, '/cart');
              }),
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

  Widget _buildNavItem(
      IconData icon, String label, bool isActive, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isActive ? const Color(0xFF27A6D1) : Colors.grey[600],
            size: 26,
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

  Widget _buildCategoryChip(Category? category, bool isActive) {
    final String label = category?.name ?? 'Tất cả';

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategoryId = category?.id;
          _selectedCategory = label;
        });

        // Fetch products with selected category filter
        _fetchProducts(
          keyword: _searchKeyword.isNotEmpty ? _searchKeyword : null,
          categoryId: _selectedCategoryId,
          brandId: _selectedBrandId,
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF1EB5D9) : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isActive)
              const Padding(
                padding: EdgeInsets.only(right: 6),
                child: Icon(
                  Icons.star,
                  size: 16,
                  color: Colors.white,
                ),
              ),
            Text(
              label,
              style: TextStyle(
                color: isActive ? Colors.white : Colors.grey.shade800,
                fontWeight: isActive ? FontWeight.bold : FontWeight.w600,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveFilterChip(String label, VoidCallback onRemove) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF1EB5D9).withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF1EB5D9),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF1EB5D9),
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: onRemove,
            child: const Icon(
              Icons.close,
              size: 16,
              color: Color(0xFF1EB5D9),
            ),
          ),
        ],
      ),
    );
  }

  // Add to cart with fly animation
  void _addToCartWithAnimation(Product product) async {
    print('🎯 Add to cart with animation triggered for: ${product.name}');

    // Use post frame callback to avoid setState during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startFlyAnimation(product);
    });

    // Then try to add to cart via API in the background
    _addToCart(product);
  }

  void _startFlyAnimation(Product product) async {
    print('🚀 Starting fly animation...');

    // Get cart icon position
    final cartBox = _cartKey.currentContext?.findRenderObject() as RenderBox?;
    if (cartBox == null) {
      print('❌ Cart icon not found, cannot animate');
      // Still update count even if animation fails
      setState(() {
        _cartCount++;
      });
      _shakeController?.forward().then((_) => _shakeController?.reset());
      return;
    }

    print('✅ Cart icon found, creating animation...');

    print('✅ Cart icon found, creating animation...');

    final cartPosition = cartBox.localToGlobal(Offset.zero);
    final cartSize = cartBox.size;
    final targetX = cartPosition.dx + cartSize.width / 2;
    final targetY = cartPosition.dy + cartSize.height / 2;

    print('📍 Target position: ($targetX, $targetY)');

    // Create overlay entry with product image
    final overlay = Overlay.of(context);
    if (overlay == null) {
      print('❌ Overlay not found');
      setState(() {
        _cartCount++;
      });
      _shakeController?.forward().then((_) => _shakeController?.reset());
      return;
    }

    late OverlayEntry overlayEntry;

    // Animation values
    final animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Start position (will be set when we know the product card position)
    // For simplicity, we'll use screen center as starting point
    final screenSize = MediaQuery.of(context).size;
    final startX = screenSize.width / 2;
    final startY = screenSize.height * 0.6; // Approximate product card position

    final animation = CurvedAnimation(
      parent: animationController,
      curve: Curves.easeInOut,
    );

    overlayEntry = OverlayEntry(
      builder: (context) => AnimatedBuilder(
        animation: animation,
        builder: (context, child) {
          // Calculate current position with parabolic curve
          final progress = animation.value;
          final currentX = startX + (targetX - startX) * progress;
          final currentY = startY +
              (targetY - startY) * progress -
              100 * (1 - progress) * progress; // Parabolic arc

          // Scale down as it flies
          final scale = 1.0 - progress * 0.7;

          return Positioned(
            left: currentX - 25,
            top: currentY - 25,
            child: IgnorePointer(
              child: Transform.scale(
                scale: scale,
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1EB5D9).withOpacity(0.3),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF1EB5D9).withOpacity(0.5),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.toys,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );

    overlay.insert(overlayEntry);
    _flyingWidget = overlayEntry;

    print('🎬 Animation started!');

    // Start animation
    await animationController.forward();

    print('✨ Animation completed!');

    // Update cart count and shake cart icon
    if (mounted) {
      setState(() {
        _cartCount++;
      });
      _shakeController?.forward().then((_) => _shakeController?.reset());
    }

    // Clean up
    await Future.delayed(const Duration(milliseconds: 100));
    overlayEntry.remove();
    animationController.dispose();

    print('🧹 Animation cleaned up');
  }

  Future<void> _addToCart(Product product) async {
    final authService = Provider.of<AuthService>(context, listen: false);
    final cartService = Provider.of<CartService>(context, listen: false);

    if (authService.currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Vui lòng đăng nhập để thêm vào giỏ hàng')),
      );
      return;
    }

    try {
      final success = await cartService.addToCart(
        authService.currentUser!.id,
        product.id,
        1,
      );
      if (mounted && success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Đã thêm ${product.name} vào giỏ hàng'),
            backgroundColor: const Color(0xFF1EB5D9),
            duration: const Duration(seconds: 1),
          ),
        );
      } else if (mounted && !success) {
        // Show detailed error but don't block the UI
        print('Failed to add to cart - Backend might be unavailable');
        // Optional: Show a less prominent error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
                'Đã thêm vào giỏ tạm thời (Chưa đồng bộ với server)'),
            backgroundColor: Colors.orange.shade600,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        print('Cart error: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Đã thêm vào giỏ tạm thời (Lỗi kết nối)'),
            backgroundColor: Colors.orange.shade600,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }
}

// Products Grid Sliver - Isolated rebuild using ValueNotifier
class ProductsGridSliver extends StatelessWidget {
  final ValueNotifier<List<Product>> productsNotifier;
  final ValueNotifier<String> searchQueryNotifier;
  final NumberFormat decimalFormat;
  final Function(Product) onProductTap;
  final Function(Product) onAddToCart;

  const ProductsGridSliver({
    super.key,
    required this.productsNotifier,
    required this.searchQueryNotifier,
    required this.decimalFormat,
    required this.onProductTap,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<Product>>(
      valueListenable: productsNotifier,
      builder: (context, products, child) {
        return ValueListenableBuilder<String>(
          valueListenable: searchQueryNotifier,
          builder: (context, searchQuery, child) {
            if (products.isEmpty) {
              return SliverFillRemaining(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        searchQuery.isEmpty
                            ? Icons.shopping_bag_outlined
                            : Icons.search_off,
                        size: 80,
                        color: Colors.grey[300],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        searchQuery.isEmpty
                            ? 'Không có sản phẩm nào'
                            : 'Không tìm thấy "$searchQuery"',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[600],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      if (searchQuery.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text(
                          'Thử tìm kiếm với từ khóa khác',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            }

            return SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.60,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return ModernProductCard(
                      product: products[index],
                      decimalFormat: decimalFormat,
                      onTap: () => onProductTap(products[index]),
                      onAddToCart: () => onAddToCart(products[index]),
                    );
                  },
                  childCount: products.length,
                ),
              ),
            );
          },
        );
      },
    );
  }
}

// Modern Product Card Widget with Flush Layout
class ModernProductCard extends StatelessWidget {
  final Product product;
  final NumberFormat decimalFormat;
  final VoidCallback onTap;
  final VoidCallback onAddToCart;

  const ModernProductCard({
    super.key,
    required this.product,
    required this.decimalFormat,
    required this.onTap,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 25,
              offset: const Offset(0, 12),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image Section - Square with Inner Rounded Container
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: AspectRatio(
                aspectRatio: 1.0,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        height: double.infinity,
                        color: const Color(0xFFF5F7FA),
                        child: product.imageUrl != null
                            ? Image.network(
                                product.imageUrl!,
                                width: double.infinity,
                                height: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Center(
                                    child: Icon(
                                      Icons.toys,
                                      size: 60,
                                      color: Colors.grey[400],
                                    ),
                                  );
                                },
                              )
                            : Center(
                                child: Icon(
                                  Icons.toys,
                                  size: 60,
                                  color: Colors.grey[400],
                                ),
                              ),
                      ),
                      // Discount Badge
                      Positioned(
                        top: 8,
                        left: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFC107),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            '-20%',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Product Info Section
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Name
                  Text(
                    product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1A1A1A),
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Stock & Rating
                  Row(
                    children: [
                      Icon(
                        Icons.inventory_2_outlined,
                        size: 12,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${product.stock} left',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Icon(
                        Icons.star,
                        size: 12,
                        color: Color(0xFFFFC107),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '4.8',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Price and Add Button Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Price - Using decimalPattern with string interpolation
                      Text(
                        '${decimalFormat.format(product.price)} đ',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),

                      // Add to Cart Button
                      GestureDetector(
                        onTap: onAddToCart,
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: const Color(0xFF1EB5D9),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF1EB5D9).withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 18,
                          ),
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

// Optimized Banner Widget
class MegaSaleBanner extends StatelessWidget {
  const MegaSaleBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      constraints: const BoxConstraints(minHeight: 140),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF2E7FD8),
            Color(0xFF1EB5D9),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          // Content with Padding
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Mega Sale',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                const Text(
                  'UP TO 50% OFF',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFFFFB800),
                    letterSpacing: 1,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: SizedBox(
                    height: 28,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF2E7FD8),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 4,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        elevation: 0,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const Text(
                        'Shop Now',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Rocket Icon - positioned to not overlap text
          Positioned(
            right: 0,
            bottom: -10,
            child: Transform.rotate(
              angle: 0.3,
              child: const Icon(
                Icons.rocket_launch,
                size: 100,
                color: Color(0xFFFFD700),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
