import 'dart:convert';
import 'dart:io';
import 'package:firebaseLoginBloc/model/news_model.dart';
import 'package:firebaseLoginBloc/networks/constants.dart';
import 'package:http/http.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'app_exception.dart';

class NewsApiClient {
  dynamic responseJson;
  Client client = Client();

  @override
  Future<NewsModel> getArticles() async {
    try {
      var response = await client.get(AppConstants.base_url + AppConstants.key);
      responseJson = returnResponse(response);
      if (responseJson != null) {
        var data = json.decode(response.body);
        //List<Articles> articles = NewsModel.fromJson(data).articles;
        NewsModel newsModel = NewsModel.fromJson(data);
        return newsModel;
      } else {
        throw Exception();
      }
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    } on HttpException {
      throw TimeOutException('No Service Found');
    } on FormatException {
      throw TimeOutException('Invalid Response format');
    } on TimeOutException {
      throw TimeOutException('Time Out Exception');
    } catch (e) {
      throw Exception();
    }
  }

  @visibleForTesting
  dynamic returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        dynamic responseJson = jsonDecode(response.body);
        return responseJson;
      case 400:
        throw BadRequestException(response.statusCode.toString());
      case 401:
      case 403:
        throw UnauthorisedException(response.statusCode.toString());
      case 404:
        throw NotFoundException(response.statusCode.toString());
      case 408:
        throw TimeOutException(response.statusCode.toString());
      case 409:
        throw ConflictException(response.statusCode.toString());
      case 500:
        throw InternalServerErrorException(response.statusCode.toString());
      case 503:
        throw ServiceUnavailableException(response.statusCode.toString());
      default:
        throw FetchDataException(
            'Error occured while communication with server' +
                ' with status code : ${response.statusCode}');
    }
  }
}
