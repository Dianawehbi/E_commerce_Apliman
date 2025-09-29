import 'package:flutter/material.dart';
import 'package:frontend_e_commerce/controllers/cart_controller.dart';
import 'package:frontend_e_commerce/models/invoice_items.dart';
import 'package:provider/provider.dart';

class ShoppingItemCardWidget extends StatelessWidget {
  final InvoiceItems invoiceItems;

  const ShoppingItemCardWidget({
    super.key,
    required this.invoiceItems,
  });

  @override
  Widget build(BuildContext context) {
    var cartController = context.watch<CartController>();
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            // Rounded Image
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                "images/shoes.jpg",
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(width: 12),

            // Item details (name + price)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    invoiceItems.item!.itemName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "\$${invoiceItems.unitPrice.toStringAsFixed(2)}",
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),

            // quantity controls
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () =>
                      cartController.addItem(invoiceItems.item!, -1),
                ),
                Text("${invoiceItems.quantity}"),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () =>
                      cartController.addItem(invoiceItems.item!, 1),
                ),
              ],
            ),

            // delete button at the end
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => cartController.deleteItem(invoiceItems.item!.id!),
            ),
          ],
        ),
      ),
    );
  }
}
