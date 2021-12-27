import 'package:firebaseLoginBloc/model/news_model.dart';
import 'package:firebaseLoginBloc/screens/news_detail_screen.dart';
import 'package:flutter/material.dart';

class News extends StatefulWidget {
  List<Articles> articles;

  News({Key key, this.articles}) : super(key: key);

  @override
  _NewsState createState() => _NewsState();
}

class _NewsState extends State<News> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.articles.length,
      itemBuilder: (ctx, pos) {
        return InkWell(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              widget.articles[pos].urlToImage != null
                  ? Image.network(
                      widget.articles[pos].urlToImage,
                      fit: BoxFit.cover,
                      height: 180,
                      width: MediaQuery.of(context).size.width,
                    )
                  : Container(),
              Text(widget.articles[pos].title,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              SizedBox(
                height: 15,
              )
            ],
          ),
          onTap: () {
            navigateToArticleDetailPage(context, widget.articles[pos]);
          },
        );
      },
    );
  }

  void navigateToArticleDetailPage(BuildContext context, Articles article) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return ArticleDetailPage(
        article: article,
      );
    }));
  }
}
