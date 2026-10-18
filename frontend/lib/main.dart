import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

void main() {
  runApp (MaterialApp(
    initialRoute: '/',
    routes: {
      '/': (context) => const HomePage(),
      'symptom_entry': (context) => const SymptomEntryPage(),
      'login': (context) => const LoginPage(),
      'register': (context) => const RegisterPage(),
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

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: Center(
        child: Text("Login Form Goes Here"),
      ),
    );
  }
}

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register"),
      ),
      body: Center(
        child: Text("Registration Form Goes Here"),
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

  _setMode(int mode) {
    setState(() {
      _selectedMode = mode;
    });
  }

  List<Symptom> _getSymptoms() {
    // Backend logic to fetch symptoms for the selected day can be called here
    switch (_selectedMode) {
      case 0:
        // Fetch symptoms for the selected day
        // return symptomsForRange(_selectedDay, 0);
        Symptom exampleSymptom = (
          name: "Headache",
          note: "Mild headache in the morning",
          severity: 3,
          date: _selectedDay,
          hours: 1,
          minutes: 30
        );
        Symptom exampleSymptom2 = (
          name: "Fatigue",
          note: "Feeling tired after work",
          severity: 5,
          date: DateTime.now(),
          hours: 2,
          minutes: 0
        );
        return [exampleSymptom, exampleSymptom2];
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
        ModeSelector(_setMode),
        Text("Selected Mode: ${_selectedMode == 0 ? "Day" : _selectedMode == 1 ? "Range" : "Symptom"}"),
        SizedBox(height: 20),
        SymptomList(_getSymptoms()),
      ],
    );
  }
}

class ModeSelector extends StatelessWidget {
  const ModeSelector(this.onModeChanged, {super.key});

  final Function(int) onModeChanged;


  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () {
            onModeChanged(0);
          },
          child: Text("Day"),
        ),
        SizedBox(width: 10),
        ElevatedButton(
          onPressed: () {
            // Set mode to range
            onModeChanged(1);
          },
          child: Text("Range"),
        ),
        SizedBox(width: 10),
        ElevatedButton(
          onPressed: () {
            // Set mode to symptom
            onModeChanged(2);
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
  static final DateFormat day = DateFormat('dd-MM-yyyy');
  static final DateFormat time = DateFormat('HH:mm');

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text("${symptom.name} - ${symptom.severity}/10"),
      subtitle: Text("Notes:\n${symptom.note}"),
      trailing: Text("${day.format(symptom.date)}\n${time.format(symptom.date)}"),
      leading: Text("${symptom.hours}h ${symptom.minutes}m"),
    );
  }
}

typedef Symptom = ({String name, String note, int severity, DateTime date, int hours, int minutes});