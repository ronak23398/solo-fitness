// app_routes.dart
import 'package:get/get.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import 'package:solo_fitness/app/modules/auth/bindings/auth_bindings.dart';
import 'package:solo_fitness/app/modules/auth/views/login_view.dart';
import 'package:solo_fitness/app/modules/auth/views/signup_view.dart';
import 'package:solo_fitness/app/modules/death/bindings/death_binding.dart';
import 'package:solo_fitness/app/modules/death/views/death_view.dart';
import 'package:solo_fitness/app/modules/home/bindings/home_binding.dart';
import 'package:solo_fitness/app/modules/home/views/home_view.dart';
import 'package:solo_fitness/app/modules/level_up/bindings/levelup_bindings.dart';
import 'package:solo_fitness/app/modules/level_up/views/levelup_view.dart';
import 'package:solo_fitness/app/modules/penalty/bindings/penalty_binding.dart';
import 'package:solo_fitness/app/modules/penalty/views/penalty_view.dart';
import 'package:solo_fitness/app/modules/profile/bindings/profile_binding.dart';
import 'package:solo_fitness/app/modules/profile/views/profile_view.dart';
import 'package:solo_fitness/app/modules/splash_screen/splash_screen.dart';
import 'package:solo_fitness/app/modules/store/bindings/store_binding.dart';
import 'package:solo_fitness/app/modules/store/views/product_details.dart';
import 'package:solo_fitness/app/modules/store/views/store_view.dart';
import 'package:solo_fitness/app/modules/streak/bindings/streak_binding.dart';
import 'package:solo_fitness/app/modules/streak/views/streak_view.dart';

abstract class AppRoutes {
  // Auth routes
  static const SPLASH = '/splash';
  static const LOGIN = '/login';
  static const REGISTER = '/register';
  static const FORGOT_PASSWORD = '/forgot-password';

  // Main app routes
  static const HOME = '/home';
  static const PROFILE = '/profile';
  static const TASK_DETAILS = '/task-details';
  static const STATS = '/stats';
  static const SETTINGS = '/settings';

  // Special screens
  static const LEVEL_UP = '/level-up';
  static const CLASS_UPGRADE = '/class-upgrade';
  static const DEATH_SCREEN = '/death-screen';
  static const PENALTY_TASK = '/penalty';
  static const STREAKS = '/streaks';

  // Tutorial
  static const ONBOARDING = '/onboarding';

   // Store routes
  static const STORE = '/store';
  static const PRODUCT_DETAIL = '/product-detail';
  static const ADD_PRODUCT = '/add-product';
  static const BLACK_HEART = '/black-heart';
  
}

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.LOGIN,
      page: () => LoginView(),
      binding: AuthBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.REGISTER,
      page: () => RegisterView(),
      binding: AuthBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.PROFILE,
      page: () => ProfileView(),
      binding: ProfileBinding(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: AppRoutes.PENALTY_TASK,
      page: () => PenaltyView(),
      binding: PenaltyBinding(),
      transition: Transition.zoom,
    ),
    GetPage(
      name: AppRoutes.DEATH_SCREEN,
      page: () => DeathView(),
      binding: DeathBinding(),
      transition: Transition.fade,
      transitionDuration: Duration(milliseconds: 800),
    ),
    GetPage(
      name: AppRoutes.LEVEL_UP,
      page: () => LevelupView(),
      binding: LevelupBinding(),
      transition: Transition.fadeIn,
      transitionDuration: Duration(milliseconds: 600),
    ),
    GetPage(
      name: AppRoutes.STREAKS,
      page: () => StreakView(),
      binding: StreakBinding(),
      transition: Transition.rightToLeft,
    ),

    GetPage(
      name: AppRoutes.SPLASH,
      page: () => SplashScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.LEVEL_UP,
      page: () => LevelupView(),
      transition: Transition.fadeIn,
    ),
      GetPage(
      name: AppRoutes.STORE,
      page: () => const StoreView(),
      binding: StoreBinding(),
    ),
    GetPage(
      name: AppRoutes.PRODUCT_DETAIL,
      page: () => const ProductDetailView(),
      binding: StoreBinding(),
    )
    // Your other routes...

    // Additional routes can be added here
  ];
}
