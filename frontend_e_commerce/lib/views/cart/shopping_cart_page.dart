import 'package:flutter/material.dart';
import 'package:frontend_e_commerce/models/invoice_items.dart';
import 'package:frontend_e_commerce/views/cart/widgets/shopping_item_card_widget.dart';
import 'package:frontend_e_commerce/widgets/app_nav_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:hive/hive.dart';
import 'package:frontend_e_commerce/controllers/cart_controller.dart';

class ShoppingCartPage extends StatefulWidget {
  const ShoppingCartPage({super.key});

  @override
  State<ShoppingCartPage> createState() => _ShoppingCartPageState();
}

class _ShoppingCartPageState extends State<ShoppingCartPage> {
  late CartController cartController;

  @override
  void initState() {
    super.initState();
    cartController = CartController(cartBox: Hive.box<InvoiceItems>('cartBox'));
    cartController.loadCart();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CartController>.value(
      value: cartController,
      child: Consumer<CartController>(
        builder: (context, controller, _) {
          return Scaffold(
            appBar: const AppNavBar(title: "Shopping Cart"),
            body: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 600),
                  child: Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: controller.isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : controller.errorMessage.isNotEmpty
                          ? Center(
                              child: Text(
                                "Error: ${controller.errorMessage}",
                                style: const TextStyle(color: Colors.red),
                              ),
                            )
                          : controller.cartItems.isEmpty
                          ? const Center(
                              child: Text(
                                "Your cart is empty",
                                style: TextStyle(fontSize: 18),
                              ),
                            )
                          : Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Header
                                Column(
                                  children: [
                                    Icon(
                                      Icons.shopping_cart_outlined,
                                      size: 48,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      "Your Cart",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineSmall
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.primary,
                                          ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      "Review your items and proceed to checkout",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(color: Colors.grey[600]),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 24),

                                // Cart Items
                                ListView.separated(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: controller.cartItems.length,
                                  separatorBuilder: (_, __) =>
                                      const SizedBox(height: 12),
                                  itemBuilder: (context, index) {
                                    final invoiceItem = controller
                                        .cartItems
                                        .values
                                        .elementAt(index);
                                    return ShoppingItemCardWidget(
                                      onIncrement: () => controller.addItem(
                                        invoiceItem.item!,
                                        1,
                                      ),
                                      onDecrement: () => controller.addItem(
                                        invoiceItem.item!,
                                        -1,
                                      ),
                                      onDelete: () => controller.deleteItem(
                                        invoiceItem.itemId!,
                                      ),
                                      invoiceItems: invoiceItem,
                                    );
                                  },
                                ),
                                const SizedBox(height: 24),

                                // Total quantity & price
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Items: ${controller.totalQuantity}",
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      "Total: \$${controller.totalPrice.toStringAsFixed(2)}",
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 24),

                                // Checkout Button
                                ElevatedButton(
                                  onPressed: () => context.push('/checkout'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                      horizontal: 24,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    elevation: 2,
                                  ),
                                  child: const Text(
                                    "Proceed to Checkout",
                                    style: TextStyle(fontSize: 16),
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
        },
      ),
    );
  }
}

extension CartControllerExtensions on CartController {
  int get totalQuantity =>
      cartItems.values.fold(0, (sum, item) => sum + item.quantity);
}
