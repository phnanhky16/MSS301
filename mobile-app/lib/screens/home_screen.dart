import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../services/cart_service.dart';
import '../services/api_service.dart';
import '../models/product.dart';
import 'product_detail_screen.dart';
import 'category_screen.dart';
import 'profile_screen.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Product> _products = [];
  bool _isLoading = true;
  String _selectedCategory = 'Popular';
  final _currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');

  @override
  void initState() {
    super.initState();
    _loadData();
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

    await _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    setState(() => _isLoading = true);

    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 500));

    // Use mock data instead of API call
    setState(() {
      _products = _createMockProducts();
      _isLoading = false;
    });

    /* 
    // Original API call - commented out for testing
    try {
      final response = await ApiService.get('/product-service/products');
      if (response['success'] == true) {
        final List<dynamic> data = response['data'];
        setState(() {
          _products = data.map((json) => Product.fromJson(json)).toList();
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() => _isLoading = false);
      print('Error fetching products: $e');
    }
    */
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
                                  backgroundImage: AssetImage('assets/images/avatar.png'),
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
                                      child: Stack(
                                        children: [
                                          IconButton(
                                            icon: const Icon(
                                                Icons.shopping_bag_outlined),
                                            onPressed: () {
                                              Navigator.pushNamed(
                                                  context, '/cart');
                                            },
                                            iconSize: 22,
                                            color: Colors.grey[700],
                                            padding: const EdgeInsets.all(8),
                                          ),
                                          if (cartService.itemCount > 0)
                                            Positioned(
                                              right: 6,
                                              top: 6,
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(4),
                                                decoration: const BoxDecoration(
                                                  color: Color(0xFFFF5252),
                                                  shape: BoxShape.circle,
                                                ),
                                                constraints:
                                                    const BoxConstraints(
                                                  minWidth: 16,
                                                  minHeight: 16,
                                                ),
                                                child: Text(
                                                  '${cartService.itemCount}',
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 9,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  textAlign: TextAlign.center,
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
                            const SizedBox(height: 20),

                            // Search Bar - Premium Pill Design
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(
                                  color: const Color(0xFF1EB5D9).withOpacity(0.2),
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
                                      decoration: InputDecoration(
                                        hintText: 'Search for toys...',
                                        hintStyle:
                                            TextStyle(color: Colors.grey[500]),
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                  const Icon(
                                    Icons.tune,
                                    color: Color(0xFF1EB5D9),
                                    size: 24,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Promotion Banner - Mega Sale
                    const SliverToBoxAdapter(
                      child: MegaSaleBanner(),
                    ),

                    // Category Chips Section
                    SliverToBoxAdapter(
                      child: Container(
                        color: Colors.white,
                        padding:
                            const EdgeInsets.only(left: 20, top: 24, bottom: 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Category Chips - Horizontal Scroll
                            SizedBox(
                              height: 50,
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: [
                                  _buildCategoryChip('Popular',
                                      _selectedCategory == 'Popular'),
                                  const SizedBox(width: 12),
                                  _buildCategoryChip('STEM Toys',
                                      _selectedCategory == 'STEM Toys'),
                                  const SizedBox(width: 12),
                                  _buildCategoryChip(
                                      'LEGO', _selectedCategory == 'LEGO'),
                                  const SizedBox(width: 12),
                                  _buildCategoryChip(
                                      'Dolls', _selectedCategory == 'Dolls'),
                                  const SizedBox(width: 12),
                                  _buildCategoryChip('Action Figures',
                                      _selectedCategory == 'Action Figures'),
                                  const SizedBox(width: 12),
                                  _buildCategoryChip('Board Games',
                                      _selectedCategory == 'Board Games'),
                                  const SizedBox(width: 12),
                                  _buildCategoryChip('Puzzles',
                                      _selectedCategory == 'Puzzles'),
                                  const SizedBox(width: 12),
                                  _buildCategoryChip('Vehicles',
                                      _selectedCategory == 'Vehicles'),
                                  const SizedBox(width: 12),
                                  _buildCategoryChip('Arts & Crafts',
                                      _selectedCategory == 'Arts & Crafts'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Trending Now Header - Premium Design
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 32, 20, 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Text(
                                  '🔥',
                                  style: TextStyle(fontSize: 24),
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  'Trending Now',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFF2D2D2D),
                                  ),
                                ),
                              ],
                            ),
                            TextButton(
                              onPressed: () {},
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
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

                    // Products Grid
                    _products.isEmpty
                        ? const SliverFillRemaining(
                            child: Center(child: Text('Không có sản phẩm nào')),
                          )
                        : SliverPadding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            sliver: SliverGrid(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 0.60,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                              ),
                              delegate: SliverChildBuilderDelegate(
                                (context, index) {
                                  return ModernProductCard(
                                    product: _products[index],
                                    currencyFormat: _currencyFormat,
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ProductDetailScreen(
                                            product: _products[index],
                                          ),
                                        ),
                                      );
                                    },
                                    onAddToCart: () {
                                      _addToCart(_products[index]);
                                    },
                                  );
                                },
                                childCount: _products.length,
                              ),
                            ),
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
              _buildNavItem(Icons.explore_outlined, 'Discover', false, () {}),
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

  Widget _buildCategoryChip(String label, bool isActive) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategory = label;
        });
        // Navigate to CategoryScreen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CategoryScreen(categoryName: label),
          ),
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

  void _addToCart(Product product) async {
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
            duration: const Duration(seconds: 2),
          ),
        );
      } else if (mounted && !success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Không thể thêm vào giỏ hàng'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi: $e')),
        );
      }
    }
  }
}

// Modern Product Card Widget with Flush Layout
class ModernProductCard extends StatelessWidget {
  final Product product;
  final NumberFormat currencyFormat;
  final VoidCallback onTap;
  final VoidCallback onAddToCart;

  const ModernProductCard({
    super.key,
    required this.product,
    required this.currencyFormat,
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
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                    children: [
                      // Price
                      Text(
                        currencyFormat.format(product.price),
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
