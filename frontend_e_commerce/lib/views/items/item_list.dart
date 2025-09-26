import 'package:flutter/material.dart';
import 'package:frontend_e_commerce/controllers/cart_controller.dart';
import 'package:frontend_e_commerce/controllers/item_controller.dart';
import 'package:frontend_e_commerce/models/invoice_items.dart';
import 'package:frontend_e_commerce/widgets/app_nav_bar.dart';
import 'package:frontend_e_commerce/widgets/item_card_widget.dart';
import 'package:frontend_e_commerce/widgets/pagination_widget.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';

class ItemListPage extends StatefulWidget {
  const ItemListPage({super.key});

  @override
  State<ItemListPage> createState() => _ItemListState();
}

class _ItemListState extends State<ItemListPage> {
  late TextEditingController _searchController;
  late CartController cartController;

  @override
  void initState() {
    super.initState();
    cartController = CartController(cartBox: Hive.box<InvoiceItems>('cartBox'));
    cartController.loadCart();
    _searchController = TextEditingController();
    // load items only once when entering this page
    Future.microtask(() {
      // ignore: use_build_context_synchronously
      context.read<ItemController>().loadItems();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  int _getCrossAxisCount(double width) {
    if (width < 600) return 2;
    if (width < 900) return 3;
    if (width < 1200) return 4;
    return 6;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppNavBar(title: "Items"),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            // Search
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: () => context.go('/items/add'),
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text("Add Item"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                ),
                const SizedBox(width: 4),
                ElevatedButton.icon(
                  onPressed: () => context.go('/cart'),
                  icon: const Icon(Icons.shopping_bag, size: 18),
                  label: const Text("cart"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
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
                      hintText: "Search items...",
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.arrow_forward_ios, size: 16),
                        onPressed: () {
                          context.read<ItemController>().setSearchQuery(
                            _searchController.text,
                          );
                        },
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
                    onSubmitted: (value) {
                      context.read<ItemController>().setSearchQuery(value);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            Expanded(
              child: Consumer<ItemController>(
                builder: (context, itemController, child) {
                  // loading
                  if (itemController.isLoading) {
                    return Center(child: CircularProgressIndicator());
                  }

                  // error message
                  if (itemController.errorMessage.isNotEmpty) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        itemController.errorMessage,
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  }

                  if (!itemController.isLoading &&
                      itemController.items.isEmpty) {
                    return Center(child: Text("No items Found"));
                  }

                  // items grid + pagination
                  return Column(
                    children: [
                      Expanded(
                        child: LayoutBuilder(
                          builder: (_, constraints) {
                            final crossAxisCount = _getCrossAxisCount(
                              constraints.maxWidth,
                            );
                            return GridView.builder(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: crossAxisCount,
                                    mainAxisSpacing: 12,
                                    crossAxisSpacing: 12,
                                    childAspectRatio: 0.7,
                                  ),
                              itemCount: itemController.items.length,
                              itemBuilder: (_, index) {
                                final item = itemController.items[index];
                                return ItemCardWidget(
                                  item: item,
                                  onDelete: () =>
                                      itemController.deleteItem(item.id!),
                                );
                              },
                            );
                          },
                        ),
                      ),
                      if (itemController.items.isNotEmpty)
                        PaginationWidget(controller: itemController),
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
