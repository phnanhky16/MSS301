import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../services/api_service.dart';

const Color kPrimaryColor = Color(0xFF0db9f2);
const Color kPrimaryDark = Color(0xFF0096cc);

class BankTransferScreen extends StatefulWidget {
  final double amount;
  final String orderNumber;

  const BankTransferScreen({
    Key? key,
    required this.amount,
    required this.orderNumber,
  }) : super(key: key);

  @override
  State<BankTransferScreen> createState() => _BankTransferScreenState();
}

class _BankTransferScreenState extends State<BankTransferScreen> {
  bool _isLoading = true;
  String? _error;

  String _bin = '';
  String _accountName = '';
  String _accountNumber = '';
  String _content = '';
  String? _qrImageUrl;

  @override
  void initState() {
    super.initState();
    _createPaymentLink();
  }

  Future<void> _createPaymentLink() async {
    try {
      final res = await ApiService.post('/payment-service/api/payments/create?orderNumber=${widget.orderNumber}', {});
      final data = res['data'] ?? res;
      setState(() {
        final qrCodeString = data['qrCode']?.toString();
        _content = data['orderCode']?.toString() ?? widget.orderNumber;
        _accountName = data['accountName']?.toString() ?? 'KIDFAVOR SHOP'; // PayOS doesn't return this so default it
        
        if (qrCodeString != null && qrCodeString.isNotEmpty) {
          _parseVietQR(qrCodeString);
        } else {
          _bin = data['bin']?.toString() ?? '970422'; // Default MB
          _accountNumber = data['accountNumber']?.toString() ?? 'N/A';
        }
        
        if (qrCodeString != null && qrCodeString.isNotEmpty) {
          final encodedQr = Uri.encodeComponent(qrCodeString);
          _qrImageUrl = 'https://api.qrserver.com/v1/create-qr-code/?size=400x400&margin=10&data=$encodedQr';
        } else if (_bin.isNotEmpty && _accountNumber.isNotEmpty && _accountNumber != 'N/A') {
          // Fallback
          final amt = widget.amount.toInt();
          final encodedName = Uri.encodeComponent(_accountName);
          final encodedInfo = Uri.encodeComponent(_content);
          _qrImageUrl = 'https://img.vietqr.io/image/$_bin/$_accountNumber-compact2.png?amount=$amt&addInfo=$encodedInfo&accountName=$encodedName';
        }
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Không thể tạo mã thanh toán: $e';
        _isLoading = false;
      });
    }
  }

  void _parseVietQR(String qrString) {
    try {
      // Lấy BIN ngân hàng từ chuẩn VietQR (0006 tiếp theo 6 chữ số)
      final binMatch = RegExp(r'0006(\d{6})').firstMatch(qrString);
      if (binMatch != null) {
        _bin = binMatch.group(1)!;
      }

      // Lấy Số tài khoản từ chuẩn VietQR
      // Format: 0006<bin>01<dodai><sotk>02
      // Ví dụ: 00069704220113VQRQAHVZW136402
      final accMatch = RegExp(r'0006\d{6}01(\d{2})(.+?)02').firstMatch(qrString);
      if (accMatch != null) {
        int length = int.parse(accMatch.group(1)!);
        // Lấy chính xác chuỗi STK
        String val = accMatch.group(2)!;
        if (val.length >= length) {
           _accountNumber = val.substring(0, length);
        } else {
           _accountNumber = val;
        }
      } else {
        // Fallback định dạng không có thẻ 02
        final fallbackMatch = RegExp(r'0006\d{6}01(\d{2})(.+)').firstMatch(qrString);
        if (fallbackMatch != null) {
          int length = int.parse(fallbackMatch.group(1)!);
          String val = fallbackMatch.group(2)!;
          if (val.length >= length) {
             _accountNumber = val.substring(0, length);
          }
        }
      }
    } catch (e) {
      debugPrint('Parse VietQR error: $e');
    }
  }

  void _copyToClipboard(BuildContext context, String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Đã sao chép $label'),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final formatCurrency = NumberFormat.currency(locale: 'vi_VN', symbol: 'VND');

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Thanh toán đơn hàng', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: Colors.grey.shade100, height: 1),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: kPrimaryColor))
          : _error != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, color: Colors.red, size: 60),
                        const SizedBox(height: 16),
                        Text(_error!, textAlign: TextAlign.center, style: const TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                )
              : Stack(
                  children: [
                    SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(20, 24, 20, 160),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            'Vui lòng chuyển khoản theo thông tin bên dưới để hoàn tất đơn hàng. Đơn hàng sẽ tự động hủy sau 15 phút nếu chưa thanh toán.',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 14, color: Color(0xFF4B5563), height: 1.5, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 24),
                          
                          // QR Code Block
                          Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 20, offset: const Offset(0, 10)),
                              ],
                            ),
                            child: Column(
                              children: [
                                Container(
                                  width: 200,
                                  height: 200,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: _qrImageUrl != null
                                      ? ClipRRect(
                                          borderRadius: BorderRadius.circular(16),
                                          child: Image.network(
                                            _qrImageUrl!,
                                            fit: BoxFit.cover,
                                            errorBuilder: (ctx, err, stack) => const Icon(Icons.qr_code_2, size: 100, color: Colors.black87),
                                          ),
                                        )
                                      : const Icon(Icons.qr_code_2, size: 100, color: Colors.black87),
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  'Quét mã qua app Ngân hàng/MoMo',
                                  style: TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                          
                          const SizedBox(height: 32),
                          
                          // Bank Info Card
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.grey.shade200, width: 1.5),
                            ),
                            child: Column(
                              children: [
                                _buildInfoRow(context, 'Ngân hàng', _bin, false),
                                const Divider(height: 1),
                                _buildInfoRow(context, 'Chủ tài khoản', _accountName.toUpperCase(), false),
                                const Divider(height: 1),
                                _buildInfoRow(context, 'Số tài khoản', _accountNumber, true, isBold: true, label: 'Số tài khoản'),
                                const Divider(height: 1),
                                _buildInfoRow(context, 'Số tiền', formatCurrency.format(widget.amount), true, isBold: true, color: kPrimaryColor, label: 'Số tiền'),
                                const Divider(height: 1),
                                _buildInfoRow(context, 'Nội dung', _content, true, isBold: true, label: 'Nội dung'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Bottom Action Bar
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))],
                        ),
                        child: SafeArea(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: double.infinity,
                                height: 56,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(colors: [kPrimaryColor, kPrimaryDark]),
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [BoxShadow(color: kPrimaryColor.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 8))],
                                ),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).popUntil((route) => route.isFirst);
                                  },
                                  child: const Text('TÔI ĐÃ CHUYỂN KHOẢN', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 0.5)),
                                ),
                              ),
                              const SizedBox(height: 12),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).popUntil((route) => route.isFirst);
                                },
                                child: const Text('Hủy giao dịch', style: TextStyle(color: Colors.redAccent, fontSize: 15, fontWeight: FontWeight.w600)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String title, String value, bool hasCopy, {bool isBold = false, Color color = Colors.black, String label = ''}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 2,
            child: Text(title, style: const TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.w500)),
          ),
          Expanded(
            flex: 3,
            child: Row(
              mainAxisAlignment: hasCopy ? MainAxisAlignment.spaceBetween : MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    value,
                    textAlign: TextAlign.right,
                    style: TextStyle(fontSize: isBold ? 16 : 14, fontWeight: isBold ? FontWeight.bold : FontWeight.w600, color: color),
                  ),
                ),
                if (hasCopy) ...[
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: () => _copyToClipboard(context, value, label),
                    child: const Icon(Icons.copy, color: kPrimaryColor, size: 20),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
