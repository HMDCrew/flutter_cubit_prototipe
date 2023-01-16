abstract class IHttpClient {
  Future<HttpResult> get(url, {Map<String, String> headers});
  Future<HttpResult> post(url, String body, {Map<String, String> headers});
}

class HttpResult {
  final String data;
  final String status;

  const HttpResult(this.data, this.status);
}

enum Status { success, failure }