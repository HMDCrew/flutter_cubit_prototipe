import 'dart:convert';
import 'package:async/async.dart';
import 'package:http/http.dart' as http;

class TaxonomyApi {
  final http.Client _client;
  String baseUrl;

  TaxonomyApi(this._client, this.baseUrl);

  Future<Result<List<dynamic>>> getTaxonomy({
    required String taxonomy_slug,
    required int hide_empty,
  }) async {
    final String endpoint = '$baseUrl/wp-json/wpr-get-taxonomy';
    http.Response result = await _client.post(Uri.parse(endpoint),
        body: jsonEncode({'taxonomy': taxonomy_slug, 'hide_empty': hide_empty}),
        headers: {"Content-type": "application/json"});

    return _parseTaxonomyJson(result);
  }

  // Helper
  Result<List<dynamic>> _parseTaxonomyJson(http.Response result) {
    Map<String, dynamic> json = jsonDecode(result.body);

    if (result.statusCode != 200 || json['status'] != 'success') {
      Map map = jsonDecode(result.body);
      return Result.error(map);
    }

    List<dynamic> response = json['message'];

    return Result.value(response);
  }
}
