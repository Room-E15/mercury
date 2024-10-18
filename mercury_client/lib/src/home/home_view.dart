import 'package:flutter/material.dart';

class HomeView extends StatelessWidget {

  static const routeName = '/';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MERCURY'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 1, // Number of blank cards
              itemBuilder: (context, index) {
                return const Card(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: SizedBox(
                    height: 100.0, // Height of each blank card
                    child: Column(children: [
                      Stack(
                        children: [
                          LinearProgressIndicator(
                            value: 0.5,
                            backgroundColor: Color.fromARGB(255, 126, 126, 126),
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                            minHeight: 20.0,
                          ),
                          Text(
                            'Card Title',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                      ],)
                    ],)
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: HomeView(),
  ));
}