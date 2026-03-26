import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../services/api_service.dart';
import '../services/cart_service.dart';
import '../services/wishlist_service.dart';
import '../services/auth_service.dart';
import 'package:intl/intl.dart';
import 'customer_reviews_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product? product;
  final bool fromCart;

  const ProductDetailScreen({
    super.key,
    this.product,
    this.fromCart = false,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final _currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');
  // _isFavorite is now driven by WishlistService

  // Mock LEGO product data
  late final Product _displayProduct;

  List<String> _galleryImages = [];
  bool _isLoadingImages = false;
  int _currentIndex = 0;
  late PageController _pageController;

  List<String> get _carouselImages {
    final List<String> images = [];
    if (_displayProduct.imageUrl != null &&
        _displayProduct.imageUrl!.isNotEmpty) {
      images.add(_displayProduct.imageUrl!);
    }
    for (final img in _galleryImages) {
      if (!images.contains(img)) images.add(img);
    }
    return images;
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _displayProduct = widget.product ?? _createMockProduct();
    _fetchGalleryImages();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _fetchGalleryImages() async {
    // Use imageUrls already embedded in the product if available
    if (_displayProduct.imageUrls.isNotEmpty) {
      setState(() {
        _galleryImages = _displayProduct.imageUrls;
      });
      return;
    }

    setState(() => _isLoadingImages = true);
    try {
      final response = await ApiService.get(
          '/product-service/products/${_displayProduct.id}/images');
      if (response['success'] == true && response['data'] != null) {
        final List<dynamic> data = response['data'] as List<dynamic>;
        final urls = data
            .map((item) => item['imageUrl'] as String?)
            .whereType<String>()
            .toList();
        if (mounted) {
          setState(() {
            _galleryImages = urls;
          });
        }
      }
    } catch (e) {
      debugPrint('Fetch gallery images error: \$e');
    } finally {
      if (mounted) setState(() => _isLoadingImages = false);
    }
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

  Future<void> _addToCart() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    final cartService = Provider.of<CartService>(context, listen: false);

    if (authService.currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please log in to add items to cart')),
      );
      return;
    }

    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 16),
                const Text('Adding to cart...'),
                const SizedBox(height: 8),
                Text(
                  'Please wait',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    try {
      final success = await cartService.addToCart(
        authService.currentUser!.id,
        _displayProduct.id,
        1,
      );

      // Dismiss loading dialog
      if (mounted) {
        Navigator.pop(context);
      }

      if (success) {
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
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            margin: const EdgeInsets.all(16),
          ),
        );
      } else {
        final errorMsg =
            cartService.lastErrorMessage ?? 'Failed to add to cart';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.error_outline, color: Colors.red.shade300),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    errorMsg,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            margin: const EdgeInsets.all(16),
          ),
        );
      }
    } catch (e) {
      // Dismiss loading dialog if still open
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (widget.fromCart) {
          Navigator.popUntil(context, ModalRoute.withName('/cart'));
          return false;
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
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

                      // Store Availability Section
                      _buildStoreAvailability(),
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
        ),
        bottomNavigationBar: _buildBottomBar(),
      ),
    );
  }

  Widget _buildHeaderWithImage() {
    final images = _carouselImages;

    return Stack(
      children: [
        // PageView Carousel
        ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(24)),
          child: SizedBox(
            height: 400,
            width: double.infinity,
            child: images.isEmpty
                ? Container(
                    color: Colors.grey[100],
                    child: Center(
                      child:
                          Icon(Icons.toys, size: 100, color: Colors.grey[400]),
                    ),
                  )
                : PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) =>
                        setState(() => _currentIndex = index),
                    itemCount: images.length,
                    itemBuilder: (context, index) {
                      return Container(
                        color: Colors.grey[100],
                        child: Image.network(
                          images[index],
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Center(
                            child: Icon(Icons.toys,
                                size: 100, color: Colors.grey[400]),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ),

        // Top Action Buttons (Back & Favorite)
        Positioned(
          top: 16,
          left: 16,
          right: 16,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildCircleButton(
                icon: Icons.arrow_back,
                onTap: () {
                  if (widget.fromCart) {
                    Navigator.popUntil(context, ModalRoute.withName('/cart'));
                  } else {
                    Navigator.pop(context);
                  }
                },
              ),
              Consumer<WishlistService>(
                builder: (context, wishlistService, _) => _buildCircleButton(
                  icon: wishlistService.isWishlisted(_displayProduct.id)
                      ? Icons.favorite
                      : Icons.favorite_border,
                  onTap: () => wishlistService.toggleWishlist(_displayProduct),
                  iconColor: wishlistService.isWishlisted(_displayProduct.id)
                      ? Colors.red
                      : Colors.black87,
                ),
              ),
            ],
          ),
        ),

        // Dot Indicator at Bottom Center
        if (images.length > 1)
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                images.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentIndex == index ? 20 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _currentIndex == index
                        ? const Color(0xFFFFC107)
                        : Colors.white.withOpacity(0.55),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
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
            if (_displayProduct.originalPrice != null)
              Text(
                _currencyFormat.format(_displayProduct.originalPrice),
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

  Future<List<Map<String, dynamic>>> _fetchStoreAvailability() async {
    try {
      final response = await ApiService.get(
        '/inventory-service/api/stores/availability?productId=${_displayProduct.id}',
      );

      if (response['status'] == 200 && response['data'] != null) {
        final List<dynamic> data = response['data'] as List<dynamic>;
        return data
            .map((item) => {
                  'storeId': item['storeId'] as int?,
                  'storeName': item['storeName'] as String? ?? 'Unknown Store',
                  'address': item['address'] as String? ?? 'No address',
                  'availableQuantity': item['availableQuantity'] as int? ?? 0,
                })
            .toList();
      }
      return [];
    } catch (e) {
      debugPrint('Fetch store availability error: $e');
      return [];
    }
  }

  Widget _buildStoreAvailability() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Có sẵn tại cửa hàng',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2C3E50),
          ),
        ),
        const SizedBox(height: 12),
        FutureBuilder<List<Map<String, dynamic>>>(
          future: _fetchStoreAvailability(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 24.0),
                  child: CircularProgressIndicator(),
                ),
              );
            }

            if (snapshot.hasError) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.red.shade200,
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: Colors.red.shade400,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Không thể tải thông tin cửa hàng',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.red.shade700,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }

            final stores = snapshot.data ?? [];

            if (stores.isEmpty) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.orange.shade200,
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Colors.orange.shade600,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Hiện tại không có cửa hàng nào có sản phẩm này',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.orange.shade700,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }

            return Column(
              children: stores
                  .asMap()
                  .entries
                  .map(
                    (entry) => Padding(
                      padding: EdgeInsets.only(
                        bottom: entry.key < stores.length - 1 ? 12 : 0,
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 16,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.grey.shade200,
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            // Left Icon
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: const Color(0xFFE8F4F8),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.storefront,
                                color: Color(0xFF1976D2),
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 16),
                            // Middle - Store Info
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    entry.value['storeName'] as String,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    entry.value['address'] as String,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey.shade600,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            // Right - Stock Status
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.check_circle_outline,
                                      color:
                                          entry.value['availableQuantity'] >= 2
                                              ? Colors.green
                                              : Colors.orange,
                                      size: 18,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      'Còn ${entry.value['availableQuantity']} đơn vị',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color:
                                            entry.value['availableQuantity'] >=
                                                    2
                                                ? Colors.green
                                                : Colors.orange,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                  .toList(),
            );
          },
        ),
      ],
    );
  }

  Widget _buildGallery() {
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
          child: _isLoadingImages
              ? const Center(child: CircularProgressIndicator())
              : _galleryImages.isEmpty
                  ? Center(
                      child: Text(
                        'No images available',
                        style: TextStyle(color: Colors.grey[500], fontSize: 13),
                      ),
                    )
                  : ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _galleryImages.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.only(
                              right:
                                  index < _galleryImages.length - 1 ? 12 : 0),
                          child: GestureDetector(
                            onTap: () => _showFullImage(_galleryImages[index]),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Container(
                                width: 100,
                                height: 100,
                                color: Colors.grey[200],
                                child: Image.network(
                                  _galleryImages[index],
                                  fit: BoxFit.cover,
                                  loadingBuilder: (context, child, progress) {
                                    if (progress == null) return child;
                                    return const Center(
                                        child: CircularProgressIndicator(
                                            strokeWidth: 2));
                                  },
                                  errorBuilder: (context, error, stackTrace) {
                                    return Center(
                                      child: Icon(Icons.broken_image,
                                          color: Colors.grey[400]),
                                    );
                                  },
                                ),
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

  void _showFullImage(String imageUrl) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.black,
        insetPadding: EdgeInsets.zero,
        child: Stack(
          children: [
            InteractiveViewer(
              child: Image.network(
                imageUrl,
                fit: BoxFit.contain,
                width: double.infinity,
                height: double.infinity,
                errorBuilder: (context, error, stackTrace) => const Center(
                  child:
                      Icon(Icons.broken_image, color: Colors.white, size: 64),
                ),
              ),
            ),
            Positioned(
              top: 40,
              right: 16,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close, color: Colors.white, size: 24),
                ),
              ),
            ),
          ],
        ),
      ),
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
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => CustomerReviewsScreen()),
                );
              },
              child: Text(
                'View all',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.blue[600],
                  fontWeight: FontWeight.w600,
                ),
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
            Consumer<WishlistService>(
              builder: (context, wishlistService, _) => Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: IconButton(
                  icon: Icon(
                    wishlistService.isWishlisted(_displayProduct.id)
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: wishlistService.isWishlisted(_displayProduct.id)
                        ? Colors.red
                        : Colors.black87,
                  ),
                  onPressed: () =>
                      wishlistService.toggleWishlist(_displayProduct),
                ),
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
