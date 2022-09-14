import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'add_movie_page.dart';

// DOC : https://firebase.flutter.dev/

Future<void> main() async {
  // Prevenir bug android
  WidgetsFlutterBinding.ensureInitialized();
  // Init firebase
  await Firebase.initializeApp();
  // Init app
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Firebase',
      theme: ThemeData.dark(),
      home: const HomePage(title: 'Flutter Firebase'),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(title),
            leading: IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AddMoviePage(),
                          fullscreenDialog: true));
                })),
        body: const MoviesInformation());
  }
}

class MoviesInformation extends StatefulWidget {
  const MoviesInformation({super.key});

  @override
  State<MoviesInformation> createState() => _MoviesInformationState();
}

class _MoviesInformationState extends State<MoviesInformation> {
  final Stream<QuerySnapshot> _moviesStream = FirebaseFirestore.instance
      .collection('movies')
      .orderBy('name')
      .snapshots();

  void addLike(String docID, int likes) {
    FirebaseFirestore.instance
        .collection('movies')
        .doc(docID)
        .update({'likes': likes + 1});
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _moviesStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text("Une erreur s'est produite");
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Chargement en cours...");
        }

        return ListView(
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data =
                document.data()! as Map<String, dynamic>;
            return Padding(
                padding: const EdgeInsets.all(10),
                child: Row(children: [
                  // Photos
                  SizedBox(width: 100, child: Image.network(data['image'])),
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Name
                          Text(
                            data['name'],
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          // Year
                          const Text('Année de production'),
                          Text(data['year'].toString()),
                          // Categories
                          Row(
                            children: [
                              for (final categorie in data['categories'])
                                Padding(
                                    padding: const EdgeInsets.only(right: 5),
                                    child: Chip(
                                      backgroundColor: Colors.lightBlue,
                                      label: Text(categorie),
                                    ))
                            ],
                          ),
                          // Likes
                          Row(
                            children: [
                              IconButton(
                                  padding: EdgeInsets.zero,
                                  iconSize: 20,
                                  icon: const Icon(Icons.favorite),
                                  onPressed: () {
                                    addLike(document.id, data['likes']);
                                  }),
                              Text(data['likes'].toString()),
                            ],
                          )
                        ],
                      ))
                ]));
          }).toList(),
        );
      },
    );
  }
}
