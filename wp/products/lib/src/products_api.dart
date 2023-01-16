import 'dart:convert';
import 'package:async/async.dart';
import 'package:http/http.dart' as http;

class ProductsApi {
  final http.Client _client;
  String baseUrl;

  ProductsApi(this._client, this.baseUrl);

  // Product
  Future<Result<List<dynamic>>> findProducts({
    required int page,
    required int pageSize,
    required String searchTerm,
  }) async {
    final String endpoint = '$baseUrl/wp-json/wpr-get-products';
    final result = await _client.post(Uri.parse(endpoint),
        body: jsonEncode(
            {'page': page, 'numberposts': pageSize, 'search': searchTerm}),
        headers: {"Content-type": "application/json"});

    return _parseProductsJson(result);
  }

  Future<Result<List<dynamic>>> getAllProducts({
    required int page,
    required int pageSize,
  }) async {
    final String endpoint = '$baseUrl/wp-json/wpr-get-products';
    http.Response result = await _client.post(Uri.parse(endpoint),
        body: jsonEncode({'page': page, 'numberposts': pageSize}),
        headers: {"Content-type": "application/json"});

    return _parseProductsJson(result);
  }

  Future<Result<Map<String, dynamic>>> getProduct({
    required String productId,
  }) async {
    final String endpoint = '$baseUrl/wp-json/wpr-get-product';
    http.Response result = await _client.post(Uri.parse(endpoint),
        body: jsonEncode({'product_id': productId}),
        headers: {"Content-type": "application/json"});

    final json = jsonDecode(result.body);

    if (result.statusCode != 200 || json['status'] != 'success') {
      Map map = jsonDecode(result.body);
      return Result.error(map);
    }

    return Result.value(json['message']);
  }

  // Helper
  Result<List<dynamic>> _parseProductsJson(http.Response result) {
    Map<String, dynamic> json = jsonDecode(result.body);

    if (result.statusCode != 200 || json['status'] != 'success') {
      Map map = jsonDecode(result.body);
      return Result.error(map);
    }

    List<dynamic> response = json['message'];

    return Result.value(response);
  }
}
