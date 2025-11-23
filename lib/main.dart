import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:magic_slides_app/core/themes/app_theme.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/bloc/auth_event.dart';
import 'features/auth/presentation/bloc/auth_state.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/onboarding/presentation/bloc/onboarding_bloc.dart';
import 'features/onboarding/presentation/bloc/onboarding_state.dart';
import 'features/onboarding/presentation/pages/onboarding_page.dart';
import 'features/onboarding/presentation/pages/splash_page.dart';
import 'features/presentation/presentation/bloc/presentation_bloc.dart';
import 'features/presentation/presentation/pages/home_page.dart';
import 'injection_container.dart' as di;

void main() async {
    await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: dotenv.env['URL']!,
    anonKey: dotenv.env['ANONKEY']!,
  );
  
  await di.init();
  
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final bool _isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => di.sl<OnboardingBloc>(),
        ),
        BlocProvider(
          create: (_) => di.sl<AuthBloc>(),
        ),
        BlocProvider(
          create: (_) => di.sl<PresentationBloc>(),
        ),
      ],
      child: MaterialApp(
        title: 'MagicSlides',
        debugShowCheckedModeBanner: false,
        theme: _isDarkMode ? AppTheme.darkTheme : AppTheme.lightTheme,
        home: const AppNavigator(),
      ),
    );
  }
}

class AppNavigator extends StatelessWidget {
  const AppNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingBloc, OnboardingState>(
      builder: (context, onboardingState) {
          // Showing the splash initially
        if (onboardingState is OnboardingInitial || 
            onboardingState is OnboardingLoading) {
          return const SplashPage();
        }
        
      // Showing the onboarding if not completed
        if (onboardingState is OnboardingNotCompleted) {
          return const OnboardingPage();
        }
        
            // Showing the auth flow if onboarding is completed
        if (onboardingState is OnboardingCompleted) {
          return BlocBuilder<AuthBloc, BlocAuthState>(
            builder: (context, authState) {
          // Checking the auth status when onboarding is completed
              if (authState is AuthInitial) {
                context.read<AuthBloc>().add(CheckAuthStatus());
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }
              
              if (authState is AuthAuthenticated) {
                return const HomePage();
              }
              
              return const LoginPage();
            },
          );
        }
        
        return const SplashPage();
      },
    );
  }
}

