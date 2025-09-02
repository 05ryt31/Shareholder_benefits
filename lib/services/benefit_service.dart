import 'package:flutter/foundation.dart';
import '../models/shareholder_benefit.dart';

class BenefitService extends ChangeNotifier {
  List<ShareholderBenefit> _benefits = [];
  List<ShareholderBenefit> _filteredBenefits = [];
  String _searchQuery = '';

  List<ShareholderBenefit> get benefits => _filteredBenefits;
  String get searchQuery => _searchQuery;

  BenefitService() {
    _loadSampleData();
  }

  void _loadSampleData() {
    _benefits = [
      ShareholderBenefit(
        id: '1',
        companyName: 'イオン',
        companyCode: '8267',
        benefitType: '買い物券',
        description: '100株以上保有で1,000円分の買い物券',
        validityPeriod: '2024年12月31日まで',
        imageUrl: 'assets/images/aeon.png',
        availableStores: [
          Store(
            id: 's1',
            name: 'イオン新宿店',
            address: '東京都新宿区新宿3-1-26',
            latitude: 35.6906,
            longitude: 139.7006,
            phone: '03-1234-5678',
            businessHours: '10:00-22:00',
            category: 'スーパーマーケット',
            prefecture: '東京都',
            city: '新宿区',
          ),
          Store(
            id: 's2',
            name: 'イオン渋谷店',
            address: '東京都渋谷区道玄坂2-1-1',
            latitude: 35.6581,
            longitude: 139.7014,
            phone: '03-1234-5679',
            businessHours: '10:00-22:00',
            category: 'スーパーマーケット',
            prefecture: '東京都',
            city: '渋谷区',
          ),
        ],
      ),
      ShareholderBenefit(
        id: '2',
        companyName: 'すかいらーくホールディングス',
        companyCode: '3197',
        benefitType: '食事券',
        description: '100株以上保有で2,000円分の食事券',
        validityPeriod: '2024年12月31日まで',
        imageUrl: 'assets/images/skylark.png',
        availableStores: [
          Store(
            id: 's3',
            name: 'ガスト新宿東口店',
            address: '東京都新宿区新宿3-37-1',
            latitude: 35.6924,
            longitude: 139.7068,
            phone: '03-2345-6789',
            businessHours: '7:00-25:00',
            category: 'ファミリーレストラン',
            prefecture: '東京都',
            city: '新宿区',
          ),
          Store(
            id: 's4',
            name: 'バーミヤン渋谷店',
            address: '東京都渋谷区渋谷1-1-8',
            latitude: 35.6598,
            longitude: 139.7026,
            phone: '03-2345-6790',
            businessHours: '11:00-24:00',
            category: 'ファミリーレストラン',
            prefecture: '東京都',
            city: '渋谷区',
          ),
        ],
      ),
      ShareholderBenefit(
        id: '3',
        companyName: '三越伊勢丹ホールディングス',
        companyCode: '3099',
        benefitType: '割引券',
        description: '100株以上保有で10%割引券',
        validityPeriod: '2024年12月31日まで',
        imageUrl: 'assets/images/mitsukoshi.png',
        availableStores: [
          Store(
            id: 's5',
            name: '伊勢丹新宿本店',
            address: '東京都新宿区新宿3-14-1',
            latitude: 35.6911,
            longitude: 139.7043,
            phone: '03-3352-1111',
            businessHours: '10:00-20:00',
            category: 'デパート',
            prefecture: '東京都',
            city: '新宿区',
          ),
          Store(
            id: 's6',
            name: '三越銀座店',
            address: '東京都中央区銀座4-6-16',
            latitude: 35.6717,
            longitude: 139.7640,
            phone: '03-3562-1111',
            businessHours: '10:00-20:00',
            category: 'デパート',
            prefecture: '東京都',
            city: '中央区',
          ),
        ],
      ),
      ShareholderBenefit(
        id: '4',
        companyName: 'ヤマダホールディングス',
        companyCode: '9831',
        benefitType: '商品券',
        description: '100株以上保有で500円分の商品券',
        validityPeriod: '2024年12月31日まで',
        imageUrl: 'assets/images/yamada.png',
        availableStores: [
          Store(
            id: 's7',
            name: 'ヤマダ電機 LABI新宿東口館',
            address: '東京都新宿区新宿3-23-7',
            latitude: 35.6913,
            longitude: 139.7054,
            phone: '03-5363-6700',
            businessHours: '10:00-22:00',
            category: '家電量販店',
            prefecture: '東京都',
            city: '新宿区',
          ),
          Store(
            id: 's8',
            name: 'ヤマダ電機 LABI渋谷',
            address: '東京都渋谷区宇田川町21-6',
            latitude: 35.6627,
            longitude: 139.6989,
            phone: '03-5728-7770',
            businessHours: '10:00-22:00',
            category: '家電量販店',
            prefecture: '東京都',
            city: '渋谷区',
          ),
        ],
      ),
    ];
    _filteredBenefits = _benefits;
    notifyListeners();
  }

  void searchBenefits(String query) {
    _searchQuery = query;
    if (query.isEmpty) {
      _filteredBenefits = _benefits;
    } else {
      _filteredBenefits = _benefits.where((benefit) {
        return benefit.companyName.contains(query) ||
               benefit.benefitType.contains(query) ||
               benefit.companyCode.contains(query);
      }).toList();
    }
    notifyListeners();
  }

  ShareholderBenefit? getBenefitById(String id) {
    try {
      return _benefits.firstWhere((benefit) => benefit.id == id);
    } catch (e) {
      return null;
    }
  }

  List<Store> getAllStores() {
    List<Store> allStores = [];
    for (var benefit in _benefits) {
      allStores.addAll(benefit.availableStores);
    }
    return allStores;
  }
}