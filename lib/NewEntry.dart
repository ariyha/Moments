// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewMomentPage extends StatelessWidget {
  var title = 'Default';
  NewMomentPage({super.key, required this.title});

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
        child: EntryPage(
          title: title,
        ),
      ),
    );
  }
}

class EntryPage extends StatelessWidget {
  String title;
  EntryPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [DetailsBar(title: title), const MomentContent()],
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

class DetailsBar extends StatefulWidget {
  String title;
  DetailsBar({super.key, required this.title});

  @override
  State<DetailsBar> createState() => _DetailsBarState();
}

class _DetailsBarState extends State<DetailsBar> {
  var titlecontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    titlecontroller.text = widget.title;
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width,
      height: size.height * 0.1,
      child: TextField(
        controller: titlecontroller,
        maxLines: 1,
        style: const TextStyle(fontSize: 32),
        decoration: const InputDecoration(
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
