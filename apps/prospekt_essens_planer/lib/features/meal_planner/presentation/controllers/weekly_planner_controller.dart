import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prospekt_core/prospekt_core.dart';
import '../../../../core/providers.dart';
import 'weekly_planner_state.dart';

final weeklyPlannerControllerProvider = StateNotifierProvider<WeeklyPlannerController, WeeklyPlannerState>((ref) {
  return WeeklyPlannerController(ref);
});

class WeeklyPlannerController extends StateNotifier<WeeklyPlannerState> {
  final Ref _ref;

  WeeklyPlannerController(this._ref) : super(WeeklyPlannerState(
    selectedWeekStart: _getStartOfWeek(DateTime.now()),
  )) {
    loadWeek();
  }

  static DateTime _getStartOfWeek(DateTime date) {
    return date.subtract(Duration(days: date.weekday - 1));
  }

  Future<void> loadWeek() async {
    state = state.copyWith(isLoading: true);
    try {
      final repo = _ref.read(mealPlanRepositoryProvider);
      final end = state.selectedWeekStart.add(const Duration(days: 7));
      final plans = await repo.getMealPlansForRange(state.selectedWeekStart, end);
      state = state.copyWith(mealPlans: plans, isLoading: false);
    } catch (_) {
      state = state.copyWith(isLoading: false);
    }
  }

  void nextWeek() {
    state = state.copyWith(selectedWeekStart: state.selectedWeekStart.add(const Duration(days: 7)));
    loadWeek();
  }

  void previousWeek() {
    state = state.copyWith(selectedWeekStart: state.selectedWeekStart.subtract(const Duration(days: 7)));
    loadWeek();
  }

  Future<void> assignRecipe(DateTime date, String mealType, Recipe recipe) async {
    final existing = state.getPlan(date, mealType);
    final repo = _ref.read(mealPlanRepositoryProvider);

    if (existing != null) {
      await repo.updateMealPlan(existing.copyWith(recipeId: recipe.id));
    } else {
      await repo.insertMealPlan(MealPlan(
        id: null,
        date: date,
        mealType: mealType,
        recipeId: recipe.id,
      ));
    }
    loadWeek();
  }

  Future<void> removePlan(int id) async {
    await _ref.read(mealPlanRepositoryProvider).deleteMealPlan(id);
    loadWeek();
  }
}
