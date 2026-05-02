import 'package:prospekt_core/prospekt_core.dart';

enum MealPlannerStatus { loading, success, error }

class MealPlannerState {
  final MealPlannerStatus status;
  final List<RecipeMatchSummary> recommendations;
  final String? errorMessage;

  MealPlannerState({
    required this.status,
    this.recommendations = const [],
    this.errorMessage,
  });

  MealPlannerState copyWith({
    MealPlannerStatus? status,
    List<RecipeMatchSummary>? recommendations,
    String? errorMessage,
  }) {
    return MealPlannerState(
      status: status ?? this.status,
      recommendations: recommendations ?? this.recommendations,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
