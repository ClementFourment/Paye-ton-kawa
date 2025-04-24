import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'Product.dart';

Future<List> fetchProducts() async {
  var response = await http.get(
    Uri.parse('https://615f5fb4f7254d0017068109.mockapi.io/api/v1/products'),
  );
  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception('Failed to load album');
  }
}

class ProductsList extends StatefulWidget {
  const ProductsList({Key? key}) : super(key: key);

  @override
  State<ProductsList> createState() => _ProductsList();
}

class _ProductsList extends State<ProductsList> {
  late Future<List> futureProducts;
  void initState() {
    super.initState();
    futureProducts = fetchProducts();
  }

  Widget build(BuildContext context) {
    final products = [];
    final productTemp = [];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(100, 63, 46, 0),
        title: const Text('Liste des produits'),
      ),
      body: Center(
        child: FutureBuilder<List>(
          future: futureProducts,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              snapshot.data?.forEach((element) => {productTemp.add(element)});

              productTemp.forEach((element) => {
                    products.add(
                      Product(
                        element["createdAt"],
                        element["name"],
                        element["details"]["price"],
                        element["details"]["description"],
                        element["details"]["color"],
                        element["stock"],
                        element["id"],
                      ),
                    )
                  });

              return ListView(
                children: products
                    .map((product) => ProductCard(product: product))
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

class ProductCard extends StatelessWidget {
  ProductCard({Key? key, required this.product}) : super(key: key);
  final Product product;

  @override
  build(BuildContext context) {
    return Card(
      child: InkWell(
        splashColor: const Color.fromARGB(190, 63, 46, 0),
        child: ListTile(
          leading: ConstrainedBox(
            constraints: const BoxConstraints(
              minWidth: 64,
              minHeight: 64,
              maxWidth: 64,
              maxHeight: 64,
            ),
            child:
                Image.network("https://picsum.photos/64/64", fit: BoxFit.fill),
          ),
          title: Text(product.name),
          subtitle: Text(product.description),
        ),
      ),
    );
  }
}
