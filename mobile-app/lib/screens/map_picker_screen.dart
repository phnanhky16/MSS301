import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

class MapPickerScreen extends StatefulWidget {
  const MapPickerScreen({Key? key}) : super(key: key);

  @override
  State<MapPickerScreen> createState() => _MapPickerScreenState();
}

class _MapPickerScreenState extends State<MapPickerScreen> {
  LatLng _selectedPosition = const LatLng(10.762622, 106.660172); // Default Ho Chi Minh City
  final MapController _mapController = MapController();
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = false;
  bool _isMapReady = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _fetchCurrentLocation();
  }

  Future<void> _fetchCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Dịch vụ vị trí đang tắt. Vui lòng bật GPS.'))
          );
        }
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Quyền truy cập vị trí bị từ chối.'))
            );
          }
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Quyền vị trí bị từ chối vĩnh viễn. Vui lòng cấp quyền trong Cài đặt.'))
          );
        }
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final newPosition = LatLng(position.latitude, position.longitude);
      if (mounted) {
        setState(() {
          _selectedPosition = newPosition;
        });
      }

      if (_isMapReady) {
        _mapController.move(newPosition, 15.0);
      }
    } catch (e) {
      debugPrint('Error getting location: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Không thể lấy vị trí hiện tại: $e'))
        );
      }
    }
  }

  Future<void> _searchAddress(String query) async {
    if (query.trim().isEmpty) return;

    FocusScope.of(context).unfocus(); // Ẩn bàn phím
    setState(() => _isLoading = true);

    try {
      final url = Uri.parse(
          'https://nominatim.openstreetmap.org/search?format=json&q=${Uri.encodeComponent(query)}&limit=1&countrycodes=vn');
      final response = await http.get(url, headers: {
        'User-Agent': 'KidFavorMobileApp/1.0',
        'Accept-Language': 'vi-VN,vi;q=0.9,en-US;q=0.8,en;q=0.7',
      });

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
        if (data.isNotEmpty) {
          final firstResult = data.first;
          final lat = double.parse(firstResult['lat'].toString());
          final lon = double.parse(firstResult['lon'].toString());
          final newPosition = LatLng(lat, lon);

          if (mounted) {
            setState(() {
              _selectedPosition = newPosition;
            });
            if (_isMapReady) {
              _mapController.move(newPosition, 15.0);
            }
          }
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Không tìm thấy địa chỉ này.')),
            );
          }
        }
      }
    } catch (e) {
      debugPrint('Error searching address from OSM: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Lỗi khi tìm kiếm địa chỉ.')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _onTap(TapPosition tapPosition, LatLng position) {
    setState(() {
      _selectedPosition = position;
    });
  }

  Future<void> _confirmLocation() async {
    setState(() => _isLoading = true);
    try {
      // Gọi API BigDataCloud để bổ trợ thông tin Tỉnh/Thành phố chuẩn xác, vì OSM Nominatim đang bị lỗi dữ liệu gộp Bình Dương vào TP.HCM
      String exactCity = '';
      String exactDistrict = '';
      try {
        final bdcUrl = Uri.parse(
            'https://api.bigdatacloud.net/data/reverse-geocode-client?latitude=${_selectedPosition.latitude}&longitude=${_selectedPosition.longitude}&localityLanguage=vi');
        final bdcResponse = await http.get(bdcUrl).timeout(const Duration(seconds: 3));
        if (bdcResponse.statusCode == 200) {
          final bdcData = json.decode(utf8.decode(bdcResponse.bodyBytes));
          exactCity = bdcData['principalSubdivision'] ?? '';
          exactDistrict = bdcData['locality'] ?? '';
        }
      } catch (e) {
        debugPrint('Error getting exact city from BigDataCloud: $e');
      }

      final url = Uri.parse(
          'https://nominatim.openstreetmap.org/reverse?format=json&lat=${_selectedPosition.latitude}&lon=${_selectedPosition.longitude}&addressdetails=1');
      final response = await http.get(url, headers: {
        'User-Agent': 'KidFavorMobileApp/1.0',
        'Accept-Language': 'vi-VN,vi;q=0.9,en-US;q=0.8,en;q=0.7',
      });

      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));
        final address = data['address'] as Map<String, dynamic>?;
        
        if (address != null) {
          String street = address['road'] ?? address['pedestrian'] ?? address['neighbourhood'] ?? '';
          
          final displayName = data['display_name'] as String? ?? '';
          final List<String> parts = displayName.split(', ').map((e) => e.trim()).toList();
          
          if (parts.isNotEmpty && parts.last.toLowerCase().contains('việt nam')) {
            parts.removeLast();
          }
          if (parts.isNotEmpty && RegExp(r'^\d+$').hasMatch(parts.last)) {
            parts.removeLast();
          }
          
          String city = '';
          if (parts.isNotEmpty) {
            city = parts.removeLast(); 
          }
          
          String district = address['county'] ?? address['city_district'] ?? address['town'] ?? '';
          if (district.isEmpty && address['city'] != null && address['city'] != city) {
             district = address['city'];
          }
          
          String ward = address['suburb'] ?? address['village'] ?? address['quarter'] ?? '';
          
          if (district.isEmpty && parts.isNotEmpty) {
             district = parts.removeLast();
          }
          if (ward.isEmpty && parts.isNotEmpty) {
             ward = parts.removeLast();
          }
          
          if (city == district) {
             district = ward;
             ward = address['suburb'] ?? '';
          }
          if (district == ward && ward.isNotEmpty) {
             ward = address['suburb'] ?? '';
             if (ward == district) ward = ''; 
          }
          
          if (city.isEmpty) {
             city = address['state'] ?? address['province'] ?? address['city'] ?? '';
          }
          
          if (city == 'Thủ Đức' && address['ISO3166-2-lvl4'] == 'VN-SG') {
             city = 'Thành phố Hồ Chí Minh';
             district = 'Thủ Đức';
          }
          
          // Ưu tiên sử dụng Tỉnh/Thành phố từ BigDataCloud nếu có để khắc phục lỗi dữ liệu của OSM (Bình Dương bị gộp)
          if (exactCity.isNotEmpty) {
             if (exactCity.contains('Hồ Chí Minh')) {
                 city = 'Thành phố Hồ Chí Minh';
             } else {
                 city = exactCity; 
             }
          }
          
          if (exactDistrict.isNotEmpty && exactDistrict != city) {
             // Nếu OSM trả về district là Thủ Đức (bị sai do lỗi dữ liệu) hoặc trống, ghi đè bằng chính xác
             if (district == 'Thủ Đức' && exactDistrict != 'Thủ Đức' && !city.contains('Hồ Chí Minh')) {
                 district = exactDistrict;
             } else if (district.isEmpty || district == city) {
                 district = exactDistrict;
             } else if (city != 'Thành phố Hồ Chí Minh') {
                 // Với các tỉnh khác bị lỗi, ưu tiên huyện chính xác
                 if (!district.toLowerCase().contains(exactDistrict.toLowerCase())) {
                     // Nếu OSM bị lệch hẳn so với BDC
                     district = exactDistrict;
                 }
             }
          }

          if (mounted) {
            Navigator.pop(context, {
              'street': street,
              'ward': ward,
              'district': district,
              'city': city,
            });
          }
          return;
        }
      }
    } catch (e) {
      debugPrint('Error getting address from OSM: $e');
    }
    
    if (mounted) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không thể lấy chi tiết địa chỉ, vui lòng thử lại hoặc ghim khu vực khác.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chọn vị trí', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _selectedPosition,
              initialZoom: 15.0,
              onTap: _onTap,
              onMapReady: () {
                _isMapReady = true;
                _mapController.move(_selectedPosition, 15.0);
              },
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.kidfavor.mobile',
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: _selectedPosition,
                    width: 80,
                    height: 80,
                    child: const Icon(
                      Icons.location_on,
                      color: Colors.red,
                      size: 40,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Positioned(
            top: 20,
            left: 20,
            right: 20,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                textInputAction: TextInputAction.search,
                onSubmitted: _searchAddress,
                decoration: InputDecoration(
                  hintText: 'Tìm kiếm địa chỉ...',
                  border: InputBorder.none,
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  contentPadding: const EdgeInsets.symmetric(vertical: 15),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear, color: Colors.grey),
                    onPressed: () {
                      _searchController.clear();
                      FocusScope.of(context).unfocus();
                    },
                  ),
                ),
              ),
            ),
          ),
          if (_isLoading)
            const Center(child: CircularProgressIndicator()),
          Positioned(
            bottom: 100,
            right: 20,
            child: Column(
              children: [
                FloatingActionButton(
                  heroTag: 'my_location',
                  mini: true,
                  backgroundColor: Colors.white,
                  onPressed: _fetchCurrentLocation,
                  child: const Icon(Icons.my_location, color: Colors.blue),
                ),
                const SizedBox(height: 8),
                FloatingActionButton(
                  heroTag: 'zoom_in',
                  mini: true,
                  backgroundColor: Colors.white,
                  onPressed: () {
                    final zoom = _mapController.camera.zoom + 1.0;
                    _mapController.move(_mapController.camera.center, zoom);
                  },
                  child: const Icon(Icons.add, color: Colors.black87),
                ),
                const SizedBox(height: 8),
                FloatingActionButton(
                  heroTag: 'zoom_out',
                  mini: true,
                  backgroundColor: Colors.white,
                  onPressed: () {
                    final zoom = _mapController.camera.zoom - 1.0;
                    _mapController.move(_mapController.camera.center, zoom);
                  },
                  child: const Icon(Icons.remove, color: Colors.black87),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 30,
            left: 20,
            right: 20,
            child: ElevatedButton.icon(
              onPressed: _isLoading ? null : _confirmLocation,
              icon: const Icon(Icons.check_circle_outline, color: Colors.white),
              label: const Text(
                'Xác nhận vị trí',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0db9f2),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
