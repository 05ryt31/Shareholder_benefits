import 'package:flutter/material.dart';
import '../models/shareholder_benefit.dart';
import '../widgets/store_card.dart';
import '../screens/store_map_screen.dart';
import '../utils/app_theme.dart';

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
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: Text(widget.benefit.companyName),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(Icons.map_outlined),
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
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.primary.withOpacity(0.05),
                  Colors.white,
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.primary.withOpacity(0.15),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.08),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        widget.benefit.benefitType,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceVariant,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '銘柄コード: ${widget.benefit.companyCode}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.onSurfaceSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceVariant.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    widget.benefit.description,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.onSurface,
                      height: 1.4,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(
                      Icons.schedule_outlined,
                      size: 16,
                      color: AppColors.warning,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '有効期限: ${widget.benefit.validityPeriod}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.onSurfaceSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainer,
              border: Border(
                bottom: BorderSide(
                  color: AppColors.onSurfaceTertiary.withOpacity(0.12),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.filter_list_outlined,
                  size: 20,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  '都道府県で絞り込み',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.onSurface,
                  ),
                ),
                const SizedBox(width: 12),
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
                            selectedColor: AppColors.primary.withOpacity(0.15),
                            checkmarkColor: AppColors.primary,
                            backgroundColor: AppColors.surfaceVariant,
                            side: BorderSide(
                              color: isSelected 
                                ? AppColors.primary 
                                : AppColors.onSurfaceTertiary.withOpacity(0.3),
                            ),
                            labelStyle: TextStyle(
                              color: isSelected 
                                ? AppColors.primary 
                                : AppColors.onSurface,
                              fontWeight: isSelected 
                                ? FontWeight.w600 
                                : FontWeight.w500,
                            ),
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
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
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
      floatingActionButton: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primary,
              AppColors.primaryLight,
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.4),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: FloatingActionButton(
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
          backgroundColor: Colors.transparent,
          elevation: 0,
          tooltip: '地図で表示',
          child: const Icon(Icons.map_outlined, color: Colors.white, size: 28),
        ),
      ),
    );
  }
}