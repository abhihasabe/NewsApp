import 'package:firebaseLoginBloc/model/news_model.dart';
import 'package:firebaseLoginBloc/networks/news_api_client.dart';

class NewsArticleRepository {
  final newsApiProvider = NewsApiClient();

  // Get news from server
  Future<NewsModel> fetchAllNews() => newsApiProvider.getArticles();
}