import 'package:flutter/material.dart';
import 'package:ar_flutter_plugin/ar_flutter_plugin.dart';

import 'dart:async';
import 'package:ar_flutter_plugin/managers/ar_anchor_manager.dart';

import 'package:flutter/services.dart';
import 'package:ar_flutter_plugin/managers/ar_location_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_session_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin/models/ar_anchor.dart';
import 'package:ar_flutter_plugin/datatypes/config_planedetection.dart';
import 'package:ar_flutter_plugin/datatypes/node_types.dart';
import 'package:ar_flutter_plugin/datatypes/hittest_result_types.dart';
import 'package:ar_flutter_plugin/models/ar_node.dart';
import 'package:ar_flutter_plugin/models/ar_hittest_result.dart';

import 'package:vector_math/vector_math_64.dart';
import 'dart:math';
import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Paye ton kawa',
      theme: ThemeData(),
      home: const MyHomePage(title: 'Accueil'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _platformVersion = 'Unknown';
  static const String _title = 'Paye ton kawa';
  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    String platformVersion;
    try {
      platformVersion = await ArFlutterPlugin.platformVersion;
    } on PlatformException {
      platformVersion = "Impossible d'obtenir la version de la plate-forme.";
    }
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setNavigationBarWhiteForeground(false);
    FlutterStatusbarcolor.setStatusBarWhiteForeground(true);
    FlutterStatusbarcolor.setNavigationBarColor(
        const Color.fromARGB(255, 255, 255, 255));
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(190, 63, 46, 0),
          title: const Text(
            _title,
            style: TextStyle(fontFamily: 'Satisfy-Regular', fontSize: 28),
          ),
        ),
        body: Column(children: [
          const Text(
            'Liste des articles',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
          ),
          Expanded(
            child: ArticleList(),
          ),
        ]),
      ),
    );
  }
}

class ArticleList extends StatelessWidget {
  ArticleList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final articles = [
      Article(
          'Article à café 1',
          'modele ...',
          () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ARArticle(
                        string: 'idArticle',
                      )))),
    ];
    return ListView(
      children:
          articles.map((article) => ArticleCard(article: article)).toList(),
    );
  }
}

class ArticleCard extends StatelessWidget {
  const ArticleCard({Key? key, required this.article}) : super(key: key);
  final Article article;

  @override
  build(BuildContext context) {
    return Card(
      child: InkWell(
        splashColor: const Color.fromARGB(190, 63, 46, 0),
        onTap: () {
          article.onTap();
        },
        child: ListTile(
          title: Text(article.name),
          subtitle: Text(article.description),
        ),
      ),
    );
  }
}

class Article {
  const Article(this.name, this.description, this.onTap);
  final String name;
  final String description;
  final Function onTap;
}

//==============================
//==============================
//==============================
//==============================
//==============================

class ARArticle extends StatefulWidget {
  ARArticle({Key? key, required String string}) : super(key: key);
  @override
  _ARArticleState createState() => _ARArticleState();
}

class _ARArticleState extends State<ARArticle> {
  ARSessionManager? arSessionManager;
  ARObjectManager? arObjectManager;
  ARAnchorManager? arAnchorManager;

  List<ARNode> nodes = [];
  List<ARAnchor> anchors = [];

  @override
  void dispose() {
    super.dispose();
    arSessionManager!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setNavigationBarColor(Color.fromARGB(255, 0, 0, 0),
        animate: true);
    FlutterStatusbarcolor.setNavigationBarWhiteForeground(true);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(190, 63, 46, 0),
          title: const Text('Nom Article'),
        ),
        body: Container(
            child: Stack(children: [
          ARView(
            onARViewCreated: onARViewCreated,
            planeDetectionConfig: PlaneDetectionConfig.horizontalAndVertical,
          ),
          Align(
            alignment: FractionalOffset.bottomCenter,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      onPressed: onRemoveEverything,
                      child: Text("Retirer tout")),
                ]),
          )
        ])));
  }

  void onARViewCreated(
      ARSessionManager arSessionManager,
      ARObjectManager arObjectManager,
      ARAnchorManager arAnchorManager,
      ARLocationManager arLocationManager) {
    this.arSessionManager = arSessionManager;
    this.arObjectManager = arObjectManager;
    this.arAnchorManager = arAnchorManager;

    this.arSessionManager!.onInitialize(
          showFeaturePoints: false,
          showPlanes: true,
          customPlaneTexturePath: "Images/triangle.png",
          showWorldOrigin: true,
          handlePans: true,
          handleRotation: true,
        );
    this.arObjectManager!.onInitialize();

    this.arSessionManager!.onPlaneOrPointTap = onPlaneOrPointTapped;
    this.arObjectManager!.onPanStart = onPanStarted;
    this.arObjectManager!.onPanChange = onPanChanged;
    this.arObjectManager!.onPanEnd = onPanEnded;
    this.arObjectManager!.onRotationStart = onRotationStarted;
    this.arObjectManager!.onRotationChange = onRotationChanged;
    this.arObjectManager!.onRotationEnd = onRotationEnded;
  }

  Future<void> onRemoveEverything() async {
    /*nodes.forEach((node) {
      this.arObjectManager.removeNode(node);
    });*/
    anchors.forEach((anchor) {
      this.arAnchorManager!.removeAnchor(anchor);
    });
    anchors = [];
  }

  Future<void> onPlaneOrPointTapped(
      List<ARHitTestResult> hitTestResults) async {
    var singleHitTestResult = hitTestResults.firstWhere(
        (hitTestResult) => hitTestResult.type == ARHitTestResultType.plane);
    if (singleHitTestResult != null) {
      var newAnchor =
          ARPlaneAnchor(transformation: singleHitTestResult.worldTransform);
      bool? didAddAnchor = await this.arAnchorManager!.addAnchor(newAnchor);
      if (didAddAnchor!) {
        this.anchors.add(newAnchor);
        // Add note to anchor

        var newNode = ARNode(
            type: NodeType.webGLB,
            uri: '',
            scale: Vector3(0.2, 0.2, 0.2),
            position: Vector3(0.0, 0.0, 0.0),
            rotation: Vector4(1.0, 0.0, 0.0, 0.0));
        bool? didAddNodeToAnchor = await this
            .arObjectManager!
            .addNode(newNode, planeAnchor: newAnchor);
        if (didAddNodeToAnchor!) {
          this.nodes.add(newNode);
        } else {
          this.arSessionManager!.onError("Adding Node to Anchor failed");
        }
      } else {
        this.arSessionManager!.onError("Adding Anchor failed");
      }
    }
  }

  onPanStarted(String nodeName) {
    print("Started panning node " + nodeName);
  }

  onPanChanged(String nodeName) {
    print("Continued panning node " + nodeName);
  }

  onPanEnded(String nodeName, Matrix4 newTransform) {
    print("Ended panning node " + nodeName);
    final pannedNode =
        this.nodes.firstWhere((element) => element.name == nodeName);

    /*
    * Uncomment the following command if you want to keep the transformations of the Flutter representations of the nodes up to date
    * (e.g. if you intend to share the nodes through the cloud)
    */
    //pannedNode.transform = newTransform;
  }

  onRotationStarted(String nodeName) {
    print("Started rotating node " + nodeName);
  }

  onRotationChanged(String nodeName) {
    print("Continued rotating node " + nodeName);
  }

  onRotationEnded(String nodeName, Matrix4 newTransform) {
    print("Ended rotating node " + nodeName);
    final rotatedNode =
        this.nodes.firstWhere((element) => element.name == nodeName);

    /*
    * Uncomment the following command if you want to keep the transformations of the Flutter representations of the nodes up to date
    * (e.g. if you intend to share the nodes through the cloud)
    */
    //rotatedNode.transform = newTransform;
  }
}
