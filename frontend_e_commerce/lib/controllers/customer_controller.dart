import 'package:flutter/material.dart';
import 'package:frontend_e_commerce/models/customer.dart';
import 'package:frontend_e_commerce/services/customer_service.dart';
import 'package:frontend_e_commerce/services/classes/page_response.dart';

class CustomerController extends ChangeNotifier {
  List<Customer> customers = [];
  bool isLoading = false;
  int currentPage = 1;
  int totalPages = 1;
  final int pageSize = 10;
  String searchQuery = '';
  String errorMessage = '';

  CustomerController();

  // Load all customers (with pagination & optional search)
  Future<void> loadCustomers({int page = 1}) async {
    isLoading = true;
    errorMessage = '';
    notifyListeners();

    try {
      PagedResponse<Customer> result;

      if (searchQuery.isNotEmpty) {
        result = await CustomerService.searchCustomers(
          searchQuery,
          page: page - 1,
          size: pageSize,
        );
      } else {
        result = await CustomerService.fetchCustomers(
          page: page - 1,
          size: pageSize,
        );
      }

      customers = result.objects;
      currentPage = result.currentPage + 1; // backend is 0-based
      totalPages = result.totalPages;
    } catch (e) {
      customers = [];
      errorMessage = e.toString();
      print(e);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Search by name
  void setSearchQuery(String query) {
    searchQuery = query;
    currentPage = 1;
    loadCustomers(page: currentPage);
  }

  // Pagination
  void nextPage() {
    if (currentPage < totalPages) loadCustomers(page: currentPage + 1);
  }

  void previousPage() {
    if (currentPage > 1) loadCustomers(page: currentPage - 1);
  }

  // Get customer by ID
  Future<Customer?> getCustomerById(int id) async {
    errorMessage = '';
    notifyListeners();

    try {
      return await CustomerService.getCustomerById(id);
    } catch (e) {
      errorMessage = e.toString();
      return null;
    } finally {
      notifyListeners();
    }
  }

  // Add customer
  Future<bool> addCustomer(Customer customer) async {
    errorMessage = '';
    notifyListeners();
    try {
      final newCustomer = await CustomerService.createCustomer(customer);
      customers.insert(0, newCustomer);
      return true;
    } catch (e) {
      errorMessage = e.toString();
      print(e);
      return false;
    } finally {
      notifyListeners();
    }
  }

  // Update customer
  Future<bool> updateCustomer(int id, Customer updatedCustomer) async {
    errorMessage = '';
    notifyListeners();

    try {
      final customer = await CustomerService.updateCustomer(
        id,
        updatedCustomer,
      );
      final index = customers.indexWhere((c) => c.id == id);
      if (index != -1) customers[index] = customer;
      return true;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    } finally {
      notifyListeners();
    }
  }

  // Delete customer
  Future<void> deleteCustomer(int id) async {
    errorMessage = '';
    notifyListeners();

    try {
      await CustomerService.deleteCustomer(id);
      customers.removeWhere((c) => c.id == id);
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      notifyListeners();
    }
  }
}
