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
            alignment: Alignment.center,
            child: Text("JohnKompot"),
          ),
        ),
        body: Calendar(),
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

  List<Symptom> _getSymptoms() {
    // Backend logic to fetch symptoms for the selected day can be called here
    switch (_selectedMode) {
      case 0:
        // Fetch symptoms for the selected day
        // return symptomsForRange(_selectedDay, 0);
      case 1:
        // Fetch symptoms for the selected range
        // return symptomsForRange(_selectedDay, _selectedRange);
      case 2:
        // Fetch symptoms for the selected symptom
        // return symptomsForSymptom(_selectedSymptom);
    }
    return [];
  }

  List<Symptom> _getSymptomsCalendar() {
    // Backend logic to fetch symptoms for the calendar can be called here
    //return sympotomsForCalendar();
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text("Calendar", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        TableCalendar(
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
          return _getSymptomsCalendar();
          },
        ),
        SizedBox(height: 20),
        //ModeSelector(),
        SizedBox(height: 20),
        //SymptomList(),
      ],
    );
  }
}

class ModeSelector extends StatelessWidget {
  const ModeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () {
            // Set mode to day
          },
          child: Text("Day"),
        ),
        SizedBox(width: 10),
        ElevatedButton(
          onPressed: () {
            // Set mode to range
          },
          child: Text("Range"),
        ),
        SizedBox(width: 10),
        ElevatedButton(
          onPressed: () {
            // Set mode to symptom
          },
          child: Text("Symptom"),
        ),
      ],
    );
  }
}

class SymptomList extends StatelessWidget {
  const SymptomList(this.symptoms, {super.key}); 

  final List<Symptom> symptoms;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: symptoms.length,
      itemBuilder: (context, index) {
        return SymptomDisplay(symptom: symptoms[index]);
      },
    );
  }
}


class SymptomDisplay extends StatelessWidget {
  const SymptomDisplay({super.key, required this.symptom});

  final Symptom symptom;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(symptom.name),
      subtitle: Text("${symptom.note} - Severity: ${symptom.severity}"),
      trailing: Text("${symptom.date.toLocal()}"),
    );
  }
}

typedef Symptom = ({String name, String note, int severity, DateTime date, int hours, int minutes});