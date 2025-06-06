import 'package:flutter/material.dart';
import 'db_helper.dart';
import 'add_entry_page.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Daily Journal',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFFFDF6F0), // pastel açık ton
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFBFD8B8), // pastel yeşil
          elevation: 0,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFFBFD8B8),
        ),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _pageController = PageController(initialPage: 0);
  final int _daysToShow = 30;
  DateTime _startDate = DateTime.now();

  Map<String, List<Map<String, dynamic>>> _entriesByDate = {};

  @override
  void initState() {
    super.initState();
    _loadAllEntries();
  }

  Future<void> _loadAllEntries() async {
    final allEntries = await DBHelper.instance.getEntries();
    Map<String, List<Map<String, dynamic>>> grouped = {};

    for (var entry in allEntries) {
      String dateKey;
      if (entry['date'] != null && entry['date'] is String && (entry['date'] as String).isNotEmpty) {
        dateKey = entry['date'];
      } else if (entry['created_at'] != null) {
        dateKey = DateFormat('yyyy-MM-dd').format(DateTime.parse(entry['created_at']));
      } else {
        dateKey = DateFormat('yyyy-MM-dd').format(DateTime.now());
      }

      grouped.putIfAbsent(dateKey, () => []);
      grouped[dateKey]!.add(entry);
    }

    setState(() {
      _entriesByDate = grouped;
    });
  }

  Future<void> _deleteEntry(int id) async {
    await DBHelper.instance.deleteEntry(id);
    await _loadAllEntries();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Journal'),
        centerTitle: true,
      ),
      body: PageView.builder(
        controller: _pageController,
        itemCount: _daysToShow,
        itemBuilder: (context, index) {
          final date = _startDate.subtract(Duration(days: -index));
          final dateKey = DateFormat('yyyy-MM-dd').format(date);
          final entries = _entriesByDate[dateKey] ?? [];

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  DateFormat('EEEE, MMMM d, yyyy').format(date),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF6B705C),
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: entries.isEmpty
                      ? Center(
                          child: Text(
                            'No entries for this day.',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        )
                      : ListView.builder(
                          itemCount: entries.length,
                          itemBuilder: (context, i) {
                            final entry = entries[i];
                            return Card(
                              color: const Color(0xFFE0E2DB), // pastel gri
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: ListTile(
                                title: Text(
                                  entry['title'],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF3D405B),
                                  ),
                                ),
                                subtitle: Text(
                                  entry['content'],
                                  style: const TextStyle(color: Color(0xFF3D405B)),
                                ),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.redAccent),
                                  onPressed: () => _deleteEntry(entry['id']),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AddEntryPage()),
          );
          _loadAllEntries();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
