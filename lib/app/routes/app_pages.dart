import 'package:flutter/cupertino.dart';

import 'package:get/get.dart';

import '../modules/botnavbar/bindings/botnavbar_binding.dart';
import '../modules/botnavbar/views/botnavbar_view.dart';
import '../modules/detail_food/bindings/detail_food_binding.dart';
import '../modules/detail_food/views/detail_food_view.dart';
import '../modules/forgot_password/bindings/forgot_password_binding.dart';
import '../modules/forgot_password/views/forgot_password_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/initialhealth/bindings/initialhealth_binding.dart';
import '../modules/initialhealth/views/initialhealth_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/meals/bindings/meals_binding.dart';
import '../modules/meals/views/meals_view.dart';
import '../modules/onboarding/bindings/onboarding_binding.dart';
import '../modules/onboarding/views/onboarding_view.dart';
import '../modules/register/bindings/register_binding.dart';
import '../modules/register/views/register_view.dart';
import '../modules/search_food/bindings/search_food_binding.dart';
import '../modules/search_food/views/search_food_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';

// ignore_for_file: constant_identifier_names

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: _Paths.ONBOARDING,
      page: () => const OnboardingView(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
      transition: Transition.downToUp,
      transitionDuration: Duration(milliseconds: 1200),
      curve: Curves.easeOut,
    ),
    GetPage(
      name: _Paths.REGISTER,
      page: () => const RegisterView(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: _Paths.INITIALHEALTH,
      page: () => const InitialhealthView(),
      binding: InitialhealthBinding(),
      transition: Transition.downToUp,
      transitionDuration: Duration(milliseconds: 1200),
      curve: Curves.easeOut,
    ),
    GetPage(
      name: _Paths.FORGOT_PASSWORD,
      page: () => const ForgotPasswordView(),
      binding: ForgotPasswordBinding(),
    ),
    GetPage(
      name: _Paths.BOTNAVBAR,
      page: () => const BotnavbarView(),
      binding: BotnavbarBinding(),
    ),
    GetPage(
      name: _Paths.SEARCH_FOOD,
      page: () => const SearchFoodView(),
      binding: SearchFoodBinding(),
    ),
    GetPage(
      name: _Paths.MEALS,
      page: () => const MealsView(),
      binding: MealsBinding(),
    ),
    GetPage(
      name: _Paths.DETAIL_FOOD,
      page: () => const DetailFoodView(),
      binding: DetailFoodBinding(),
    ),
  ];
}
