import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../data/item_model.dart';
import 'course_card.dart';

class CoursesViewWidget extends StatefulWidget {
  final List<ItemModel> items;

  const CoursesViewWidget({
    super.key,
    required this.items,
  });

  @override
  State<CoursesViewWidget> createState() => _CoursesViewWidgetState();
}

class _CoursesViewWidgetState extends State<CoursesViewWidget> {
  static const int _virtualItemCount = 100000;
  late final PageController _pageController;
  late final int _initialPage;

  @override
  void initState() {
    super.initState();
    final length = widget.items.isEmpty ? 1 : widget.items.length;
    final middle = _virtualItemCount ~/ 2;
    _initialPage = middle - (middle % length);

    _pageController = PageController(
      viewportFraction: 0.66,
      initialPage: _initialPage,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final carouselHeight = width < 700 ? 320.0 : 460.0;
    final showIndicators = widget.items.length > 1;

    if (widget.items.isEmpty) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: carouselHeight + (showIndicators ? 28 : 0),
      child: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: widget.items.length == 1 ? 1 : _virtualItemCount,
              padEnds: true,
              physics: const BouncingScrollPhysics(),
              pageSnapping: true,
              itemBuilder: (context, index) {
                final realIndex = index % widget.items.length;

                return AnimatedBuilder(
                  animation: _pageController,
                  child: CourseCard(model: widget.items[realIndex]),
                  builder: (context, child) {
                    final page = _pageController.hasClients
                        ? (_pageController.page ??
                            _pageController.initialPage.toDouble())
                        : _pageController.initialPage.toDouble();

                    final distance = (page - index).abs().clamp(0.0, 1.0);

                    final scale = lerpDouble(1.0, 0.82, distance)!;
                    final saturation = lerpDouble(1.0, 0.55, distance)!;
                    final overlayOpacity = lerpDouble(0.0, 0.22, distance)!;
                    final shadowOpacity = lerpDouble(0.35, 0.14, distance)!;
                    final blur = lerpDouble(24.0, 12.0, distance)!;

                    return Center(
                      child: Transform.scale(
                        scale: scale,
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(22),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black
                                    .withValues(alpha: shadowOpacity),
                                blurRadius: blur,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(22),
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                ColorFiltered(
                                  colorFilter: ColorFilter.matrix(
                                      _saturationMatrix(saturation)),
                                  child: child,
                                ),
                                IgnorePointer(
                                  child: Container(
                                    color: Colors.black
                                        .withValues(alpha: overlayOpacity),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          if (showIndicators) ...[
            const SizedBox(height: 6),
            AnimatedBuilder(
              animation: _pageController,
              builder: (context, _) {
                final page = _pageController.hasClients
                    ? (_pageController.page ??
                        _pageController.initialPage.toDouble())
                    : _pageController.initialPage.toDouble();
                final activeIndex =
                    _normalizeIndex(page.round(), widget.items.length);

                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    widget.items.length,
                    (index) {
                      final isActive = index == activeIndex;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 240),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        height: 6,
                        width: isActive ? 20 : 6,
                        decoration: BoxDecoration(
                          color: isActive
                              ? AppColors.accent
                              : Colors.white.withValues(alpha: 0.25),
                          borderRadius: BorderRadius.circular(20),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ],
      ),
    );
  }

  int _normalizeIndex(int value, int length) {
    return ((value % length) + length) % length;
  }

  List<double> _saturationMatrix(double saturation) {
    final invSat = 1 - saturation;
    final r = 0.213 * invSat;
    final g = 0.715 * invSat;
    final b = 0.072 * invSat;

    return <double>[
      r + saturation,
      g,
      b,
      0,
      0,
      r,
      g + saturation,
      b,
      0,
      0,
      r,
      g,
      b + saturation,
      0,
      0,
      0,
      0,
      0,
      1,
      0,
    ];
  }
}
