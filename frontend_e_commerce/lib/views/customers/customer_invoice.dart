import 'package:flutter/material.dart';
import 'package:frontend_e_commerce/controllers/invoice_controller.dart';
import 'package:frontend_e_commerce/models/invoice.dart';
import 'package:frontend_e_commerce/widgets/app_nav_bar.dart';
import 'package:frontend_e_commerce/widgets/invoice_card_widget.dart';
import 'package:provider/provider.dart';

class CustomerInvoicePage extends StatefulWidget {
  final int customerId;

  const CustomerInvoicePage({super.key, required this.customerId});

  @override
  State<CustomerInvoicePage> createState() => _CustomerInvoicePageState();
}

class _CustomerInvoicePageState extends State<CustomerInvoicePage> {
  late InvoiceController invoiceController;
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    invoiceController = InvoiceController();
    _searchController = TextEditingController();
    _loadInvoices();
  }

  Future<void> _loadInvoices() async {
    try {
      await invoiceController.loadInvoicesByCustomerId(widget.customerId);
    } catch (e) {
      debugPrint("Error loading invoices: $e");
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<InvoiceController>.value(
      value: invoiceController,
      child: Consumer<InvoiceController>(
        builder: (context, controller, _) {
          return Scaffold(
            appBar: AppNavBar(title: "Customer Invoices"),
            body: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  // Search Bar
                  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: "Search invoices...",
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.arrow_forward_ios, size: 16),
                        onPressed: () =>
                            controller.setSearchQuery(_searchController.text),
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
                    onSubmitted: (_) =>
                        controller.setSearchQuery(_searchController.text),
                  ),
                  const SizedBox(height: 12),

                  // Error Message
                  if (controller.errorMessage.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        controller.errorMessage,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),

                  // Loading / Empty / Data
                  Expanded(
                    child: controller.isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : controller.invoices.isEmpty
                        ? const Center(child: Text("No invoices found."))
                        : ListView.builder(
                            itemCount: controller.invoices.length,
                            itemBuilder: (context, index) {
                              final Invoice invoice =
                                  controller.invoices[index];

                              return InvoiceCardWidget(invoice: invoice ,onDelete: () => controller.deleteInvoice(invoice.id!),);
                            },
                          ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
