import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/zodiac_local_datasource.dart';
import '../../data/repositories/zodiac_repository_impl.dart';
import '../../domain/entities/zodiac_sign.dart';
import '../../domain/repositories/zodiac_repository.dart';
import '../../domain/usecases/get_zodiac_signs.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/utils/usecase.dart';

/// Zodiac local data source provider
final zodiacLocalDataSourceProvider = Provider<ZodiacLocalDataSource>((ref) {
  return ZodiacLocalDataSourceImpl();
});

/// Zodiac repository provider
final zodiacRepositoryProvider = Provider<ZodiacRepository>((ref) {
  return ZodiacRepositoryImpl(
    localDataSource: ref.watch(zodiacLocalDataSourceProvider),
  );
});

/// Get zodiac signs use case provider
final getZodiacSignsUseCaseProvider = Provider<GetZodiacSigns>((ref) {
  return GetZodiacSigns(ref.watch(zodiacRepositoryProvider));
});

/// Zodiac signs state
class ZodiacSignsState {
  final List<ZodiacSign> signs;
  final bool isLoading;
  final String? error;

  const ZodiacSignsState({
    this.signs = const [],
    this.isLoading = false,
    this.error,
  });

  ZodiacSignsState copyWith({
    List<ZodiacSign>? signs,
    bool? isLoading,
    String? error,
  }) {
    return ZodiacSignsState(
      signs: signs ?? this.signs,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// Zodiac signs notifier
class ZodiacSignsNotifier extends StateNotifier<ZodiacSignsState> {
  final GetZodiacSigns getZodiacSigns;

  ZodiacSignsNotifier(this.getZodiacSigns) : super(const ZodiacSignsState());

  Future<void> loadZodiacSigns() async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await getZodiacSigns(const NoParams());

    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        error: failure.message,
      ),
      (signs) => state = state.copyWith(
        isLoading: false,
        signs: signs,
      ),
    );
  }
}

/// Zodiac signs provider
final zodiacSignsProvider =
    StateNotifierProvider<ZodiacSignsNotifier, ZodiacSignsState>((ref) {
  return ZodiacSignsNotifier(ref.watch(getZodiacSignsUseCaseProvider));
});

/// Selected zodiac sign provider
final selectedZodiacSignProvider = StateProvider<ZodiacSign?>((ref) => null);
