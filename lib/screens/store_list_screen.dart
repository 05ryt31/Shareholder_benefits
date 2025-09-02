import 'package:flutter/material.dart';
import '../models/shareholder_benefit.dart';
import '../widgets/store_card.dart';
import '../screens/store_map_screen.dart';

class StoreListScreen extends StatefulWidget {
  final ShareholderBenefit benefit;

  const StoreListScreen({
    super.key,
    required this.benefit,
  });

  @override
  State<StoreListScreen> createState() => _StoreListScreenState();
}

class _StoreListScreenState extends State<StoreListScreen> {
  String _selectedPrefecture = '全て';
  List<Store> _filteredStores = [];

  @override
  void initState() {
    super.initState();
    _filteredStores = widget.benefit.availableStores;
  }

  List<String> get _prefectures {
    final prefectures = widget.benefit.availableStores
        .map((store) => store.prefecture)
        .toSet()
        .toList();
    prefectures.insert(0, '全て');
    return prefectures;
  }

  void _filterByPrefecture(String prefecture) {
    setState(() {
      _selectedPrefecture = prefecture;
      if (prefecture == '全て') {
        _filteredStores = widget.benefit.availableStores;
      } else {
        _filteredStores = widget.benefit.availableStores
            .where((store) => store.prefecture == prefecture)
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.benefit.companyName),
        backgroundColor: Colors.blue[600],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.map),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => StoreMapScreen(
                    benefit: widget.benefit,
                    stores: _filteredStores,
                  ),
                ),
              );
            },
            tooltip: '地図で表示',
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            color: Colors.blue[50],
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.orange[100],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            widget.benefit.benefitType,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.orange[800],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '銘柄コード: ${widget.benefit.companyCode}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.benefit.description,
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '有効期限: ${widget.benefit.validityPeriod}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                const Text(
                  '都道府県で絞り込み:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: _prefectures.map((prefecture) {
                        final isSelected = _selectedPrefecture == prefecture;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: FilterChip(
                            label: Text(prefecture),
                            selected: isSelected,
                            onSelected: (selected) {
                              _filterByPrefecture(prefecture);
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
          const Divider(height: 1),
          Expanded(
            child: _filteredStores.isEmpty
                ? const Center(
                    child: Text(
                      '該当する店舗がありません',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: _filteredStores.length,
                    itemBuilder: (context, index) {
                      final store = _filteredStores[index];
                      return StoreCard(
                        store: store,
                        onMapTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => StoreMapScreen(
                                benefit: widget.benefit,
                                stores: [store],
                                initialStore: store,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => StoreMapScreen(
                benefit: widget.benefit,
                stores: _filteredStores,
              ),
            ),
          );
        },
        backgroundColor: Colors.blue[600],
        child: const Icon(Icons.map, color: Colors.white),
        tooltip: '地図で表示',
      ),
    );
  }
}