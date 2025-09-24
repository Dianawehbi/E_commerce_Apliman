import 'dart:convert';
import 'package:frontend_e_commerce/models/item.dart';
import 'package:frontend_e_commerce/services/classes/api_exception.dart';
import 'package:frontend_e_commerce/services/classes/page_response.dart';
import 'package:http/http.dart' as http;

// getAllitems() => return PagedResponse( items(Item) : items ,totalpages , currentPage) i
// same for getAllItemsByItemName()

class ItemService {
  static const String baseUrl = "http://localhost:8080";
  static const String endpoint = '/items';
  static const headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  //* APIS
  // fetching all items with paging
  static Future<PagedResponse<Item>> getAllItems({
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
      final items = (data['content'] as List)
          .map((json) => Item.fromJson(json))
          .toList();
      return PagedResponse<Item>(
        objects: items,
        totalPages: data['totalPages'] ?? 1,
        currentPage: data['pageable']['pageNumber'] ?? page,
      );
    } else {
      throw ApiException(response.statusCode, response.body);
    }
  }

  // search for an item by item_name , /items/search?name=...
  static Future<PagedResponse<Item>> getAllItemsByItemName({
    int page = 0,
    int size = 10,
    String name = "",
  }) async {
    final params = {'page': '$page', 'size': '$size', 'name': name.trim()};
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
      final items = (data['content'] as List)
          .map((json) => Item.fromJson(json))
          .toList();
      return PagedResponse<Item>(
        objects: items,
        totalPages: data['totalPages'] ?? 1,
        currentPage: data['pageable']['pageNumber'] ?? page,
      );
    } else {
      throw ApiException(response.statusCode, response.body);
    }
  }

  // get single item by id -> /items/{id}
  static Future<Item> getItemById(int id) async {
    final response = await http
        .get(Uri.parse('$baseUrl$endpoint/$id'), headers: headers)
        .timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      return Item.fromJson(jsonDecode(response.body));
    } else {
      throw ApiException(response.statusCode, response.body);
    }
  }

  // create new Item
  static Future<Item> createItem(Item item) async {
    final response = await http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: headers,
      body: jsonEncode(item.toJson()),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return Item.fromJson(jsonDecode(response.body));
    } else {
      throw ApiException(response.statusCode, response.body);
    }
  }

  // update Item
  static Future<Item> updateItem(int id, Item item) async {
    final response = await http.put(
      Uri.parse('$baseUrl$endpoint/$id'),
      headers: headers,
      body: jsonEncode(item.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Item.fromJson(jsonDecode(response.body));
    } else {
      throw ApiException(response.statusCode, response.body);
    }
  }

  // delete
  static Future<void> deleteItem(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl$endpoint/$id'),
      headers: headers,
    );
    if (response.statusCode != 200) {
      throw ApiException(response.statusCode, response.body);
    }
  }
}
