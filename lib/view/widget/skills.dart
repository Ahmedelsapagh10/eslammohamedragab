import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../../core/theme/app_colors.dart';
import '../../data/content.dart';

class SkillsWidget extends StatelessWidget {
  const SkillsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = MediaQuery.of(context).orientation == Orientation.portrait;
    // Responsive column count
    final crossAxisCount = width > 1100
        ? 4
        : width > 800
            ? 3
            : width > 600
                ? 2
                : 1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            Content.skillsTitle,
            style: TextStyle(
              fontSize: isMobile ? 24 : 32,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
              fontFamily: 'Barlow',
            ),
          ),
        ),
        const SizedBox(height: 20),
        MasonryGridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: crossAxisCount,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          itemCount: Content.skills.length,
          itemBuilder: (context, index) {
            final entry = Content.skills.entries.elementAt(index);
            return _SkillCard(
              title: entry.key,
              skills: entry.value,
              icon: _getIconForCategory(entry.key),
            );
          },
        ),
      ],
    );
  }

  IconData _getIconForCategory(String category) {
    switch (category) {
      case 'Architecture & Design':
        return Icons.architecture;
      case 'Flutter & Dart':
        return Icons.flutter_dash;
      case 'State Management':
        return Icons.settings_input_component;
      case 'Testing & CI/CD':
        return Icons.bug_report;
      case 'Leadership':
        return Icons.groups;
      case 'Backend & Cloud':
        return Icons.cloud_queue;
      case 'Deployment':
        return Icons.rocket_launch;
      case 'Tools & Others':
        return Icons.build;
      default:
        return Icons.code;
    }
  }
}

class _SkillCard extends StatefulWidget {
  final String title;
  final List<String> skills;
  final IconData icon;

  const _SkillCard({
    required this.title,
    required this.skills,
    required this.icon,
  });

  @override
  State<_SkillCard> createState() => _SkillCardState();
}

class _SkillCardState extends State<_SkillCard> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.all(
            MediaQuery.of(context).orientation == Orientation.portrait
                ? 12
                : 16), // Reduced padding for compactness
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isHovered
                ? AppColors.accent
                : AppColors.secondary.withValues(alpha: 0.1),
            width: isHovered ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isHovered ? 0.15 : 0.05),
              blurRadius: isHovered ? 20 : 10,
              offset: Offset(0, isHovered ? 8 : 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isHovered
                        ? AppColors.accent.withValues(alpha: 0.2)
                        : AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    widget.icon,
                    size: 20,
                    color: isHovered ? AppColors.accent : AppColors.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    widget.title,
                    style: TextStyle(
                      fontSize: 18, // Slightly smaller title
                      fontWeight: FontWeight.bold,
                      color: isHovered ? AppColors.accent : AppColors.primary,
                      fontFamily: 'Barlow',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 6,
              runSpacing: 8,
              children: widget.skills.map((skill) {
                return Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.secondary.withValues(alpha: 0.15),
                    ),
                  ),
                  child: Text(
                    skill,
                    style: const TextStyle(
                      fontSize: 12, // Compact text
                      color: AppColors.secondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
