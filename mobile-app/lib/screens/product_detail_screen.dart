import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../services/cart_service.dart';
import 'package:intl/intl.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product? product;

  const ProductDetailScreen({super.key, this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final _currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: '\$');
  bool _isFavorite = false;

  // Mock LEGO product data
  late final Product _displayProduct;

  @override
  void initState() {
    super.initState();
    _displayProduct = widget.product ?? _createMockProduct();
  }

  Product _createMockProduct() {
    return Product(
      id: 999,
      name: 'LEGO® City Space Explorer',
      description:
          'Blast off into intergalactic adventures! This premium set features a detailed space shuttle with an opening cockpit, retractable landing gear, and a working satellite deployment system. Perfect for young astronauts ready to explore the cosmos.',
      price: 89.99,
      stock: 50,
      imageUrl:
          'https://images.unsplash.com/photo-1587654780291-39c9404d746b?w=800',
      categoryName: 'LEGO',
      brandName: 'LEGO',
    );
  }

  List<String> _getGalleryImages() {
    return [
      'https://images.unsplash.com/photo-1587654780291-39c9404d746b?w=400',
      'https://images.unsplash.com/photo-1611604548018-d56bbd85d681?w=400',
      'https://images.unsplash.com/photo-1587654780291-39c9404d746b?w=400',
    ];
  }

  Future<void> _addToCart() async {
    final cartService = Provider.of<CartService>(context, listen: false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 12),
            Text('Added to cart successfully!'),
          ],
        ),
        backgroundColor: Colors.green.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header & Image Section
            _buildHeaderWithImage(),

            // Content Section
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title & Price Row
                  _buildTitleAndPrice(),
                  const SizedBox(height: 12),

                  // Rating & Reviews
                  _buildRatingSection(),
                  const SizedBox(height: 20),

                  // Description
                  _buildDescription(),
                  const SizedBox(height: 24),

                  // Specs Row (Pieces, Minifigs, Build Time)
                  _buildSpecsRow(),
                  const SizedBox(height: 24),

                  // Gallery Section
                  _buildGallery(),
                  const SizedBox(height: 24),

                  // Rating Breakdown Section
                  _buildRatingBreakdown(),
                  const SizedBox(height: 100), // Space for bottom bar
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildHeaderWithImage() {
    return Stack(
      children: [
        // Main Product Image
        ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(24)),
          child: Container(
            height: 400,
            width: double.infinity,
            color: Colors.grey[100],
            child: _displayProduct.imageUrl != null
                ? Image.network(
                    _displayProduct.imageUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Center(
                        child: Icon(Icons.toys,
                            size: 100, color: Colors.grey[400]),
                      );
                    },
                  )
                : Center(
                    child: Icon(Icons.toys, size: 100, color: Colors.grey[400]),
                  ),
          ),
        ),

        // Top Action Buttons (Back & Favorite)
        Positioned(
          top: 50,
          left: 16,
          right: 16,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildCircleButton(
                icon: Icons.arrow_back,
                onTap: () => Navigator.pop(context),
              ),
              Row(
                children: [
                  _buildCircleButton(
                    icon: _isFavorite ? Icons.favorite : Icons.favorite_border,
                    onTap: () => setState(() => _isFavorite = !_isFavorite),
                    iconColor: _isFavorite ? Colors.red : Colors.black87,
                  ),
                  const SizedBox(width: 12),
                  _buildCircleButton(
                    icon: Icons.share_outlined,
                    onTap: () {},
                  ),
                ],
              ),
            ],
          ),
        ),

        // Badges at Bottom Left
        Positioned(
          bottom: 16,
          left: 16,
          child: Row(
            children: [
              _buildBadge(
                'NEW ARRIVAL',
                const Color(0xFFFFC107),
                Colors.black87,
              ),
              const SizedBox(width: 8),
              _buildBadge(
                'AGES 9+',
                const Color(0xFF81D4FA),
                Colors.black87,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCircleButton({
    required IconData icon,
    required VoidCallback onTap,
    Color? iconColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: iconColor ?? Colors.black87, size: 22),
      ),
    );
  }

  Widget _buildBadge(String label, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontSize: 11,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildTitleAndPrice() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Product Name
        Expanded(
          child: Text(
            _displayProduct.name,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              height: 1.2,
            ),
          ),
        ),
        const SizedBox(width: 16),
        // Price Section
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              _currencyFormat.format(_displayProduct.price),
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1976D2),
              ),
            ),
            Text(
              '\$109.99',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
                decoration: TextDecoration.lineThrough,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRatingSection() {
    return Row(
      children: [
        // Star icons
        Row(
          children: List.generate(
            5,
            (index) => Icon(
              index < 4 ? Icons.star : Icons.star_half,
              color: const Color(0xFFFFC107),
              size: 20,
            ),
          ),
        ),
        const SizedBox(width: 8),
        const Text(
          '4.8',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          '(124 reviews)',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildDescription() {
    return Text(
      _displayProduct.description,
      style: TextStyle(
        fontSize: 15,
        color: Colors.grey.shade700,
        height: 1.6,
      ),
    );
  }

  Widget _buildSpecsRow() {
    return Row(
      children: [
        _buildSpecCard(
          icon: Icons.extension,
          label: 'Pieces',
          value: '1,254',
          color: const Color(0xFF42A5F5),
        ),
        const SizedBox(width: 12),
        _buildSpecCard(
          icon: Icons.person,
          label: 'Minifigs',
          value: '4 Included',
          color: const Color(0xFFEF5350),
        ),
        const SizedBox(width: 12),
        _buildSpecCard(
          icon: Icons.access_time,
          label: 'Build Time',
          value: '4-5 hrs',
          color: const Color(0xFFFFA726),
        ),
      ],
    );
  }

  Widget _buildSpecCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey[200]!, width: 1),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGallery() {
    final images = _getGalleryImages();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Gallery',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: images.length,
            itemBuilder: (context, index) {
              return Padding(
                padding:
                    EdgeInsets.only(right: index < images.length - 1 ? 12 : 0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    width: 100,
                    height: 100,
                    color: Colors.grey[200],
                    child: Image.network(
                      images[index],
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Center(
                          child: Icon(Icons.image, color: Colors.grey[400]),
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRatingBreakdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Rating Breakdown',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'View all',
              style: TextStyle(
                fontSize: 14,
                color: Colors.blue[600],
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildRatingBar(5, 0.77),
        const SizedBox(height: 8),
        _buildRatingBar(4, 0.15),
        const SizedBox(height: 8),
        _buildRatingBar(3, 0.08),
      ],
    );
  }

  Widget _buildRatingBar(int stars, double percentage) {
    return Row(
      children: [
        SizedBox(
          width: 12,
          child: Text(
            '$stars',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: percentage,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(
                stars >= 4
                    ? const Color(0xFF42A5F5)
                    : stars == 3
                        ? const Color(0xFFFFA726)
                        : const Color(0xFFEF5350),
              ),
              minHeight: 8,
            ),
          ),
        ),
        const SizedBox(width: 12),
        SizedBox(
          width: 36,
          child: Text(
            '${(percentage * 100).toInt()}%',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomBar() {
    return Container(
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
        child: Row(
          children: [
            // Favorite Button
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(16),
              ),
              child: IconButton(
                icon: Icon(
                  _isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: _isFavorite ? Colors.red : Colors.black87,
                ),
                onPressed: () => setState(() => _isFavorite = !_isFavorite),
              ),
            ),
            const SizedBox(width: 16),
            // Add to Cart Button
            Expanded(
              child: ElevatedButton(
                onPressed: _addToCart,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFC107),
                  foregroundColor: Colors.black87,
                  shape: const StadiumBorder(),
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.shopping_bag, size: 22),
                    SizedBox(width: 12),
                    Text(
                      'Add to Cart',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
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
}
