import 'package:flutter/material.dart';
import 'package:frontend_e_commerce/controllers/item_controller.dart';
import 'package:frontend_e_commerce/models/item.dart';
import 'package:frontend_e_commerce/views/items/widgets/form_text_field.dart';
import 'package:frontend_e_commerce/widgets/app_nav_bar.dart';
import 'package:provider/provider.dart';

class UpdateItemPage extends StatefulWidget {
  final int itemId;

  const UpdateItemPage({super.key, required this.itemId});

  @override
  State<UpdateItemPage> createState() => _UpdateItemPageState();
}

class _UpdateItemPageState extends State<UpdateItemPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descController;
  late TextEditingController _priceController;
  late TextEditingController _stockController;

  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _descController = TextEditingController();
    _priceController = TextEditingController();
    _stockController = TextEditingController();
    _loadItem();
  }

  Future<void> _loadItem() async {
    final itemProvider = context.read<ItemController>();
    try {
      final fetchedItem = await itemProvider.getItemById(widget.itemId);
      if (fetchedItem == null) {
        setState(() {
          _errorMessage = "Item not found";
          _isLoading = false;
        });
        return;
      }

      _nameController.text = fetchedItem.itemName;
      _descController.text = fetchedItem.description;
      _priceController.text = fetchedItem.price.toString();
      _stockController.text = fetchedItem.stockQuantity.toString();

      setState(() => _isLoading = false);
    } catch (e) {
      setState(() {
        _errorMessage = "Failed to load item: $e";
        _isLoading = false;
      });
    }
  }

  Future<void> _updateItem() async {
    if (!_formKey.currentState!.validate()) return;

    final itemProvider = context.read<ItemController>();
    final updatedItem = Item(
      id: widget.itemId,
      itemName: _nameController.text,
      description: _descController.text,
      price: double.parse(_priceController.text),
      stockQuantity: int.parse(_stockController.text),
    );

    final success = await itemProvider.updateItem(widget.itemId, updatedItem);

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Item updated successfully"),
          backgroundColor: Colors.lightGreen,
        ),
      );
      Navigator.pop(context, true); // return to previous page
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed: ${itemProvider.errorMessage}"),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ItemController>(
      builder: (context, itemProvider, child) {
        if (_isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (_errorMessage.isNotEmpty) {
          return Scaffold(
            appBar: const AppNavBar(title: "Update Item"),
            body: Center(
              child: Text(
                _errorMessage,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          );
        }

        return Scaffold(
          appBar: const AppNavBar(title: "Update Item"),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 600,
                  minHeight: 400,
                ),
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
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Header
                          Column(
                            children: [
                              Icon(
                                Icons.edit_rounded,
                                size: 48,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                "Update Item",
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
                                "Edit the item details below",
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(color: Colors.grey[600]),
                              ),
                            ],
                          ),
                          const SizedBox(height: 32),

                          // Item fields
                          FormTextFieldWidget(
                            textController: _nameController,
                            label: "Item Name",
                            icon: Icons.drive_file_rename_outline,
                            validator: (value) => value!.isEmpty
                                ? "Please enter item name"
                                : null,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _descController,
                            decoration: InputDecoration(
                              labelText: "Description",
                              prefixIcon: const Icon(
                                Icons.description_outlined,
                              ),
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

                          // Buttons
                          ElevatedButton(
                            onPressed: _updateItem,
                            child: const Text("Update Item"),
                          ),
                          const SizedBox(height: 16),
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(
                              "Cancel",
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
