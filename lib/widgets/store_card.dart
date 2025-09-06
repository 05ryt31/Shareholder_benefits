import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/shareholder_benefit.dart';
import '../utils/app_theme.dart';

class StoreCard extends StatelessWidget {
  final Store store;
  final VoidCallback onMapTap;

  const StoreCard({
    super.key,
    required this.store,
    required this.onMapTap,
  });

  void _copyToClipboard(BuildContext context, String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$labelをコピーしました'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'スーパーマーケット':
        return AppColors.primary;
      case 'ファミリーレストラン':
        return AppColors.accent;
      case 'デパート':
        return AppColors.secondary;
      case '家電量販店':
        return AppColors.info;
      default:
        return AppColors.primary;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'スーパーマーケット':
        return Icons.shopping_cart_outlined;
      case 'ファミリーレストラン':
        return Icons.restaurant_menu_outlined;
      case 'デパート':
        return Icons.store_mall_directory_outlined;
      case '家電量販店':
        return Icons.electrical_services_outlined;
      default:
        return Icons.store_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoryColor = _getCategoryColor(store.category);
    final categoryIcon = _getCategoryIcon(store.category);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: categoryColor.withOpacity(0.15),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.onSurface.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        categoryColor,
                        categoryColor.withOpacity(0.8),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: categoryColor.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    categoryIcon,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        store.name,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.onSurface,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: categoryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          store.category,
                          style: TextStyle(
                            fontSize: 12,
                            color: categoryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant.withOpacity(0.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  InkWell(
                    onTap: () => _copyToClipboard(context, store.address, '住所'),
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            size: 20,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              store.address,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppColors.onSurface,
                              ),
                            ),
                          ),
                          const Icon(
                            Icons.content_copy_outlined,
                            size: 18,
                            color: AppColors.onSurfaceSecondary,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  InkWell(
                    onTap: () => _copyToClipboard(context, store.phone, '電話番号'),
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.phone_outlined,
                            size: 20,
                            color: AppColors.success,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            store.phone,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.onSurface,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.content_copy_outlined,
                            size: 18,
                            color: AppColors.onSurfaceSecondary,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(
                        Icons.schedule_outlined,
                        size: 20,
                        color: AppColors.warning,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          '営業時間: ${store.businessHours}',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.onSurface,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
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
                    color: AppColors.primary.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ElevatedButton.icon(
                onPressed: onMapTap,
                icon: const Icon(Icons.map_outlined, size: 20),
                label: const Text('地図で表示'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}