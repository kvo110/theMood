import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => MoodModel()),
        ChangeNotifierProvider(create: (context) => ThemeModel()),
      ],
      child: MyApp(),
    ),
  );
}

// Mood Model - The "Brain" of our app
class MoodModel with ChangeNotifier {
  String _currentMood = 'assets/images/happy.png';
  String _currentMoodKey = 'Happy';

  String get currentMood => _currentMood;
  String get currentMoodKey => _currentMoodKey;

  // Tracks the count for each mood
  final Map<String, int> moodCounts = {
    'Happy': 0,
    'Sad': 0,
    'Excited': 0,
    'Random': 0,
  };

  void setMood(String moodKey) {
    _currentMoodKey = moodKey;
    switch (moodKey) {
      case 'Happy':
        _currentMood = 'assets/images/happy.png';
        break;
      case 'Sad':
        _currentMood = 'assets/images/sad.png';
        break;
      case 'Excited':
        _currentMood = 'assets/images/excited.png';
        break;
      case 'Random':
        _currentMood = 'assets/images/random.png';
        break;
    }
    moodCounts[moodKey] = (moodCounts[moodKey] ?? 0) + 1;
    notifyListeners();
  }

  void setHappy() => setMood('Happy');
  void setSad() => setMood('Sad');
  void setExcited() => setMood('Excited');

  void setRandomMood() {
    final moods = ['Happy', 'Sad', 'Excited', 'Random'];
    final randomIndex = Random().nextInt(moods.length);
    setMood(moods[randomIndex]);
  }
}

// Theme Model - For different app themes
class ThemeModel with ChangeNotifier {
  String _currentTheme = 'Light';
  String get currentTheme => _currentTheme;

  Map<String, Map<String, Color>> moodColors = {
    'Light': {
      'Happy': Colors.yellow,
      'Sad': Colors.blue,
      'Excited': Colors.orange,
      'Random': Colors.grey,
    },
    'Dark': {
      'Happy': Colors.amber[700]!,
      'Sad': Colors.blue[800]!,
      'Excited': Colors.deepOrange[700]!,
      'Random': Colors.grey[800]!,
    },
    'Pastel': {
      'Happy': Color(0xFFFFF9C4), 
      'Sad': Color(0xFFBBDEFB),   
      'Excited': Color(0xFFFFCC80), 
      'Random': Color(0xFFE0E0E0), 
    }
  };

  void setTheme(String themeName) {
    _currentTheme = themeName;
    notifyListeners();
  }

  Color getMoodColor(String moodKey) {
    return moodColors[_currentTheme]![moodKey]!;
  }
}

// Main App Widget
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mood Toggle Challenge',
      home: HomePage(),
    );
  }
}

// Home Page
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final moodModel = context.watch<MoodModel>();
    final themeModel = context.watch<ThemeModel>();

    Color backgroundColor = themeModel.getMoodColor(moodModel.currentMoodKey);

    return Scaffold(
      appBar: AppBar(
        title: Text('Mood Toggle Challenge'),
        backgroundColor: backgroundColor,
      ),
      backgroundColor: backgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Theme Buttons for user to select from
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => themeModel.setTheme('Light'),
                  child: Text('Light'),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => themeModel.setTheme('Dark'),
                  child: Text('Dark'),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => themeModel.setTheme('Pastel'),
                  child: Text('Pastel'),
                ),
              ],
            ),
            SizedBox(height: 20),
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: () => Provider.of<MoodModel>(context, listen: false).setHappy(),
          child: Text('Happy'),
        ),
        ElevatedButton(
          onPressed: () => Provider.of<MoodModel>(context, listen: false).setSad(),
          child: Text('Sad'),
        ),
        ElevatedButton(
          onPressed: () => Provider.of<MoodModel>(context, listen: false).setExcited(),
          child: Text('Excited'),
        ),
        ElevatedButton(
          onPressed: () => Provider.of<MoodModel>(context, listen: false).setRandomMood(),
          child: Text('Random'),
        ),
      ],
    );
  }
}

// Widget to display mood counts
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