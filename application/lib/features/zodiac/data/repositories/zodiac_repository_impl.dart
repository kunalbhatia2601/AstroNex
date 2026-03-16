import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/zodiac_sign.dart';
import '../../domain/repositories/zodiac_repository.dart';
import '../datasources/zodiac_local_datasource.dart';

/// Implementation of zodiac repository
class ZodiacRepositoryImpl implements ZodiacRepository {
  final ZodiacLocalDataSource localDataSource;

  ZodiacRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<ZodiacSign>>> getZodiacSigns() async {
    try {
      final signs = await localDataSource.getZodiacSigns();
      return Right(signs);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ZodiacSign>> getZodiacSignById(String id) async {
    try {
      final sign = await localDataSource.getZodiacSignById(id);
      return Right(sign);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ZodiacSign>> getZodiacSignByName(String name) async {
    try {
      final sign = await localDataSource.getZodiacSignByName(name);
      return Right(sign);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }
}
