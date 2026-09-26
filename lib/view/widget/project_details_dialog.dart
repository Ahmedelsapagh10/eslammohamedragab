import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/launcher.dart';
import '../../core/utils/smooth_scroll.dart';
import '../../data/item_model.dart';
import 'custom_image.dart';

class ProjectDetailsDialog extends StatefulWidget {
  const ProjectDetailsDialog({
    super.key,
    required this.model,
  });

  final ItemModel model;

  @override
  State<ProjectDetailsDialog> createState() => _ProjectDetailsDialogState();
}

class _ProjectDetailsDialogState extends State<ProjectDetailsDialog> {
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = _DialogColors.from(context);
    final width = MediaQuery.of(context).size.width;
    final isWide = width >= 860;

    return Center(
      child: Material(
        color: Colors.transparent,
        child: Padding(
          padding: EdgeInsets.all(width < 640 ? 14 : 34),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 980),
            child: ClipRect(
              child: BackdropFilter(
                filter: ui.ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                child: Container(
                  decoration: BoxDecoration(
                    color: colors.surface.withValues(alpha: 0.94),
                    border: Border.all(color: colors.border),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.32),
                        blurRadius: 42,
                        offset: const Offset(0, 24),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      SmoothScroll(
                        controller: _scrollController,
                        child: SingleChildScrollView(
                          controller: _scrollController,
                          physics: const BouncingScrollPhysics(),
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(
                              width < 640 ? 16 : 24,
                              width < 640 ? 58 : 24,
                              width < 640 ? 16 : 24,
                              width < 640 ? 18 : 24,
                            ),
                            child: isWide
                                ? Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        flex: 5,
                                        child: _ImagePanel(
                                          colors: colors,
                                          model: widget.model,
                                        ),
                                      ),
                                      const SizedBox(width: 26),
                                      Expanded(
                                        flex: 6,
                                        child: _DetailsPanel(
                                          colors: colors,
                                          model: widget.model,
                                        ),
                                      ),
                                    ],
                                  )
                                : Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      _ImagePanel(
                                          colors: colors, model: widget.model),
                                      const SizedBox(height: 22),
                                      _DetailsPanel(
                                          colors: colors, model: widget.model),
                                    ],
                                  ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 12,
                        right: 12,
                        child: Tooltip(
                          message: 'Close',
                          child: GestureDetector(
                            onTap: () => Navigator.of(context).pop(),
                            child: Container(
                              width: 42,
                              height: 42,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: colors.surfaceSoft,
                                border: Border.all(color: colors.border),
                              ),
                              child: Icon(
                                Icons.close_rounded,
                                color: colors.text,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ImagePanel extends StatelessWidget {
  const _ImagePanel({
    required this.colors,
    required this.model,
  });

  final _DialogColors colors;
  final ItemModel model;

  @override
  Widget build(BuildContext context) {
    final screenshots = model.screenshots ?? const <String>[];

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: colors.surfaceSoft,
        border: Border.all(color: colors.border),
      ),
      child: screenshots.isEmpty
          ? CustomImage(
              image: model.image,
              width: double.infinity,
              fit: BoxFit.fitWidth,
              alignment: Alignment.topCenter,
            )
          : AspectRatio(
              aspectRatio: 4 / 3,
              child: PageView.builder(
                itemCount: screenshots.length,
                itemBuilder: (context, index) {
                  return CustomImage(
                    image: screenshots[index],
                    width: double.infinity,
                    fit: BoxFit.fitWidth,
                    alignment: Alignment.topCenter,
                  );
                },
              ),
            ),
    );
  }
}

class _DetailsPanel extends StatelessWidget {
  const _DetailsPanel({
    required this.colors,
    required this.model,
  });

  final _DialogColors colors;
  final ItemModel model;

  @override
  Widget build(BuildContext context) {
    final actions = _actionsFor(model);
    final direction = _textDirection(model.description);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            if (model.googlePlay != null)
              _DialogChip(colors: colors, label: 'Google Play'),
            if (model.appleStore != null)
              _DialogChip(colors: colors, label: 'App Store'),
            if (model.huaweiStore != null)
              _DialogChip(colors: colors, label: 'AppGallery'),
            if (model.courseLink != null)
              _DialogChip(colors: colors, label: 'Course'),
            if (model.docsLink != null)
              _DialogChip(colors: colors, label: 'Docs'),
            if (model.youtubeLink != null)
              _DialogChip(colors: colors, label: 'YouTube'),
            if (model.url.isNotEmpty)
              _DialogChip(colors: colors, label: 'Live'),
          ],
        ),
        const SizedBox(height: 14),
        Text(
          model.name.trim(),
          textDirection: TextDirection.ltr,
          style: TextStyle(
            color: colors.text,
            fontFamily: 'Nunito-ExtraBold',
            fontSize: MediaQuery.of(context).size.width >= 640 ? 36 : 28,
            height: 1.05,
          ),
        ),
        const SizedBox(height: 16),
        _CaseStudyLabel(colors: colors, label: 'PROJECT OVERVIEW'),
        const SizedBox(height: 9),
        Text(
          model.description ?? 'No description available.',
          textDirection: direction,
          textAlign:
              direction == TextDirection.rtl ? TextAlign.right : TextAlign.left,
          style: TextStyle(
            color: colors.muted,
            fontSize: 16,
            height: 1.72,
            fontWeight: FontWeight.w500,
          ),
        ),
        if (model.highlights != null && model.highlights!.isNotEmpty) ...[
          const SizedBox(height: 20),
          _CaseStudyLabel(colors: colors, label: 'CONTRIBUTION & RESULTS'),
          const SizedBox(height: 12),
          for (final highlight in model.highlights!)
            Padding(
              padding: const EdgeInsets.only(bottom: 9),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.check_rounded, color: colors.accent, size: 18),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      highlight,
                      style: TextStyle(
                        color: colors.text,
                        height: 1.45,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
        if (actions.isNotEmpty) ...[
          const SizedBox(height: 24),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              for (final action in actions)
                _DialogActionButton(
                  colors: colors,
                  action: action,
                ),
            ],
          ),
        ],
      ],
    );
  }

  List<_DialogAction> _actionsFor(ItemModel model) {
    return [
      if (model.googlePlay != null)
        _DialogAction(
          label: 'Google Play',
          icon: Icons.android_rounded,
          url: model.googlePlay!,
          filled: true,
        ),
      if (model.appleStore != null)
        _DialogAction(
          label: 'App Store',
          icon: Icons.apple,
          url: model.appleStore!,
        ),
      if (model.huaweiStore != null)
        _DialogAction(
          label: 'AppGallery',
          icon: Icons.shopping_bag_outlined,
          url: model.huaweiStore!,
        ),
      if (model.courseLink != null)
        _DialogAction(
          label: 'Watch Course',
          icon: Icons.play_lesson_outlined,
          url: model.courseLink!,
          filled: true,
        ),
      if (model.youtubeLink != null)
        _DialogAction(
          label: 'Watch Video',
          icon: Icons.play_circle_outline_rounded,
          url: model.youtubeLink!,
          filled: true,
        ),
      if (model.docsLink != null)
        _DialogAction(
          label: 'Documentation',
          icon: Icons.menu_book_outlined,
          url: model.docsLink!,
        ),
      if (model.url.isNotEmpty)
        _DialogAction(
          label: 'View Project',
          icon: Icons.open_in_new_rounded,
          url: model.url,
        ),
    ];
  }
}

class _CaseStudyLabel extends StatelessWidget {
  const _CaseStudyLabel({required this.colors, required this.label});

  final _DialogColors colors;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 7, height: 7, color: colors.accent),
        const SizedBox(width: 9),
        Text(
          label,
          style: TextStyle(
            color: colors.text,
            fontFamily: 'Barlow',
            fontWeight: FontWeight.w900,
            letterSpacing: 1.4,
          ),
        ),
      ],
    );
  }
}

class _DialogActionButton extends StatefulWidget {
  const _DialogActionButton({
    required this.colors,
    required this.action,
  });

  final _DialogColors colors;
  final _DialogAction action;

  @override
  State<_DialogActionButton> createState() => _DialogActionButtonState();
}

class _DialogActionButtonState extends State<_DialogActionButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final background = widget.action.filled
        ? widget.colors.accent
        : (_hovered ? widget.colors.accentSoft : Colors.transparent);
    final foreground =
        widget.action.filled ? widget.colors.onAccent : widget.colors.text;

    return MouseRegion(
      cursor: SystemMouseCursors.none,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () => Launcher.open(widget.action.url),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
          decoration: BoxDecoration(
            color: background,
            border: Border.all(
              color: widget.action.filled
                  ? widget.colors.accent
                  : widget.colors.border,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(widget.action.icon, size: 18, color: foreground),
              const SizedBox(width: 8),
              Text(
                widget.action.label,
                style: TextStyle(
                  color: foreground,
                  fontFamily: 'Barlow',
                  fontWeight: FontWeight.w900,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DialogChip extends StatelessWidget {
  const _DialogChip({
    required this.colors,
    required this.label,
  });

  final _DialogColors colors;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
      decoration: BoxDecoration(
        color: colors.surfaceSoft,
        border: Border.all(color: colors.border),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: colors.muted,
          fontFamily: 'Barlow',
          fontWeight: FontWeight.w900,
          fontSize: 12,
        ),
      ),
    );
  }
}

class _DialogAction {
  const _DialogAction({
    required this.label,
    required this.icon,
    required this.url,
    this.filled = false,
  });

  final String label;
  final IconData icon;
  final String url;
  final bool filled;
}

class _DialogColors {
  const _DialogColors({
    required this.surface,
    required this.surfaceSoft,
    required this.text,
    required this.muted,
    required this.border,
    required this.accent,
    required this.accentSoft,
    required this.onAccent,
  });

  final Color surface;
  final Color surfaceSoft;
  final Color text;
  final Color muted;
  final Color border;
  final Color accent;
  final Color accentSoft;
  final Color onAccent;

  factory _DialogColors.from(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    if (isDark) {
      return const _DialogColors(
        surface: AppColors.surface,
        surfaceSoft: AppColors.surfaceElevated,
        text: AppColors.primary,
        muted: AppColors.secondary,
        border: AppColors.border,
        accent: AppColors.accent,
        accentSoft: AppColors.accentSoft,
        onAccent: Color(0xff061B2C),
      );
    }

    return const _DialogColors(
      surface: AppColors.lightSurface,
      surfaceSoft: Color(0xffF3EDE5),
      text: AppColors.lightText,
      muted: AppColors.lightMuted,
      border: AppColors.lightBorder,
      accent: AppColors.lightAccent,
      accentSoft: AppColors.lightAccentSoft,
      onAccent: Colors.white,
    );
  }
}

TextDirection _textDirection(String? text) {
  if (text == null) return TextDirection.ltr;
  return RegExp(r'[\u0600-\u06FF]').hasMatch(text)
      ? TextDirection.rtl
      : TextDirection.ltr;
}
