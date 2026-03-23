import 'dart:ui';
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
import 'screens/notifications/notifications_screen.dart';

import 'package:hugeicons/hugeicons.dart';
import 'widgets/glass_card.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
          path: '/notifications',
          builder: (context, state) => const NotificationsScreen(),
        ),
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
            final isDark = Theme.of(context).brightness == Brightness.dark;
            final glassFill = isDark ? AppColorsDark.glassFill : AppColors.glassFill;

            return Scaffold(
              body: navigationShell,
              extendBody: true,
              bottomNavigationBar: Container(
                height: 84, // Extra space for pill and glass aesthetics
                decoration: BoxDecoration(
                  border: Border(top: BorderSide(color: (isDark ? AppColorsDark.border : AppColors.border), width: 0.5)),
                ),
                child: ClipRRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                    child: Container(
                      color: glassFill,
                      child: BottomNavigationBar(
                        currentIndex: navigationShell.currentIndex,
                        onTap: (index) => navigationShell.goBranch(index),
                        type: BottomNavigationBarType.fixed,
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        selectedItemColor: isDark ? AppColorsDark.primary : AppColors.primary,
                        unselectedItemColor: isDark ? AppColorsDark.textHint : AppColors.textHint,
                        selectedLabelStyle: AppTextStyles.labelSmall.copyWith(fontSize: 10, fontWeight: FontWeight.w600),
                        unselectedLabelStyle: AppTextStyles.labelSmall.copyWith(fontSize: 10, fontWeight: FontWeight.w400),
                        items: [
                          _buildNavItem(HugeIcons.strokeRoundedHome01, 'Home', 0, navigationShell.currentIndex, isDark),
                          _buildNavItem(HugeIcons.strokeRoundedTicket01, 'Offers', 1, navigationShell.currentIndex, isDark),
                          _buildNavItem(HugeIcons.strokeRoundedCalendar03, 'Activity', 2, navigationShell.currentIndex, isDark),
                          _buildNavItem(HugeIcons.strokeRoundedUser, 'Profile', 3, navigationShell.currentIndex, isDark),
                        ],
                      ),
                    ),
                  ),
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
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }

  BottomNavigationBarItem _buildNavItem(IconData icon, String label, int index, int current, bool isDark) {
    final isSelected = index == current;
    final color = isSelected 
        ? (isDark ? AppColorsDark.primary : AppColors.primary)
        : (isDark ? AppColorsDark.textHint : AppColors.textHint);
    
    return BottomNavigationBarItem(
      icon: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          HugeIcon(icon: icon, color: color, size: 22),
          const SizedBox(height: 4),
          if (isSelected)
            Container(
              width: 4,
              height: 4,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            )
          else
            const SizedBox(height: 4),
        ],
      ),
      label: label,
    );
  }
}
