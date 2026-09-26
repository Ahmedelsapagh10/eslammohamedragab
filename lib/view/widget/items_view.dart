import 'package:flutter/material.dart';

import '../../data/item_model.dart';
import '../../core/theme/app_colors.dart';
import 'project_card.dart';

class ItemsviewWidget extends StatelessWidget {
  const ItemsviewWidget({
    super.key,
    required this.items,
  });

  final List<ItemModel> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: MediaQuery.of(context).orientation == Orientation.landscape
          ? const EdgeInsets.all(12)
          : const EdgeInsets.all(0),
      margin: MediaQuery.of(context).orientation == Orientation.landscape
          ? const EdgeInsets.all(12)
          : const EdgeInsets.all(0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: AppColors.surface,
      ),
      child: GridView.builder(
          physics: const ClampingScrollPhysics(),
          itemCount: items.length,
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount:
                  MediaQuery.of(context).orientation == Orientation.landscape
                      ? 4
                      : 2,
              childAspectRatio: 3 / 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10),
          itemBuilder: ((context, index) {
            return ProjectCard(model: items[index]);
          })),
    );
  }
}
