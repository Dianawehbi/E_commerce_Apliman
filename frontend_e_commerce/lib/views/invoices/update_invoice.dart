import 'package:flutter/material.dart';
import 'package:frontend_e_commerce/controllers/invoice_controller.dart';
import 'package:frontend_e_commerce/models/invoice.dart';
import 'package:frontend_e_commerce/models/invoice_items.dart';
import 'package:frontend_e_commerce/widgets/app_nav_bar.dart';
import 'package:provider/provider.dart';

class UpdateInvoicePage extends StatefulWidget {
  final int invoiceId;

  const UpdateInvoicePage({super.key, required this.invoiceId});

  @override
  State<UpdateInvoicePage> createState() => _UpdateInvoicePageState();
}

class _UpdateInvoicePageState extends State<UpdateInvoicePage> {
  late InvoiceController invoiceController;

  // ignore: non_constant_identifier_names
  late List<InvoiceItems> updated_items_list;
  late Invoice invoice;

  bool _isLoading = true;
  String errorMessage = '';

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final invoiceController = context.read<InvoiceController>();
    updated_items_list = [];

    try {
      var fetchedInvoice = await invoiceController.getInvoiceById(
        widget.invoiceId,
      );

      if (fetchedInvoice == null) {
        setState(() {
          errorMessage = "Invoice not found";
          _isLoading = false;
        });
        return;
      }

      setState(() {
        // ignore: non_constant_identifier_names
        for (var invoice_item in fetchedInvoice.invoiceItems.toList()) {
          updated_items_list.add(
            InvoiceItems(
              itemId: invoice_item.item?.id,
              quantity: invoice_item.quantity,
              unitPrice: invoice_item.unitPrice,
              item: invoice_item.item
            ),
          );
        }
        invoice = fetchedInvoice;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = "Failed to load invoice: $e";
        _isLoading = false;
      });
    }
  }

  void _increaseQuantity(int index) {
    setState(() {
      updated_items_list[index].quantity++;
    });
  }

  void _decreaseQuantity(int index) {
    setState(() {
      if (updated_items_list[index].quantity > 1) {
        updated_items_list[index].quantity--;
      }
    });
  }

  void _removeItem(int index) {
    setState(() {
      updated_items_list.removeAt(index);
    });
  }

  Future<void> _saveInvoice() async {
    final invoiceController = context.read<InvoiceController>();

    final updatedInvoice = Invoice(
      id: invoice.id,
      customerId: invoice.customerId,
      invoiceItems: updated_items_list,
    );

    await invoiceController.updateInvoice(invoice.id!, updatedInvoice);

    if (!mounted) return;

    if (invoiceController.errorMessage.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed: ${invoiceController.errorMessage}"),
          backgroundColor: Colors.redAccent,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Invoice updated successfully"),
          backgroundColor: Colors.lightGreen,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (errorMessage.isNotEmpty) {
      return Scaffold(
        appBar: const AppNavBar(title: "Update Invoice"),
        body: Center(
          child: Text(errorMessage, style: const TextStyle(color: Colors.red)),
        ),
      );
    }

    return Scaffold(
      appBar: const AppNavBar(title: "Update Invoice"),
      body: SingleChildScrollView(
        controller: _scrollController,
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // header
                    Column(
                      children: [
                        Icon(
                          Icons.edit_document,
                          size: 48,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "Update Invoice",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Update Items",
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // customer id
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Customer Id:",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "${invoice.customerId}",
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // items
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Invoice Items",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ...List.generate(updated_items_list.length, (index) {
                          final item = updated_items_list[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                children: [
                                  // image ]
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.asset(
                                      "images/shoes.jpg",
                                      width: 60,
                                      height: 60,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  //  details
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "#id: ${item.itemId}",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Text(
                                          item.item?.itemName ?? "Unknown Item",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          "\$${item.unitPrice.toStringAsFixed(2)}",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // quantty
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.remove),
                                        onPressed: () =>
                                            _decreaseQuantity(index),
                                      ),
                                      Text("${item.quantity}"),
                                      IconButton(
                                        icon: const Icon(Icons.add),
                                        onPressed: () =>
                                            _increaseQuantity(index),
                                      ),
                                    ],
                                  ),
                                  // delete
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                    onPressed: () => _removeItem(index),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                      ],
                    ),

                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _saveInvoice,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                        ),
                        child: const Text(
                          "Save Changes",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
