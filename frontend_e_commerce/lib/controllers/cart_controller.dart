import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:frontend_e_commerce/models/item.dart';
import 'package:frontend_e_commerce/models/invoice_items.dart';

//* Hive - localstorage (shopping cart)

class CartController extends ChangeNotifier {
  final Box<InvoiceItems> cartBox;

  // cartItems will look like : InvoiceItems model

  Map<int, InvoiceItems> cartItems = {};
  bool isLoading = false;
  String errorMessage = '';

  CartController({required this.cartBox});

  Future<void> loadCart() async {
    isLoading = true;
    errorMessage = '';
    notifyListeners();

    try {
      cartItems = Map<int, InvoiceItems>.from(cartBox.toMap());
    } catch (e) {
      errorMessage = e.toString();
      cartItems = {};
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // add or update item
  Future<void> addItem(Item item, int quantity) async {
    try {
      cartItems = Map<int, InvoiceItems>.from(cartBox.toMap());
      final existing = cartItems[item.id];

      int newQuantity;

      if (existing != null) {
        // item already exist
        newQuantity = existing.quantity + quantity;
      } else {
        // new item
        newQuantity = quantity;
      }

      if (newQuantity <= 0) {
        await cartBox.delete(item.id);
        cartItems.remove(item.id);
      } else {
        final invoiceItem = InvoiceItems(
          itemId: item.id ?? -1,
          quantity: newQuantity,
          unitPrice: item.price,
          item: item,
        );

        await cartBox.put(item.id, invoiceItem);
        cartItems[item.id!] = invoiceItem; // update in memory
      }

      notifyListeners();
    } catch (e) {
      errorMessage = e.toString();
      notifyListeners();
    }
  }

  // delete item
  Future<void> deleteItem(int itemId) async {
    try {
      await cartBox.delete(itemId);
      cartItems.remove(itemId);
      notifyListeners();
    } catch (e) {
      errorMessage = e.toString();
      notifyListeners();
    }
  }

  // clear cart
  Future<void> clearCart() async {
    try {
      await cartBox.clear();
      cartItems.clear();
      notifyListeners();
    } catch (e) {
      errorMessage = e.toString();
      notifyListeners();
    }
  }

  // total price
  double get totalPrice => cartItems.values.fold(
    0,
    (sum, item) => sum + item.unitPrice * item.quantity,
  );

  // rotal quantity
  int get totalQuantity =>
      cartItems.values.fold(0, (sum, item) => sum + item.quantity);
}
