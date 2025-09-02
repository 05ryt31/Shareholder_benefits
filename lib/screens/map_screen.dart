import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../services/benefit_service.dart';
import '../models/shareholder_benefit.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _controller;
  Set<Marker> _markers = {};
  String _selectedCategory = '全て';

  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(35.6762, 139.6503), // Tokyo Station
    zoom: 11,
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadAllMarkers();
    });
  }

  void _loadAllMarkers() {
    final benefitService = context.read<BenefitService>();
    final allStores = benefitService.getAllStores();
    
    setState(() {
      _markers = _createMarkers(allStores);
    });
  }

  Set<Marker> _createMarkers(List<Store> stores) {
    return stores.map((store) {
      return Marker(
        markerId: MarkerId(store.id),
        position: LatLng(store.latitude, store.longitude),
        infoWindow: InfoWindow(
          title: store.name,
          snippet: '${store.category} - ${store.address}',
        ),
        icon: _getMarkerIcon(store.category),
      );
    }).toSet();
  }

  BitmapDescriptor _getMarkerIcon(String category) {
    switch (category) {
      case 'スーパーマーケット':
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue);
      case 'ファミリーレストラン':
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange);
      case 'デパート':
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet);
      case '家電量販店':
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
      default:
        return BitmapDescriptor.defaultMarker;
    }
  }

  List<String> get _categories {
    final benefitService = context.read<BenefitService>();
    final allStores = benefitService.getAllStores();
    final categories = allStores.map((store) => store.category).toSet().toList();
    categories.insert(0, '全て');
    return categories;
  }

  void _filterByCategory(String category) {
    final benefitService = context.read<BenefitService>();
    final allStores = benefitService.getAllStores();
    
    setState(() {
      _selectedCategory = category;
      if (category == '全て') {
        _markers = _createMarkers(allStores);
      } else {
        final filteredStores = allStores.where((store) => store.category == category).toList();
        _markers = _createMarkers(filteredStores);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('店舗マップ'),
        backgroundColor: Colors.blue[600],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.my_location),
            onPressed: () async {
              if (_controller != null) {
                await _controller!.animateCamera(
                  CameraUpdate.newCameraPosition(_initialPosition),
                );
              }
            },
            tooltip: '現在地に戻る',
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            height: 60,
            padding: const EdgeInsets.all(8.0),
            color: Colors.blue[50],
            child: Row(
              children: [
                const Text(
                  'カテゴリ:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: _categories.map((category) {
                        final isSelected = _selectedCategory == category;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: FilterChip(
                            label: Text(category),
                            selected: isSelected,
                            onSelected: (selected) {
                              _filterByCategory(category);
                            },
                            selectedColor: Colors.blue[100],
                            checkmarkColor: Colors.blue[800],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: GoogleMap(
              onMapCreated: (GoogleMapController controller) {
                _controller = controller;
              },
              initialCameraPosition: _initialPosition,
              markers: _markers,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              mapType: MapType.normal,
              zoomControlsEnabled: false,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}