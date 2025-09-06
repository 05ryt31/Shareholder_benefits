import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/benefit_service.dart';
import '../widgets/benefit_card.dart';
import '../screens/store_list_screen.dart';
import '../screens/map_screen.dart';
import '../utils/app_theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('株主優待マップ'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.primary,
                AppColors.primaryLight,
              ],
            ),
          ),
        ),
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
                    builder: (context) => const MapScreen(),
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
            height: 120,
            padding: const EdgeInsets.fromLTRB(20, 100, 20, 20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.primary,
                  AppColors.primaryLight,
                ],
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                style: const TextStyle(
                  fontSize: 16,
                  color: AppColors.onSurface,
                ),
                decoration: InputDecoration(
                  hintText: '会社名、優待内容、銘柄コードで検索',
                  hintStyle: TextStyle(
                    color: AppColors.onSurfaceSecondary.withOpacity(0.7),
                  ),
                  prefixIcon: const Icon(
                    Icons.search_rounded,
                    color: AppColors.primary,
                    size: 24,
                  ),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(
                            Icons.clear_rounded,
                            color: AppColors.onSurfaceSecondary,
                          ),
                          onPressed: () {
                            _searchController.clear();
                            context.read<BenefitService>().searchBenefits('');
                          },
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 16.0,
                  ),
                ),
                onChanged: (value) {
                  context.read<BenefitService>().searchBenefits(value);
                  setState(() {});
                },
              ),
            ),
          ),
          Expanded(
            child: Consumer<BenefitService>(
              builder: (context, benefitService, child) {
                final benefits = benefitService.benefits;
                
                if (benefits.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: AppColors.surfaceVariant,
                            borderRadius: BorderRadius.circular(60),
                          ),
                          child: const Icon(
                            Icons.search_off_rounded,
                            size: 60,
                            color: AppColors.onSurfaceSecondary,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          '検索結果がありません',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: AppColors.onSurface,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '別の検索キーワードでお試しください',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.onSurfaceSecondary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
                  itemCount: benefits.length,
                  itemBuilder: (context, index) {
                    final benefit = benefits[index];
                    return BenefitCard(
                      benefit: benefit,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => StoreListScreen(
                              benefit: benefit,
                            ),
                          ),
                        );
                      },
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
                builder: (context) => const MapScreen(),
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