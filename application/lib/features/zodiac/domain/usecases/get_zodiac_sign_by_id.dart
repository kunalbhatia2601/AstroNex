import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/usecase.dart';
import '../entities/zodiac_sign.dart';
import '../repositories/zodiac_repository.dart';

/// Use case to get a zodiac sign by ID
class GetZodiacSignById implements UseCase<ZodiacSign, String> {
  final ZodiacRepository repository;

  GetZodiacSignById(this.repository);

  @override
  Future<Either<Failure, ZodiacSign>> call(String id) {
    return repository.getZodiacSignById(id);
  }
}
