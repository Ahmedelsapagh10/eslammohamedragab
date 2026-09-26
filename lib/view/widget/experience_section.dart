import 'package:flutter/material.dart';
import '../../core/utils/launcher.dart';
import '../../core/theme/app_colors.dart';

class ExperienceSection extends StatelessWidget {
  final String title;
  final List<Map<String, String>> items;

  const ExperienceSection({
    super.key,
    required this.title,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width > 900;
    final isMobile = MediaQuery.of(context).orientation == Orientation.portrait;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: isMobile ? 24 : 32,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
              fontFamily: 'Barlow',
            ),
          ),
          SizedBox(height: isMobile ? 20 : 40),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];

              if (isDesktop) {
                return _buildDesktopTimelineRow(index, item, isMobile);
              } else {
                return _buildMobileTimelineRow(
                    index, item, index == items.length - 1, isMobile);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopTimelineRow(
      int index, Map<String, String> item, bool isMobile) {
    final isLeft = index % 2 == 0;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Left Content
          Expanded(
            child: isLeft
                ? Padding(
                    padding: const EdgeInsets.only(right: 20, bottom: 40),
                    child: _ExperienceCard(
                        title: title, item: item, isMobile: isMobile),
                  )
                : const SizedBox(),
          ),

          // Center Timeline
          SizedBox(
            width: 40,
            child: Column(
              children: [
                _TimelineNode(
                    title: title, isHovered: false), // Static node for now
                Expanded(
                  child: Container(
                    width: 2,
                    color: AppColors.primary.withValues(alpha: 0.2),
                  ),
                ),
              ],
            ),
          ),

          // Right Content
          Expanded(
            child: !isLeft
                ? Padding(
                    padding: const EdgeInsets.only(left: 20, bottom: 40),
                    child: _ExperienceCard(
                        title: title, item: item, isMobile: isMobile),
                  )
                : const SizedBox(),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileTimelineRow(
      int index, Map<String, String> item, bool isLast, bool isMobile) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Left Timeline
          SizedBox(
            width: 40,
            child: Column(
              children: [
                _TimelineNode(title: title, isHovered: false),
                Expanded(
                  child: isLast
                      ? const SizedBox()
                      : Container(
                          width: 2,
                          color: AppColors.primary.withValues(alpha: 0.2),
                        ),
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 20, bottom: 40),
              child:
                  _ExperienceCard(title: title, item: item, isMobile: isMobile),
            ),
          ),
        ],
      ),
    );
  }
}

class _TimelineNode extends StatelessWidget {
  final String title;
  final bool isHovered;

  const _TimelineNode({required this.title, required this.isHovered});

  @override
  Widget build(BuildContext context) {
    final isEducation = title == 'Education';

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: AppColors.surface,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.accent, width: 2),
        boxShadow: [
          BoxShadow(
            color: AppColors.accent.withValues(alpha: 0.3),
            blurRadius: 10,
            spreadRadius: 2,
          )
        ],
      ),
      child: Center(
        child: Icon(
          isEducation ? Icons.school : Icons.work,
          size: 20,
          color: AppColors.accent,
        ),
      ),
    );
  }
}

class _ExperienceCard extends StatefulWidget {
  final String title;
  final Map<String, String> item;
  final bool isMobile;

  const _ExperienceCard({
    required this.title,
    required this.item,
    this.isMobile = false,
  });

  @override
  State<_ExperienceCard> createState() => _ExperienceCardState();
}

class _ExperienceCardState extends State<_ExperienceCard> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isEducation = widget.title == 'Education';
    final role = isEducation ? widget.item['degree']! : widget.item['role']!;
    final company = isEducation ? '' : widget.item['company']!;
    final date = widget.item['date'] ?? '';
    final location = widget.item['location'] ?? '';
    final link = widget.item['link'];

    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.all(widget.isMobile ? 16 : 24),
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
          children: [
            // Header (Role + Company)
            Text(
              role,
              style: TextStyle(
                fontSize: widget.isMobile ? 16 : 20,
                fontWeight: FontWeight.bold,
                color: isHovered ? AppColors.accent : AppColors.primary,
                fontFamily: 'Barlow',
              ),
            ),
            if (company.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                company,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary.withValues(alpha: 0.8),
                  fontFamily: 'Barlow',
                ),
              ),
            ],
            const SizedBox(height: 16),

            // Metadata Badges (Date | Location)
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                if (date.isNotEmpty)
                  _Badge(
                    icon: Icons.calendar_today_outlined,
                    text: date,
                    isHovered: isHovered,
                  ),
                if (location.isNotEmpty)
                  _Badge(
                    icon: Icons.location_on_outlined,
                    text: location,
                    isHovered: isHovered,
                  ),
              ],
            ),
            const SizedBox(height: 16),

            // Description
            Text(
              widget.item['description']!,
              style: TextStyle(
                fontSize: widget.isMobile ? 14 : 16,
                height: 1.6,
                color: AppColors.secondary,
                fontFamily: 'Barlow',
              ),
            ),

            // Link Button
            if (link != null) ...[
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  onPressed: () {
                    if (link == 'Youtube') {
                      Launcher.open(
                          'https://www.youtube.com/channel/UCgEj5nlK8_5MrADHCzqOMUA?sub_confirmation=1');
                    } else if (link == 'GDSC') {
                      Launcher.open('https://gdsc.community.dev/');
                    }
                  },
                  icon: const Icon(Icons.link, size: 20),
                  label: Text('Visit $link'),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.accent,
                    padding: EdgeInsets.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              )
            ]
          ],
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool isHovered;

  const _Badge({
    required this.icon,
    required this.text,
    required this.isHovered,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isHovered
            ? AppColors.accent.withValues(alpha: 0.1)
            : AppColors.secondary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isHovered
              ? AppColors.accent.withValues(alpha: 0.3)
              : Colors.transparent,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon,
              size: 14,
              color: isHovered ? AppColors.accent : AppColors.secondary),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isHovered ? AppColors.accent : AppColors.secondary,
              fontFamily: 'Barlow',
            ),
          ),
        ],
      ),
    );
  }
}
