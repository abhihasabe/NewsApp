import 'package:bloc/bloc.dart';
import 'package:firebaseLoginBloc/blocs/articalBloc/article_event.dart';
import 'package:firebaseLoginBloc/blocs/articalBloc/article_state.dart';
import 'package:firebaseLoginBloc/model/news_model.dart';
import 'package:firebaseLoginBloc/repositories/news_repository.dart';
import 'package:meta/meta.dart';

class ArticleBloc extends Bloc<ArticleEvent, ArticleState> {

  NewsArticleRepository repository;

  ArticleBloc({@required this.repository}) : super(ArticleInitialState());

  @override
  // TODO: implement initialState
  ArticleState get initialState => ArticleInitialState();

  @override
  Stream<ArticleState> mapEventToState(ArticleEvent event) async* {
    if (event is FetchArticlesEvent) {
      yield ArticleLoadingState();
      try {
        NewsModel news = await repository.fetchAllNews();
        yield ArticleLoadedState(articles: news.articles);
      } catch (e) {
        yield ArticleErrorState(message: e.toString());
      }
    }
  }

}