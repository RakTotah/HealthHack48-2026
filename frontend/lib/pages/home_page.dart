import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../models/symptom.dart';
import '../providers/symptom_provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<SymptomProvider>().fetchSymptomsByDate(DateTime.now(), 1));
    Future.microtask(() => context.read<SymptomProvider>().fetchSymptomsNames());
  }

  DateTime _selectedDay = DateTime.now();
    DateTime _focusedDay = DateTime.now();
    bool _symptomMode = false;

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
        body: Consumer<SymptomProvider>(
        builder: (context, provider, child) {
          if (provider.symptoms.isEmpty) {
            return Center(child: CircularProgressIndicator());
          }
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
              ),
              SizedBox(height: 20),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _symptomMode = false;
                          });
                        },
                        child: Text("By Date"),
                      ),
                      SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {
                          // Set mode to symptom mode
                          setState(() {
                            _symptomMode = false;
                          });
                        },
                        child: Text("By Symptom"),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  if (_symptomMode == false) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            provider.fetchSymptomsByDate(_selectedDay, 1);
                          },
                          child: Text("Day"),
                        ),
                        SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () {
                            provider.fetchSymptomsByDate(_selectedDay, 7);
                          },
                          child: Text("Week"),
                        ),
                        SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () {
                            provider.fetchSymptomsByDate(_selectedDay, DateUtils.getDaysInMonth(_selectedDay.year, _selectedDay.month));
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
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            onSubmitted: (value) {
                              int? customDays = int.tryParse(value);
                              if (customDays != null && customDays > 0) {
                                provider.fetchSymptomsByDate(_selectedDay, customDays);
                              }
                              },
                            ),
                          ),
                        ],
                      ),
                    ]
                    else ...[
                      DropdownMenu<String>(
                        initialSelection: null,
                        label: Text("Select Symptom"),
                        dropdownMenuEntries: [
                          for (String symptom in provider.symptomNames) DropdownMenuEntry(value: symptom, label: symptom),
                        ],
                        onSelected: (String? value) {
                          if (value != null) {
                            provider.fetchSymptomsBySymptom(value);
                          }
                        },
                      ),
                    ]
                  ],
                ),
                SizedBox(height: 20),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: provider.symptoms.length,
                  itemBuilder: (context, index) {
                    return SymptomDisplay(symptom: provider.symptoms[index]);
                  },
                ),
              ],
            );
          },
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