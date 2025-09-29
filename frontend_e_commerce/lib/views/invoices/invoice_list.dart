import 'package:flutter/material.dart';
import 'package:frontend_e_commerce/controllers/invoice_controller.dart';
import 'package:frontend_e_commerce/widgets/app_nav_bar.dart';
import 'package:frontend_e_commerce/widgets/invoice_card_widget.dart';
import 'package:frontend_e_commerce/widgets/pagination_widget.dart';
import 'package:provider/provider.dart';

class InvoiceListPage extends StatelessWidget {
  const InvoiceListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) =>
          InvoiceController()..loadInvoices(), // load initial invoices
      child: const _InvoiceListPageBody(),
    );
  }
}

class _InvoiceListPageBody extends StatefulWidget {
  const _InvoiceListPageBody();

  @override
  State<_InvoiceListPageBody> createState() => _InvoiceListPageBodyState();
}

class _InvoiceListPageBodyState extends State<_InvoiceListPageBody> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  void _searchInvoices() {
    final controller = context.read<InvoiceController>();
    final text = _searchController.text.trim();

      controller.setSearchQuery(text);
  
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<InvoiceController>();

    return Scaffold(
      appBar: const AppNavBar(title: "Invoices"),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            // Search
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: "Search invoices by Customer's Name...",
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.arrow_forward_ios, size: 16),
                        onPressed: _searchInvoices,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onSubmitted: (_) => _searchInvoices(),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: _searchInvoices,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text("Search"),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Invoices list
            Expanded(
              child: Builder(
                builder: (_) {
                  if (controller.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (controller.errorMessage.isNotEmpty) {
                    return Center(
                      child: Text(
                        controller.errorMessage,
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  }

                  if (controller.invoices.isEmpty) {
                    return const Center(child: Text("No invoices found"));
                  }

                  return Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: controller.invoices.length,
                          itemBuilder: (_, index) {
                            final invoice = controller.invoices[index];
                            return InvoiceCardWidget(
                              invoice: invoice,
                              onDelete: () =>
                                  controller.deleteInvoice(invoice.id!),
                            );
                          },
                        ),
                      ),
                      PaginationWidget(controller: controller),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
