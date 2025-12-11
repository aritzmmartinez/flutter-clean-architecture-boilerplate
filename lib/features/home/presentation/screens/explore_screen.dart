import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';

/// Explore Screen - Placeholder for your custom content
///
/// TODO: Replace this screen with your own implementation
/// Examples:
/// - Product catalog
/// - Content discovery
/// - Search functionality
/// - Browse categories
class ExploreScreen extends ConsumerWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: AppTheme.isDarkMode(context)
                        ? AppTheme.color2.withValues(alpha: 0.2)
                        : AppTheme.color1,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Icon(
                    Icons.explore_outlined,
                    size: 60,
                    color: AppTheme.isDarkMode(context)
                        ? AppTheme.color1
                        : AppTheme.color5,
                  ),
                ),
                const SizedBox(height: 32),

                // Title
                Text(
                  'Explore',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),

                // Description
                Text(
                  'This is a placeholder screen.\nCustomize it according to your app needs.',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppTheme.getSecondaryTextColor(context),
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),

                // Suggestions
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppTheme.isDarkMode(context)
                          ? AppTheme.color3.withValues(alpha: 0.3)
                          : AppTheme.color2.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.lightbulb_outline,
                            size: 20,
                            color: AppTheme.isDarkMode(context)
                                ? AppTheme.color1
                                : AppTheme.color5,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Ideas for this screen',
                            style:
                                Theme.of(context).textTheme.titleSmall?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _buildSuggestion(context, 'Product catalog'),
                      _buildSuggestion(context, 'Content search'),
                      _buildSuggestion(context, 'Activity feed'),
                      _buildSuggestion(context, 'Browse categories'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSuggestion(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        children: [
          Icon(
            Icons.arrow_right,
            size: 16,
            color: AppTheme.getSecondaryTextColor(context),
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.getSecondaryTextColor(context),
                ),
          ),
        ],
      ),
    );
  }
}
