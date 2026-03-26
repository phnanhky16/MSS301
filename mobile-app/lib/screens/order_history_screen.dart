import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/order.dart';
import '../services/order_service.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen>
    with SingleTickerProviderStateMixin {
  final _currencyFormat =
      NumberFormat.currency(locale: 'vi_VN', symbol: '₫');

  late TabController _tabController;

  static const _tabs = ['All', 'Pending', 'Confirmed', 'Shipped', 'Delivered', 'Cancelled'];

  static const _statusColors = {
    'PENDING': Color(0xFFF59E0B),
    'CONFIRMED': Color(0xFF3B82F6),
    'SHIPPED': Color(0xFF8B5CF6),
    'DELIVERED': Color(0xFF10B981),
    'CANCELLED': Color(0xFFEF4444),
  };

  static const _statusIcons = {
    'PENDING': Icons.hourglass_empty_rounded,
    'CONFIRMED': Icons.check_circle_outline_rounded,
    'SHIPPED': Icons.local_shipping_outlined,
    'DELIVERED': Icons.inventory_2_outlined,
    'CANCELLED': Icons.cancel_outlined,
  };

  static const _statusBg = {
    'PENDING': Color(0xFFFEF3C7),
    'CONFIRMED': Color(0xFFDBEAFE),
    'SHIPPED': Color(0xFFEDE9FE),
    'DELIVERED': Color(0xFFD1FAE5),
    'CANCELLED': Color(0xFFFEE2E2),
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<OrderService>(context, listen: false).fetchOrders();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Order> _filteredOrders(List<Order> orders, String tab) {
    if (tab == 'All') return orders;
    return orders.where((o) => o.status == tab.toUpperCase()).toList();
  }

  Future<void> _cancelOrder(Order order) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Cancel Order',
            style: TextStyle(fontWeight: FontWeight.bold)),
        content: Text(
            'Are you sure you want to cancel Order #${order.id}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('No'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Cancel Order',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirm != true || !mounted) return;

    final ok =
        await Provider.of<OrderService>(context, listen: false)
            .cancelOrder(order.id);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(ok
              ? 'Order #${order.id} cancelled'
              : 'Failed to cancel. Please try again.'),
          backgroundColor: ok ? const Color(0xFF1EB5D9) : Colors.red,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Column(
        children: [
          _buildHeader(),
          _buildTabBar(),
          Expanded(
            child: Consumer<OrderService>(
              builder: (context, orderService, _) {
                if (orderService.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(
                        color: Color(0xFF1EB5D9)),
                  );
                }

                if (orderService.error != null &&
                    orderService.orders.isEmpty) {
                  return _buildErrorState(orderService);
                }

                return TabBarView(
                  controller: _tabController,
                  children: _tabs.map((tab) {
                    final filtered =
                        _filteredOrders(orderService.orders, tab);
                    if (filtered.isEmpty) {
                      return _buildEmptyState(tab);
                    }
                    return RefreshIndicator(
                      color: const Color(0xFF1EB5D9),
                      onRefresh: orderService.fetchOrders,
                      child: ListView.builder(
                        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                        itemCount: filtered.length,
                        itemBuilder: (context, index) =>
                            _buildOrderCard(filtered[index]),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
        child: Row(
          children: [
            // Back button
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.07),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(Icons.arrow_back,
                    size: 20, color: Color(0xFF1E293B)),
              ),
            ),

            const Expanded(
              child: Text(
                'Order History',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A1A),
                  letterSpacing: -0.5,
                ),
              ),
            ),

            // Refresh button
            Consumer<OrderService>(
              builder: (_, svc, __) => GestureDetector(
                onTap: svc.fetchOrders,
                child: Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.07),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.refresh_rounded,
                      size: 20, color: Color(0xFF1EB5D9)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        tabAlignment: TabAlignment.start,
        indicator: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF1E88E5), Color(0xFF00ACC1)],
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorPadding:
            const EdgeInsets.symmetric(horizontal: 4, vertical: 5),
        labelColor: Colors.white,
        unselectedLabelColor: const Color(0xFF64748B),
        labelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.normal,
        ),
        dividerColor: Colors.transparent,
        tabs: _tabs
            .map((t) => Tab(text: t, height: 38))
            .toList(),
      ),
    );
  }

  Widget _buildOrderCard(Order order) {
    final statusColor =
        _statusColors[order.status] ?? const Color(0xFF64748B);
    final statusBg =
        _statusBg[order.status] ?? const Color(0xFFF1F5F9);
    final statusIcon =
        _statusIcons[order.status] ?? Icons.receipt_long;
    final dateStr =
        DateFormat('dd MMM yyyy • HH:mm').format(order.createdAt);
    final canCancel =
        order.status == 'PENDING' || order.status == 'CONFIRMED';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ──────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Row(
              children: [
                // Order ID
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Order #${order.id}',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        dateStr,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF94A3B8),
                        ),
                      ),
                    ],
                  ),
                ),

                // Status chip
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusBg,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(statusIcon, size: 13, color: statusColor),
                      const SizedBox(width: 5),
                      Text(
                        _capitalize(order.status),
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: statusColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ── Divider ──────────────────────────────────────
          Divider(
              height: 1,
              color: const Color(0xFFF1F5F9),
              indent: 16,
              endIndent: 16),

          // ── Product previews ─────────────────────────────
          _buildProductPreviews(order),

          // ── Divider ──────────────────────────────────────
          Divider(
              height: 1,
              color: const Color(0xFFF1F5F9),
              indent: 16,
              endIndent: 16),

          // ── Footer ───────────────────────────────────────
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${order.totalItems} item${order.totalItems != 1 ? 's' : ''}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF94A3B8),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _currencyFormat.format(order.totalAmount),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                  ],
                ),
                const Spacer(),

                if (canCancel)
                  GestureDetector(
                    onTap: () => _cancelOrder(order),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: const Color(0xFFEF4444), width: 1.5),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFEF4444),
                        ),
                      ),
                    ),
                  ),

                if (canCancel) const SizedBox(width: 10),

                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF1E88E5), Color(0xFF00ACC1)],
                    ),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Text(
                    'View Detail',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductPreviews(Order order) {
    const maxShow = 3;
    final items = order.items.take(maxShow).toList();
    final extra = order.items.length - maxShow;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          ...items.map((item) => _buildProductThumb(item)),
          if (extra > 0)
            Container(
              width: 52,
              height: 52,
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(14),
              ),
              alignment: Alignment.center,
              child: Text(
                '+$extra',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF64748B),
                ),
              ),
            ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              items.map((i) => i.productName).join(', ') +
                  (extra > 0 ? '...' : ''),
              style: const TextStyle(
                fontSize: 11,
                color: Color(0xFF64748B),
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductThumb(OrderItem item) {
    return Container(
      width: 52,
      height: 52,
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFE0F2FE),
        borderRadius: BorderRadius.circular(14),
      ),
      clipBehavior: Clip.antiAlias,
      child: item.productImageUrl != null
          ? Image.network(
              item.productImageUrl!,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const Icon(
                Icons.toys,
                size: 26,
                color: Color(0xFFBDBDBD),
              ),
            )
          : const Icon(Icons.toys, size: 26, color: Color(0xFFBDBDBD)),
    );
  }

  Widget _buildEmptyState(String tab) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: const Color(0xFFE0F2FE),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.receipt_long_outlined,
              size: 48,
              color: Color(0xFF1EB5D9),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            tab == 'All' ? 'No orders yet' : 'No $tab orders',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            tab == 'All'
                ? 'Start shopping to see your orders here'
                : 'No orders with "$tab" status',
            style: const TextStyle(fontSize: 14, color: Color(0xFF94A3B8)),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(OrderService svc) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.wifi_off_rounded,
                size: 64, color: Color(0xFFCBD5E1)),
            const SizedBox(height: 16),
            const Text(
              'Failed to load orders',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Check your internet connection and try again.',
              style: TextStyle(fontSize: 14, color: Color(0xFF94A3B8)),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            GestureDetector(
              onTap: svc.fetchOrders,
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 32, vertical: 14),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1E88E5), Color(0xFF00ACC1)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Try Again',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _capitalize(String s) {
    if (s.isEmpty) return s;
    return s[0].toUpperCase() + s.substring(1).toLowerCase();
  }
}
