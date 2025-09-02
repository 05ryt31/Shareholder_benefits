import 'package:flutter/material.dart';
import '../models/shareholder_benefit.dart';
import '../utils/app_theme.dart';

class BenefitCard extends StatelessWidget {
  final ShareholderBenefit benefit;
  final VoidCallback onTap;

  const BenefitCard({
    super.key,
    required this.benefit,
    required this.onTap,
  });

  Color _getBenefitColor(String benefitType) {
    switch (benefitType) {
      case '買い物券':
        return AppColors.primary;
      case '食事券':
        return AppColors.accent;
      case '割引券':
        return AppColors.secondary;
      case '商品券':
        return AppColors.info;
      default:
        return AppColors.primary;
    }
  }

  IconData _getBenefitIcon(String benefitType) {
    switch (benefitType) {
      case '買い物券':
        return Icons.shopping_bag_outlined;
      case '食事券':
        return Icons.restaurant_outlined;
      case '割引券':
        return Icons.discount_outlined;
      case '商品券':
        return Icons.card_giftcard_outlined;
      default:
        return Icons.business_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final benefitColor = _getBenefitColor(benefit.benefitType);
    final benefitIcon = _getBenefitIcon(benefit.benefitType);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            benefitColor.withOpacity(0.05),
            Colors.white,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: benefitColor.withOpacity(0.15),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: benefitColor.withOpacity(0.08),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            benefitColor,
                            benefitColor.withOpacity(0.8),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: benefitColor.withOpacity(0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(
                        benefitIcon,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            benefit.companyName,
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.onSurface,
                            ),
                          ),
                          const SizedBox(height: 6),
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
                              '銘柄コード: ${benefit.companyCode}',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppColors.onSurfaceSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: benefitColor,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: benefitColor.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        benefit.benefitType,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
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
                    benefit.description,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.onSurface,
                      height: 1.4,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.success.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppColors.success.withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.store_outlined,
                            size: 16,
                            color: AppColors.success,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '${benefit.availableStores.length}店舗',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.success,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.warning.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppColors.warning.withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.schedule_outlined,
                            size: 16,
                            color: AppColors.warning,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            benefit.validityPeriod.replaceAll('まで', ''),
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.warning,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: benefitColor,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}