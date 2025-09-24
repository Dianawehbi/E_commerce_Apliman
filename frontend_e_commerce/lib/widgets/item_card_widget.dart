import 'package:flutter/material.dart';
import 'package:frontend_e_commerce/controllers/cart_controller.dart';
import 'package:frontend_e_commerce/controllers/item_controller.dart';
import 'package:frontend_e_commerce/models/invoice_items.dart';
import 'package:frontend_e_commerce/models/item.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';

class ItemCardWidget extends StatefulWidget {
  final Item item;

  const ItemCardWidget({super.key, required this.item});

  @override
  State<ItemCardWidget> createState() => _ItemCardWidgetState();
}

class _ItemCardWidgetState extends State<ItemCardWidget> {
  int quantity = 1;
  late CartController cartController;
  late ItemController itemController;

  @override
  void initState() {
    super.initState();
    cartController = CartController(cartBox: Hive.box<InvoiceItems>('cartBox'));
    itemController = ItemController();
    quantity = 1;
  }

  void _increment() {
    if (quantity < widget.item.stockQuantity) {
      setState(() => quantity++);
    }
  }

  void _decrement() {
    if (quantity > 1) {
      setState(() => quantity--);
    }
  }

  void _addToCart() {
    cartController.addItem(widget.item, quantity);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("${widget.item.itemName} added to cart!")),
    );
  }

  void _deleteItem() {
    setState(() {
      itemController.deleteItem(widget.item.id!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          clipBehavior: Clip.antiAlias, // for rounded image corners
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image with max height
              SizedBox(
                height: 150, // max image height
                width: double.infinity,
                child: Image.asset("images/shoes.png", fit: BoxFit.cover),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.item.itemName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      "\$${widget.item.price.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(height: 3),
                    // Description that expands but stays constrained
                    Text(
                      widget.item.description,
                      maxLines:
                          4, // optional: limits lines but still expandable
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: _decrement,
                            ),
                            Text("$quantity"),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: _increment,
                            ),
                          ],
                        ),
                        IconButton(
                          icon: const Icon(Icons.add_shopping_cart),
                          onPressed: _addToCart,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Update & Delete buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () =>
                                context.go('/items/update/${widget.item.id}'),
                            icon: const Icon(Icons.edit, size: 18),
                            label: const Text("Update"),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _deleteItem,
                            icon: const Icon(Icons.delete, size: 18),
                            label: const Text("Delete"),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
