import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppNavBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const AppNavBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      elevation: 2,
      actions: [
        TextButton(
          onPressed: () => context.go('/'),
          child: const Text("Dashboard"),
        ),
        TextButton(
          onPressed: () => context.go('/customers'),
          child: const Text("Customers"),
        ),
        TextButton(
          onPressed: () => context.go('/items'),
          child: const Text("Items"),
        ),
        TextButton(
          onPressed: () => context.go('/invoices'),
          child: const Text("Invoices"),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
