import 'package:equatable/equatable.dart';

/// Horoscope type enum
enum HoroscopeType {
  daily,
  weekly,
  monthly;

  String get displayName {
    switch (this) {
      case HoroscopeType.daily:
        return 'Daily';
      case HoroscopeType.weekly:
        return 'Weekly';
      case HoroscopeType.monthly:
        return 'Monthly';
    }
  }
}

/// Horoscope entity
class Horoscope extends Equatable {
  final String id;
  final String zodiacSignId;
  final HoroscopeType type;
  final DateTime date;
  final String title;
  final String content;
  final int? rating; // 1-5 stars
  final List<String> luckyNumbers;
  final String? luckyColor;
  final String? mood;

  const Horoscope({
    required this.id,
    required this.zodiacSignId,
    required this.type,
    required this.date,
    required this.title,
    required this.content,
    this.rating,
    this.luckyNumbers = const [],
    this.luckyColor,
    this.mood,
  });

  @override
  List<Object?> get props => [
        id,
        zodiacSignId,
        type,
        date,
        title,
        content,
        rating,
        luckyNumbers,
        luckyColor,
        mood,
      ];
}
