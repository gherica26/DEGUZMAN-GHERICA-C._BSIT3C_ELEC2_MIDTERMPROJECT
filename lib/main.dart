import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  // Screens for each navigation item
  static final List<Widget> _pages = [
    const ToDoScreen(),
    const SwipeScreen(),
    const MusicScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.menu),
            label: 'To-Do',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.mobile_friendly),
            label: 'Swipe',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.music_note),
            label: 'Music',
          ),
        ],
      ),
    );
  }
}

// ✅ First Navigator: To-Do List
class ToDoScreen extends StatefulWidget {
  const ToDoScreen({super.key});

  @override
  State<ToDoScreen> createState() => _ToDoScreenState();
}

class _ToDoScreenState extends State<ToDoScreen> {
  final List<String> _tasks = [];
  final TextEditingController _controller = TextEditingController();

  void _addTask() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        _tasks.add(_controller.text);
        _controller.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('To-Do List')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _tasks.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_tasks[index]),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      labelText: 'Enter task',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _addTask,
                  child: const Text('Add'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ✅ Second Navigator: Swipe-Based Color Change
class SwipeScreen extends StatefulWidget {
  const SwipeScreen({super.key});

  @override
  SwipeScreenState createState() => SwipeScreenState();
}

class SwipeScreenState extends State<SwipeScreen> {
  Color bgColor = Colors.white;

  void onSwipe(String direction) {
    setState(() {
      switch (direction) {
        case "left":
          bgColor = Colors.red;
          break;
        case "right":
          bgColor = Colors.blue;
          break;
        case "up":
          bgColor = Colors.green;
          break;
        case "down":
          bgColor = Colors.yellow;
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: GestureDetector(
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity! < 0) {
            onSwipe("left");
          } else if (details.primaryVelocity! > 0) {
            onSwipe("right");
          }
        },
        onVerticalDragEnd: (details) {
          if (details.primaryVelocity! < 0) {
            onSwipe("up");
          } else if (details.primaryVelocity! > 0) {
            onSwipe("down");
          }
        },
        child: const Center(
          child: Text(
            'Swipe to Change Color',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}

// ✅ Third Navigator: Music Player
class MusicScreen extends StatefulWidget {
  const MusicScreen({super.key});

  @override
  State<MusicScreen> createState() => _MusicScreenState();
}

class _MusicScreenState extends State<MusicScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();

  void _playSong(String path) async {
    await _audioPlayer.stop();
    await _audioPlayer.play(AssetSource(path));
  }

  void _stopSong() async {
    await _audioPlayer.stop();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Music Player')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () => _playSong('music/youre_gonna_go_far.mp3'),
            child: const Text('Play "You’re Gonna Go Far"'),
          ),
          ElevatedButton(
            onPressed: () => _playSong('music/all_too_well.mp3'),
            child: const Text('Play "All Too Well"'),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _stopSong,
            child: const Text('Stop'),
          ),
        ],
      ),
    );
  }
}
