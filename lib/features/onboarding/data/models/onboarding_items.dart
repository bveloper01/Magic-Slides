import '../../domain/entities/onboarding_info.dart';

class OnboardingItems {
  static List<OnboardingInfo> items = [
    OnboardingInfo(
      title: "Create Stunning Presentations",
      description: "Transform your ideas into beautiful slides with AI-powered magic",
      lottieAsset: "assets/lottie/presentation.json",
    ),
    OnboardingInfo(
      title: "Powered by AI",
      description: "Let artificial intelligence do the heavy lifting while you focus on your content",
      lottieAsset: "assets/lottie/ai.json",
    ),
  ];
}