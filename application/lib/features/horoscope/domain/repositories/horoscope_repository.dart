import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/horoscope.dart';

/// Repository interface for horoscopes
abstract class HoroscopeRepository {
  /// Get horoscope for a specific sign and type
  Future<Either<Failure, Horoscope>> getHoroscope({
    required String zodiacSignId,
    required HoroscopeType type,
    DateTime? date,
  });

  /// Get daily horoscope for a specific sign
  Future<Either<Failure, Horoscope>> getDailyHoroscope(String zodiacSignId);

  /// Get weekly horoscope for a specific sign
  Future<Either<Failure, Horoscope>> getWeeklyHoroscope(String zodiacSignId);

  /// Get monthly horoscope for a specific sign
  Future<Either<Failure, Horoscope>> getMonthlyHoroscope(String zodiacSignId);
}
