import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

Widget myButton(
    {required BuildContext context,
    required String buttonName,
    required Function() onTap}) {
  final width = MediaQuery.of(context).size.width;
  final isMobile = width < 700;
  return InkWell(
    onTap: onTap,
    child: Container(
      alignment: Alignment.center,
      width: width / 2,
      height: isMobile ? 36 : 50,
      decoration: BoxDecoration(
        color: AppColors.accent,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        buttonName,
        style: TextStyle(
          fontWeight: isMobile ? FontWeight.w600 : FontWeight.bold,
          color: Colors.white,
          fontSize: isMobile ? 16 : 24,
        ),
      ),
    ),
  );
}

Widget spaceWidget({required BuildContext context}) {
  final width = MediaQuery.of(context).size.width;
  if (width >= 1100) {
    return const SizedBox(height: 50);
  }
  if (width >= 700) {
    return const SizedBox(height: 36);
  }
  return SizedBox(
    height: 20,
  );
}

Widget space2Widget({required BuildContext context}) {
  final width = MediaQuery.of(context).size.width;
  if (width >= 700) {
    return const SizedBox(width: 10);
  }
  return SizedBox(
    width: 5,
  );
}

Widget myIconLink(
    {required BuildContext context,
    required Function() onTap,
    required String image}) {
  final width = MediaQuery.of(context).size.width;
  return InkWell(
      onTap: onTap,
      child: SizedBox(
        width: width >= 700 ? 38 : 28,
        child: Image.asset(
          image,
        ),
      ));
}
