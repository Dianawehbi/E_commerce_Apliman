import 'package:flutter/material.dart';
import 'package:frontend_e_commerce/widgets/app_nav_bar.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppNavBar(title: "Dashboard"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Overview cards
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _buildOverviewCard(
                  context,
                  title: "Customers",
                  description: "Add, edit or view customers",
                  icon: Icons.people_alt_outlined,
                  color: Colors.blue.shade400,
                  onTap: () => context.go('/customers'),
                ),
                _buildOverviewCard(
                  context,
                  title: "Items",
                  description: "Manage your product catalog",
                  icon: Icons.shopping_bag_outlined,
                  color: Colors.orange.shade400,
                  onTap: () => context.go('/items'),
                ),
                _buildOverviewCard(
                  context,
                  title: "Invoices",
                  description: "View and manage all invoices",
                  icon: Icons.receipt_long_outlined,
                  color: Colors.green.shade400,
                  onTap: () => context.go('/invoices'),
                ),
                _buildOverviewCard(
                  context,
                  title: "Cart & Checkout",
                  description: "Manage pending orders",
                  icon: Icons.shopping_cart_outlined,
                  color: Colors.red.shade400,
                  onTap: () => context.go('/cart'),
                ),
              ],
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewCard(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 6,
        child: Container(
          width: 400,
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 40, color: color),
              const SizedBox(height: 16),
              Text(title),
              const SizedBox(height: 8),
              Text(
                description,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.grey[700]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
