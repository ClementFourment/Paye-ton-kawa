import 'dart:ffi';

import 'package:flutter/material.dart';
import 'Article.dart';
import 'arArticle.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class DetailArticle extends StatelessWidget {
  const DetailArticle({Key? key, required this.id, required this.articles})
      : super(key: key);

  final int id;
  final List articles;

  @override
  Widget build(BuildContext context) {
    Article article = Article(0, "undefined", "undefined", 0, "undefined", 0, 0,
        0, 0, "undefined", "undefined", 0, () => null);
    articles.forEach(
      (element) => {
        if (element.id == id)
          {
            article = element,
          }
      },
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(190, 63, 46, 0),
        title: const Text(
          "Paye ton kawa",
          style: TextStyle(fontFamily: 'Satisfy-Regular', fontSize: 28),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding:
                const EdgeInsets.only(left: 8, top: 16, right: 8, bottom: 8),
            child: Row(
              children: [
                Text(
                  article.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.only(right: 5),
                  child: RatingBar.builder(
                    initialRating: article.mark,
                    minRating: 0,
                    itemSize: 20,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    ignoreGestures: true,
                    itemCount: 5,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 0),
                    itemBuilder: (context, _) => const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) {},
                  ),
                ),
                Text(
                  article.mark.toString(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding:
                const EdgeInsets.only(left: 8, top: 8, right: 8, bottom: 24),
            child: Text(
              article.description,
              style: TextStyle(
                color: Colors.grey[500],
              ),
            ),
          ),
          Image.network(
            article.urlImage,
            width: 600,
            height: 300,
            fit: BoxFit.cover,
          ),
          Container(
            padding:
                const EdgeInsets.only(left: 8, top: 16, right: 8, bottom: 8),
            child: Text(
              "Prix : ${article.price} ${article.priceUnit}s",
              style: TextStyle(
                color: Colors.grey[500],
              ),
            ),
          ),
          Container(
            padding:
                const EdgeInsets.only(left: 8, top: 8, right: 8, bottom: 8),
            child: Text(
              "Dimensions (w, l, h) : ${article.w} cm, ${article.l} cm, ${article.h} cm",
              style: TextStyle(
                color: Colors.grey[500],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ARArticle(
                          article: article,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(
                        100, 63, 46, 0), // Background color
                  ),
                  child: const Text("Visualiser en 3D"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
