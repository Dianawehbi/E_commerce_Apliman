import 'dart:convert';
import 'package:frontend_e_commerce/models/invoice.dart';
import 'package:frontend_e_commerce/services/classes/api_exception.dart';
import 'package:frontend_e_commerce/services/classes/page_response.dart';
import 'package:http/http.dart' as http;

class InvoiceService {
  static const String baseUrl = "http://localhost:8080"; // adjust if needed
  static const String endpoint = '/invoices';
  static const headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  //* APIS
  // Create invoice
  static Future<Invoice> createInvoice(Invoice invoice) async {
    final response = await http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: headers,
      body: jsonEncode(invoice.toJson()),
    );
    //check invoide to json
    if (response.statusCode == 200 || response.statusCode == 201) {
      return Invoice.fromJson(jsonDecode(response.body));
    } else {
      throw ApiException(
        response.statusCode,
        jsonDecode(response.body)['message'],
      );
    }
  }

  // fetch all invoices with pagination
  static Future<PagedResponse<Invoice>> fetchInvoices({
    int page = 0,
    int size = 10,
  }) async {
    final params = {'page': '$page', 'size': '$size'};
    final response = await http
        .get(
          Uri.parse('$baseUrl$endpoint').replace(queryParameters: params),
          headers: headers,
        )
        .timeout(const Duration(seconds: 10));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final invoices = (data['content'] as List)
          .map((json) => Invoice.fromJson(json))
          .toList();

      return PagedResponse<Invoice>(
        objects: invoices,
        totalPages: data['totalPages'] ?? 1,
        currentPage: data['pageable']['pageNumber'] ?? page,
      );
    } else {
      throw ApiException(response.statusCode, response.body);
    }
  }

  // get invoice by ID
  static Future<Invoice> getInvoiceById(int id) async {
    final response = await http.get(
      Uri.parse('$baseUrl$endpoint/$id'),
      headers: headers,
    );
    print(jsonDecode(response.body));

    if (response.statusCode == 200) {
      return Invoice.fromJson(jsonDecode(response.body));
    } else {
      throw ApiException(response.statusCode, response.body);
    }
  }

  // get invoices by customer ID
  static Future<PagedResponse<Invoice>> getInvoicesByCustomerId(
    int customerId, {
    int page = 0,
    int size = 10,
  }) async {
    final params = {'page': '$page', 'size': '$size'};
    final response = await http.get(
      Uri.parse(
        '$baseUrl$endpoint/customer_id/$customerId',
      ).replace(queryParameters: params),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final invoices = (data['content'] as List)
          .map((json) => Invoice.fromJson(json))
          .toList();
      return PagedResponse<Invoice>(
        objects: invoices,
        totalPages: data['totalPages'] ?? 1,
        currentPage: page,
      );
    } else {
      throw ApiException(response.statusCode, response.body);
    }
  }

  // get invoices by customer name
  static Future<PagedResponse<Invoice>> getInvoicesByCustomerName(
    String customerName, {
    int page = 0,
    int size = 10,
  }) async {
    final params = {'page': '$page', 'size': '$size'};
    final response = await http.get(
      Uri.parse(
        '$baseUrl$endpoint/customer_name/$customerName',
      ).replace(queryParameters: params),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final invoices = (data['content'] as List)
          .map((json) => Invoice.fromJson(json))
          .toList();
      return PagedResponse<Invoice>(
        objects: invoices,
        totalPages: data['totalPages'] ?? 1,
        currentPage: page,
      );
    } else {
      throw ApiException(response.statusCode, response.body);
    }
  }

  // update invoice (must include all invoiceitems)
  static Future<Invoice> updateInvoice(int id, Invoice invoice) async {
    print(jsonEncode(invoice.toJson()));
    final response = await http.put(
      Uri.parse('$baseUrl$endpoint/$id'),
      headers: headers,
      body: jsonEncode(invoice.toJson()),
    );

    print(jsonDecode(response.body));

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Invoice.fromJson(jsonDecode(response.body));
    } else {
      throw ApiException(response.statusCode, response.body);
    }
  }

  // delete invoice
  static Future<void> deleteInvoice(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl$endpoint/$id'),
      headers: headers,
    );
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw ApiException(response.statusCode, jsonDecode(response.body)['message']);
    }
  }
}
