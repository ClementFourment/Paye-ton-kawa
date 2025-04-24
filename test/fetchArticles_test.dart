import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:collection/collection.dart';

import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:path/path.dart';
import 'package:paye_ton_kawa/Article.dart';
import 'package:paye_ton_kawa/articleList.dart';

// Generate a MockClient using the Mockito package.
// Create new instances of this class in each test.
@GenerateMocks([http.Client])
void main() {
  group('fetchQrCode', () {
    test('returns an Revendeur if the http call completes successfully',
        () async {
      ArticleListState articleList = ArticleListState();

      const json =
          '{"id": 1,"name": "Coffeematic","description": "Machine à café Coffeematic","price": 49.99,"priceUnit": "euro","w": 30,"l": 60,"h": 50,"mark": 3.8,"urlImage": "https://clemfourment.fr/articles/img/machine1.png","urlGLB": "https://clemfourment.fr/articles/glb/machine1.glb","glbRatio": 20}';
      void fakeFunction() {}

      Article articleFake = const Article(
          1,
          "Coffeematic",
          "Machine à café Coffeematic",
          49.99,
          "euro",
          30,
          60,
          50,
          3.8,
          "https://clemfourment.fr/articles/img/machine1.png",
          "https://clemfourment.fr/articles/glb/machine1.glb",
          20,
          null);
      Article article =
          const Article(1, "", "", 0, "", 0, 0, 0, 0, "", "", 0, null);

      List<dynamic> futureArticles = await articleList.fetchArticles();

      expect(articleFake.name, futureArticles[0]['name']);
    });
  });
}
