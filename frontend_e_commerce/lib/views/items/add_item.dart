import 'package:flutter/material.dart';
import 'package:frontend_e_commerce/controllers/item_controller.dart';
import 'package:frontend_e_commerce/models/item.dart';
import 'package:frontend_e_commerce/views/items/widgets/form_text_field.dart';
import 'package:frontend_e_commerce/widgets/app_nav_bar.dart';
import 'package:provider/provider.dart';

class AddItemPage extends StatefulWidget {
  const AddItemPage({super.key});

  @override
  State<AddItemPage> createState() => _AddItemPageState();
}

class _AddItemPageState extends State<AddItemPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    super.dispose();
  }

  Future<void> _addItem() async {
    if (_formKey.currentState!.validate()) {
      final itemProvider = context.read<ItemController>();

      Item newItem = Item(
        itemName: _nameController.text,
        description: _descController.text,
        price: double.parse(_priceController.text),
        stockQuantity: int.parse(_stockController.text),
      );

      final success = await itemProvider.addItem(newItem);

      if (!mounted) return;

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("item added successfully"),
            backgroundColor: Colors.lightGreen,
          ),
        );
        _nameController.clear();
        _descController.clear();
        _priceController.clear();
        _stockController.clear();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed: ${itemProvider.errorMessage}"),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ItemController>(
      builder: (context, itemController, child) => Scaffold(
        appBar: AppNavBar(title: "Add Item"),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600, minHeight: 400),
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // header
                        Column(
                          children: [
                            Icon(
                              Icons.add_box_rounded,
                              size: 48,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              "Add New Item",
                              style: Theme.of(context).textTheme.headlineSmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                  ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Fill in the item details below",
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(color: Colors.grey[600]),
                            ),

                            // on error
                            if (itemController.errorMessage.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  itemController.errorMessage,
                                  style: const TextStyle(color: Colors.red),
                                ),
                              ),
                          ],
                        ),

                        const SizedBox(height: 32),

                        // item Name
                        FormTextFieldWidget(
                          textController: _nameController,
                          label: "Item Name",
                          icon: Icons.drive_file_rename_outline,
                          validator: (value) =>
                              value!.isEmpty ? "Please enter item name" : null,
                        ),
                        const SizedBox(height: 16),

                        // description
                        TextFormField(
                          controller: _descController,
                          decoration: InputDecoration(
                            labelText: "Description",
                            prefixIcon: const Icon(Icons.description_outlined),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: Colors.grey[50],
                          ),
                          maxLines: 3,
                          validator: (value) => value!.isEmpty
                              ? "Please enter description"
                              : null,
                        ),
                        const SizedBox(height: 16),

                        // price
                        FormTextFieldWidget(
                          textController: _priceController,
                          label: "Price",
                          icon: Icons.attach_money,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Enter price";
                            }
                            if (double.tryParse(value) == null) {
                              return "Invalid number";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        FormTextFieldWidget(
                          textController: _stockController,
                          label: "Stock Quantity",
                          icon: Icons.inventory_2_outlined,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Enter qunatity";
                            }
                            if (double.tryParse(value) == null) {
                              return "Invalid number";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        // save Button
                        itemController.isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : ElevatedButton(
                                onPressed: () => _addItem(),
                                child: const Text("Save Item"),
                              ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
