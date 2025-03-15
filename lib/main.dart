import 'package:flutter/material.dart';
import '../models/cards.dart';
import '../models/flip.dart';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Card Start Screen'),
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
  List<bool> flipped = [];
  List<bool> matched = [];
  int score = 0;
  int firstFlippedIndex = -1;
  int secondFlippedIndex = -1;
  bool waitingForCheck = false;

  @override
  void initState() {
    super.initState();
    generateCards();
  }

  void generateCards() {
    List<Cards> tempCards = [];
    for (int i = 0; i < 18; i++) {
      int cardNumber = Random().nextInt(13) + 1;
      int cardSuite = Random().nextInt(4) + 1;
      int cardID = cardSuite * 100 + cardNumber;
      tempCards.add(
        Cards(cardID: cardID, cardImagePath: "assets/images/back.jpg"),
      );
    }
    cards = [...tempCards, ...tempCards];
    cards.shuffle();

    flipped = List.generate(36, (index) => false);
    matched = List.generate(36, (index) => false);
  }

  void flipCard(int index) {
    if (matched[index] || flipped[index] || waitingForCheck) return;

    setState(() {
      flipped[index] = true;
    });

    if (firstFlippedIndex == -1) {
      firstFlippedIndex = index;
    } else {
      secondFlippedIndex = index;
      waitingForCheck = true;
      Future.delayed(const Duration(seconds: 1), () {
        checkMatch();
      });
    }
  }

  void checkMatch() {
    if (cards[firstFlippedIndex].cardID == cards[secondFlippedIndex].cardID) {
      setState(() {
        matched[firstFlippedIndex] = true;
        matched[secondFlippedIndex] = true;
        score += 10;
      });
    } else {
      setState(() {
        flipped[firstFlippedIndex] = false;
        flipped[secondFlippedIndex] = false;
      });
    }
    firstFlippedIndex = -1;
    secondFlippedIndex = -1;
    waitingForCheck = false;

    if (matched.every((m) => m)) {
      showWinDialog();
    }
  }

  void showWinDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("You Win!"),
            content: Text("Final Score: $score"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  setState(() {
                    generateCards();
                    score = 0;
                  });
                },
                child: const Text("Play Again"),
              ),
            ],
          ),
    );
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
            Text(
              'Score: $score',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
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
                return FlipCard(
                  frontImage: "assets/images/back.jpg", // Card back
                  backImage: "assets/images/${cards[index].cardID}.png", // Card face
                  isFlipped: flipped[index] || matched[index],
                  onFlip: () => flipCard(index),
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
