import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/shareholder_benefit.dart';

class StoreMapScreen extends StatefulWidget {
  final ShareholderBenefit benefit;
  final List<Store> stores;
  final Store? initialStore;

  const StoreMapScreen({
    super.key,
    required this.benefit,
    required this.stores,
    this.initialStore,
  });

  @override
  State<StoreMapScreen> createState() => _StoreMapScreenState();
}

class _StoreMapScreenState extends State<StoreMapScreen> {
  GoogleMapController? _controller;
  Set<Marker> _markers = {};
  late CameraPosition _initialPosition;

  @override
  void initState() {
    super.initState();
    _setupMap();
  }

  void _setupMap() {
    if (widget.stores.isEmpty) return;

    final targetStore = widget.initialStore ?? widget.stores.first;
    _initialPosition = CameraPosition(
      target: LatLng(targetStore.latitude, targetStore.longitude),
      zoom: widget.stores.length == 1 ? 16 : 12,
    );

    _markers = widget.stores.map((store) {
      return Marker(
        markerId: MarkerId(store.id),
        position: LatLng(store.latitude, store.longitude),
        infoWindow: InfoWindow(
          title: store.name,
          snippet: '${store.address}\n営業時間: ${store.businessHours}',
          onTap: () => _showStoreDetails(store),
        ),
        icon: _getMarkerIcon(store.category),
        onTap: () => _showStoreDetails(store),
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

  void _showStoreDetails(Store store) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      store.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      store.category,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.green[800],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Icon(Icons.location_on, size: 20, color: Colors.grey[600]),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      store.address,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.phone, size: 20, color: Colors.grey[600]),
                  const SizedBox(width: 8),
                  Text(
                    store.phone,
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.schedule, size: 20, color: Colors.grey[600]),
                  const SizedBox(width: 8),
                  Text(
                    '営業時間: ${store.businessHours}',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[600],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text('閉じる'),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
            ],
          ),
        ),
      ),
    );
  }

  void _fitAllMarkers() async {
    if (_controller == null || widget.stores.isEmpty) return;

    if (widget.stores.length == 1) {
      final store = widget.stores.first;
      await _controller!.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(store.latitude, store.longitude),
          16,
        ),
      );
      return;
    }

    double minLat = widget.stores.first.latitude;
    double maxLat = widget.stores.first.latitude;
    double minLng = widget.stores.first.longitude;
    double maxLng = widget.stores.first.longitude;

    for (var store in widget.stores) {
      minLat = minLat < store.latitude ? minLat : store.latitude;
      maxLat = maxLat > store.latitude ? maxLat : store.latitude;
      minLng = minLng < store.longitude ? minLng : store.longitude;
      maxLng = maxLng > store.longitude ? maxLng : store.longitude;
    }

    await _controller!.animateCamera(
      CameraUpdate.newLatLngBounds(
        LatLngBounds(
          southwest: LatLng(minLat, minLng),
          northeast: LatLng(maxLat, maxLng),
        ),
        100.0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.benefit.companyName} - 店舗マップ'),
        backgroundColor: Colors.blue[600],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.fit_screen),
            onPressed: _fitAllMarkers,
            tooltip: '全店舗を表示',
          ),
        ],
      ),
      body: widget.stores.isEmpty
          ? const Center(
              child: Text(
                '表示する店舗がありません',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            )
          : GoogleMap(
              onMapCreated: (GoogleMapController controller) {
                _controller = controller;
                if (widget.stores.length > 1) {
                  Future.delayed(const Duration(milliseconds: 500), () {
                    _fitAllMarkers();
                  });
                }
              },
              initialCameraPosition: _initialPosition,
              markers: _markers,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              mapType: MapType.normal,
              zoomControlsEnabled: true,
            ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16.0),
        color: Colors.blue[50],
        child: Text(
          '${widget.benefit.benefitType}: ${widget.benefit.description}',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}