import 'package:flutter/material.dart';
import 'package:frontend_e_commerce/models/item.dart';
import 'package:frontend_e_commerce/services/item_service.dart';
import 'package:frontend_e_commerce/services/classes/page_response.dart';

class ItemController extends ChangeNotifier {
  List<Item> items = [];
  bool isLoading = false;
  int currentPage = 1;
  int totalPages = 1;
  final int pageSize = 15;
  String searchQuery = '';
  String errorMessage = '';

  ItemController();

  Future<void> loadItems({int page = 1}) async {
    isLoading = true;
    errorMessage = '';
    notifyListeners();

    try {
      PagedResponse<Item> result;

      if (searchQuery.isNotEmpty) {
        result = await ItemService.getAllItemsByItemName(
          page: page - 1,
          size: pageSize,
          name: searchQuery,
        );
      } else {
        result = await ItemService.getAllItems(page: page - 1, size: pageSize);
      }
      items = result.objects;
      currentPage =
          result.currentPage + 1; //0 + 1 (if we are in the first page)
      totalPages = result.totalPages;
    } catch (e) {
      items = [];
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // get item by id
  Future<Item?> getItemById(int id) async {
    errorMessage = '';
    notifyListeners();

    try {
      final item = await ItemService.getItemById(id);
      return item; // returns Item type
    } catch (e) {
      errorMessage = e.toString();
      return null; // in case of error, return null
    } finally {
      notifyListeners();
    }
  }

  // on searching
  void setSearchQuery(String query) {
    searchQuery = query;
    currentPage = 1;
    loadItems(page: currentPage);
  }

  void nextPage() {
    if (currentPage < totalPages) loadItems(page: currentPage + 1);
  }

  void previousPage() {
    if (currentPage > 1) loadItems(page: currentPage - 1);
  }

  // add item
  Future<bool> addItem(Item item) async {
    errorMessage = '';
    notifyListeners();

    try {
      final newItem = await ItemService.createItem(item);
      items.insert(0, newItem);
      return true;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    } finally {
      notifyListeners();
    }
  }

  // update item
  Future<bool> updateItem(int id, Item updatedItem) async {
    errorMessage = '';
    notifyListeners();

    try {
      final item = await ItemService.updateItem(id, updatedItem);
      final index = items.indexWhere((i) => i.id == id);
      if (index != -1) items[index] = item;
      return true;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    } finally {
      notifyListeners();
    }
  }

  // delete item
  Future<void> deleteItem(int id) async {
    errorMessage = '';
    notifyListeners();

    try {
      await ItemService.deleteItem(id);
      items.removeWhere((i) => i.id == id);
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      notifyListeners();
    }
  }

  Future<void> setErrorMessage(String err) async {
    errorMessage = err;
    notifyListeners();
  }
}
