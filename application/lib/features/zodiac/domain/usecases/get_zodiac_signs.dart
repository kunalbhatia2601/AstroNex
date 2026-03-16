import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/usecase.dart';
import '../entities/zodiac_sign.dart';
import '../repositories/zodiac_repository.dart';

/// Use case to get all zodiac signs
class GetZodiacSigns implements UseCase<List<ZodiacSign>, NoParams> {
  final ZodiacRepository repository;

  GetZodiacSigns(this.repository);

  @override
  Future<Either<Failure, List<ZodiacSign>>> call(NoParams params) {
    return repository.getZodiacSigns();
  }
}
