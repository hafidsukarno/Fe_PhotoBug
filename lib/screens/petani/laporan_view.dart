import 'package:flutter/material.dart';
import 'package:fe_photobug/screens/petani/laporan_hasil_screen.dart';
import 'package:fe_photobug/screens/auth/login_screen.dart';
import 'package:fe_photobug/services/auth_service.dart';
import 'package:fe_photobug/services/detection_service.dart';
import 'package:fe_photobug/utils/dialog_utils.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

class LaporanView extends StatefulWidget {
  final void Function(int)? onReportSubmitted;

  const LaporanView({super.key, this.onReportSubmitted});

  @override
  State<LaporanView> createState() => _LaporanViewState();
}

class _LaporanViewState extends State<LaporanView> {
  bool _hasImage = false;
  File? _selectedImageFile;
  Uint8List? _imageBytes;
  bool _isSubmitting = false;
  bool _isGettingLocation = false;
  String _locationName = '';
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _latController = TextEditingController();
  final TextEditingController _lngController = TextEditingController();
  String _selectedPhase = 'vegetatif';

  @override
  void initState() {
    super.initState();
    // Auto-get GPS on page load
    WidgetsBinding.instance.addPostFrameCallback((_) => _getGpsLocation());
  }

  @override
  void dispose() {
    _descController.dispose();
    _latController.dispose();
    _lngController.dispose();
    super.dispose();
  }

  Future<void> _getGpsLocation() async {
    setState(() => _isGettingLocation = true);
    try {
      // Check & request permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.deniedForever ||
          permission == LocationPermission.denied) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Izin lokasi ditolak. Masukkan koordinat secara manual.'),
              backgroundColor: Colors.orange,
            ),
          );
        }
        setState(() => _isGettingLocation = false);
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 15),
        ),
      );

      final lat = position.latitude;
      final lng = position.longitude;

      // Reverse geocoding via Nominatim (OpenStreetMap)
      String locationName = 'Lat: ${lat.toStringAsFixed(4)}, Lng: ${lng.toStringAsFixed(4)}';
      try {
        final uri = Uri.parse(
          'https://nominatim.openstreetmap.org/reverse?lat=$lat&lon=$lng&format=json&accept-language=id',
        );
        final geoResponse = await http.get(uri, headers: {'User-Agent': 'PhotoBug-App/1.0'});
        if (geoResponse.statusCode == 200) {
          final geoData = jsonDecode(geoResponse.body);
          final addr = geoData['address'] as Map<String, dynamic>? ?? {};
          // Build a human-readable address: village + subdistrict + city/regency
          final parts = <String>[];
          final village = addr['village'] ?? addr['hamlet'] ?? addr['neighbourhood'] ?? addr['suburb'] ?? '';
          final subdistrict = addr['subdistrict'] ?? addr['suburb'] ?? addr['town'] ?? '';
          final city = addr['city'] ?? addr['regency'] ?? addr['county'] ?? addr['state_district'] ?? '';
          final state = addr['state'] ?? '';
          if (village.toString().isNotEmpty) parts.add(village.toString());
          if (subdistrict.toString().isNotEmpty && subdistrict != village) parts.add(subdistrict.toString());
          if (city.toString().isNotEmpty) parts.add(city.toString());
          if (state.toString().isNotEmpty) parts.add(state.toString());
          if (parts.isNotEmpty) locationName = parts.join(', ');
        }
      } catch (_) {
        // Keep fallback to coordinates if geocoding fails
      }

      setState(() {
        _latController.text = lat.toStringAsFixed(6);
        _lngController.text = lng.toStringAsFixed(6);
        _locationName = locationName;
        _isGettingLocation = false;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal mendapatkan lokasi: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
      setState(() => _isGettingLocation = false);
    }
  }

  Future<void> _pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      
      if (image != null) {
        final bytes = await image.readAsBytes();
        setState(() {
          _selectedImageFile = File(image.path);
          _imageBytes = bytes;
          _hasImage = true;
        });
      }
    } catch (e) {
      print('Error picking image: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memilih foto: $e')),
        );
      }
    }
  }

  Future<void> _submitReport() async {
    if (_selectedImageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Silakan pilih foto terlebih dahulu')),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    String fileName = _selectedImageFile?.path.split('/').last ?? 'image.jpg';
    if (!fileName.contains('.')) {
      fileName = '$fileName.jpg';
    }

    final response = await DetectionService.submitDetection(
      imageBytes: _imageBytes!,
      fileName: fileName,
      description: _descController.text,
      latitude: double.tryParse(_latController.text.trim()),
      longitude: double.tryParse(_lngController.text.trim()),
      ricePhase: _selectedPhase,
    );

    setState(() {
      _isSubmitting = false;
    });

    if (mounted) {
      if (response.success) {
        // Clear form and navigate with detection data
        setState(() {
          _hasImage = false;
          _selectedImageFile = null;
          _descController.clear();
        });
        
        // Navigate to result screen with detection data
        final targetTab = await Navigator.push<int>(
          context,
          MaterialPageRoute(
            builder: (context) => LaporanHasilScreen(
              detection: response.detection!,
              penyuluhName: response.penyuluhName,
              totalPests: response.totalPests,
            ),
          ),
        );

        if (widget.onReportSubmitted != null) {
          widget.onReportSubmitted!(targetTab ?? 0);
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.message)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    
    return Column(
      children: [
        // Premium Header
        Container(
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(22, topPadding + 16, 22, 24),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF4A148C),
                Color(0xFF6A1B9A),
                Color(0xFF9C27B0),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: Color(0x444A148C),
                blurRadius: 16,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Background decorations
              Positioned(
                top: -10,
                right: -20,
                child: Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.05),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.15),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.camera_enhance_rounded,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Deteksi Real-Time',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.white.withValues(alpha: 0.75),
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const Text(
                                'Laporan Hama',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                  letterSpacing: -0.3,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      
                      // Profile Dropdown
                      PopupMenuButton<int>(
                        position: PopupMenuPosition.under,
                        offset: const Offset(0, 12),
                        elevation: 16,
                        shadowColor: const Color(0xFF4A148C).withValues(alpha: 0.16),
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(22),
                        ),
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.3),
                              width: 1.5,
                            ),
                          ),
                          child: const Icon(
                            Icons.person_rounded,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            enabled: false,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Row(
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: LinearGradient(
                                        colors: [Color(0xFF4A148C), Color(0xFF9C27B0)],
                                      ),
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      (AuthService.userName?.isNotEmpty ?? false)
                                          ? AuthService.userName![0].toUpperCase()
                                          : '?',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w900,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          AuthService.userName ?? 'Pengguna',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w800,
                                            color: Color(0xFF1A1A2E),
                                            fontSize: 14.5,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const PopupMenuDivider(),
                          PopupMenuItem(
                            value: 1,
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.red.shade50,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.logout_rounded,
                                    color: Colors.red.shade700,
                                    size: 18,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  'Keluar Akun',
                                  style: TextStyle(
                                    color: Colors.red.shade700,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                        onSelected: (value) {
                          if (value == 1) {
                            DialogUtils.showLogoutConfirmation(context);
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),

        // Body Content
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Subtitle moved from header
                const Text(
                  'Buat Laporan',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF4A148C),
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Foto & deskripsikan hama yang ditemukan',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 20),

                // Image Upload Section
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    width: double.infinity,
                    height: 180,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: _hasImage
                          ? null
                          : Border.all(
                              color: const Color(0xFF7B1FA2).withValues(alpha: 0.3),
                              width: 2,
                              style: BorderStyle.solid,
                            ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: _hasImage && _imageBytes != null
                        ? Stack(
                            children: [
                              // Display selected image
                              Image.memory(
                                _imageBytes!,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: 180,
                              ),
                              // Remove button
                              Positioned(
                                top: 12,
                                right: 12,
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _hasImage = false;
                                      _selectedImageFile = null;
                                      _imageBytes = null;
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: const BoxDecoration(
                                      color: Colors.black54,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.close_rounded,
                                        color: Colors.white, size: 20),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF7B1FA2)
                                      .withValues(alpha: 0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.add_a_photo_rounded,
                                  color: Color(0xFF7B1FA2),
                                  size: 32,
                                ),
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                'Sentuh untuk Ambil / Pilih Foto',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF4A148C),
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'Format: PNG, JPG, JPEG, WEBP',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
                const SizedBox(height: 24),

                // Form Card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Detail Laporan',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF4A148C),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Rice Phase Dropdown
                      const Text(
                        'Fase Pertumbuhan Padi',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8F9FA),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedPhase,
                            isExpanded: true,
                            icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF7B1FA2)),
                            items: const [
                              DropdownMenuItem(
                                value: 'vegetatif',
                                child: Text('Fase Vegetatif (< 40 HST)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF2C3E50))),
                              ),
                              DropdownMenuItem(
                                value: 'generatif',
                                child: Text('Fase Generatif (~40-60 HST)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF2C3E50))),
                              ),
                            ],
                            onChanged: (val) {
                              if (val != null) {
                                setState(() {
                                  _selectedPhase = val;
                                });
                              }
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // GPS Section
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              const Color(0xFF4A148C).withValues(alpha: 0.05),
                              const Color(0xFF7B1FA2).withValues(alpha: 0.08),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: const Color(0xFF7B1FA2).withValues(alpha: 0.2),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.location_on_rounded, color: Color(0xFF7B1FA2), size: 18),
                                const SizedBox(width: 6),
                                const Text(
                                  'Koordinat GPS',
                                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Color(0xFF4A148C)),
                                ),
                                const Spacer(),
                                GestureDetector(
                                  onTap: _isGettingLocation ? null : _getGpsLocation,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      gradient: _isGettingLocation
                                          ? const LinearGradient(colors: [Colors.grey, Colors.grey])
                                          : const LinearGradient(colors: [Color(0xFF7B1FA2), Color(0xFF9C27B0)]),
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(0xFF7B1FA2).withValues(alpha: 0.3),
                                          blurRadius: 8,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: _isGettingLocation
                                        ? const SizedBox(
                                            width: 14,
                                            height: 14,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              valueColor: AlwaysStoppedAnimation(Colors.white),
                                            ),
                                          )
                                        : const Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(Icons.my_location_rounded, color: Colors.white, size: 13),
                                              SizedBox(width: 5),
                                              Text('Ambil Lokasi', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Colors.white)),
                                            ],
                                          ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            // Location display
                            if (_latController.text.isNotEmpty && _lngController.text.isNotEmpty)
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: const Color(0xFF4CAF50).withValues(alpha: 0.4)),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: const BoxDecoration(
                                        color: Color(0xFFE8F5E9),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(Icons.place_rounded, color: Color(0xFF4CAF50), size: 16),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            _locationName,
                                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Color(0xFF1A1A2E), height: 1.3),
                                          ),
                                          const SizedBox(height: 3),
                                          Text(
                                            '${_latController.text}, ${_lngController.text}',
                                            style: TextStyle(fontSize: 10.5, color: Colors.grey.shade500, fontWeight: FontWeight.w500),
                                          ),
                                          const SizedBox(height: 2),
                                          const Text('✓ Lokasi GPS terdeteksi', style: TextStyle(fontSize: 10.5, color: Color(0xFF4CAF50), fontWeight: FontWeight.w600)),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            else if (!_isGettingLocation)
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.orange.shade50,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.orange.shade200),
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.location_off_rounded, color: Colors.orange.shade600, size: 16),
                                    const SizedBox(width: 8),
                                    Text('Tekan tombol untuk mendapatkan lokasi GPS', style: TextStyle(fontSize: 11.5, color: Colors.orange.shade700, fontWeight: FontWeight.w600)),
                                  ],
                                ),
                              )
                            else
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.blue.shade200)),
                                child: Row(
                                  children: [
                                    SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation(Colors.blue.shade600))),
                                    const SizedBox(width: 10),
                                    Text('Mendapatkan lokasi GPS...', style: TextStyle(fontSize: 11.5, color: Colors.blue.shade700, fontWeight: FontWeight.w600)),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Description Field
                      const Text(
                        'Deskripsi Hama',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _descController,
                        maxLines: 4,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF2C3E50),
                        ),
                        decoration: InputDecoration(
                          hintText:
                              'Contoh: Daun padi banyak yang menguning kecoklatan, terdapat serangga kecil berwarna coklat di batang padi bagian bawah...',
                          hintStyle: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade400,
                          ),
                          filled: true,
                          fillColor: const Color(0xFFF8F9FA),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(color: Colors.grey.shade200),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(color: Colors.grey.shade200),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(
                                color: Color(0xFF7B1FA2), width: 1.5),
                          ),
                          contentPadding: const EdgeInsets.all(16),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Submit Button - Deteksi dan Kirim Laporan ke Penyuluh
                Container(
                  width: double.infinity,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF4A148C), Color(0xFF7B1FA2)],
                    ),
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF7B1FA2).withValues(alpha: 0.35),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: _isSubmitting ? null : _submitReport,
                      borderRadius: BorderRadius.circular(18),
                      child: _isSubmitting
                          ? const Center(
                              child: SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              ),
                            )
                          : const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.camera_alt_outlined,
                                    color: Colors.white),
                                SizedBox(width: 10),
                                Text(
                                  'Deteksi dan Kirim Laporan ke Penyuluh',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
