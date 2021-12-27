import 'package:firebaseLoginBloc/blocs/articalBloc/article_bloc.dart';
import 'package:firebaseLoginBloc/blocs/articalBloc/article_event.dart';
import 'package:firebaseLoginBloc/blocs/articalBloc/article_state.dart';
import 'package:firebaseLoginBloc/blocs/authBloc/authentication_bloc.dart';
import 'package:firebaseLoginBloc/blocs/authBloc/authentication_event.dart';
import 'package:firebaseLoginBloc/model/news_model.dart';
import 'package:firebaseLoginBloc/screens/news_detail_screen.dart';
import 'package:firebaseLoginBloc/theme/colors.dart';
import 'package:firebaseLoginBloc/utils/utils.dart';
import 'package:firebaseLoginBloc/widgets/news_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<HomePage> {
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  ArticleBloc articleBloc;

  @override
  void initState() {
    super.initState();
    articleBloc = BlocProvider.of<ArticleBloc>(context)..add(FetchArticlesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldMessengerKey,
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text('News'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              BlocProvider.of<AuthenticationBloc>(context)
                ..add(AuthenticationEventLoggedOut());
            },
          )
        ],
      ),
      body: Container(
        child: BlocListener<ArticleBloc, ArticleState>(
          listener: (context, state) {
            if (state is ArticleErrorState) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("${state.message}"),
                ));
              });
            }
          },
          child: BlocBuilder<ArticleBloc, ArticleState>(
            builder: (context, state) {
              if (state is ArticleInitialState) {
                return Utils.buildLoading();
              } else if (state is ArticleLoadingState) {
                return Utils.buildLoading();
              } else if (state is ArticleLoadedState) {
                return News(articles:state.articles);
              } else if (state is ArticleErrorState) {
                return buildErrorUi(state.message);
              }
            },
          ),
        ),
      ),
    );
  }

  Widget buildErrorUi(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          message,
          style: TextStyle(color: Colors.red),
        ),
      ),
    );
  }
}
