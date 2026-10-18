import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

void main() {
  runApp (MaterialApp(
    initialRoute: '/',
    routes: {
      '/': (context) => const HomePage(),
      'symptom_entry': (context) => const SymptomEntryPage(),
    },
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Align(
            alignment: Alignment.centerLeft,
            child: Text("JohnKompot"),
          ),
        ),
        body: Center(
          child: Calendar(),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, 'symptom_entry');
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}

class SymptomEntryPage extends StatelessWidget {
  const SymptomEntryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Symptom Entry"),
      ),
      body: Center(
        child: Text("Symptom Entry Form Goes Here"),
      ),
    );
  }
}

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  int _selectedMode = 0; // 0 for day, 1 for range, 2 for symptom
  String _selectedSymptom = ""; // Name of the selected symptom
  int _selectedRange = 0; // Number of days for range selection

  List<Symptom> _getEvents() {
    // Backend logic to fetch events for the selected day can be called here
    switch (_selectedMode) {
      case 0:
        // Fetch events for the selected day
        // return eventsForRange(_selectedDay, 0);
      case 1:
        // Fetch events for the selected range
        // return eventsForRange(_selectedDay, _selectedRange);
      case 2:
        // Fetch events for the selected symptom
        // return eventsForSymptom(_selectedSymptom);
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TableCalendar(
        firstDay: DateTime.utc(2020, 1, 1),
        lastDay: DateTime.now(),
        focusedDay: _focusedDay,
        selectedDayPredicate: (day) {
          return isSameDay(_selectedDay, day);
        },
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = selectedDay;
          });
        },
        eventLoader: (day) {
        return _getEvents();
        },
      ),
    );
  }
}

typedef Symptom = ({String name, String note, int severity, DateTime date, int hours, int minutes});