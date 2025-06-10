import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(DailyJournalApp());
}

class DailyJournalApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DailyJournalPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class DailyJournalPage extends StatefulWidget {
  @override
  _DailyJournalPageState createState() => _DailyJournalPageState();
}

class _DailyJournalPageState extends State<DailyJournalPage> {
  List<String> tasks = [];

  Future<void> _addTaskDialog(BuildContext context) async {
    // Tarih seçimi
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (selectedDate == null) return; // Tarih seçilmediyse çık

    // Saat seçimi
    TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: 8, minute: 0),
    );

    if (selectedTime == null) return; // Saat seçilmediyse çık

    String taskText = '';
    bool isValid = false;

    // Görev açıklaması için dialog
    await showDialog(
      context: context,
      barrierDismissible: false, // dış tıklamayla kapanmayı engelle
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('New Task'),
              content: TextField(
                autofocus: true,
                decoration: const InputDecoration(hintText: 'Task description'),
                onChanged: (value) {
                  setState(() {
                    taskText = value;
                    isValid = taskText.trim().isNotEmpty;
                  });
                },
              ),
              actions: [
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                TextButton(
                  child: const Text('Add'),
                  onPressed: isValid
                      ? () {
                          Navigator.of(context).pop();
                        }
                      : null, // açıklama yoksa devre dışı
                ),
              ],
            );
          },
        );
      },
    );

    if (taskText.trim().isEmpty) return; // boşsa çık

    // Tarih ve saati birleştir
    final combinedDateTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      selectedTime.hour,
      selectedTime.minute,
    );

    // Formatla (Türkçe ay isimleri için tr_TR kullandım)
    final formattedDate = DateFormat('d MMMM', 'tr_TR').format(combinedDateTime);
    final formattedTime = DateFormat('HH:mm').format(combinedDateTime);

    final newTask = '$formattedDate $formattedTime - $taskText';

    setState(() {
      tasks.add(newTask);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[100],
      body: SafeArea(
        left: true,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Üst başlık ve tarih
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Journal',
                    style: TextStyle(fontSize: 30, fontFamily: 'Cursive'),
                  ),
                  Text('11 HAZ', style: TextStyle(fontSize: 16)),
                ],
              ),
              SizedBox(height: 20),

              // "How was your day?"
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text("How was your day?"),
              ),
              SizedBox(height: 16),

              // Örnek günlük giriş
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
                ),
                child: Row(
                  children: [
                    Column(
                      children: [
                        Text('Mon Jun', style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('10', style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'hfushhfejahvndv\nnsugaggjf<ngbzb\ngzurhgzurzgjijw\nfjfwvnbnbn',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),

              // Görev ekleme bölümü (buton)
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Add new task',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => _addTaskDialog(context),
                      style: ElevatedButton.styleFrom(
                        shape: CircleBorder(),
                        padding: EdgeInsets.all(12),
                      ),
                      child: Icon(Icons.add),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),

              // To-Do List
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('To-Do List', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(height: 8),
                      Expanded(
                        child: tasks.isEmpty
                            ? Center(child: Text('No tasks yet'))
                            : ListView.builder(
                                itemCount: tasks.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 4),
                                    child: Row(
                                      children: [
                                        Icon(Icons.circle, size: 8),
                                        SizedBox(width: 8),
                                        Expanded(child: Text(tasks[index])),
                                      ],
                                    ),
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
