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
    debugShowCheckedModeBanner: false,
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
        child: SymptomEntryForm()
      ),
    );
  }
}

class SymptomEntryForm extends StatefulWidget {
  const SymptomEntryForm({super.key});

  @override
  State<SymptomEntryForm> createState() => _SymptomEntryFormState();
}

class _SymptomEntryFormState extends State<SymptomEntryForm> {
  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          // Form fields go here
        ],
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
  bool _symptomMode = false; // false for date range, true for symptom
  String _selectedSymptom = ""; // Name of the selected symptom
  int _selectedRange = 1; // Number of days for range selection

  _setMode(bool mode) {
    setState(() {
      _symptomMode = mode;
    });
  }

  _setSymptom(String symptom) {
    setState(() {
      _selectedSymptom = symptom;
    });
  }

  _setRange(String range) {
    int days = 0;
    switch (range) {
      case "day":
        days = 1;
        break;
      case "week":
        days = 7;
        break;
      case "month":
        days = DateUtils.getDaysInMonth(_selectedDay.year, _selectedDay.month);
        break;
      case "custom":
        // Custom range logic can be implemented here
        break;
    }
    setState(() {
      _selectedRange = days;
    });
  }

  List<String> _getUserSymptoms() {
    // Backend logic to fetch user symptoms can be called here
    return ["Headache", "Fatigue", "Nausea"]; // Example symptom options
  }

  List<Symptom> _getSymptoms() {
    // Backend logic to fetch symptoms for the selected day can be called here
    switch (_symptomMode) {
      case false:
        // Fetch symptoms for the selected range
        // return symptomsForRange(_selectedDay, _selectedRange);
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
      case true:
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

  late final List<String> _symptomOptions = _getUserSymptoms(); // Example symptom options

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
        ModeSelector(_symptomMode, _selectedSymptom, _symptomOptions, _setMode, _setRange, _setSymptom),
        SizedBox(height: 20),
        SymptomList(_getSymptoms()),
      ],
    );
  }
}

class ModeSelector extends StatelessWidget {
  const ModeSelector(this.mode, this.symptom, this.symptomOptions, this.onModeChanged, this.onRangeChanged, this.onSymptomChanged, {super.key});

  final bool mode;
  final String symptom;
  final List<String> symptomOptions;
  final Function(bool) onModeChanged;
  final Function(String) onRangeChanged;
  final Function(String) onSymptomChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                onModeChanged(false);
              },
              child: Text("By Date"),
            ),
            SizedBox(width: 10),
            ElevatedButton(
              onPressed: () {
                // Set mode to symptom mode
                onModeChanged(true);
              },
              child: Text("By Symptom"),
            ),
          ],
        ),
        SizedBox(height: 10),
        if (mode == false) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  onRangeChanged("day");
                },
                child: Text("Day"),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  onRangeChanged("week");
                },
                child: Text("Week"),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  onRangeChanged("month");
                },
                child: Text("Month"),
              ),
              SizedBox(width: 10),
              Container(
                width: 100,
                child: TextField(
                  decoration: InputDecoration(
                    labelText: "Custom",
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  onSubmitted: (value) {
                    int? customDays = int.tryParse(value);
                    if (customDays != null && customDays > 0) {
                      onRangeChanged("custom");
                    }
                  },
                ),
              ),
            ],
          ),
        ]
        else ...[
          DropdownMenu<String>(
            initialSelection: symptom,
            label: Text("Select Symptom"),
            dropdownMenuEntries: [
              for (var symptom in symptomOptions) DropdownMenuEntry(value: symptom, label: symptom),
              // Add more symptoms as needed
            ],
            onSelected: (String? value) {
              if (value != null) {
                onSymptomChanged(value);
              }
            },
          ),
        ]
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