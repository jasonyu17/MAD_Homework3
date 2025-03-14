import 'package:flutter/material.dart';
import '../models/cards.dart';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MyGamePage(title: 'Card Game'),
                  ),
                );
              },
              child: const Text('Start Card Game'),
            ),
          ],
        ),
      ),
    );
  }
}

class MyGamePage extends StatefulWidget {
  const MyGamePage({super.key, required this.title});

  final String title;

  @override
  State<MyGamePage> createState() => _MyGamePageState();
}

class _MyGamePageState extends State<MyGamePage> {
  List<Cards> cards = [];
  int score = 0;

  @override
  void initState() {
    super.initState();
    generateCards();
  }

  void generateCards() {
    List<Cards> tempCards = [];
    for (int i = 0; i < 18; i++) {
      int cardNumber = Random().nextInt(13) + 1;
      int cardSuite = Random().nextInt(4)+1;
      int cardID = cardSuite * 100 + cardNumber;
      tempCards.add(
        Cards(cardID: cardID, cardImagePath: "assets/images/back.jpg"),
      );
    }
    cards = [...tempCards, ...tempCards];
    cards.shuffle();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Score:$score'),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(8.0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 6,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 0.7,
                ),
                itemCount: cards.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: (){
                      print(cards[index].cardID);
                    },
                    child: AspectRatio(
                      aspectRatio: 0.7,
                      child: Card(
                        shape: RoundedRectangleBorder(),
                        elevation: 4,
                        child: ClipRRect(
                          child: Image.asset(
                            cards[index].cardImagePath,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
