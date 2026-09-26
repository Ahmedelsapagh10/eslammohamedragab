import 'package:flutter/material.dart';

import 'package:myportfolio/core/utils/app_scroll_behavior.dart';
import 'package:myportfolio/core/utils/url_strategy.dart';

import 'core/theme/app_colors.dart';
import 'core/theme/app_theme.dart';
import 'core/widgets/responsive_widget.dart';
import 'view/pages/home_screen.dart';

void main() {
  configureUrlStrategy();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.dark;

  void _toggleThemeMode() {
    setState(() {
      _themeMode =
          _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ahmed Elsapagh',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _themeMode,
      debugShowCheckedModeBanner: false,
      scrollBehavior: AppScrollBehavior(),
      builder: (context, child) => _AppCursorOverlay(
        child: child ?? const SizedBox.shrink(),
      ),
      onGenerateRoute: _buildRoute,
    );
  }

  Route<void> _buildRoute(RouteSettings settings) {
    return PageRouteBuilder<void>(
      settings: settings,
      transitionDuration: Duration.zero,
      reverseTransitionDuration: Duration.zero,
      pageBuilder: (_, __, ___) => SelectionArea(
        child: HomeScreen(
          initialSection: _sectionFromRoute(settings.name),
          themeMode: _themeMode,
          onThemeToggle: _toggleThemeMode,
        ),
      ),
    );
  }

  String? _sectionFromRoute(String? routeName) {
    final route = (routeName ?? '/').split('?').first;
    switch (route) {
      case '/':
      case '/home':
        return null;
      case '/about':
        return 'about';
      case '/projects':
        return 'projects';
      case '/courses':
        return 'courses';
      case '/experience':
        return 'experience';
      case '/skills':
        return 'skills';
      case '/contact':
        return 'contact';
      default:
        return null;
    }
  }
}

class _AppCursorOverlay extends StatefulWidget {
  const _AppCursorOverlay({required this.child});

  final Widget child;

  @override
  State<_AppCursorOverlay> createState() => _AppCursorOverlayState();
}

class _AppCursorOverlayState extends State<_AppCursorOverlay> {
  Offset? _position;
  bool _visible = false;
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveWidget.isMobile(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accent = isDark ? AppColors.accent : AppColors.lightAccent;
    final ringShadow = isDark ? Colors.black : Colors.black26;

    return MouseRegion(
      cursor: SystemMouseCursors.none,
      onHover: (event) {
        if (isMobile) return;
        setState(() {
          _position = event.localPosition;
          _visible = true;
        });
      },
      onExit: (_) {
        setState(() {
          _visible = false;
        });
      },
      child: Listener(
        onPointerDown: isMobile ? null : (_) => setState(() => _pressed = true),
        onPointerUp: isMobile ? null : (_) => setState(() => _pressed = false),
        onPointerCancel:
            isMobile ? null : (_) => setState(() => _pressed = false),
        child: Stack(
          children: [
            widget.child,
            if (!isMobile && _visible && _position != null)
              Positioned.fill(
                child: IgnorePointer(
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      _CursorRing(
                        accent: accent,
                        shadow: ringShadow,
                        position: _position!,
                        pressed: _pressed,
                      ),
                      Positioned(
                        left: _position!.dx - 4,
                        top: _position!.dy - 4,
                        width: 8,
                        height: 8,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: accent,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: accent.withValues(alpha: 0.42),
                                blurRadius: 10,
                              ),
                            ],
                          ),
                        ),
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
}

class _CursorRing extends StatelessWidget {
  const _CursorRing({
    required this.accent,
    required this.shadow,
    required this.position,
    required this.pressed,
  });

  final Color accent;
  final Color shadow;
  final Offset position;
  final bool pressed;

  @override
  Widget build(BuildContext context) {
    final size = pressed ? 24.0 : 38.0;

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 90),
      curve: Curves.easeOutCubic,
      left: position.dx - size / 2,
      top: position.dy - size / 2,
      width: size,
      height: size,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        decoration: BoxDecoration(
          color: accent.withValues(alpha: pressed ? 0.08 : 0.04),
          shape: BoxShape.circle,
          border: Border.all(
            color: accent.withValues(alpha: pressed ? 0.62 : 0.78),
          ),
          boxShadow: [
            BoxShadow(
              color: shadow.withValues(alpha: pressed ? 0.12 : 0.2),
              blurRadius: pressed ? 10 : 18,
            ),
            BoxShadow(
              color: accent.withValues(alpha: pressed ? 0.14 : 0.22),
              blurRadius: pressed ? 12 : 20,
            ),
          ],
        ),
      ),
    );
  }
}
