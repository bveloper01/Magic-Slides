import 'package:shared_preferences/shared_preferences.dart';

class OnboardingLocalDataSource {
  static const String _onboardingKey = 'onboarding_completed';
  final SharedPreferences sharedPreferences;

  OnboardingLocalDataSource(this.sharedPreferences);

  Future<bool> isOnboardingCompleted() async {
    return sharedPreferences.getBool(_onboardingKey) ?? false;
  }

  Future<void> setOnboardingCompleted() async {
    await sharedPreferences.setBool(_onboardingKey, true);
  }
}