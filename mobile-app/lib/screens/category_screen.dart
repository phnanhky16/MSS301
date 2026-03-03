import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../services/cart_service.dart';
import 'product_detail_screen.dart';
import 'package:intl/intl.dart';

class CategoryScreen extends StatefulWidget {
  final String categoryName;

  const CategoryScreen({super.key, required this.categoryName});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  String _selectedFilter = 'All Toys';
  final _currencyFormat = NumberFormat.currency(locale: 'en_US', symbol: '\$');
  List<Product> _products = [];

  @override
  void initState() {
    super.initState();
    _loadMockProducts();
  }

  void _loadMockProducts() {
    _products = [
      Product(
        id: 101,
        name: 'Robo-Builder X1',
        description: 'Advanced AI learning robot with programmable features',
        price: 45.00,
        stock: 25,
        imageUrl:
            'https://images.unsplash.com/photo-1620325867502-221cfb5faa5f?w=400',
        categoryName: 'Robotics & Engineering',
        brandName: 'TechKids',
      ),
      Product(
        id: 102,
        name: 'Circuit Master 5000',
        description: 'Electronic circuit building kit for beginners',
        price: 32.99,
        stock: 40,
        imageUrl:
            'https://images.unsplash.com/photo-1518770660439-4636190af475?w=400',
        categoryName: 'Electronics',
        brandName: 'MakerLab',
      ),
      Product(
        id: 103,
        name: 'Space Explorer',
        description: 'Build your own rocket and learn about space',
        price: 55.00,
        stock: 18,
        imageUrl:
            'https://images.unsplash.com/photo-1614728894747-a83421e2b9c9?w=400',
        categoryName: 'Astronomy',
        brandName: 'NASA Kids',
      ),
      Product(
        id: 104,
        name: 'Eco-Power Station',
        description: 'Green energy learning kit with solar panels',
        price: 28.50,
        stock: 30,
        imageUrl:
            'https://images.unsplash.com/photo-1473341304170-971dccb5ac1e?w=400',
        categoryName: 'Green Energy',
        brandName: 'EcoToys',
      ),
      Product(
        id: 105,
        name: 'Code-a-Pillar',
        description: 'Interactive coding toy for early learners',
        price: 39.99,
        stock: 35,
        imageUrl:
            'https://images.unsplash.com/photo-1587654780291-39c9404d746b?w=400',
        categoryName: 'Coding for Kids',
        brandName: 'CodePlay',
      ),
      Product(
        id: 106,
        name: 'Microscope Set',
        description: 'Professional grade microscope for young scientists',
        price: 24.99,
        stock: 22,
        imageUrl:
            'https://images.unsplash.com/photo-1582719508461-905c673771fd?w=400',
        categoryName: 'Science',
        brandName: 'SciencePro',
      ),
    ];
  }

  Future<void> _addToCart(Product product) async {
    final cartService = Provider.of<CartService>(context, listen: false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text('${product.name} added to cart!'),
            ),
          ],
        ),
        backgroundColor: Colors.green.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cartService = Provider.of<CartService>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              widget.categoryName,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '${_products.length} items',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 13,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Stack(
              alignment: Alignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.shopping_bag_outlined,
                      color: Colors.black87),
                  onPressed: () {
                    // Navigate to cart
                  },
                ),
                if (cartService.itemCount > 0)
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Color(0xFFFF5252),
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 18,
                        minHeight: 18,
                      ),
                      child: Text(
                        '${cartService.itemCount}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
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
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.search, color: Colors.grey[600]),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search robots, coding kits...',
                        hintStyle: TextStyle(color: Colors.grey[500]),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  Icon(Icons.tune, color: Colors.grey[600]),
                ],
              ),
            ),
          ),

          // Sub-category Filter Tabs
          Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildFilterChip('All Toys'),
                const SizedBox(width: 10),
                _buildFilterChip('Age 3-5'),
                const SizedBox(width: 10),
                _buildFilterChip('Coding'),
                const SizedBox(width: 10),
                _buildFilterChip('Robotics'),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Product Grid
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.60,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: _products.length,
              itemBuilder: (context, index) {
                return _buildProductCard(_products[index]);
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildFilterChip(String label) {
    final isActive = _selectedFilter == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilter = label;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF00BCD4) : Colors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: isActive ? const Color(0xFF00BCD4) : Colors.grey[300]!,
            width: 1,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isActive ? Colors.white : Colors.grey[700],
              fontWeight: isActive ? FontWeight.bold : FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProductCard(Product product) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(product: product),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: Colors.grey[200]!,
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Section with overlays
            Expanded(
              flex: 6,
              child: Stack(
                children: [
                  // Product Image
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      color: _getCardBackgroundColor(product.id),
                      child: product.imageUrl != null
                          ? Image.network(
                              product.imageUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Center(
                                  child: Icon(
                                    Icons.toys,
                                    size: 50,
                                    color: Colors.grey[400],
                                  ),
                                );
                              },
                            )
                          : Center(
                              child: Icon(
                                Icons.toys,
                                size: 50,
                                color: Colors.grey[400],
                              ),
                            ),
                    ),
                  ),

                  // Heart Icon - Top Left
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.favorite_border,
                        size: 18,
                        color: Colors.black87,
                      ),
                    ),
                  ),

                  // Price Tag - Top Right
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.75),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _currencyFormat.format(product.price),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  // "New" Badge - Bottom Left (for some products)
                  if (product.id == 104)
                    Positioned(
                      bottom: 12,
                      left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF8BC34A),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'New',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Info Section
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Name
                    Text(
                      product.name,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),

                    // Category Name
                    Text(
                      product.categoryName ?? 'Category',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const Spacer(),

                    // Add Button
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () => _addToCart(product),
                        icon: const Icon(Icons.shopping_cart, size: 16),
                        label: const Text('Add'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF00BCD4),
                          side: const BorderSide(
                            color: Color(0xFF00BCD4),
                            width: 1.5,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 8),
                        ),
                      ),
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

  Color _getCardBackgroundColor(int productId) {
    // Different pastel backgrounds for variety
    final colors = [
      const Color(0xFFF5F5F5), // Light gray
      const Color(0xFFF1F8F6), // Light mint
      const Color(0xFFFFF9E6), // Light yellow
      const Color(0xFFF0F8FF), // Light blue
      const Color(0xFFFFF0F5), // Light pink
      const Color(0xFFE8F5E9), // Light green
    ];
    return colors[productId % colors.length];
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
              _buildNavItem(Icons.store, 'Shop', false),
              _buildNavItem(Icons.explore_outlined, 'Discover', false),
              _buildNavItem(Icons.shopping_cart_outlined, 'Cart', false),
              _buildNavItem(Icons.person_outline, 'Profile', false),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isActive) {
    return GestureDetector(
      onTap: () {
        if (label == 'Shop') {
          Navigator.pop(context);
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isActive ? const Color(0xFF00BCD4) : Colors.grey[600],
            size: 26,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isActive ? const Color(0xFF00BCD4) : Colors.grey[600],
              fontSize: 12,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
