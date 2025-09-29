import 'dart:convert';
import 'package:frontend_e_commerce/models/customer.dart';
import 'package:frontend_e_commerce/services/classes/api_exception.dart';
import 'package:frontend_e_commerce/services/classes/page_response.dart';
import 'package:http/http.dart' as http;

class CustomerService {
  static const String baseUrl = "http://localhost:8080"; // adjust if needed
  static const String endpoint = '/customers';
  static const headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  //* APIS

  // create customer
  static Future<Customer> createCustomer(Customer customer) async {
    final response = await http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: headers,
      body: jsonEncode(customer.toJson()),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return Customer.fromJson(jsonDecode(response.body));
    } else {
      var err = jsonDecode(response.body);
      throw ApiException(err['status'], err['message']);
    }
  }

  // get all customers + pagination
  static Future<PagedResponse<Customer>> fetchCustomers({
    int page = 0,
    int size = 10,
    String search = "",
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
      final customers = (data['content'] as List)
          .map((json) => Customer.fromJson(json))
          .toList();

      return PagedResponse<Customer>(
        objects: customers,
        totalPages: data['totalPages'] ?? 1,
        currentPage: data['pageable']['pageNumber'] ?? page,
      );
    } else {
      throw ApiException(response.statusCode, response.body);
    }
  }

  // Get customer by ID
  static Future<Customer> getCustomerById(int id) async {
    final response = await http.get(
      Uri.parse('$baseUrl$endpoint/$id'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return Customer.fromJson(jsonDecode(response.body));
    } else {
      throw ApiException(response.statusCode, response.body);
    }
  }

  // search customers by name
  static Future<PagedResponse<Customer>> searchCustomers(
    String name, {
    int page = 0,
    int size = 10,
  }) async {
    final params = {'name': name.trim(), 'page': '$page', 'size': '$size'};
    final response = await http
        .get(
          Uri.parse(
            '$baseUrl$endpoint/search',
          ).replace(queryParameters: params),
          headers: headers,
        )
        .timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final customers = (data['content'] as List)
          .map((json) => Customer.fromJson(json))
          .toList();

      return PagedResponse<Customer>(
        objects: customers,
        totalPages: data['totalPages'] ?? 1,
        currentPage: data['pageable']['pageNumber'] ?? page,
      );
    } else {
      throw ApiException(response.statusCode, response.body);
    }
  }

  // Update customer
  static Future<Customer> updateCustomer(int id, Customer customer) async {
    final response = await http.put(
      Uri.parse('$baseUrl$endpoint/$id'),
      headers: headers,
      body: jsonEncode(customer.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Customer.fromJson(jsonDecode(response.body));
    } else {
      throw ApiException(
        response.statusCode,
        jsonDecode(response.body)['message'],
      );
    }
  }

  // Delete customer
  static Future<void> deleteCustomer(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl$endpoint/$id'),
      headers: headers,
    );
    if (response.statusCode != 200) {
      throw ApiException(response.statusCode, response.body);
    }
  }
}
