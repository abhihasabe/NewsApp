import 'package:firebaseLoginBloc/networks/news_api_client.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'dart:convert';

void main() {
  test("Testing the News Api call", () async {

    final newsApiclient = NewsApiClient();
    newsApiclient.client = MockClient((request) async {
      final mapJson = {'status': "ok", 'totalResults': 38};
      return Response(json.encode(mapJson), 200);
    });

    final item = await newsApiclient.getArticles();
    expect(item.status, "ok");
    expect(item.totalResults, 38);
  });
}
