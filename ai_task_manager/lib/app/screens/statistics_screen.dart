import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/stat_card.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              const Text(
                'Statistics',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Track your productivity',
                style: TextStyle(
                  fontSize: 15,
                  color: AppColors.textSecondary,
                ),
              ),

              const SizedBox(height: 24),

              // Weekly overview header
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primary, AppColors.primaryLight],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'This Week',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Row(
                      children: [
                        Text(
                          '78%',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 42,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -1,
                          ),
                        ),
                        SizedBox(width: 8),
                        Text(
                          'completion\nrate',
                          style: TextStyle(
                            color: Colors.white60,
                            fontSize: 13,
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Mini bar chart
                    Row(
                      children: List.generate(7, (i) {
                        final heights = [0.4, 0.7, 0.5, 0.9, 0.6, 0.8, 0.3];
                        final days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
                        final isToday = i == 4;
                        return Expanded(
                          child: Column(
                            children: [
                              Container(
                                height: 80,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 3),
                                alignment: Alignment.bottomCenter,
                                child: AnimatedContainer(
                                  duration: Duration(milliseconds: 300 + i * 50),
                                  height: 80 * heights[i],
                                  decoration: BoxDecoration(
                                    color: isToday
                                        ? Colors.white
                                        : Colors.white
                                            .withValues(alpha: 0.3),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                days[i],
                                style: TextStyle(
                                  color: isToday
                                      ? Colors.white
                                      : Colors.white60,
                                  fontSize: 11,
                                  fontWeight: isToday
                                      ? FontWeight.w700
                                      : FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Stats grid
              Row(
                children: [
                  Expanded(
                    child: StatCard(
                      title: 'Completed',
                      value: '24',
                      subtitle: '+15%',
                      icon: Icons.check_circle_outline_rounded,
                      color: AppColors.success,
                      progress: 0.78,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: StatCard(
                      title: 'Pending',
                      value: '7',
                      subtitle: '-3',
                      icon: Icons.pending_outlined,
                      color: AppColors.warning,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: StatCard(
                      title: 'Focus Time',
                      value: '12h',
                      subtitle: 'This week',
                      icon: Icons.timer_outlined,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: StatCard(
                      title: 'Streak',
                      value: '5',
                      subtitle: 'Days',
                      icon: Icons.local_fire_department_rounded,
                      color: AppColors.error,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Category breakdown
              const Text(
                'By Category',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),

              _buildCategoryBar('Work', 0.45, AppColors.categoryWork, '12'),
              _buildCategoryBar(
                  'Personal', 0.25, AppColors.categoryPersonal, '6'),
              _buildCategoryBar(
                  'Health', 0.15, AppColors.categoryHealth, '4'),
              _buildCategoryBar('Study', 0.10, AppColors.categoryStudy, '3'),
              _buildCategoryBar(
                  'Shopping', 0.05, AppColors.categoryShopping, '1'),

              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryBar(
      String label, double progress, Color color, String count) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
                const Spacer(),
                Text(
                  '$count tasks',
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: color.withValues(alpha: 0.12),
                valueColor: AlwaysStoppedAnimation<Color>(color),
                minHeight: 6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
