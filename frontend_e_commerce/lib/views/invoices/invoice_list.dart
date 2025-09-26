import 'package:flutter/material.dart';
import 'package:frontend_e_commerce/controllers/invoice_controller.dart';
import 'package:frontend_e_commerce/widgets/app_nav_bar.dart';
import 'package:frontend_e_commerce/widgets/invoice_card_widget.dart';
import 'package:frontend_e_commerce/widgets/pagination_widget.dart';
import 'package:provider/provider.dart';

class InvoiceListPage extends StatefulWidget {
  const InvoiceListPage({super.key});

  @override
  State<InvoiceListPage> createState() => _InvoiceListPageState();
}

class _InvoiceListPageState extends State<InvoiceListPage> {
  late TextEditingController _searchController;
  late InvoiceController invoiceController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    invoiceController = InvoiceController();
    _loadInvoices();
  }

  Future<void> _loadInvoices() async {
    try {
      await invoiceController.loadInvoices();
    } catch (e) {
      debugPrint("Error loading invoices: $e");
    }
  }

  void _searchInvoices() {
    final ctrl = context.read<InvoiceController>();
    final text = _searchController.text;

    if (text.isNotEmpty) {
      final customerId = int.tryParse(text);
      if (customerId != null) {
        ctrl.loadInvoicesByCustomerId(customerId);
      }
    } else {
      ctrl.loadInvoices(page: 1);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                      hintText: "Search invoices by Customer ID...",
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
                    keyboardType: TextInputType.number,
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
              child: ChangeNotifierProvider<InvoiceController>.value(
                value: invoiceController,
                child: Consumer<InvoiceController>(
                  builder: (context, controller, _) {
                    // Loading
                    if (invoiceController.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    // Error
                    if (invoiceController.errorMessage.isNotEmpty) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          invoiceController.errorMessage,
                          style: const TextStyle(color: Colors.red),
                        ),
                      );
                    }

                    // Empty
                    if (!invoiceController.isLoading &&
                        invoiceController.invoices.isEmpty) {
                      return const Center(child: Text("No invoices found"));
                    }

                    // Invoices list + pagination
                    return Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            itemCount: invoiceController.invoices.length,
                            itemBuilder: (_, index) {
                              final invoice = invoiceController.invoices[index];
                              return InvoiceCardWidget(
                                invoice: invoice,
                                onDelete: () => invoiceController.deleteInvoice(
                                  invoice.id!,
                                ),
                              );
                            },
                          ),
                        ),
                        PaginationWidget(controller: invoiceController),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
