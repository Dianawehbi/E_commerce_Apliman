import 'package:flutter/material.dart';
import 'package:frontend_e_commerce/models/invoice.dart';
import 'package:go_router/go_router.dart';

class InvoiceCardWidget extends StatefulWidget {
  final Invoice invoice;
  final VoidCallback onDelete;
  const InvoiceCardWidget({
    super.key,
    required this.invoice,
    required this.onDelete,
  });

  @override
  State<InvoiceCardWidget> createState() => _InvoiceCardWidgetState();
}

class _InvoiceCardWidgetState extends State<InvoiceCardWidget> {
  late Invoice invoice;

  @override
  void initState() {
    super.initState();
    invoice = widget.invoice;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: ExpansionTile(
        title: Text("Invoice #${invoice.id}"),
        subtitle: Text(
          "Customer ID: ${invoice.customerId} | Total: \$${invoice.totalAmount?.toStringAsFixed(2) ?? "0.00"} | Items: ${invoice.invoiceItems.length}",
        ),
        childrenPadding: const EdgeInsets.symmetric(
          vertical: 4,
          horizontal: 16,
        ),
        children: [
          if (invoice.invoiceDate != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                "Date: ${invoice.invoiceDate!.toLocal().toString().split(' ')[0]}",
              ),
            ),
          const Divider(),
          ...invoice.invoiceItems.map(
            (item) => ListTile(
              dense: true,
              title: Text("Item: ${item.item!.itemName}"),
              subtitle: Text(
                "Qty: ${item.quantity} | Unit: \$${item.unitPrice.toStringAsFixed(2)}",
              ),
              trailing: Text(
                "\$${(item.unitPrice * item.quantity).toStringAsFixed(2)}",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Actions
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () => context.go('/invoices/update/${invoice.id}'),
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  label: const Text(
                    "Edit",
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
                const SizedBox(width: 8),
                TextButton.icon(
                  onPressed: widget.onDelete,
                  icon: const Icon(Icons.delete, color: Colors.red),
                  label: const Text(
                    "Delete",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
