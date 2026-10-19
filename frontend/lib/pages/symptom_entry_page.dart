import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../models/symptom.dart';
import '../providers/symptom_provider.dart';
import 'package:intl/intl.dart';


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
  bool _newSymptomType = false;
  String _newSymptomName = "";
  int _severity = 1;
  DateTime _selectedDate = DateTime.now();
  int _hour = 0;
  int _min = 0;
  int _durationHours = 0;
  int _durationMins = 0;
  String _notes = "";

  static final DateFormat day = DateFormat('dd-MM-yyyy');
  static final DateFormat time = DateFormat('HH:mm');

  @override
  Widget build(BuildContext context) {
    return Consumer<SymptomProvider>(
      builder: (context, provider, child) {
        return Form(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Checkbox(
                value: _newSymptomType,
                onChanged: (bool? value) {
                  _newSymptomType = value!;
                }, 
              ),
              SizedBox(height: 10),
              
              if (_newSymptomType) ...[
                Container(
                  width: 500,
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: "Symptom Name",
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.text,
                    onSubmitted: (value) {
                      _newSymptomName = value;
                    },
                  ),
                ),
              ] else ...[
                DropdownMenu<String>(
                  initialSelection: null,
                  label: Text("Select Symptom"),
                  dropdownMenuEntries: [
                    for (String symptom in provider.symptomNames) DropdownMenuEntry(value: symptom, label: symptom),
                  ],
                  onSelected: (String? value) {
                    _newSymptomName = value!;
                  },
                ),
              ],

              SizedBox(height: 20),
              DropdownMenu<int>(
                initialSelection: 1,
                label: Text("Select Symptom"),
                dropdownMenuEntries: [
                  for (int i = 1; i <= 10; i++) DropdownMenuEntry(value: i, label: "$i"),
                ],
                onSelected: (int? value) {
                  _severity = value!;
                },
              ),
              SizedBox(height: 20),

              Text("Start Time:"),
              Row( children: [
                InputDatePickerFormField(
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime.now(),
                  onDateSaved: (date) {
                    setState(() {
                      _selectedDate = date;
                    });
                  },
                  fieldLabelText: 'Date',
                ),
                SizedBox(width: 20), 
                DropdownMenu<int>(
                  initialSelection: DateTime.now().hour,
                  label: Text("Hour"),
                  dropdownMenuEntries: [
                    for (int i = 0; i <= 23; i++) DropdownMenuEntry(value: i, label: "$i"),
                  ],
                  onSelected: (int? value) {
                    _hour = value!;
                  },
                ),
                SizedBox(width: 20), 
                DropdownMenu<int>(
                  initialSelection: DateTime.now().minute,
                  label: Text("Min"),
                  dropdownMenuEntries: [
                    for (int i = 0; i < 60; i += 15) DropdownMenuEntry(value: i, label: "$i"),
                  ],
                  onSelected: (int? value) {
                    _min = value!;
                  },
                ),
              ]),
              SizedBox(height: 20),

              Text("Duration:"),
                Row( children: [
                Container(
                  width: 100,
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: "Hours",
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    onSubmitted: (value) {
                      int? hours = int.tryParse(value);
                      if (hours != null) {
                        _durationHours = hours;
                      }
                    },
                  ),
                ),
                SizedBox(width: 20),
                Container(
                  width: 80,
                  child:TextField(
                    decoration: InputDecoration(
                      labelText: "Minutes",
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    onSubmitted: (value) {
                      int? minutes = int.tryParse(value);
                      if (minutes != null && minutes < 60) {
                        _durationMins = minutes;
                      }
                    },
                  ),
                ),
              ]),

              Text("Notes:"),
              Container(
                width: 1000,
                height: 500,
                child:TextField(
                  decoration: InputDecoration(
                    labelText: "Notes",
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.text,
                  onSubmitted: (value) {
                    _notes = value;
                  },
                ),
              ),

              ElevatedButton(
                onPressed: () {
                  DateTime date = DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day, _hour, _min, 0);
                  provider.addSymptom(Symptom(id: 0, name: _newSymptomName, note: _notes, severity: _severity, date: date, hours: _durationHours, minutes: _durationMins));
                  Navigator.pop(context);
                },
                child: Text("Submit")
              )
            ],
          ),
        );
      },
    );
  }
}