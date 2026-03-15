import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/coupon_service.dart';
import '../models/coupon.dart';
import '../models/cart.dart';

// --- MÀU SẮC CHỦ ĐẠO ---
const Color kPrimaryColor = Color(0xFF0db9f2);
const Color kPrimaryDark = Color(0xFF0096cc);
const Color kBgLight = Color(0xFFF5F8F8);
const Color kTextDark = Color(0xFF0F172A); // slate-900

class CheckoutScreen extends StatefulWidget {
  final List<CartItem> cartItems;
  final double cartTotal;

  const CheckoutScreen({
    Key? key,
    required this.cartItems,
    required this.cartTotal,
  }) : super(key: key);

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');

  // 0: Online Payment, 1: Cash on Delivery
  int _selectedPaymentMethod = 1;

  // Coupon state
  late TextEditingController _couponController;
  Coupon? _appliedCoupon;
  bool _loadingCoupon = false;
  String? _couponError;

  @override
  void initState() {
    super.initState();
    _couponController = TextEditingController();
  }

  @override
  void dispose() {
    _couponController.dispose();
    super.dispose();
  }

  Future<void> _applyCoupon() async {
    final code = _couponController.text.trim();
    if (code.isEmpty) {
      setState(() {
        _couponError = 'Vui lòng nhập mã giảm giá';
      });
      return;
    }

    setState(() {
      _loadingCoupon = true;
      _couponError = null;
    });

    try {
      final coupon = await CouponService.getCouponByCode(code);
      if (coupon == null) {
        setState(() {
          _couponError = 'Mã giảm giá không tồn tại';
          _appliedCoupon = null;
        });
      } else if (!coupon.isUsable) {
        setState(() {
          if (coupon.isExpired) {
            _couponError = 'Mã giảm giá đã hết hạn';
          } else if (!coupon.active) {
            _couponError = 'Mã giảm giá không hoạt động';
          } else {
            _couponError = 'Mã giảm giá đã hết lượt sử dụng';
          }
          _appliedCoupon = null;
        });
      } else {
        setState(() {
          _appliedCoupon = coupon;
          _couponError = null;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Áp dụng mã "${coupon.code}" thành công'),
              backgroundColor: Colors.green,
            ),
          );
        });
      }
    } catch (e) {
      setState(() {
        _couponError = 'Lỗi: ${e.toString()}';
        _appliedCoupon = null;
      });
    } finally {
      setState(() {
        _loadingCoupon = false;
      });
    }
  }

  double get _subtotal => widget.cartTotal;
  double get _discount =>
      _appliedCoupon?.calculateDiscount(widget.cartTotal) ?? 0;
  double get _total => widget.cartTotal - _discount;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      // Dùng Stack để cố định thanh Bottom Bar ở dưới cùng
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(
                left: 20,
                right: 20,
                top: 16,
                bottom: 140), // Tránh bị BottomBar đè
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAddressSection(),
                const SizedBox(height: 24),
                _buildOrderSummarySection(),
                const SizedBox(height: 24),
                _buildCouponSection(),
                const SizedBox(height: 24),
                _buildPaymentSection(),
              ],
            ),
          ),
          _buildBottomBar(),
        ],
      ),
    );
  }

  // --- APP BAR ---
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white.withOpacity(0.9),
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        icon: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.arrow_back, color: kTextDark, size: 20),
        ),
        onPressed: () => Navigator.pop(context),
      ),
      title: const Text(
        'Checkout',
        style: TextStyle(
            color: kTextDark, fontSize: 18, fontWeight: FontWeight.bold),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(color: Colors.grey.shade100, height: 1),
      ),
    );
  }

  // --- 1. SHIPPING ADDRESS ---
  Widget _buildAddressSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Shipping Address',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: kTextDark)),
            TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(50, 30),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap),
              child: const Text('Change',
                  style: TextStyle(
                      color: kPrimaryColor, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: kPrimaryColor.withOpacity(0.05),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: kPrimaryColor, width: 2),
          ),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                        color: kPrimaryColor, shape: BoxShape.circle),
                    child:
                        const Icon(Icons.home, color: Colors.white, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Home',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: kTextDark)),
                            Icon(Icons.edit,
                                color: Colors.grey.shade400, size: 18),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '123 Toy Street, District 1\nHo Chi Minh City, Vietnam',
                          style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 14,
                              height: 1.4),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Khối chứa ảnh giả lập Bản đồ
              Container(
                width: double.infinity,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(12),
                  image: const DecorationImage(
                    image: NetworkImage(
                        'https://images.unsplash.com/photo-1524661135-423995f22d0b?ixlib=rb-4.0.3&auto=format&fit=crop&w=600&q=80'), // Ảnh map demo
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // --- 2. ORDER SUMMARY ---
  Widget _buildOrderSummarySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Order Summary',
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: kTextDark)),
        const SizedBox(height: 12),
        ...widget.cartItems.map((cartItem) {
          final product = cartItem.product;
          if (product == null) {
            return const SizedBox.shrink();
          }
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _buildOrderItem(
              product.name,
              'Qty: ${cartItem.quantity}',
              _currencyFormat.format(product.price * cartItem.quantity),
              product.imageUrl ?? '',
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildOrderItem(
      String title, String qty, String price, String imgUrl) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
              image: DecorationImage(
                  image: NetworkImage(imgUrl), fit: BoxFit.cover),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: kTextDark),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                Text(qty,
                    style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 13,
                        fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(price,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: kTextDark)),
              const Text('VND',
                  style: TextStyle(fontSize: 10, color: kTextDark)),
            ],
          ),
        ],
      ),
    );
  }

  // --- 3. COUPON CODE ---
  Widget _buildCouponSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Coupon Code',
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: kTextDark)),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
                color:
                    _couponError != null ? Colors.red : Colors.grey.shade200),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _couponController,
                  decoration: InputDecoration(
                    hintText: 'Nhập mã giảm giá',
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: Colors.grey.shade400),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                  ),
                  enabled: !_loadingCoupon,
                ),
              ),
              if (_loadingCoupon)
                SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),
                  ),
                )
              else if (_appliedCoupon != null)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: const [
                      Icon(Icons.check_circle, color: Colors.green, size: 18),
                      SizedBox(width: 4),
                      Text('Applied',
                          style: TextStyle(
                              color: Colors.green,
                              fontSize: 12,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                )
              else
                ElevatedButton(
                  onPressed: _applyCoupon,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryColor,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Apply',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                ),
            ],
          ),
        ),
        if (_couponError != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(_couponError!,
                style: const TextStyle(color: Colors.red, fontSize: 12)),
          ),
        if (_appliedCoupon != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              'Discount: ${_appliedCoupon!.discountType == 'PERCENT' ? '${_appliedCoupon!.discountValue.toStringAsFixed(0)}%' : '₫${_discount.toStringAsFixed(0)}'} saved',
              style: const TextStyle(
                  color: Colors.green,
                  fontSize: 12,
                  fontWeight: FontWeight.w600),
            ),
          ),
      ],
    );
  }

  // --- 4. PAYMENT METHOD (Chỉ 2 lựa chọn) ---
  Widget _buildPaymentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Payment Method',
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: kTextDark)),
        const SizedBox(height: 12),
        _buildPaymentOption(
          index: 0,
          title: 'Online Payment',
          icon: Icons.credit_card,
          iconBgColor: Colors.blue.shade50,
          iconColor: Colors.blue.shade600,
        ),
        const SizedBox(height: 12),
        _buildPaymentOption(
          index: 1,
          title: 'Cash on Delivery',
          icon: Icons.local_shipping_outlined, // Icon giao hàng
          iconBgColor: Colors.green.shade50,
          iconColor: Colors.green.shade500,
        ),
      ],
    );
  }

  Widget _buildPaymentOption({
    required int index,
    required String title,
    required IconData icon,
    required Color iconBgColor,
    required Color iconColor,
  }) {
    final isSelected = _selectedPaymentMethod == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPaymentMethod = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? kPrimaryColor : Colors.grey.shade200,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                      color: kPrimaryColor.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4))
                ]
              : [],
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                  color: iconBgColor, borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(title,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: kTextDark)),
            ),
            // Custom Radio Button Design
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? kPrimaryColor : Colors.transparent,
                border: Border.all(
                  color: isSelected ? kPrimaryColor : Colors.grey.shade300,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? const Center(
                      child: CircleAvatar(
                          radius: 4, backgroundColor: Colors.white))
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  // --- BOTTOM BAR ---
  Widget _buildBottomBar() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.grey.shade100)),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 20,
                offset: const Offset(0, -5)),
          ],
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Subtotal and Discount
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Subtotal',
                      style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 13,
                          fontWeight: FontWeight.w500)),
                  Text('₫${_subtotal.toStringAsFixed(0)}',
                      style:
                          TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                ],
              ),
              if (_discount > 0) ...[
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Discount',
                        style: TextStyle(
                            color: Colors.green.shade600,
                            fontSize: 13,
                            fontWeight: FontWeight.w500)),
                    Text('-₫${_discount.toStringAsFixed(0)}',
                        style: TextStyle(
                            color: Colors.green.shade600,
                            fontSize: 13,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
              const SizedBox(height: 12),
              Divider(color: Colors.grey.shade200, height: 1),
              const SizedBox(height: 12),
              // Total
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Order Total',
                          style: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 14,
                              fontWeight: FontWeight.w500)),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('${_total.toStringAsFixed(0)}',
                              style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w900,
                                  color: kTextDark)),
                          const SizedBox(width: 4),
                          const Text('VND',
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: kTextDark)),
                        ],
                      ),
                    ],
                  ),
                  const Text('FREE DELIVERY',
                      style: TextStyle(
                          color: kPrimaryColor,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.0)),
                ],
              ),
              const SizedBox(height: 16),
              // Nút Place Order Gradient
              Container(
                width: double.infinity,
                height: 56,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                      colors: [kPrimaryColor, kPrimaryDark]),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                        color: kPrimaryColor.withOpacity(0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 8)),
                  ],
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                  ),
                  onPressed: () {
                    // Logic đặt hàng ở đây
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('PLACE ORDER',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 1.0)),
                      SizedBox(width: 8),
                      Icon(Icons.chevron_right, color: Colors.white),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
