import 'package:flutter/material.dart';
import 'package:multiselect/multiselect.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddMoviePage extends StatefulWidget {
  const AddMoviePage({super.key});

  @override
  _AddMoviePageState createState() => _AddMoviePageState();
}

class _AddMoviePageState extends State<AddMoviePage> {
  final nameController = TextEditingController();
  final yearController = TextEditingController();
  final imageController = TextEditingController();

  List<String> categories = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // App Bar
        appBar: AppBar(title: const Text('Add Movie')),
        body: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                // Nom
                ListTile(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                        side: const BorderSide(
                            color: Colors.white30, width: 1.5)),
                    title: Row(
                      children: [
                        const Text('Nom : '),
                        Expanded(
                            child: TextField(
                                decoration: const InputDecoration(
                                    border: InputBorder.none),
                                controller: nameController))
                      ],
                    )),
                const SizedBox(height: 20),
                // Année
                ListTile(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                        side: const BorderSide(
                            color: Colors.white30, width: 1.5)),
                    title: Row(
                      children: [
                        const Text('Année : '),
                        Expanded(
                            child: TextField(
                                decoration: const InputDecoration(
                                    border: InputBorder.none),
                                controller: yearController))
                      ],
                    )),
                const SizedBox(height: 20),
                // Image
                ListTile(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                        side: const BorderSide(
                            color: Colors.white30, width: 1.5)),
                    title: Row(
                      children: [
                        const Text('Image : '),
                        Expanded(
                            child: TextField(
                                decoration: const InputDecoration(
                                    border: InputBorder.none),
                                controller: imageController))
                      ],
                    )),
                const SizedBox(height: 20),
                // Dropdown categories
                DropDownMultiSelect(
                  onChanged: (List<String> x) {
                    setState(() {
                      categories = x;
                    });
                  },
                  // ignore: prefer_const_literals_to_create_immutables
                  options: [
                    'Action',
                    'Aventure',
                    'Comédie',
                    'Science fiction',
                    'Fanstique',
                    'Drame',
                    'Horreur'
                  ],
                  selectedValues: categories,
                  whenEmpty: 'Catégorie',
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                    onPressed: () {
                      FirebaseFirestore.instance.collection('movies').add({
                        'name': nameController.value.text,
                        'year': yearController.value.text,
                        'image': imageController.value.text,
                        'categories': categories,
                        'likes': 0,
                      });
                    },
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50)),
                    child: const Text('Ajouter'))
              ],
            )));
  }
}
