import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../services/coupon_service.dart';
import '../services/address_service.dart';
import '../services/auth_service.dart';
import '../services/order_service.dart';
import '../models/coupon.dart';
import '../models/cart.dart';
import '../models/shipment.dart';

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

  // Order state
  bool _placingOrder = false;

  @override
  void initState() {
    super.initState();
    _couponController = TextEditingController();

    // Lấy danh sách addresses từ API
    Future.delayed(Duration.zero, () {
      try {
        final authService = Provider.of<AuthService>(context, listen: false);
        final addressService =
            Provider.of<AddressService>(context, listen: false);

        final userId = authService.currentUser?.id;
        print('[CheckoutScreen] Current userId: $userId');

        if (userId != null && userId > 0) {
          addressService.fetchByUser(userId);
        } else {
          print(
              '[CheckoutScreen] UserId is null or invalid, using default userId: 1');
          addressService.fetchByUser(1);
        }
      } catch (e) {
        print('[CheckoutScreen] Error loading addresses: $e');
        // Fallback to userId 1
        Provider.of<AddressService>(context, listen: false).fetchByUser(1);
      }
    });
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

  Future<void> _placeOrder() async {
    // Validate required fields
    final authService = Provider.of<AuthService>(context, listen: false);
    final addressService = Provider.of<AddressService>(context, listen: false);
    final orderService = Provider.of<OrderService>(context, listen: false);

    if (authService.currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng đăng nhập để tiếp tục'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (addressService.selectedShipment == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng chọn địa chỉ giao hàng'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (widget.cartItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Giỏ hàng của bạn trống'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _placingOrder = true;
    });

    try {
      // Prepare order items
      final items = widget.cartItems
          .where((item) => item.product != null)
          .map((item) => {
                'productId': item.productId,
                'quantity': item.quantity,
              })
          .toList();

      // Create order (coupon will be checked but discount is only applied after order is accepted)
      final order = await orderService.createOrder(
        userId: authService.currentUser!.id,
        items: items,
        shippingAddressId: addressService.selectedShipment!.shipId,
        paymentMethod:
            _selectedPaymentMethod == 0 ? 'ONLINE_PAYMENT' : 'CASH_ON_DELIVERY',
        couponCode: _appliedCoupon?.code,
      );

      if (order != null) {
        // Order created successfully
        // Note: Coupon discount and inventory deduction only apply after order is accepted by admin
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Đặt hàng thành công! Chờ xác nhận từ quản lý...'),
            backgroundColor: Colors.green,
          ),
        );

        // Navigate back or to order detail
        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) {
            Navigator.pop(context);
            Navigator.pop(context); // Back to cart screen
          }
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi: ${orderService.error ?? 'Đặt hàng thất bại'}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lỗi: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _placingOrder = false;
        });
      }
    }
  }

  double get _subtotal => widget.cartTotal;
  double get _discount =>
      _appliedCoupon?.calculateDiscount(widget.cartTotal) ?? 0;
  double get _total => widget.cartTotal - _discount;

  // Show address selector (list of saved addresses)
  void _showAddressSelector() {
    final addressService = Provider.of<AddressService>(context, listen: false);

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
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Drag handle
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
                      color: kTextDark,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  if (svc.isLoading)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: CircularProgressIndicator(color: kPrimaryColor),
                    )
                  else if (svc.shipments.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Column(
                        children: [
                          Text(
                            'Chưa có địa chỉ nào',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 15,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: () {
                              Navigator.pop(ctx);
                              _showAddressForm();
                            },
                            icon: const Icon(Icons.add, size: 20),
                            label: const Text('Thêm địa chỉ mới'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: kPrimaryColor,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 10,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    Flexible(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: svc.shipments.length,
                        itemBuilder: (_, index) {
                          final shipment = svc.shipments[index];
                          final isSelected = svc.selectedId == shipment.shipId;
                          return ListTile(
                            leading: Icon(
                              isSelected
                                  ? Icons.check_circle
                                  : Icons.location_on_outlined,
                              color:
                                  isSelected ? kPrimaryColor : Colors.grey[500],
                            ),
                            title: Text(
                              (shipment.note?.isEmpty ?? true)
                                  ? 'Địa chỉ'
                                  : shipment.note!,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: kTextDark,
                              ),
                            ),
                            subtitle: Text(
                              '${shipment.street}, ${shipment.ward}, ${shipment.district}, ${shipment.city}',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: Colors.grey[600], fontSize: 12),
                            ),
                            trailing: PopupMenuButton(
                              itemBuilder: (ctx) => [
                                PopupMenuItem(
                                  onTap: () {
                                    Navigator.pop(ctx);
                                    _showAddressForm(existing: shipment);
                                  },
                                  child: const Row(
                                    children: [
                                      Icon(Icons.edit,
                                          size: 18, color: kPrimaryColor),
                                      SizedBox(width: 8),
                                      Text('Sửa'),
                                    ],
                                  ),
                                ),
                                PopupMenuItem(
                                  onTap: () async {
                                    Navigator.pop(ctx);
                                    final confirm = await showDialog<bool>(
                                      context: context,
                                      builder: (dialogCtx) => AlertDialog(
                                        title: const Text('Xác nhận xoá'),
                                        content: const Text(
                                            'Bạn có chắc muốn xoá địa chỉ này?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(dialogCtx, false),
                                            child: const Text('Huỷ'),
                                          ),
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(dialogCtx, true),
                                            child: const Text('Xoá',
                                                style: TextStyle(
                                                    color: Colors.red)),
                                          ),
                                        ],
                                      ),
                                    );
                                    if (confirm == true) {
                                      await svc.delete(shipment.shipId);
                                      if (mounted) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text('Đã xoá địa chỉ'),
                                            backgroundColor: kPrimaryColor,
                                          ),
                                        );
                                      }
                                    }
                                  },
                                  child: const Row(
                                    children: [
                                      Icon(Icons.delete,
                                          size: 18, color: Colors.red),
                                      SizedBox(width: 8),
                                      Text('Xoá'),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            onTap: () {
                              svc.select(shipment.shipId);
                              Navigator.pop(ctx);
                            },
                          );
                        },
                      ),
                    ),
                  const SizedBox(height: 8),
                  TextButton.icon(
                    icon: const Icon(Icons.add, color: kPrimaryColor, size: 18),
                    label: const Text(
                      'Thêm địa chỉ mới',
                      style: TextStyle(color: kPrimaryColor),
                    ),
                    onPressed: () {
                      Navigator.pop(ctx);
                      _showAddressForm();
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

  void _showAddressForm({Shipment? existing}) {
    final userId =
        Provider.of<AuthService>(context, listen: false).currentUser?.id ?? 0;
    final noteCtrl = TextEditingController(text: existing?.note ?? '');
    final streetCtrl = TextEditingController(text: existing?.street ?? '');
    final wardCtrl = TextEditingController(text: existing?.ward ?? '');
    final districtCtrl = TextEditingController(text: existing?.district ?? '');
    final cityCtrl = TextEditingController(text: existing?.city ?? '');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Drag handle
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Title
                  Text(
                    existing == null ? 'Thêm địa chỉ mới' : 'Sửa địa chỉ',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: kTextDark,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  // Input fields
                  _buildAddressInput(
                    controller: noteCtrl,
                    label: 'Tên địa chỉ',
                    hint: 'VD: Nhà riêng, Công ty, ...',
                    icon: Icons.label_outline,
                  ),
                  const SizedBox(height: 16),
                  _buildAddressInput(
                    controller: streetCtrl,
                    label: 'Số nhà / Đường',
                    icon: Icons.signpost_outlined,
                  ),
                  const SizedBox(height: 16),
                  _buildAddressInput(
                    controller: wardCtrl,
                    label: 'Phường / Xã',
                    icon: Icons.holiday_village_outlined,
                  ),
                  const SizedBox(height: 16),
                  _buildAddressInput(
                    controller: districtCtrl,
                    label: 'Quận / Huyện',
                    icon: Icons.location_city_outlined,
                  ),
                  const SizedBox(height: 16),
                  _buildAddressInput(
                    controller: cityCtrl,
                    label: 'Tỉnh / Thành phố',
                    icon: Icons.map_outlined,
                  ),
                  const SizedBox(height: 28),
                  // Save button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kPrimaryColor,
                        foregroundColor: Colors.white,
                        elevation: 4,
                        shadowColor: kPrimaryColor.withOpacity(0.4),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: () async {
                        final addressService =
                            Provider.of<AddressService>(ctx, listen: false);
                        final payload = {
                          'note': noteCtrl.text.trim(),
                          'street': streetCtrl.text.trim(),
                          'ward': wardCtrl.text.trim(),
                          'district': districtCtrl.text.trim(),
                          'city': cityCtrl.text.trim(),
                        };
                        bool ok;
                        if (existing == null) {
                          ok = await addressService
                                  .create({...payload, 'userId': userId}) !=
                              null;
                        } else {
                          ok = await addressService.update(
                                  existing.shipId, payload) !=
                              null;
                        }
                        if (ctx.mounted) {
                          Navigator.pop(ctx);
                          // Refresh address list
                          if (mounted) {
                            Provider.of<AddressService>(context, listen: false)
                                .fetchByUser(userId);
                          }
                        }
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(ok
                                ? 'Đã lưu địa chỉ'
                                : 'Lỗi! Vui lòng thử lại'),
                            backgroundColor: ok ? kPrimaryColor : Colors.red,
                          ));
                        }
                      },
                      child: const Text(
                        'Lưu địa chỉ',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Cancel button
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: Text(
                        'Hủy',
                        style: TextStyle(color: Colors.grey[500], fontSize: 15),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAddressInput({
    required TextEditingController controller,
    required String label,
    String? hint,
    required IconData icon,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: Color(0xFF0096cc)),
        filled: true,
        fillColor: Colors.grey[100],
        labelStyle: const TextStyle(color: Colors.black54),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: kPrimaryColor, width: 1.5),
        ),
      ),
    );
  }

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
        'Thanh toán',
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
    return Consumer<AddressService>(
      builder: (context, addressService, _) {
        final selectedShipment = addressService.selectedShipment;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Địa chỉ giao hàng',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: kTextDark)),
                TextButton(
                  onPressed: () => _showAddressSelector(),
                  style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(50, 30),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                  child: const Text('Thay đổi',
                      style: TextStyle(
                          color: kPrimaryColor, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (addressService.isLoading)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: kPrimaryColor.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: kPrimaryColor, width: 2),
                ),
                child: const Center(child: CircularProgressIndicator()),
              )
            else if (selectedShipment == null)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: kPrimaryColor.withOpacity(0.3),
                    width: 2,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Icon thân thiện
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: kPrimaryColor.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.add_location_alt,
                        color: kPrimaryColor,
                        size: 32,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Tiêu đề
                    const Text(
                      'Chưa có địa chỉ giao hàng',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: kTextDark,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Mô tả phụ
                    Text(
                      'Vui lòng thêm địa chỉ để chúng tôi giao đồ chơi cho bé nhé!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Nút Pill-shape "Thêm địa chỉ"
                    ElevatedButton(
                      onPressed: () => _showAddressForm(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kPrimaryColor,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 10,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        '+ Thêm địa chỉ',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            else
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: kPrimaryColor.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: kPrimaryColor, width: 2),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                          color: kPrimaryColor, shape: BoxShape.circle),
                      child: const Icon(Icons.location_on,
                          color: Colors.white, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(selectedShipment.fullAddress,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: kTextDark)),
                          const SizedBox(height: 8),
                          if (selectedShipment.note != null &&
                              selectedShipment.note!.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                'Note: ${selectedShipment.note}',
                                style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 12,
                                    fontStyle: FontStyle.italic),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }

  // --- 2. ORDER SUMMARY ---
  Widget _buildOrderSummarySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Tóm tắt đơn hàng',
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
              '${cartItem.quantity}',
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
          // --- Khối thông tin sản phẩm (Bên trái) ---
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: kTextDark),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis),
                const SizedBox(height: 6),
                Text('Số lượng: $qty',
                    style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 13,
                        fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          // --- Khoảng cách giữa 2 khối ---
          const SizedBox(width: 12),
          // --- Khối giá tiền (Bên phải) ---
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text('$price ₫',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: kTextDark)),
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
        const Text('Mã giảm giá',
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
                    hintText: 'Nhập mã giảm giá của bạn',
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
                      Text('Đã áp dụng',
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
                  child: const Text('Áp dụng',
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
        const Text('Phương thức thanh toán',
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: kTextDark)),
        const SizedBox(height: 12),
        _buildPaymentOption(
          index: 0,
          title: 'Thanh toán trực tuyến',
          icon: Icons.credit_card,
          iconBgColor: Colors.blue.shade50,
          iconColor: Colors.blue.shade600,
        ),
        const SizedBox(height: 12),
        _buildPaymentOption(
          index: 1,
          title: 'Thanh toán khi nhận hàng',
          icon: Icons.local_shipping_outlined,
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
              if (_discount > 0) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Giảm giá',
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
                const SizedBox(height: 12),
              ],
              // Total
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Tổng cộng',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: kTextDark)),
                  Text('₫${_total.toStringAsFixed(0)}',
                      style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: kPrimaryColor)),
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
                  onPressed: _placingOrder ? null : _placeOrder,
                  child: _placingOrder
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('ĐẶT HÀNG',
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
