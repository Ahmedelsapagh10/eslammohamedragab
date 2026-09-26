import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/launcher.dart';
import '../../data/item_model.dart';
import 'custom_image.dart';

class PackagesSectionWidget extends StatelessWidget {
  const PackagesSectionWidget({
    super.key,
    required this.items,
  });

  final List<ItemModel> items;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const _PackagesEmptyState();
    }

    final isMobile = MediaQuery.of(context).size.width < 900;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      decoration: BoxDecoration(
        color: _FlatTokens.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _FlatTokens.border, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 10,
            runSpacing: 10,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: const [
              Text(
                'Featured Flutter Packages',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: _FlatTokens.text,
                  fontFamily: 'Nunito',
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _PackageFlatCard(
                item: item,
                isMobile: isMobile,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PackageFlatCard extends StatefulWidget {
  const _PackageFlatCard({
    required this.item,
    required this.isMobile,
  });

  final ItemModel item;
  final bool isMobile;

  @override
  State<_PackageFlatCard> createState() => _PackageFlatCardState();
}

class _PackageFlatCardState extends State<_PackageFlatCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final highlights = widget.item.highlights ?? const <String>[];

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: EdgeInsets.all(widget.isMobile ? 14 : 18),
        decoration: BoxDecoration(
          color: _FlatTokens.cardSurface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _hovered ? _FlatTokens.primary : _FlatTokens.border,
            width: 1.5,
          ),
        ),
        child: widget.isMobile
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _PackageImage(image: widget.item.image),
                  const SizedBox(height: 14),
                  _PackageDetails(
                    item: widget.item,
                    highlights: highlights,
                  ),
                ],
              )
            : Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(width: 2),
                  SizedBox(
                    width: 210,
                    child: _PackageImage(image: widget.item.image),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: _PackageDetails(
                      item: widget.item,
                      highlights: highlights,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class _PackageDetails extends StatelessWidget {
  const _PackageDetails({
    required this.item,
    required this.highlights,
  });

  final ItemModel item;
  final List<String> highlights;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(
              item.name,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: _FlatTokens.text,
                fontFamily: 'Nunito',
              ),
            ),
            const _FlatBadge(
              label: 'Flutter',
              color: _FlatTokens.successSoft,
              textColor: _FlatTokens.success,
            ),
            const _FlatBadge(
              label: 'WhatsApp API',
              color: _FlatTokens.warningSoft,
              textColor: _FlatTokens.warning,
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          _summary(item.description),
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 16,
            height: 1.45,
            color: _FlatTokens.neutralText,
            fontWeight: FontWeight.w500,
            fontFamily: 'Barlow',
          ),
        ),
        if (highlights.isNotEmpty) ...[
          const SizedBox(height: 14),
          ...highlights.take(4).map(
                (feature) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 2),
                        child: Icon(
                          Icons.check_circle_rounded,
                          size: 18,
                          color: _FlatTokens.success,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          feature,
                          style: const TextStyle(
                            fontSize: 14,
                            color: _FlatTokens.text,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Barlow',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
        ],
        const SizedBox(height: 14),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            if (item.url.isNotEmpty)
              _FlatActionButton(
                label: 'View on pub.dev',
                background: _FlatTokens.primary,
                foreground: Colors.white,
                borderColor: _FlatTokens.primary,
                onPressed: () => Launcher.open(item.url),
              ),
            if (item.docsLink != null && item.docsLink!.isNotEmpty)
              _FlatActionButton(
                label: 'Open Docs',
                background: _FlatTokens.cardSurface,
                foreground: _FlatTokens.text,
                borderColor: _FlatTokens.borderStrong,
                onPressed: () => Launcher.open(item.docsLink!),
              ),
          ],
        ),
      ],
    );
  }

  String _summary(String? description) {
    if (description == null || description.trim().isEmpty) {
      return 'No description available.';
    }

    final normalized = description
        .trim()
        .replaceAll('\n', ' ')
        .replaceAll(RegExp(r'\s+'), ' ');
    final dotIndex = normalized.indexOf('.');

    if (dotIndex > 0 && dotIndex < 180) {
      return normalized.substring(0, dotIndex + 1);
    }

    return normalized.length > 170
        ? '${normalized.substring(0, 167)}...'
        : normalized;
  }
}

class _PackageImage extends StatelessWidget {
  const _PackageImage({required this.image});

  final String image;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 120, maxHeight: 180),
      decoration: BoxDecoration(
        color: _FlatTokens.neutralSoft,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _FlatTokens.border),
      ),
      padding: const EdgeInsets.all(14),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: CustomImage(
          image: image,
          fit: BoxFit.contain,
          width: double.infinity,
          height: double.infinity,
        ),
      ),
    );
  }
}

class _FlatBadge extends StatelessWidget {
  const _FlatBadge({
    required this.label,
    required this.color,
    required this.textColor,
  });

  final String label;
  final Color color;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: 'Barlow',
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: textColor,
        ),
      ),
    );
  }
}

class _FlatActionButton extends StatelessWidget {
  const _FlatActionButton({
    required this.label,
    required this.background,
    required this.foreground,
    required this.borderColor,
    required this.onPressed,
  });

  final String label;
  final Color background;
  final Color foreground;
  final Color borderColor;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        backgroundColor: background,
        foregroundColor: foreground,
        side: BorderSide(color: borderColor, width: 1.4),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontFamily: 'Barlow',
          fontSize: 14,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _PackagesEmptyState extends StatelessWidget {
  const _PackagesEmptyState();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: _FlatTokens.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _FlatTokens.border, width: 1),
      ),
      child: const Text(
        'No packages yet.',
        style: TextStyle(
          fontFamily: 'Barlow',
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: _FlatTokens.neutralText,
        ),
      ),
    );
  }
}

class _FlatTokens {
  static const Color primary = AppColors.accent;
  static const Color success = Color(0xFF16A34A);
  static const Color warning = AppColors.accent;
  static const Color surface = AppColors.surface;
  static const Color cardSurface = Color(0xFF242424);
  static const Color text = AppColors.primary;
  static const Color neutralText = AppColors.secondary;
  static const Color border = Color(0xFF333333);
  static const Color borderStrong = Color(0xFF4A4A4A);
  static const Color neutralSoft = Color(0xFF171717);
  static const Color successSoft = Color(0xFF10341E);
  static const Color warningSoft =
      Color(0x1F00A8FF); // AppColors.accent with 0.12 opacity
}
