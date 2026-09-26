import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// A utility widget that provides smooth, fluid scrolling for mouse wheel events
/// on Flutter Web, mimicking the behavior of native browser scrolling in
/// frameworks like React or Next.js.
class SmoothScroll extends StatefulWidget {
  final Widget child;
  final ScrollController controller;
  final double scrollSpeed;
  final int scrollDuration;
  final Curve curve;

  const SmoothScroll({
    super.key,
    required this.child,
    required this.controller,
    this.scrollSpeed = 130,
    this.scrollDuration = 380,
    this.curve = Curves.easeOutQuart,
  });

  @override
  State<SmoothScroll> createState() => _SmoothScrollState();
}

class _SmoothScrollState extends State<SmoothScroll> {
  double _scrollTarget = 0;

  @override
  void initState() {
    super.initState();
    // Initialize target to current position after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.controller.hasClients) {
        _scrollTarget = widget.controller.offset;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerSignal: (pointerSignal) {
        if (pointerSignal is PointerScrollEvent) {
          if (!widget.controller.hasClients) return;

          // Sync target if manual scrolling or other events moved the controller
          // significantly away from our tracked target.
          final currentOffset = widget.controller.offset;
          if ((_scrollTarget - currentOffset).abs() > 50) {
            _scrollTarget = currentOffset;
          }

          // Calculate new target based on scroll delta
          final double newScroll = _scrollTarget + pointerSignal.scrollDelta.dy;
          
          // Clamp target to valid scroll range
          final maxExtent = widget.controller.position.maxScrollExtent;
          _scrollTarget = newScroll.clamp(0.0, maxExtent);

          // Animate to the new target
          widget.controller.animateTo(
            _scrollTarget,
            duration: Duration(milliseconds: widget.scrollDuration),
            curve: widget.curve,
          );
        }
      },
      child: widget.child,
    );
  }
}
