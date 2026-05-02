import 'package:prospekt_core/prospekt_core.dart';

class WeeklyPlannerState {
  final DateTime selectedWeekStart;
  final List<MealPlan> mealPlans;
  final bool isLoading;

  WeeklyPlannerState({
    required this.selectedWeekStart,
    this.mealPlans = const [],
    this.isLoading = false,
  });

  WeeklyPlannerState copyWith({
    DateTime? selectedWeekStart,
    List<MealPlan>? mealPlans,
    bool? isLoading,
  }) {
    return WeeklyPlannerState(
      selectedWeekStart: selectedWeekStart ?? this.selectedWeekStart,
      mealPlans: mealPlans ?? this.mealPlans,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  /// Returns the meal plan for a specific day and meal type.
  MealPlan? getPlan(DateTime date, String mealType) {
    try {
      return mealPlans.firstWhere((p) => 
        p.date.year == date.year && 
        p.date.month == date.month && 
        p.date.day == date.day && 
        p.mealType == mealType
      );
    } catch (_) {
      return null;
    }
  }
}
