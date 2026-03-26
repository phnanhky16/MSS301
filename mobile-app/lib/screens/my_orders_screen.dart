import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/order.dart';
import '../services/order_service.dart';

// --- BẢNG MÀU TÙY CHỈNH ---
const Color kPrimaryColor = Color(0xFF0db9f2);
const Color kBgLight = Color(0xFFF5F8F8);
const Color kTextDark = Color(0xFF0F172A); // slate-900
const Color kTextLight = Color(0xFF64748B); // slate-500

class MyOrdersScreen extends StatefulWidget {
  const MyOrdersScreen({Key? key}) : super(key: key);

  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
  int _selectedFilterIndex = 0;
  final List<String> _filters = [
    'All',
    'Pending',
    'Processing',
    'In Transit',
    'Delivered',
    'Cancelled'
  ];

  final _currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');

  // Status color mappings based on actual order statuses
  static const Map<String, Color> _statusColors = {
    'PENDING': Color(0xFFF59E0B),
    'CONFIRMED': Color(0xFF3B82F6),
    'PROCESSING': Color(0xFF8B5CF6),
    'SHIPPED': Color(0xFF06B6D4),
    'DELIVERED': Color(0xFF10B981),
    'CANCELLED': Color(0xFFEF4444),
    'REFUNDED': Color(0xFF6366F1),
  };

  static const Map<String, IconData> _statusIcons = {
    'PENDING': Icons.hourglass_empty_rounded,
    'CONFIRMED': Icons.check_circle_outline_rounded,
    'PROCESSING': Icons.inventory_2_outlined,
    'SHIPPED': Icons.local_shipping_outlined,
    'DELIVERED': Icons.check_circle_rounded,
    'CANCELLED': Icons.cancel_rounded,
    'REFUNDED': Icons.undo_rounded,
  };

  static const Map<String, Color> _statusBgColors = {
    'PENDING': Color(0xFFFEF3C7),
    'CONFIRMED': Color(0xFFDBEAFE),
    'PROCESSING': Color(0xFFEDE9FE),
    'SHIPPED': Color(0xFFCFFAFE),
    'DELIVERED': Color(0xFFD1FAE5),
    'CANCELLED': Color(0xFFFEE2E2),
    'REFUNDED': Color(0xFFE0E7FF),
  };

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<OrderService>(context, listen: false).fetchOrders();
    });
  }

  List<Order> _filteredOrders(List<Order> orders, String filterTab) {
    if (filterTab == 'All') return orders;

    if (filterTab == 'Pending') {
      return orders.where((o) => o.status == 'PENDING').toList();
    } else if (filterTab == 'Processing') {
      return orders.where((o) => o.status == 'PROCESSING').toList();
    } else if (filterTab == 'In Transit') {
      return orders.where((o) => o.status == 'SHIPPED').toList();
    } else if (filterTab == 'Delivered') {
      return orders.where((o) => o.status == 'DELIVERED').toList();
    } else if (filterTab == 'Cancelled') {
      return orders.where((o) => o.status == 'CANCELLED').toList();
    }
    return orders;
  }

  String _getStatusDisplayName(String status) {
    switch (status.toUpperCase()) {
      case 'PENDING':
        return 'Pending';
      case 'CONFIRMED':
        return 'Confirmed';
      case 'PROCESSING':
        return 'Processing';
      case 'SHIPPED':
        return 'In Transit';
      case 'DELIVERED':
        return 'Delivered';
      case 'CANCELLED':
        return 'Cancelled';
      case 'REFUNDED':
        return 'Refunded';
      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildSearchBar(),
          _buildFilterTabs(),
          Expanded(
            child: Consumer<OrderService>(
              builder: (context, orderService, _) {
                final filteredOrders = _filteredOrders(
                    orderService.orders, _filters[_selectedFilterIndex]);

                if (filteredOrders.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.shopping_bag_outlined,
                            size: 64, color: Colors.grey.shade300),
                        const SizedBox(height: 16),
                        Text(
                          'No orders found',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  );
                }

                return Container(
                  color: Colors.grey.shade50,
                  child: ListView(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 24),
                    physics: const BouncingScrollPhysics(),
                    children: [
                      ...filteredOrders.map((order) {
                        final firstItem =
                            order.items.isNotEmpty ? order.items.first : null;
                        final statusUpperCase = order.status.toUpperCase();
                        final statusColor =
                            _statusColors[statusUpperCase] ?? kPrimaryColor;
                        final statusBgColor =
                            _statusBgColors[statusUpperCase] ??
                                Colors.grey.shade100;
                        final statusIcon = _statusIcons[statusUpperCase] ??
                            Icons.help_outline_rounded;

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: _buildOrderCard(
                            orderId: 'Order #${order.id}',
                            date: _formatDate(order.createdAt),
                            title: firstItem?.productName ?? 'Order Items',
                            subtitle:
                                '${order.totalItems} item${order.totalItems > 1 ? 's' : ''}',
                            price: _currencyFormat.format(order.totalAmount),
                            status: _getStatusDisplayName(order.status),
                            statusColor: statusColor,
                            statusBgColor: statusBgColor,
                            statusIcon: statusIcon,
                            imageBgColor: Colors.indigo.shade50,
                            imageUrl: firstItem?.productImageUrl ?? '',
                            buttons: _buildOrderButtons(order),
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final orderDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

    if (orderDate == today) {
      return 'Today, ${TimeOfDay.fromDateTime(dateTime).format(context)}';
    } else if (orderDate == yesterday) {
      return 'Yesterday';
    } else {
      return DateFormat('MMM dd, yyyy').format(dateTime);
    }
  }

  List<Widget> _buildOrderButtons(Order order) {
    final status = order.status.toUpperCase();

    if (status == 'DELIVERED') {
      return [
        _buildOutlinedButton('View Details'),
        const SizedBox(width: 12),
        _buildSolidButton('Buy Again'),
      ];
    } else if (status == 'CANCELLED' || status == 'REFUNDED') {
      return [
        _buildSolidButton('Buy Again', isExpanded: true),
      ];
    } else {
      return [
        _buildOutlinedButton('Track Order', isExpanded: true),
      ];
    }
  }

  // --- APP BAR ---
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      leading: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.transparent,
            ),
            child: const Icon(Icons.arrow_back, color: kTextDark),
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      title: const Text(
        'My Orders',
        style: TextStyle(
            color: kTextDark, fontSize: 20, fontWeight: FontWeight.bold),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(color: Colors.grey.shade100, height: 1),
      ),
    );
  }

  // --- SEARCH BAR ---
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
        ),
        child: TextField(
          decoration: InputDecoration(
            hintText: 'Search orders or ID',
            hintStyle: TextStyle(
                color: Colors.grey.shade400, fontWeight: FontWeight.w500),
            prefixIcon: Icon(Icons.search, color: Colors.grey.shade400),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 14),
          ),
        ),
      ),
    );
  }

  // --- FILTER TABS ---
  Widget _buildFilterTabs() {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        scrollDirection: Axis.horizontal,
        itemCount: _filters.length,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final isSelected = _selectedFilterIndex == index;
          return GestureDetector(
            onTap: () => setState(() => _selectedFilterIndex = index),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected ? kTextDark : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(30),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                            color: Colors.grey.shade300,
                            blurRadius: 8,
                            offset: const Offset(0, 4))
                      ]
                    : [],
              ),
              child: Text(
                _filters[index],
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.grey.shade600,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // --- ORDER CARD ---
  Widget _buildOrderCard({
    required String orderId,
    required String date,
    required String title,
    required String subtitle,
    required String price,
    required String status,
    required Color statusColor,
    required Color statusBgColor,
    required IconData statusIcon,
    required Color imageBgColor,
    required String imageUrl,
    required List<Widget> buttons,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: kPrimaryColor.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                orderId.toUpperCase(),
                style: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5),
              ),
              Text(
                date,
                style: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: 12,
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(height: 1, color: Color(0xFFF1F5F9)),
          ),
          // Content
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product image
              Container(
                width: 80,
                height: 80,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: imageBgColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: imageUrl.isNotEmpty
                    ? Image.network(
                        imageUrl,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.toys, color: Colors.grey),
                      )
                    : const Icon(Icons.toys, color: Colors.grey),
              ),
              const SizedBox(width: 16),
              // Product info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: kTextDark),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                          fontSize: 14,
                          color: kTextLight,
                          fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          price,
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: kTextDark),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: kPrimaryColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              Icon(statusIcon, color: Colors.white, size: 14),
                              const SizedBox(width: 4),
                              Text(
                                status,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Buttons
          Row(
            children: buttons
                .map((btn) => btn is Expanded ? btn : Expanded(child: btn))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildOutlinedButton(String text, {bool isExpanded = false}) {
    Widget button = OutlinedButton(
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 12),
        side: BorderSide(color: Colors.grey.shade200),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      onPressed: () {},
      child: Text(text,
          style: TextStyle(
              color: Colors.grey.shade700, fontWeight: FontWeight.bold)),
    );
    return isExpanded ? Expanded(child: button) : button;
  }

  Widget _buildSolidButton(String text, {bool isExpanded = false}) {
    Widget button = ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: kPrimaryColor,
        elevation: 4,
        shadowColor: kPrimaryColor.withOpacity(0.4),
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      onPressed: () {},
      child: Text(text,
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold)),
    );
    return isExpanded ? Expanded(child: button) : button;
  }
}
