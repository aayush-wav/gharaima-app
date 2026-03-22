import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../config/theme.dart';
import '../../widgets/custom_button.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingData> _pages = [
    OnboardingData(
      title: 'Quality Services at Your Door',
      subtitle: 'Book trusted professionals for your home in minutes',
      color: Colors.red.shade100,
    ),
    OnboardingData(
      title: 'Track in Real Time',
      subtitle: 'Know exactly when your provider arrives',
      color: Colors.blue.shade100,
    ),
    OnboardingData(
      title: 'Pay Your Way',
      subtitle: 'Cash, eSewa, or Khalti — you choose',
      color: Colors.green.shade100,
    ),
  ];

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_seen', true);
    if (mounted) context.go('/auth/phone');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              onPageChanged: (index) => setState(() => _currentPage = index),
              itemCount: _pages.length,
              itemBuilder: (context, index) => _buildSlide(_pages[index]),
            ),
            
            // Skip Button
            if (_currentPage < 2)
              Positioned(
                top: 16,
                right: 24,
                child: TextButton(
                  onPressed: _completeOnboarding,
                  child: const Text('Skip', style: TextStyle(color: AppTheme.textSecondary)),
                ),
              ),
            
            // Bottom Controls
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(_pages.length, (index) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: index == _currentPage ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: index == _currentPage ? AppTheme.primary : AppTheme.border,
                        ),
                      )),
                    ),
                    const SizedBox(height: 40),
                    CustomButton(
                      text: _currentPage == 2 ? 'Get Started' : 'Next',
                      onPressed: () {
                        if (_currentPage < 2) {
                          _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
                        } else {
                          _completeOnboarding();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSlide(OnboardingData data) {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 250,
            width: double.infinity,
            decoration: BoxDecoration(
              color: data.color,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Center(
              child: Icon(Icons.home_repair_service, size: 100, color: AppTheme.primary), // TODO: Add illustrations
            ),
          ),
          const SizedBox(height: 40),
          Text(data.title, textAlign: TextAlign.center, style: AppTheme.textTheme.displayLarge),
          const SizedBox(height: 16),
          Text(data.subtitle, textAlign: TextAlign.center, style: AppTheme.textTheme.bodyLarge?.copyWith(color: AppTheme.textSecondary)),
        ],
      ),
    );
  }
}

class OnboardingData {
  final String title;
  final String subtitle;
  final Color color;

  OnboardingData({required this.title, required this.subtitle, required this.color});
}
