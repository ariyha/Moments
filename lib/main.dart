import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    title: "Diary",
    home: home(),
  ));
}

class home extends StatelessWidget {
  const home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final x = <Widget>[];
    for (int i = 0; i <= 100; i++) {
      x.add(record());
    }
    return Scaffold(
        backgroundColor: ColorScheme.dark().background,
        appBar: AppBar(
          backgroundColor: ColorScheme.dark().primaryContainer,
          title: const Text(
            "Diary",
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.search_outlined),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('This is a snackbar')));
              },
            )
          ],
        ),
        body: ListView(children: x),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              final bar = SnackBar(content: Text("Fuck this shitttt"));
              ScaffoldMessenger.of(context).showSnackBar(bar);
            }));
  }
}

class record extends StatelessWidget {
  const record({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SizedBox(
        height: size.height * 0.1,
        width: size.width,
        child: const Card(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Flexible(
                  flex: 7,
                  fit: FlexFit.tight,
                  child: Card(
                    child: Text("text"),
                  )),
              Flexible(
                  flex: 3,
                  fit: FlexFit.tight,
                  child: Card(
                    child: Text("Date"),
                  ))
            ],
          ),
        ));
  }
}
