import 'package:flutter/material.dart';
import 'package:frontend_e_commerce/models/invoice.dart';
import 'package:frontend_e_commerce/services/invoice_service.dart';
import 'package:frontend_e_commerce/services/classes/page_response.dart';

class InvoiceController extends ChangeNotifier {
  List<Invoice> invoices = [];
  bool isLoading = false;
  int currentPage = 1;
  int totalPages = 1;
  final int pageSize = 10;
  String searchQuery = '';
  String errorMessage = '';

  InvoiceController();

  // Load all invoices (with pagination)
  Future<void> loadInvoices({int page = 1}) async {
    isLoading = true;
    errorMessage = '';
    notifyListeners();

    try {
      PagedResponse<Invoice> result;

      if (searchQuery.isNotEmpty) {
        // Fetch by customer name
        result = await InvoiceService.getInvoicesByCustomerName(
          searchQuery,
          page: page - 1,
          size: pageSize,
        );
      } else {
        result = await InvoiceService.fetchInvoices(
          page: page - 1,
          size: pageSize,
        );
      }
      invoices = result.objects;
      currentPage = result.currentPage + 1; // backend is 0-based
      totalPages = result.totalPages;
    } catch (e) {
      invoices = [];
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Search invoices by customer name
  void setSearchQuery(String query) {
    searchQuery = query;
    currentPage = 1;
    loadInvoices(page: currentPage);
  }

  void nextPage() {
    if (currentPage < totalPages) loadInvoices(page: currentPage + 1);
  }

  void previousPage() {
    if (currentPage > 1) loadInvoices(page: currentPage - 1);
  }

  // get invoice by ID
  Future<Invoice?> getInvoiceById(int id) async {
    errorMessage = '';
    notifyListeners();

    try {
      return await InvoiceService.getInvoiceById(id);
    } catch (e) {
      errorMessage = e.toString();
      return null;
    } finally {
      notifyListeners();
    }
  }

  // get invoices by customer ID
  Future<void> loadInvoicesByCustomerId(int customerId, {int page = 1}) async {
    isLoading = true;
    errorMessage = '';
    notifyListeners();

    try {
      final result = await InvoiceService.getInvoicesByCustomerId(
        customerId,
        page: page - 1,
        size: pageSize,
      );
      invoices = result.objects;
      currentPage = result.currentPage + 1;
      totalPages = result.totalPages;
    } catch (e) {
      invoices = [];
      print(e);
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // add invoice
  Future<void> addInvoice(Invoice invoice) async {
    errorMessage = '';
    notifyListeners();

    try {
      final newInvoice = await InvoiceService.createInvoice(invoice);
      invoices.insert(0, newInvoice);
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      notifyListeners();
    }
  }

  // update invoice
  Future<void> updateInvoice(int id, Invoice updatedInvoice) async {
    errorMessage = '';
    notifyListeners();

    try {
      final invoice = await InvoiceService.updateInvoice(id, updatedInvoice);
      final index = invoices.indexWhere((inv) => inv.id == id);
      if (index != -1) invoices[index] = invoice;
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      notifyListeners();
    }
  }

  // delete invoice
  Future<void> deleteInvoice(int id) async {
    errorMessage = '';
    notifyListeners();

    try {
      await InvoiceService.deleteInvoice(id);
      invoices.removeWhere((inv) => inv.id == id);
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      notifyListeners();
    }
  }
}
