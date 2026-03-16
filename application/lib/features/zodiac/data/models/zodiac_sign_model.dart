import '../../domain/entities/zodiac_sign.dart';

/// Zodiac sign model for data layer
class ZodiacSignModel extends ZodiacSign {
  const ZodiacSignModel({
    required super.id,
    required super.name,
    required super.symbol,
    required super.element,
    required super.dateRange,
    required super.rulingPlanet,
    required super.traits,
    required super.description,
    required super.imageUrl,
  });

  /// Create from JSON
  factory ZodiacSignModel.fromJson(Map<String, dynamic> json) {
    return ZodiacSignModel(
      id: json['id'] as String,
      name: json['name'] as String,
      symbol: json['symbol'] as String,
      element: _parseElement(json['element'] as String),
      dateRange: json['date_range'] as String,
      rulingPlanet: json['ruling_planet'] as String,
      traits: json['traits'] as String,
      description: json['description'] as String,
      imageUrl: json['image_url'] as String,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'symbol': symbol,
      'element': element.name,
      'date_range': dateRange,
      'ruling_planet': rulingPlanet,
      'traits': traits,
      'description': description,
      'image_url': imageUrl,
    };
  }

  /// Parse element from string
  static ZodiacElement _parseElement(String element) {
    switch (element.toLowerCase()) {
      case 'fire':
        return ZodiacElement.fire;
      case 'earth':
        return ZodiacElement.earth;
      case 'air':
        return ZodiacElement.air;
      case 'water':
        return ZodiacElement.water;
      default:
        return ZodiacElement.fire;
    }
  }
}
