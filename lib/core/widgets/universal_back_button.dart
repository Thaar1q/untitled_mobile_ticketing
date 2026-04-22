import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../navigation/app_routes.dart';

class UniversalBackButton extends StatelessWidget {
  const UniversalBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'Kembali',
      icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
      onPressed: () {
        if (context.canPop()) {
          context.pop();
          return;
        }
        context.go(AppRoutes.dashboard);
      },
    );
  }
}
