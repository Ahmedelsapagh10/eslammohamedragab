import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../../core/theme/app_colors.dart';
import '../../core/widgets/particle_background.dart';
import '../../data/content.dart';
import 'hexagon_profile.dart';

class BioWidget extends StatefulWidget {
  const BioWidget({super.key});

  @override
  State<BioWidget> createState() => _BioWidgetState();
}

class _BioWidgetState extends State<BioWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  bool _showFullBio = false;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0, 0.5, curve: Curves.easeIn),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.95, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 1, curve: Curves.easeOut),
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    // Start animation after the first frame is rendered
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = constraints.maxWidth;
        final isMobile = cardWidth < 700;
        final isTablet = cardWidth >= 700 && cardWidth < 1100;
        final titleSize = _clamp(cardWidth * (isMobile ? 0.07 : 0.045), 28, 56);
        final bodySize = _clamp(cardWidth * 0.018, 14, 22);
        final avatarSize = isMobile
            ? _clamp(cardWidth * 0.44, 150, 190)
            : isTablet
                ? _clamp(cardWidth * 0.24, 180, 230)
                : _clamp(cardWidth * 0.2, 220, 290);
        final horizontalPadding = isMobile ? 16.0 : (isTablet ? 24.0 : 36.0);
        final verticalPadding = isMobile ? 18.0 : 26.0;
        final previewText = _createPreview(Content.bioSubtitle);
        final hasMoreText = previewText != Content.bioSubtitle;
        final bioText = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            DefaultTextStyle(
              style: TextStyle(
                fontSize: titleSize,
                fontFamily: 'Nunito',
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
                height: 1.18,
              ),
              child: AnimatedTextKit(
                repeatForever: false,
                pause: const Duration(seconds: 5),
                animatedTexts: [
                  TypewriterAnimatedText(
                    Content.bioTitle,
                    speed: const Duration(milliseconds: 70),
                  ),
                ],
              ),
            ),
            SizedBox(height: isMobile ? 12 : 16),
            SelectableText(
              isMobile && !_showFullBio ? previewText : Content.bioSubtitle,
              style: TextStyle(
                fontSize: bodySize,
                color: AppColors.secondary,
                height: 1.45,
              ),
              textAlign: TextAlign.left,
            ),
            if (isMobile && hasMoreText) ...[
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () => setState(() => _showFullBio = !_showFullBio),
                child: Text(
                  _showFullBio ? 'Show Less' : 'Read More',
                  style: const TextStyle(
                    fontSize: 15,
                    color: AppColors.accent,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ],
        );

        return AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: child,
                ),
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: AppColors.background,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.16),
                  blurRadius: 24,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: ParticleBackground(
                numberOfParticles: isMobile ? 22 : (isTablet ? 36 : 50),
                particleColor: AppColors.accent,
                lineColor: AppColors.accent,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding,
                    vertical: verticalPadding,
                  ),
                  child: Flex(
                    direction: isMobile ? Axis.vertical : Axis.horizontal,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: isMobile
                        ? CrossAxisAlignment.stretch
                        : CrossAxisAlignment.center,
                    children: [
                      if (isMobile)
                        bioText
                      else
                        Expanded(
                          flex: 7,
                          child: bioText,
                        ),
                      if (!isMobile) const SizedBox(width: 28),
                      Align(
                        alignment:
                            isMobile ? Alignment.center : Alignment.centerRight,
                        child: Container(
                          margin: EdgeInsets.only(
                            left: isMobile ? 0 : 6,
                            top: isMobile ? 18 : 0,
                          ),
                          child: HexagonProfile(
                            imagePath: 'assets/images/me3.jpg',
                            size: avatarSize,
                            sides: 42,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  double _clamp(double value, double min, double max) {
    return value.clamp(min, max).toDouble();
  }

  String _createPreview(String text, {int maxChars = 210}) {
    if (text.length <= maxChars) {
      return text;
    }

    final safeCutoff = text.lastIndexOf(' ', maxChars);
    final endIndex = safeCutoff > 0 ? safeCutoff : maxChars;
    return '${text.substring(0, endIndex)}…';
  }
}
