import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => MoodModel(),
      child: MyApp(),
    ),
  );
}

// Mood Model - The "Brain" of our app
class MoodModel with ChangeNotifier {
  String _currentMood = 'assets/images/happy.png';
  Color _backgroundColor = Colors.yellow;

  // Tracks the count for each mood
  final Map<String, int> moodCounts = {
    'Happy': 0,
    'Sad': 0,
    'Excited': 0,
    'Random': 0,
  };

  String get currentMood => _currentMood;
  Color get backgroundColor => _backgroundColor;

  void setHappy() {
    _currentMood = 'assets/images/happy.png';
    _backgroundColor = Colors.yellow; // sets the background to yellow when mood is happy
    moodCounts['Happy'] = (moodCounts['Happy'] ?? 0) + 1;
    notifyListeners();
  }

  void setSad() {
    _currentMood = 'assets/images/sad.png';
    _backgroundColor = Colors.blue; // sets the background to blue when mood is sad
    moodCounts['Sad'] = (moodCounts['Sad'] ?? 0) + 1;
    notifyListeners();
  }

  void setExcited() {
    _currentMood = 'assets/images/excited.png';
    _backgroundColor = Colors.orange; // sets the background to orange when mode is excited
    moodCounts['Excited'] = (moodCounts['Excited'] ?? 0) + 1;
    notifyListeners();
  }

  void setRandomMood() {
    final moods = ['Happy', 'Sad', 'Excited', 'Random'];
    final randomIndex = Random().nextInt(moods.length);
    final selectedMood = moods[randomIndex];

    switch (selectedMood) {
      case 'Happy':
        setHappy();
        break;
      case 'Sad':
        setSad();
        break;
      case 'Excited':
        setExcited();
        break;
      case 'Random':
        _currentMood = 'assets/images/random.png';
        _backgroundColor = Colors.purple;
        moodCounts['Random'] = (moodCounts['Random'] ?? 0) + 1;
        notifyListeners();
        break;
    }
  }
}

// Main App Widget
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mood Toggle Challenge',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomePage(),
    );
  }
}

// Home Page
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final moodModel = context.watch<MoodModel>();

    return Scaffold(
      appBar: AppBar(title: Text('Mood Toggle Challenge')),
      backgroundColor: moodModel.backgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('How are you feeling?', style: TextStyle(fontSize: 24)),
            SizedBox(height: 30),
            MoodDisplay(),
            SizedBox(height: 50),
            MoodButtons(),
            SizedBox(height: 20),
            Text(
              'Mood Selection Counter: ',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            MoodCounter(),
          ],
        ),
      ),
    );
  }
}

// Widget that displays the current mood
class MoodDisplay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<MoodModel>(
      builder: (context, moodModel, child) {
        return Image.asset(
          moodModel.currentMood,
          height: 200,
          width: 200,
        );
      },
    );
  }
}

// Widget with buttons to change the mood
class MoodButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () {
                Provider.of<MoodModel>(context, listen: false).setHappy();
              },
              child: Text('Happy'),
            ),
            ElevatedButton(
              onPressed: () {
                Provider.of<MoodModel>(context, listen: false).setSad();
              },
              child: Text('Sad'),
            ),
            ElevatedButton(
              onPressed: () {
                Provider.of<MoodModel>(context, listen: false).setExcited();
              },
              child: Text('Excited'),
            ),
          ],
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Provider.of<MoodModel>(context, listen: false).setRandomMood();
              },
              child: Text('Random'),
            ),
          ],
        ),
      ],
    );
  }
}

class MoodCounter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<MoodModel>(
      builder: (context, moodModel, child) {
        return Column(
          children: moodModel.moodCounts.entries.map((entry) {
            return Text(
              '${entry.key}: ${entry.value}',
              style: TextStyle(fontSize: 20),
            );
          }).toList(),
        );
      },
    );
  }
}