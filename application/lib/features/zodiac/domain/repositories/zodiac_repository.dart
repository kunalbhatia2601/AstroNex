import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/zodiac_sign.dart';

/// Repository interface for zodiac signs
abstract class ZodiacRepository {
  /// Get all zodiac signs
  Future<Either<Failure, List<ZodiacSign>>> getZodiacSigns();

  /// Get a single zodiac sign by ID
  Future<Either<Failure, ZodiacSign>> getZodiacSignById(String id);

  /// Get zodiac sign by name
  Future<Either<Failure, ZodiacSign>> getZodiacSignByName(String name);
}
