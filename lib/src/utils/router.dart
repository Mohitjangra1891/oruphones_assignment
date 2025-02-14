// Create keys for `root` & `section` navigator avoiding unnecessary rebuilds
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:oruphones_assignment/src/features/auth/views/addNameScreen.dart';
import 'package:oruphones_assignment/src/features/home/homeScreen.dart';

import '../common/views/splashScreen.dart';
import '../features/auth/views/loginScreen.dart';
import '../features/auth/views/verifyOtp_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _sectionNavigatorKey = GlobalKey<NavigatorState>();

class routeNames {
  static String splash = '/splash';
  static String home = '/home';
  static String LoginScreen = '/LoginScreen';
  static String verifyOtp = '/verifyOtp';
  static String addUserName = '/addUserName';
}

final GoRouter router = GoRouter(
  initialLocation: routeNames.splash,
  routes: [
    GoRoute(
      name: routeNames.splash,
      path: routeNames.splash,
      builder: (BuildContext context, GoRouterState state) {
        return SplashScreen();
      },
    ),  GoRoute(
      name: routeNames.LoginScreen,
      path: routeNames.LoginScreen,
      builder: (BuildContext context, GoRouterState state) {
        return LoginScreen();
      },
    ),GoRoute(
      name: routeNames.verifyOtp,
      path: routeNames.verifyOtp,
      builder: (BuildContext context, GoRouterState state) {
        return OtpVerificationScreen(phoneNumber: '91-830721891',);
      },
    ),GoRoute(
      name: routeNames.addUserName,
      path: routeNames.addUserName,
      builder: (BuildContext context, GoRouterState state) {
        return addNameScreen();
      },
    ),

    ///Orders Tab
    GoRoute(
      path: routeNames.home,
      builder: (context, state) => homeScreen(),
      routes: <RouteBase>[
        GoRoute(
          path: routeNames.addUserName,
          builder: (context, state) => addNameScreen(),
        ),
      ],
    ),
    //
    // ///Menu Tab
    // GoRoute(path: '/menu', builder: (context, state) => menu_screen(), routes: <RouteBase>[
    //   GoRoute(
    //     path: 'addNewItem',
    //     builder: (context, state) => add_new_item_screen(),
    //   ),
    //   GoRoute(
    //     path: 'itemAdded',
    //     builder: (context, state) => item_added_successfully(),
    //   ),
    // ]),
    //
    // ///Analytics Tab
    // GoRoute(path: '/analytics', builder: (context, state) => const analytics_screen(), routes: <RouteBase>[
    //   GoRoute(
    //     path: 'insights',
    //     builder: (context, state) => const insights_screen(),
    //   ),
    //   GoRoute(
    //     path: 'growth',
    //     builder: (context, state) => const growth_screen(),
    //   ),
    //   GoRoute(
    //     path: 'customer',
    //     builder: (context, state) => const customer_feedback_analysis_screen(),
    //   ),
    // ]),
    //
    // // /Account Tab
    // GoRoute(
    //   path: '/account',
    //   builder: (context, state) => const account_screen(),
    //   routes: <RouteBase>[
    //     GoRoute(
    //       path: 'setting',
    //       builder: (context, state) => const settings_screen(),
    //       routes: <RouteBase>[
    //         GoRoute(
    //           path: 'delete_account',
    //           builder: (context, state) => const delete_account_screen(),
    //         )
    //       ],
    //     )
    //   ],
    // ),
  ],
);
