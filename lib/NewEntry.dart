import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart'; //this is an external package for formatting date and time

class NewMomentPage extends StatelessWidget {
  const NewMomentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const DatePicker(),
          centerTitle: true,
        ),
        //body: ListView(children: x),
        body: Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10.0),
          child: const EntryPage(),
        ),
        floatingActionButton: FloatingActionButton(
            child: const Text("Done"),
            onPressed: () {
              const bar = SnackBar(content: Text("Fuck this shitttt"));
              ScaffoldMessenger.of(context).showSnackBar(bar);
            }));
  }
}

class EntryPage extends StatelessWidget {
  const EntryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [DetailsBar(), MomentContent()],
    );
  }
}

class DatePicker extends StatefulWidget {
  const DatePicker({super.key});

  @override
  State<DatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  DateTime _selectedDate = DateTime.now();

  //Method for showing the date picker
  void _pickDateDialog() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            //which date will display when user open the picker
            firstDate: DateTime(2020),
            //what will be the previous supported year in picker
            lastDate: DateTime
                .now()) //what will be the up to supported date in picker
        .then((pickedDate) {
      //then usually do the future job
      if (pickedDate == null) {
        //if user tap cancel then this function will stop
        return;
      }
      setState(() {
        //for rebuilding the ui
        _selectedDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: _pickDateDialog,
        child: Text(DateFormat.yMMMMd().format(_selectedDate)));
  }
}

class DetailsBar extends StatelessWidget {
  const DetailsBar({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width,
      height: size.height * 0.1,
      child: const TextField(
        maxLines: 1,
        style: TextStyle(fontSize: 32),
        decoration: InputDecoration(
            border: UnderlineInputBorder(),
            hintText: "Title",
            hintStyle: TextStyle(fontSize: 32)),
      ),
    );
  }
}

class MomentContent extends StatelessWidget {
  const MomentContent({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Expanded(
      child: SizedBox(
        width: size.width,
        child: const TextField(
          maxLines: null,
          style: TextStyle(fontSize: 20),
          keyboardType: TextInputType.multiline,
          decoration: InputDecoration(
              border: InputBorder.none,
              hintText: "Moment",
              hintStyle: TextStyle(fontSize: 20)),
        ),
      ),
    );
  }
}
