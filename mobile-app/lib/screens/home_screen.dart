import 'dart:async';
import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../services/cart_service.dart';
import '../services/wishlist_service.dart';
import '../services/address_service.dart';
import '../services/api_service.dart';
import 'shipping_address_screen.dart';
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
  final GlobalKey _wishlistNavKey = GlobalKey();
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userId = context.read<AuthService>().currentUser?.id;
      if (userId != null) {
        context.read<AddressService>().fetchByUser(userId);
      }
    });
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
    final wishlistService =
        Provider.of<WishlistService>(context, listen: false);

    if (authService.currentUser != null) {
      await cartService.fetchCart(authService.currentUser!.id);
    }
    await wishlistService.fetchWishlist();

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

  void _showAddressSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Consumer<AddressService>(
          builder: (ctx, svc, _) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(24)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // drag handle
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Chọn địa chỉ giao hàng',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  if (svc.isLoading)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: CircularProgressIndicator(
                          color: Color(0xFF1EB5D9)),
                    )
                  else if (svc.shipments.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Text(
                        'Chưa có địa chỉ nào. Hãy thêm địa chỉ mới!',
                        style:
                            TextStyle(color: Colors.grey[500], fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                    )
                  else
                    Flexible(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: svc.shipments.length,
                        itemBuilder: (_, i) {
                          final s = svc.shipments[i];
                          final isSelected = svc.selectedId == s.shipId;
                          return ListTile(
                            leading: Icon(
                              Icons.location_on,
                              color: isSelected
                                  ? const Color(0xFF1EB5D9)
                                  : Colors.grey[500],
                            ),
                            title: Text(
                              s.note?.isNotEmpty == true ? s.note! : s.city,
                              style: TextStyle(
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: isSelected
                                    ? const Color(0xFF1EB5D9)
                                    : Colors.black87,
                              ),
                            ),
                            subtitle: Text(
                              s.fullAddress,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.black54),
                            ),
                            trailing: isSelected
                                ? const Icon(Icons.check_circle,
                                    color: Color(0xFF1EB5D9))
                                : null,
                            onTap: () {
                              svc.select(s.shipId);
                              Navigator.pop(ctx);
                            },
                          );
                        },
                      ),
                    ),
                  const SizedBox(height: 8),
                  TextButton.icon(
                    icon: const Icon(Icons.add,
                        color: Color(0xFF1EB5D9), size: 18),
                    label: const Text(
                      'Quản lý địa chỉ',
                      style: TextStyle(color: Color(0xFF1EB5D9)),
                    ),
                    onPressed: () {
                      Navigator.pop(ctx);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const ShippingAddressScreen()),
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            );
          },
        );
      },
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
                                    _showAddressSelector(context);
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
                                    child: Consumer<AddressService>(
                                      builder: (_, addrSvc, __) {
                                        final sel = addrSvc.selectedShipment;
                                        final label = sel != null
                                            ? (sel.note?.isNotEmpty == true
                                                ? sel.note!
                                                : sel.city)
                                            : 'Chọn địa chỉ';
                                        return Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Icon(
                                              Icons.location_on,
                                              size: 18,
                                              color: Color(0xFF1EB5D9),
                                            ),
                                            const SizedBox(width: 6),
                                            ConstrainedBox(
                                              constraints:
                                                  const BoxConstraints(
                                                      maxWidth: 140),
                                              child: Text(
                                                label,
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xFF2D2D2D),
                                                ),
                                                overflow:
                                                    TextOverflow.ellipsis,
                                                maxLines: 1,
                                              ),
                                            ),
                                            const SizedBox(width: 4),
                                            Icon(
                                              Icons.keyboard_arrow_down,
                                              size: 18,
                                              color: Colors.grey[600],
                                            ),
                                          ],
                                        );
                                      },
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
                                      child: Consumer<CartService>(
                                        builder: (_, cartSvc, __) => Container(
                                          key: _cartKey,
                                          width: 44,
                                          height: 44,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(0.08),
                                                blurRadius: 10,
                                                offset: const Offset(0, 3),
                                              ),
                                            ],
                                          ),
                                          child: Stack(
                                            clipBehavior: Clip.none,
                                            children: [
                                              Center(
                                                child: Icon(
                                                  Icons.shopping_bag_outlined,
                                                  size: 22,
                                                  color:
                                                      const Color(0xFF1EB5D9),
                                                ),
                                              ),
                                              if (cartSvc.itemCount > 0)
                                                Positioned(
                                                  top: -2,
                                                  right: -2,
                                                  child: Container(
                                                    width: 17,
                                                    height: 17,
                                                    decoration: BoxDecoration(
                                                      color: const Color(
                                                          0xFFBEF264),
                                                      shape: BoxShape.circle,
                                                      border: Border.all(
                                                          color: Colors.white,
                                                          width: 1.5),
                                                    ),
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      '${cartSvc.itemCount}',
                                                      style: const TextStyle(
                                                        color:
                                                            Color(0xFF0F172A),
                                                        fontSize: 9,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                      textAlign:
                                                          TextAlign.center,
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
                      onAddToCart: (product, sourceKey) {
                        _addToCartWithAnimation(product, sourceKey);
                      },
                      onWishlistToggle: (product, sourceKey) {
                        _flyToWishlist(sourceKey);
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
              },
                  badge: Consumer<WishlistService>(
                    builder: (_, wishlist, __) => wishlist.count > 0
                        ? _buildNavBadge(
                            '${wishlist.count}',
                            badgeColor: Colors.redAccent,
                            textColor: Colors.white,
                          )
                        : const SizedBox.shrink(),
                  ),
                  iconKey: _wishlistNavKey),
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
      {Widget? badge, Key? iconKey}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            key: iconKey,
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
  void _addToCartWithAnimation(Product product, GlobalKey sourceKey) {
    // Launch bezier fly animation immediately
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _flyToCart(sourceKey, _cartKey);
    });
    // Call API in background
    _addToCart(product);
  }

  void _flyToCart(GlobalKey sourceKey, GlobalKey targetKey) {
    final sourceBox =
        sourceKey.currentContext?.findRenderObject() as RenderBox?;
    final targetBox =
        targetKey.currentContext?.findRenderObject() as RenderBox?;
    if (sourceBox == null || targetBox == null) return;
    final startPos =
        sourceBox.localToGlobal(sourceBox.size.center(Offset.zero));
    final endPos = targetBox.localToGlobal(targetBox.size.center(Offset.zero));

    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (_) => _HomeFlyingDot(
        startPos: startPos,
        endPos: endPos,
        onComplete: () => entry.remove(),
      ),
    );
    Overlay.of(context).insert(entry);
    _flyingWidget = entry;
  }

  void _flyToWishlist(GlobalKey sourceKey) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final sourceBox =
          sourceKey.currentContext?.findRenderObject() as RenderBox?;
      final targetBox =
          _wishlistNavKey.currentContext?.findRenderObject() as RenderBox?;
      if (sourceBox == null || targetBox == null) return;
      final startPos =
          sourceBox.localToGlobal(sourceBox.size.center(Offset.zero));
      final endPos =
          targetBox.localToGlobal(targetBox.size.center(Offset.zero));

      late OverlayEntry entry;
      entry = OverlayEntry(
        builder: (_) => _HomeFlyingHeart(
          startPos: startPos,
          endPos: endPos,
          onComplete: () => entry.remove(),
        ),
      );
      Overlay.of(context).insert(entry);
    });
  }

  void _startFlyAnimation(Product product) async {}

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
      if (mounted && !success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Không thể thêm vào giỏ hàng'),
            backgroundColor: Colors.redAccent,
            duration: const Duration(seconds: 1),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Lỗi kết nối'),
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
  final Function(Product, GlobalKey) onAddToCart;
  final Function(Product, GlobalKey) onWishlistToggle;

  const ProductsGridSliver({
    super.key,
    required this.productsNotifier,
    required this.searchQueryNotifier,
    required this.decimalFormat,
    required this.onProductTap,
    required this.onAddToCart,
    required this.onWishlistToggle,
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
                      onAddToCart: (key) => onAddToCart(products[index], key),
                      onWishlistToggle: (key) =>
                          onWishlistToggle(products[index], key),
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
class ModernProductCard extends StatefulWidget {
  final Product product;
  final NumberFormat decimalFormat;
  final VoidCallback onTap;
  final Function(GlobalKey) onAddToCart;
  final Function(GlobalKey)? onWishlistToggle;

  const ModernProductCard({
    super.key,
    required this.product,
    required this.decimalFormat,
    required this.onTap,
    required this.onAddToCart,
    this.onWishlistToggle,
  });

  @override
  State<ModernProductCard> createState() => _ModernProductCardState();
}

class _ModernProductCardState extends State<ModernProductCard> {
  final _addBtnKey = GlobalKey();
  final _heartBtnKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final decimalFormat = widget.decimalFormat;
    return GestureDetector(
      onTap: widget.onTap,
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
                      // Wishlist heart button
                      Positioned(
                        top: 8,
                        left: 8,
                        child: Consumer<WishlistService>(
                          builder: (_, wishlist, __) => GestureDetector(
                            onTap: () {
                              final ws = Provider.of<WishlistService>(context,
                                  listen: false);
                              final wasWishlisted =
                                  ws.isWishlisted(widget.product.id);
                              ws.toggleWishlist(widget.product);
                              if (!wasWishlisted) {
                                widget.onWishlistToggle?.call(_heartBtnKey);
                              }
                            },
                            child: Container(
                              key: _heartBtnKey,
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 5,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Icon(
                                wishlist.isWishlisted(widget.product.id)
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                size: 16,
                                color: wishlist.isWishlisted(widget.product.id)
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
                        onTap: () => widget.onAddToCart(_addBtnKey),
                        child: Container(
                          key: _addBtnKey,
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

// ─── Home Fly-to-Cart Overlay Animation ────────────────────────────────────

class _HomeFlyingDot extends StatefulWidget {
  const _HomeFlyingDot({
    required this.startPos,
    required this.endPos,
    required this.onComplete,
  });
  final Offset startPos;
  final Offset endPos;
  final VoidCallback onComplete;

  @override
  State<_HomeFlyingDot> createState() => _HomeFlyingDotState();
}

class _HomeFlyingDotState extends State<_HomeFlyingDot>
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

  /// Quadratic Bézier parabol: P(t) = (1-t)²P0 + 2(1-t)t·P1 + t²P2
  Offset _bezier(double t) {
    final p0 = widget.startPos;
    final p2 = widget.endPos;
    final ctrl = Offset(
      (p0.dx + p2.dx) / 2,
      math.min(p0.dy, p2.dy) - 130,
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
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF1EB5D9).withOpacity(0.4),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.shopping_bag_outlined,
                    color: Color(0xFF1EB5D9),
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

// ─── Home Fly-to-Wishlist Overlay Animation ─────────────────────────────────

class _HomeFlyingHeart extends StatefulWidget {
  const _HomeFlyingHeart({
    required this.startPos,
    required this.endPos,
    required this.onComplete,
  });
  final Offset startPos;
  final Offset endPos;
  final VoidCallback onComplete;

  @override
  State<_HomeFlyingHeart> createState() => _HomeFlyingHeartState();
}

class _HomeFlyingHeartState extends State<_HomeFlyingHeart>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 650));
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
      math.min(p0.dy, p2.dy) - 60,
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
        final scale = lerpDouble(1.2, 0.3, t)!;
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
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.redAccent.withOpacity(0.45),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.favorite,
                    color: Colors.redAccent,
                    size: 18,
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

// Optimized Banner Widget
class MegaSaleBanner extends StatelessWidget {
  const MegaSaleBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      width: double.infinity,
      height: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [Color(0xFF3B82F6), Color(0xFF22D3EE)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            // Hiệu ứng đốm sáng mờ 1 (Góc trên phải)
            Positioned(
              top: -20,
              right: 80,
              child: Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.1),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.1),
                      blurRadius: 24,
                      spreadRadius: 10,
                    ),
                  ],
                ),
              ),
            ),

            // Hiệu ứng đốm sáng mờ 2 (Góc dưới trái)
            Positioned(
              bottom: -10,
              left: 20,
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.1),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.1),
                      blurRadius: 16,
                      spreadRadius: 5,
                    ),
                  ],
                ),
              ),
            ),

            // Icon Tên lửa (Xoay và đổ bóng)
            Positioned(
              right: -20,
              bottom: -20,
              child: Transform.rotate(
                angle: -10 * math.pi / 180,
                child: SizedBox(
                  width: 160,
                  height: 160,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Lớp tên lửa mờ phía sau
                      Icon(
                        Icons.rocket_launch_rounded,
                        size: 140,
                        color: Colors.white.withOpacity(0.2),
                      ),
                      // Lớp tên lửa vàng rực phía trước
                      const Icon(
                        Icons.rocket_launch_rounded,
                        size: 100,
                        color: Color(0xFFFDE047),
                        shadows: [
                          Shadow(
                            color: Colors.black26,
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Cụm nội dung Chữ & Nút bấm
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Mega Sale',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                      shadows: [
                        Shadow(
                            color: Colors.black26,
                            blurRadius: 4,
                            offset: Offset(0, 2)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'UP TO 50% OFF',
                    style: TextStyle(
                      color: Color(0xFFFDE047),
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      shadows: [
                        Shadow(
                            color: Colors.black12,
                            blurRadius: 2,
                            offset: Offset(0, 1)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Nút Shop Now
                  InkWell(
                    onTap: () {},
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 4,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: const Text(
                        'Shop Now',
                        style: TextStyle(
                          color: Color(0xFF2563EB),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
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
