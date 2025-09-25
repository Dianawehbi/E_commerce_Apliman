import 'package:flutter/material.dart';
import 'package:frontend_e_commerce/controllers/customer_controller.dart';
import 'package:frontend_e_commerce/views/customers/widgets/customer_card_widget.dart';
import 'package:frontend_e_commerce/widgets/app_nav_bar.dart';
import 'package:frontend_e_commerce/widgets/pagination_widget.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class CustomerList extends StatefulWidget {
  const CustomerList({super.key});

  @override
  State<CustomerList> createState() => _CustomerListState();
}

class _CustomerListState extends State<CustomerList> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();

    // load customers once
    Future.microtask(() {
      context.read<CustomerController>().loadCustomers();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<CustomerController>();

    return Scaffold(
      appBar: AppNavBar(title: "Customers"),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // add Customer & Search Row
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: () => context.go('/customers/add'),
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text("Add Customer"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: "Search customers by name...",
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.arrow_forward_ios, size: 16),
                        onPressed: () => controller.setSearchQuery(
                          _searchController.text,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onSubmitted: (_) =>
                        controller.setSearchQuery(_searchController.text),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // customer list
            Expanded(
              child: controller.isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : controller.customers.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.people_outline,
                                  size: 48, color: Colors.grey),
                              SizedBox(height: 8),
                              Text("No customers found."),
                            ],
                          ),
                        )
                      : ListView.separated(
                          itemCount: controller.customers.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 12),
                          itemBuilder: (_, index) {
                            final customer = controller.customers[index];
                            return CustomerCardWidget(onDelete: () => controller.deleteCustomer(customer.id), customer: customer,);
                          },
                        ),
            ),
            if (!controller.isLoading && controller.customers.isNotEmpty)
              PaginationWidget(controller: controller),
          ],
        ),
      ),
    );
  }
}
