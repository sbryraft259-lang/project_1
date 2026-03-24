class Beach {
  final int id;
  final String name;
  final String location;
  final int price;
  final String imageUrl;
  final String description;
  final int? adminId;
  final int? maxCapacity;   // القيمة الحالية
  final num rating;
  final bool hasChairs;
  final int chairPrice;
  final bool hasUmbrellas;
  final int umbrellaPrice;
  final String createdAt;
  final String updatedAt;
  int? baseCapacity;        // القيمة الأساسية

  Beach({
    required this.id,
    required this.name,
    required this.location,
    required this.price,
    required this.imageUrl,
    required this.description,
    required this.adminId,
    required this.maxCapacity,
    required this.rating,
    required this.hasChairs,
    required this.chairPrice,
    required this.hasUmbrellas,
    required this.umbrellaPrice,
    required this.createdAt,
    required this.updatedAt,
    this.baseCapacity,
  }) {
    // لو baseCapacity فاضية، نخليها قيمة maxCapacity كقيمة أساسية
    baseCapacity ??= maxCapacity;
  }

  factory Beach.fromJson(Map<String, dynamic> json) {
    int? maxCap = (json['maxCapacity'] as num?)?.toInt();
    int? baseCap = (json['baseCapacity'] as num?)?.toInt();

    return Beach(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name'] ?? '',
      location: json['location'] ?? '',
      price: (json['price'] as num?)?.toInt() ?? 0,
      imageUrl: json['imageUrl'] ?? '',
      description: json['description'] ?? '',
      adminId: (json['adminId'] as num?)?.toInt(),
      maxCapacity: maxCap,
      rating: (json['rating'] as num?) ?? 0,
      hasChairs: json['hasChairs'] ?? false,
      chairPrice: (json['chairPrice'] as num?)?.toInt() ?? 0,
      hasUmbrellas: json['hasUmbrellas'] ?? false,
      umbrellaPrice: (json['umbrellaPrice'] as num?)?.toInt() ?? 0,
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      baseCapacity: baseCap ?? maxCap, // لو ما فيش قيمة أساسية في الـ JSON، نخليها maxCapacity
    );
  }

  // دالة لحساب النسبة المئوية على أساس القيمة الأساسية
  double getPercentage() {
    if (maxCapacity == null || baseCapacity == null || maxCapacity == 0) return 0;
    return (baseCapacity! / maxCapacity!) * 100;
  }
} 

String? name;

final List<Map<String, String>> sliderData = [
  {
    "image": "model/9f92b0de458a453a51cd7caf0afcf950cd1a66ed.png",
    "text": "صيفك معانا غير\nاكتشف أقوى عروض الصيف",
  },
  {
    "image": "model/f4b2cb26660ccea98c2c821f1d6176e690deeb6e.jpg",
    "text": "استمتع بعروض الصيف الخاصة\nوالمميزة عند غروب الشمس",
  },
];
List favoriteBeaches = [];

class ApiConstant {
  static const String baseurl =
      "https://beachflow-app-production-7bce.up.railway.app/";
}
