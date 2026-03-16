import 'package:equatable/equatable.dart';

/// Zodiac element enum
enum ZodiacElement {
  fire,
  earth,
  air,
  water;

  String get displayName {
    switch (this) {
      case ZodiacElement.fire:
        return 'Fire';
      case ZodiacElement.earth:
        return 'Earth';
      case ZodiacElement.air:
        return 'Air';
      case ZodiacElement.water:
        return 'Water';
    }
  }
}

/// Zodiac sign entity
class ZodiacSign extends Equatable {
  final String id;
  final String name;
  final String symbol;
  final ZodiacElement element;
  final String dateRange;
  final String rulingPlanet;
  final String traits;
  final String description;
  final String imageUrl;

  const ZodiacSign({
    required this.id,
    required this.name,
    required this.symbol,
    required this.element,
    required this.dateRange,
    required this.rulingPlanet,
    required this.traits,
    required this.description,
    required this.imageUrl,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        symbol,
        element,
        dateRange,
        rulingPlanet,
        traits,
        description,
        imageUrl,
      ];
}
