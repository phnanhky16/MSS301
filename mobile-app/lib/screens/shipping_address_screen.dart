import 'package:flutter/material.dart';

// --- BẢNG MÀU (Design System) ---
// primary blue matches other screens (1EB5D9 used widely)
const Color kfBlue = Color(0xFF1EB5D9);
// a slightly deeper variant for icons/borders
const Color kfBlueDeep = Color(0xFF27A6D1);
// lighter pastel background based on primary
const Color kfBluePastel = Color(0xFFE0F7FA);
const Color kfYellow = Color(0xFFFFB800);
const Color kfTextDark = Color(0xFF1E293B);
const Color scaffoldBg = Color(0xFFFAFAFA);
const Color neutralBorderLight = Color(0xFFEEEEEE);
const Color cardBorderUnselected = Color(0xFFE5E7EB);

class ShippingAddressScreen extends StatefulWidget {
  const ShippingAddressScreen({Key? key}) : super(key: key);

  @override
  State<ShippingAddressScreen> createState() => _ShippingAddressScreenState();
}

class _ShippingAddressScreenState extends State<ShippingAddressScreen> {
  // Biến lưu trữ ID của địa chỉ đang được chọn
  int _selectedAddressId = 1;

  // Dữ liệu mẫu (Mock Data)
  final List<Map<String, dynamic>> _addresses = [
    {
      'id': 1,
      'title': 'Home',
      'address': '123 Candy Lane\nToytown, CA 90210',
      'isDefault': true,
    },
    {
      'id': 2,
      'title': "Grandma's House",
      'address': '456 Cookie Circle\nSweetville, NY 10001',
      'isDefault': false,
    },
    {
      'id': 3,
      'title': 'Office',
      'address': '789 Work Plaza, Suite 200\nBusiness City, TX 75001',
      'isDefault': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldBg,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Shipping Addresses',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: neutralBorderLight, height: 1),
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.fromLTRB(
            24, 16, 24, 100), // Padding dưới lớn để không bị nút đè
        itemCount: _addresses.length,
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final address = _addresses[index];
          final isSelected = _selectedAddressId == address['id'];

          return _buildAddressCard(
            title: address['title'],
            address: address['address'],
            isDefault: address['isDefault'],
            isSelected: isSelected,
            onTap: () {
              setState(() {
                _selectedAddressId = address['id'];
              });
            },
          );
        },
      ),
      // Khu vực nút bấm cố định ở dưới cùng
      bottomSheet: Container(
        padding:
            const EdgeInsets.only(left: 24, right: 24, top: 16, bottom: 32),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5), // Đổ bóng hướng lên trên (upward)
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: () {
            // Xử lý thêm địa chỉ mới
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: kfBlue,
            foregroundColor: Colors.white,
            elevation: 8,
            shadowColor: kfBlue.withOpacity(0.5),
            minimumSize:
                const Size(double.infinity, 0), // Trải dài full màn hình
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add, size: 24),
              SizedBox(width: 8),
              Text(
                'Add New Address',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget hiển thị từng Thẻ địa chỉ
  Widget _buildAddressCard({
    required String title,
    required String address,
    required bool isDefault,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? kfBlue : cardBorderUnselected,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Khối Icon Location
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: isSelected ? kfBluePastel : Colors.grey[100],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    Icons.location_on,
                    color: isSelected ? kfBlueDeep : Colors.grey[400],
                    size: 26,
                  ),
                ),
                const SizedBox(width: 16),
                // Khối Text
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 8,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          if (isDefault)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: kfYellow,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                'DEFAULT',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: kfTextDark,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        address,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
                // Icon Check/Uncheck
                Icon(
                  isSelected
                      ? Icons.check_circle
                      : Icons.radio_button_unchecked,
                  color: isSelected ? kfBlue : Colors.grey[300],
                  size: 28,
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Khối nút Edit / Delete ở góc dưới
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, size: 20),
                  color: Colors.grey[400],
                  onPressed: () {
                    // Xử lý nút Edit
                  },
                ),
                if (!isDefault) // Thường địa chỉ mặc định không cho xóa trực tiếp
                  IconButton(
                    icon: const Icon(Icons.delete, size: 20),
                    color: Colors.grey[400],
                    onPressed: () {
                      // Xử lý nút Delete
                    },
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
