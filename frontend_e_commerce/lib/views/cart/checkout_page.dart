import 'package:flutter/material.dart';
import 'package:frontend_e_commerce/controllers/cart_controller.dart';
import 'package:frontend_e_commerce/controllers/customer_controller.dart';
import 'package:frontend_e_commerce/controllers/invoice_controller.dart';
import 'package:frontend_e_commerce/models/customer.dart';
import 'package:frontend_e_commerce/models/invoice.dart';
import 'package:frontend_e_commerce/models/invoice_items.dart';
import 'package:frontend_e_commerce/widgets/app_nav_bar.dart';
import 'package:frontend_e_commerce/widgets/pagination_widget.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  Customer? selectedCustomer;
  String errorMessage = '';
  final ScrollController _scrollController = ScrollController();

  void _saveInvoice(
    InvoiceController invoiceController,
    CartController cartController,
  ) async {
    if (selectedCustomer == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please select a customer")));
      return;
    }

    // save InvoiceItems as list
    final List<InvoiceItems> invoiceItems = cartController.cartItems.values
        .map(
          (item) => InvoiceItems(
            quantity: item.quantity,
            unitPrice: item.unitPrice,
            itemId: item.itemId ,
          ),
        )
        .toList();

    // create new Invoice
    final new_invoice = Invoice(
      id: -1,
      customerId: selectedCustomer!.id,
      invoiceItems: invoiceItems,
    );


    await invoiceController.addInvoice(new_invoice);

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
        SnackBar(
          content: Text("Invoice added successfully"),
          backgroundColor: Colors.lightGreen,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppNavBar(title: "Checkout"),
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
                    // Header
                    Column(
                      children: [
                        Icon(
                          Icons.payment_outlined,
                          size: 48,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "Checkout",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Select a customer to save this invoice",
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        if (errorMessage.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              errorMessage,
                              style: const TextStyle(color: Colors.red),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // Customer Selection
                    Consumer<CustomerController>(
                      builder: (context, customerController, child) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Select Customer",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.grey[50],
                              ),
                              constraints: const BoxConstraints(maxHeight: 200),
                              child: customerController.isLoading
                                  ? const Center(
                                      child: CircularProgressIndicator(),
                                    )
                                  : customerController.customers.isEmpty
                                  ? const Center(
                                      child: Text("No customers available"),
                                    )
                                  : Scrollbar(
                                      controller: _scrollController,
                                      thumbVisibility: true,
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        itemCount:
                                            customerController.customers.length,
                                        itemBuilder: (context, index) {
                                          final customer = customerController
                                              .customers[index];
                                          return ListTile(
                                            title: Text(
                                              "${customer.username} | ${customer.email} | ID: ${customer.id}",
                                            ),
                                            selected:
                                                selectedCustomer == customer,
                                            onTap: () => setState(() {
                                              selectedCustomer = customer;
                                            }),
                                          );
                                        },
                                      ),
                                    ),
                            ),
                            PaginationWidget(controller: customerController),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 16),

                    // add customer Button
                    ElevatedButton.icon(
                      onPressed: () => context.push('/customers/add'),
                      icon: const Icon(Icons.person_add_outlined),
                      label: const Text("Add New Customer"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // General Info + Save
                    Consumer2<CartController, InvoiceController>(
                      builder: (context, cartController, invoiceController, child) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Items: ${cartController.totalQuantity}"),
                                Text(
                                  "Total: \$${cartController.totalPrice.toStringAsFixed(2)}",
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),

                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () => _saveInvoice(
                                  invoiceController,
                                  cartController,
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Theme.of(
                                    context,
                                  ).colorScheme.primary,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 2,
                                ),
                                child: const Text(
                                  "Save Invoice",
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
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
