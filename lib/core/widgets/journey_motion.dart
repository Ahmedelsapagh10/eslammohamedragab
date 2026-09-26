import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Shared scroll state for the portfolio journey.
class JourneyScrollState extends ChangeNotifier {
  JourneyScrollState(this.controller);

  final ScrollController controller;
  final Map<String, GlobalKey> _sections = <String, GlobalKey>{};

  String activeSection = 'about';
  double pageProgress = 0;
  final Map<String, double> sectionProgress = <String, double>{};

  void register(String id, GlobalKey key) {
    _sections[id] = key;
    sectionProgress.putIfAbsent(id, () => 0);
  }

  void attach() => controller.addListener(update);

  void detach() => controller.removeListener(update);

  void update() {
    if (!controller.hasClients) return;
    final position = controller.position;
    final nextPageProgress = position.maxScrollExtent <= 0
        ? 0.0
        : (position.pixels / position.maxScrollExtent).clamp(0.0, 1.0);
    final viewportHeight = position.viewportDimension;
    String nextActive = activeSection;
    var bestDistance = double.infinity;
    var changed = (nextPageProgress - pageProgress).abs() > 0.001;
    pageProgress = nextPageProgress;

    for (final entry in _sections.entries) {
      final context = entry.value.currentContext;
      final renderObject = context?.findRenderObject();
      if (renderObject is! RenderBox || !renderObject.attached) continue;
      final top = renderObject.localToGlobal(Offset.zero).dy;
      final height = math.max(renderObject.size.height, 1.0);
      final bottom = top + height;
      final visible = (math.min(bottom, viewportHeight) - math.max(top, 0.0))
          .clamp(0.0, math.min(height, viewportHeight));
      final progress =
          (visible / math.min(height, viewportHeight)).clamp(0.0, 1.0);
      if ((progress - (sectionProgress[entry.key] ?? 0)).abs() > 0.01) {
        sectionProgress[entry.key] = progress;
        changed = true;
      }

      final distance = (top - viewportHeight * 0.28).abs();
      if (bottom > viewportHeight * 0.18 &&
          top < viewportHeight * 0.72 &&
          distance < bestDistance) {
        bestDistance = distance;
        nextActive = entry.key;
      }
    }

    if (nextActive != activeSection) {
      activeSection = nextActive;
      changed = true;
    }
    if (changed) notifyListeners();
  }
}

class JourneyReveal extends StatefulWidget {
  const JourneyReveal({
    super.key,
    required this.controller,
    required this.child,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 560),
    this.offset = const Offset(0, 26),
    this.scaleFrom = 0.985,
  });

  final ScrollController controller;
  final Widget child;
  final Duration delay;
  final Duration duration;
  final Offset offset;
  final double scaleFrom;

  @override
  State<JourneyReveal> createState() => _JourneyRevealState();
}

class _JourneyRevealState extends State<JourneyReveal> {
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_checkVisibility);
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkVisibility());
  }

  @override
  void didUpdateWidget(covariant JourneyReveal oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_checkVisibility);
      widget.controller.addListener(_checkVisibility);
    }
  }

  void _checkVisibility() {
    if (_visible || !mounted) return;
    final renderObject = context.findRenderObject();
    if (renderObject is! RenderBox || !renderObject.attached) return;
    final viewport = MediaQuery.sizeOf(context).height;
    final top = renderObject.localToGlobal(Offset.zero).dy;
    if (top < viewport * 0.88 && top + renderObject.size.height > 0) {
      Future<void>.delayed(widget.delay, () {
        if (mounted) setState(() => _visible = true);
      });
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_checkVisibility);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reduceMotion =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    final visible = _visible || reduceMotion;
    return AnimatedOpacity(
      opacity: visible ? 1 : 0,
      duration: reduceMotion ? Duration.zero : widget.duration,
      curve: Curves.easeOutCubic,
      child: AnimatedSlide(
        offset: visible ? Offset.zero : widget.offset,
        duration: reduceMotion ? Duration.zero : widget.duration,
        curve: Curves.easeOutCubic,
        child: AnimatedScale(
          scale: visible ? 1 : widget.scaleFrom,
          duration: reduceMotion ? Duration.zero : widget.duration,
          curve: Curves.easeOutCubic,
          child: widget.child,
        ),
      ),
    );
  }
}

class PointerTilt extends StatefulWidget {
  const PointerTilt({
    super.key,
    required this.child,
    this.maxTilt = 0.018,
    this.onHoverChanged,
    this.cursor = MouseCursor.defer,
  });

  final Widget child;
  final double maxTilt;
  final ValueChanged<bool>? onHoverChanged;
  final MouseCursor cursor;

  @override
  State<PointerTilt> createState() => _PointerTiltState();
}

class _PointerTiltState extends State<PointerTilt> {
  Offset _position = Offset.zero;

  @override
  Widget build(BuildContext context) {
    final disabled = MediaQuery.sizeOf(context).width < 720 ||
        (MediaQuery.maybeOf(context)?.disableAnimations ?? false);
    return MouseRegion(
      cursor: widget.cursor,
      onEnter: (_) => widget.onHoverChanged?.call(true),
      onExit: (_) {
        widget.onHoverChanged?.call(false);
        setState(() => _position = Offset.zero);
      },
      onHover: disabled
          ? null
          : (event) {
              final box = context.findRenderObject() as RenderBox?;
              if (box == null) return;
              final local = box.globalToLocal(event.position);
              setState(() {
                _position = Offset(
                  (local.dx / box.size.width - .5) * 2,
                  (local.dy / box.size.height - .5) * 2,
                );
              });
            },
      child: TweenAnimationBuilder<Offset>(
        tween: Tween(end: disabled ? Offset.zero : _position),
        duration: const Duration(milliseconds: 160),
        curve: Curves.easeOut,
        builder: (context, value, child) => Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateX(-value.dy * widget.maxTilt)
            ..rotateY(value.dx * widget.maxTilt),
          child: child,
        ),
        child: widget.child,
      ),
    );
  }
}

class AnimatedCountText extends StatelessWidget {
  const AnimatedCountText({
    super.key,
    required this.value,
    required this.enabled,
    required this.style,
  });

  final String value;
  final bool enabled;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    final match = RegExp(r'^(\d+)(.*)$').firstMatch(value);
    final reduceMotion =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    if (match == null || reduceMotion) return Text(value, style: style);
    final target = int.parse(match.group(1)!);
    final suffix = match.group(2)!;
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: enabled ? target.toDouble() : 0),
      duration: const Duration(milliseconds: 900),
      curve: Curves.easeOutCubic,
      builder: (_, count, __) => Text('${count.round()}$suffix', style: style),
    );
  }
}
