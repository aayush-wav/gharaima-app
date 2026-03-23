import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'config/app_config.dart';
import 'config/theme.dart';
import 'providers/auth_provider.dart';
import 'screens/auth/phone_entry_screen.dart';
import 'screens/auth/otp_screen.dart';
import 'screens/auth/profile_setup_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'screens/categories/category_detail_screen.dart';
import 'screens/services/service_detail_screen.dart';
import 'screens/booking/booking_form_screen.dart';
import 'screens/booking/booking_confirmation_screen.dart';
import 'screens/bookings/my_bookings_screen.dart';
import 'screens/bookings/booking_detail_screen.dart';
import 'screens/profile/profile_screen.dart';
import 'screens/profile/edit_profile_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'screens/offers/offers_screen.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    final router = GoRouter(
      initialLocation: '/',
      redirect: (context, state) async {
        final prefs = await SharedPreferences.getInstance();
        final onboardingSeen = prefs.getBool('onboarding_seen') ?? false;

        if (!onboardingSeen) {
          if (state.matchedLocation != '/onboarding') return '/onboarding';
          return null;
        }

        final session = Supabase.instance.client.auth.currentSession;
        final guestMode = ref.watch(guestModeProvider);
        final loggedIn = session != null || guestMode;
        final isLoggingIn = state.matchedLocation.startsWith('/auth');

        if (!loggedIn && !isLoggingIn) return '/auth/phone';
        if (loggedIn && isLoggingIn) return '/home';

        return null;
      },
      routes: [
        GoRoute(
          path: '/onboarding',
          builder: (context, state) => const OnboardingScreen(),
        ),
        GoRoute(
          path: '/auth/phone',
          builder: (context, state) => const PhoneEntryScreen(),
        ),
        GoRoute(
          path: '/auth/otp',
          builder: (context, state) {
            final phone = state.extra as String? ?? '';
            return OTPScreen(phone: phone);
          },
        ),
        GoRoute(
          path: '/auth/setup',
          builder: (context, state) => const ProfileSetupScreen(),
        ),
        // Shell route for bottom nav
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) {
            return Scaffold(
              body: navigationShell,
              bottomNavigationBar: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(top: BorderSide(color: AppTheme.border, width: 0.5)),
                  boxShadow: const [AppTheme.softShadow],
                ),
                child: BottomNavigationBar(
                  currentIndex: navigationShell.currentIndex,
                  onTap: (index) => navigationShell.goBranch(index),
                  type: BottomNavigationBarType.fixed,
                  selectedItemColor: AppTheme.primary,
                  unselectedItemColor: AppTheme.textMuted,
                  selectedLabelStyle: AppTheme.textTheme.bodySmall?.copyWith(color: AppTheme.primary, fontWeight: FontWeight.bold),
                  unselectedLabelStyle: AppTheme.textTheme.bodySmall,
                  showSelectedLabels: true,
                  showUnselectedLabels: true,
                  items: const [
                    BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Home'),
                    BottomNavigationBarItem(icon: Icon(Icons.flash_on_rounded), label: 'Offers'),
                    BottomNavigationBarItem(icon: Icon(Icons.receipt_long_rounded), label: 'Activity'),
                    BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: 'Profile'),
                  ],
                ),
              ),
            );
          },
          branches: [
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/home',
                  builder: (context, state) => const HomeScreen(),
                  routes: [
                    GoRoute(
                      path: 'categories/:id',
                      builder: (context, state) {
                        final id = int.parse(state.pathParameters['id']!);
                        return CategoryDetailScreen(categoryId: id);
                      },
                    ),
                    GoRoute(
                      path: 'services/:id',
                      builder: (context, state) {
                        final id = int.parse(state.pathParameters['id']!);
                        return ServiceDetailScreen(serviceId: id);
                      },
                    ),
                    GoRoute(
                      path: 'booking',
                      builder: (context, state) => const BookingFormScreen(),
                    ),
                    GoRoute(
                      path: 'booking/confirm',
                      builder: (context, state) => const BookingConfirmationScreen(),
                    ),
                  ],
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/offers',
                  builder: (context, state) => const OffersScreen(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/bookings',
                  builder: (context, state) => const MyBookingsScreen(),
                  routes: [
                    GoRoute(
                      path: ':id',
                      builder: (context, state) {
                        final id = state.pathParameters['id']!;
                        return BookingDetailScreen(bookingId: id);
                      },
                    ),
                  ],
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/profile',
                  builder: (context, state) => const ProfileScreen(),
                  routes: [
                    GoRoute(
                      path: 'edit',
                      builder: (context, state) => const EditProfileScreen(),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        GoRoute(
          path: '/',
          redirect: (context, state) => '/home',
        ),
      ],
    );

    return MaterialApp.router(
      title: AppConfig.appName,
      theme: AppTheme.lightTheme,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
