import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'detailArticle.dart';
import 'package:http/http.dart' as http;
import 'Article.dart';

class ArticleList extends StatefulWidget {
  const ArticleList({Key? key}) : super(key: key);

  @override
  State<ArticleList> createState() => ArticleListState();
}

class ArticleListState extends State<ArticleList> {
  Future<List> fetchArticles() async {
    final response = await http.get(Uri.parse(
        'https://clemfourment.fr/?api_key=k7M58iSTK2qcfgT7R3Em8G3mCH825qRv4Map'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load album');
    }
  }

  late Future<List> futureArticles;
  void initState() {
    super.initState();
    futureArticles = fetchArticles();
  }

  Widget build(BuildContext context) {
    final articles = [];
    final articleTemp = [];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(100, 63, 46, 0),
        title: const Text('Liste des articles'),
      ),
      body: Center(
        child: FutureBuilder<List>(
          future: futureArticles,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              snapshot.data?.forEach((element) => {articleTemp.add(element)});

              articleTemp.forEach((element) => {
                    articles.add(
                      Article(
                        element["id"],
                        element["name"],
                        element["description"],
                        double.parse(element["price"].toString()),
                        element["priceUnit"],
                        element["w"],
                        element["l"],
                        element["h"],
                        double.parse(element["mark"].toString()),
                        element["urlImage"],
                        element["urlGLB"],
                        element["glbRatio"],
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailArticle(
                                id: element["id"], articles: articles),
                          ),
                        ),
                      ),
                    )
                  });

              return ListView(
                children: articles
                    .map((article) => ArticleCard(article: article))
                    .toList(),
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}

class ArticleCard extends StatelessWidget {
  ArticleCard({Key? key, required this.article}) : super(key: key);
  final Article article;

  @override
  build(BuildContext context) {
    return Card(
      child: InkWell(
        splashColor: const Color.fromARGB(190, 63, 46, 0),
        onTap: () {
          article.onTap!();
        },
        child: ListTile(
          leading: ConstrainedBox(
            constraints: const BoxConstraints(
              minWidth: 64,
              minHeight: 64,
              maxWidth: 64,
              maxHeight: 64,
            ),
            child: Image.network(article.urlImage, fit: BoxFit.fill),
          ),
          title: Text(article.name),
          subtitle: Text(article.description),
        ),
      ),
    );
  }
}
