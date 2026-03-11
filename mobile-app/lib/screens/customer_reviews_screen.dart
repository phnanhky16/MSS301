import 'package:flutter/material.dart';

// --- MÀU SẮC CHỦ ĐẠO ---
const Color kPrimaryColor = Color(0xFF0db9f2);
const Color kAccentYellow = Color(0xFFFFC107);
const Color kBgLight = Color(0xFFF5F8F8);

class CustomerReviewsScreen extends StatefulWidget {
  const CustomerReviewsScreen({Key? key}) : super(key: key);

  @override
  State<CustomerReviewsScreen> createState() => _CustomerReviewsScreenState();
}

class _CustomerReviewsScreenState extends State<CustomerReviewsScreen> {
  // Biến lưu trạng thái của bộ lọc
  int _selectedFilterIndex = 0;
  final List<String> _filters = ['All', 'With Photos', '5 Stars', '4 Stars'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgLight,
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            _buildRatingOverview(),
            _buildFilterChips(),
            _buildReviewList(),
            const SizedBox(height: 80), // Khoảng trống cho Bottom Nav
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
      extendBody:
          true, // Cho phép nội dung cuộn xuống dưới Bottom Nav trong suốt
    );
  }

  // --- APP BAR ---
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white.withOpacity(0.9),
      elevation: 0,
      centerTitle: false,
      titleSpacing: 0,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black87, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
      title: const Text(
        'Customer Reviews',
        style: TextStyle(
          color: Colors.black87,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // --- TỔNG QUAN ĐÁNH GIÁ (Rating Overview) ---
  Widget _buildRatingOverview() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [kPrimaryColor.withOpacity(0.05), Colors.transparent],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Khối điểm số tổng
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: kPrimaryColor.withOpacity(0.1),
                  blurRadius: 25,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              children: [
                const Text(
                  '4.8',
                  style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.w900,
                      color: Colors.black87),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(5, (index) {
                    if (index == 4)
                      return const Icon(Icons.star_half,
                          color: kAccentYellow, size: 20);
                    return const Icon(Icons.star,
                        color: kAccentYellow, size: 20);
                  }),
                ),
                const SizedBox(height: 8),
                Text(
                  '1,240 verified ratings',
                  style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade500,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          const SizedBox(width: 24),
          // Khối thanh phần trăm (Progress Bars)
          Expanded(
            child: Column(
              children: [
                _buildRatingBar('5', 0.82, '82%', kPrimaryColor),
                const SizedBox(height: 8),
                _buildRatingBar('4', 0.12, '12%', kPrimaryColor),
                const SizedBox(height: 8),
                _buildRatingBar(
                    '3', 0.04, '4%', kPrimaryColor.withOpacity(0.4)),
                const SizedBox(height: 8),
                _buildRatingBar(
                    '2', 0.01, '1%', kPrimaryColor.withOpacity(0.2)),
                const SizedBox(height: 8),
                _buildRatingBar(
                    '1', 0.01, '1%', kPrimaryColor.withOpacity(0.1)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Hàm Helper tạo thanh phần trăm
  Widget _buildRatingBar(
      String star, double percent, String percentStr, Color barColor) {
    return Row(
      children: [
        SizedBox(
          width: 16,
          child: Text(star,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: percent,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(barColor),
              minHeight: 8,
            ),
          ),
        ),
        const SizedBox(width: 12),
        SizedBox(
          width: 30,
          child: Text(
            percentStr,
            textAlign: TextAlign.right,
            style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
          ),
        ),
      ],
    );
  }

  // --- BỘ LỌC (Filter Chips) ---
  Widget _buildFilterChips() {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        scrollDirection: Axis.horizontal,
        itemCount: _filters.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final isSelected = _selectedFilterIndex == index;
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedFilterIndex = index;
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected ? kPrimaryColor : Colors.white,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: isSelected ? kPrimaryColor : Colors.grey.shade300,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                            color: kPrimaryColor.withOpacity(0.3),
                            blurRadius: 6,
                            offset: const Offset(0, 3))
                      ]
                    : [],
              ),
              child: Text(
                _filters[index],
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.grey.shade600,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // --- DANH SÁCH REVIEW ---
  Widget _buildReviewList() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          _buildReviewCard(
            initials: 'SM',
            name: 'Sarah Miller',
            date: '2 days ago',
            rating: 5,
            reviewText:
                "Amazing Lego set! My kid loves the 3D details on the dragon's wings. The instructions were very clear and the quality is top-notch as expected from ToyWorld. Fast shipping too!",
            helpfulCount: 12,
            isHelpfulClicked: true,
          ),
          const SizedBox(height: 20),
          _buildReviewCard(
            initials: 'JK',
            name: 'Jason Kent',
            date: '1 week ago',
            rating: 4,
            reviewText:
                "Great build, very solid. My son spent 3 hours straight working on this. Only minor issue was one missing sticker, but ToyWorld support was quick to resolve!",
            helpfulCount: 5,
            isHelpfulClicked: false,
          ),
        ],
      ),
    );
  }

  // Hàm Helper tạo Thẻ Review
  Widget _buildReviewCard({
    required String initials,
    required String name,
    required String date,
    required int rating,
    required String reviewText,
    required int helpfulCount,
    required bool isHelpfulClicked,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: kPrimaryColor.withOpacity(0.05),
            blurRadius: 25,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Avatar, Name, Rating
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: kPrimaryColor.withOpacity(0.2),
                    child: Text(initials,
                        style: const TextStyle(
                            color: kPrimaryColor, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(name,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14)),
                          const SizedBox(width: 4),
                          const Icon(Icons.verified_user,
                              color: kPrimaryColor, size: 14),
                        ],
                      ),
                      Text(date,
                          style: TextStyle(
                              color: Colors.grey.shade500, fontSize: 12)),
                    ],
                  ),
                ],
              ),
              Row(
                children: List.generate(5, (index) {
                  return Icon(
                    index < rating ? Icons.star : Icons.star_border,
                    color:
                        index < rating ? kAccentYellow : Colors.grey.shade300,
                    size: 16,
                  );
                }),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Nội dung Review
          Text(
            reviewText,
            style: TextStyle(
                color: Colors.grey.shade700, height: 1.5, fontSize: 14),
          ),
          const SizedBox(height: 16),
          // Footer: Helpful Button
          Container(
            padding: const EdgeInsets.only(top: 16),
            decoration: BoxDecoration(
                border: Border(top: BorderSide(color: Colors.grey.shade100))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('$helpfulCount people found this helpful',
                    style:
                        TextStyle(color: Colors.grey.shade400, fontSize: 12)),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    color: isHelpfulClicked
                        ? kPrimaryColor.withOpacity(0.05)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: isHelpfulClicked
                            ? kPrimaryColor.withOpacity(0.3)
                            : Colors.grey.shade300),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.thumb_up_alt_outlined,
                          color: isHelpfulClicked
                              ? kPrimaryColor
                              : Colors.grey.shade600,
                          size: 16),
                      const SizedBox(width: 6),
                      Text(
                        'Helpful',
                        style: TextStyle(
                          color: isHelpfulClicked
                              ? kPrimaryColor
                              : Colors.grey.shade600,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- CUSTOM BOTTOM NAVIGATION ---
  Widget _buildBottomNav() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        border: Border(top: BorderSide(color: Colors.grey.shade100)),
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildNavItem(Icons.home_outlined, 'Home', false),
            _buildNavItem(Icons.toys, 'Toys', true), // Toys đang active
            _buildNavItem(Icons.favorite_outline, 'Wishlist', false),
            _buildNavItem(Icons.shopping_cart_outlined, 'Cart', false,
                badgeCount: 3),
            _buildNavItem(Icons.person_outline, 'Profile', false),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isActive,
      {int? badgeCount}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Icon(icon,
                color: isActive ? kPrimaryColor : Colors.grey.shade400,
                size: 26),
            if (badgeCount != null)
              Positioned(
                right: -6,
                top: -4,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: kPrimaryColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: Text(
                    badgeCount.toString(),
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          label.toUpperCase(),
          style: TextStyle(
            color: isActive ? kPrimaryColor : Colors.grey.shade400,
            fontSize: 9,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}
