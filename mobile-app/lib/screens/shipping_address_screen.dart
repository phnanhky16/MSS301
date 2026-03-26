import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/address_service.dart';
import '../services/auth_service.dart';
import '../models/shipment.dart';

// --- BẢNG MÀU (Design System) ---
const Color kfBlue = Color(0xFF1EB5D9);
const Color kfBlueDeep = Color(0xFF27A6D1);
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
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userId = context.read<AuthService>().currentUser?.id;
      if (userId != null) {
        context.read<AddressService>().fetchByUser(userId);
      }
    });
  }

  void _showAddressForm({Shipment? existing}) {
    final userId = context.read<AuthService>().currentUser?.id ?? 0;
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
                  // ── Drag handle ──
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
                  // ── Tiêu đề ──
                  Text(
                    existing == null ? 'Thêm địa chỉ mới' : 'Sửa địa chỉ',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: kfTextDark,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  // ── Input fields ──
                  _inputField(
                    controller: noteCtrl,
                    label: 'Tên địa chỉ',
                    hint: 'VD: Nhà riêng, Công ty, ...',
                    icon: Icons.label_outline,
                  ),
                  const SizedBox(height: 16),
                  _inputField(
                    controller: streetCtrl,
                    label: 'Số nhà / Đường',
                    icon: Icons.signpost_outlined,
                  ),
                  const SizedBox(height: 16),
                  _inputField(
                    controller: wardCtrl,
                    label: 'Phường / Xã',
                    icon: Icons.holiday_village_outlined,
                  ),
                  const SizedBox(height: 16),
                  _inputField(
                    controller: districtCtrl,
                    label: 'Quận / Huyện',
                    icon: Icons.location_city_outlined,
                  ),
                  const SizedBox(height: 16),
                  _inputField(
                    controller: cityCtrl,
                    label: 'Tỉnh / Thành phố',
                    icon: Icons.map_outlined,
                  ),
                  const SizedBox(height: 28),
                  // ── Nút Lưu ──
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kfBlue,
                        foregroundColor: Colors.white,
                        elevation: 4,
                        shadowColor: kfBlue.withOpacity(0.4),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: () async {
                        final svc = context.read<AddressService>();
                        final payload = {
                          'note': noteCtrl.text.trim(),
                          'street': streetCtrl.text.trim(),
                          'ward': wardCtrl.text.trim(),
                          'district': districtCtrl.text.trim(),
                          'city': cityCtrl.text.trim(),
                        };
                        bool ok;
                        if (existing == null) {
                          ok = await svc
                                  .create({...payload, 'userId': userId}) !=
                              null;
                        } else {
                          ok = await svc.update(existing.shipId, payload) !=
                              null;
                        }
                        if (ctx.mounted) Navigator.pop(ctx);
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(ok
                                ? 'Đã lưu địa chỉ'
                                : 'Lỗi! Vui lòng thử lại'),
                            backgroundColor: ok ? kfBlue : Colors.red,
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
                  // ── Nút Huỷ ──
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: Text(
                        'Huỷ',
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

  Widget _inputField({
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
        prefixIcon: Icon(icon, color: kfBlueDeep),
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
          borderSide: BorderSide(color: kfBlue, width: 1.5),
        ),
      ),
    );
  }

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
      body: Consumer<AddressService>(
        builder: (context, svc, _) {
          if (svc.isLoading) {
            return const Center(
                child: CircularProgressIndicator(color: kfBlue));
          }
          if (svc.shipments.isEmpty) {
            return _buildEmptyState();
          }
          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 120),
            itemCount: svc.shipments.length,
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final shipment = svc.shipments[index];
              final isSelected = svc.selectedId == shipment.shipId;
              final isDefault = index == 0;
              return _buildAddressCard(
                shipment: shipment,
                isDefault: isDefault,
                isSelected: isSelected,
                onTap: () => svc.select(shipment.shipId),
                onEdit: () => _showAddressForm(existing: shipment),
                onDelete: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Xác nhận xoá'),
                      content: const Text('Bạn có chắc muốn xoá địa chỉ này?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx, false),
                          child: const Text('Huỷ'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(ctx, true),
                          child: const Text('Xoá',
                              style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    ),
                  );
                  if (confirm == true) {
                    await svc.delete(shipment.shipId);
                  }
                },
              );
            },
          );
        },
      ),
      bottomSheet: Container(
        padding:
            const EdgeInsets.only(left: 24, right: 24, top: 16, bottom: 32),
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
        child: ElevatedButton(
          onPressed: () => _showAddressForm(),
          style: ElevatedButton.styleFrom(
            backgroundColor: kfBlue,
            foregroundColor: Colors.white,
            elevation: 8,
            shadowColor: kfBlue.withOpacity(0.5),
            minimumSize: const Size(double.infinity, 0),
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

  Widget _buildAddressCard({
    required Shipment shipment,
    required bool isDefault,
    required bool isSelected,
    required VoidCallback onTap,
    required VoidCallback onEdit,
    required VoidCallback onDelete,
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
                            shipment.note?.isNotEmpty == true
                                ? shipment.note!
                                : shipment.city,
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
                        shipment.fullAddress,
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
                  onPressed: onEdit,
                ),
                if (!isDefault)
                  IconButton(
                    icon: const Icon(Icons.delete, size: 20),
                    color: Colors.grey[400],
                    onPressed: onDelete,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ── Hàm xây dựng Empty State khi chưa có địa chỉ nào ──
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ── Khối Hình Ảnh ──
            Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                color: const Color(0xFFDBEAFE),
                shape: BoxShape.circle,
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Icon lớp dưới (Map outline)
                  Icon(
                    Icons.map_outlined,
                    size: 70,
                    color: Colors.blue.withOpacity(0.5),
                  ),
                  // Icon lớp trên (Location pin)
                  Positioned(
                    bottom: 30,
                    right: 25,
                    child: Icon(
                      Icons.location_on,
                      size: 45,
                      color: kfBlue,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            // ── Khối Văn Bản: Tiêu Đề ──
            Text(
              'Chưa có địa chỉ nào!',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 16),
            // ── Khối Văn Bản: Mô Tả ──
            Text(
              'Hãy thêm địa chỉ giao hàng để chúng tôi có thể mang những món đồ chơi tuyệt vời đến tận cửa nhà bạn nhé.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 15,
                color: Color(0xFF64748B),
                height: 1.6,
              ),
            ),
            // ── Cân bằng khoảng không ──
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}
