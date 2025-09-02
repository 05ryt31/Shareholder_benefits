class ShareholderBenefit {
  final String id;
  final String companyName;
  final String companyCode;
  final String benefitType;
  final String description;
  final String validityPeriod;
  final String imageUrl;
  final List<Store> availableStores;

  ShareholderBenefit({
    required this.id,
    required this.companyName,
    required this.companyCode,
    required this.benefitType,
    required this.description,
    required this.validityPeriod,
    required this.imageUrl,
    required this.availableStores,
  });

  factory ShareholderBenefit.fromJson(Map<String, dynamic> json) {
    return ShareholderBenefit(
      id: json['id'],
      companyName: json['companyName'],
      companyCode: json['companyCode'],
      benefitType: json['benefitType'],
      description: json['description'],
      validityPeriod: json['validityPeriod'],
      imageUrl: json['imageUrl'],
      availableStores: (json['availableStores'] as List)
          .map((store) => Store.fromJson(store))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'companyName': companyName,
      'companyCode': companyCode,
      'benefitType': benefitType,
      'description': description,
      'validityPeriod': validityPeriod,
      'imageUrl': imageUrl,
      'availableStores': availableStores.map((store) => store.toJson()).toList(),
    };
  }
}

class Store {
  final String id;
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final String phone;
  final String businessHours;
  final String category;
  final String prefecture;
  final String city;

  Store({
    required this.id,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.phone,
    required this.businessHours,
    required this.category,
    required this.prefecture,
    required this.city,
  });

  factory Store.fromJson(Map<String, dynamic> json) {
    return Store(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      latitude: json['latitude'].toDouble(),
      longitude: json['longitude'].toDouble(),
      phone: json['phone'],
      businessHours: json['businessHours'],
      category: json['category'],
      prefecture: json['prefecture'],
      city: json['city'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'phone': phone,
      'businessHours': businessHours,
      'category': category,
      'prefecture': prefecture,
      'city': city,
    };
  }
}