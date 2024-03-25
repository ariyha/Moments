import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(MaterialApp(
      title: "Diary",
      home: const Home(),
      theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.green,
            brightness: Brightness.dark,
          ))));
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final x = <Widget>[const QuoteWidget()];
    for (int i = 0; i <= 30; i++) {
      x.add(const Record());
    }

    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Diary",
            style: GoogleFonts.pacifico(),
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
            child: const Icon(Icons.add),
            onPressed: () {
              const bar = SnackBar(content: Text("Fuck this shitttt"));
              ScaffoldMessenger.of(context).showSnackBar(bar);
            }));
  }
}

class QuoteWidget extends StatelessWidget {
  const QuoteWidget({super.key});

  Future<String> getquote() async {
    final httppack =
        Uri.parse('https://api.quotable.io/quotes/random?&maxLength=40');
    final response = await http.get(httppack);
    if (response.statusCode != 200) {
      return "Well be calm and complete your shit";
    } else {
      final List<dynamic> responseData = jsonDecode(response.body);
      if (responseData.isNotEmpty) {
        final Map<String, dynamic> quoteData = responseData.first;
        final String quoteContent = quoteData["content"];
        return quoteContent;
      } else {
        return "Be calm and complete your shit";
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: getquote(),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // While the future is not yet complete, show a loading indicator
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          // If an error occurs, display the error message
          return _buildQuoteCard("Be calm and complete your shit", context);
        } else {
          // Once the future is complete, display the fetched quote
          return _buildQuoteCard(
              snapshot.data ?? "No quote available", context);
        }
      },
    );
  }

  Widget _buildQuoteCard(String quote, BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width,
      height: size.height * 0.05,
      child: Card(
        child: Align(
          child: Text(
            quote,
            style: GoogleFonts.eduNswActFoundation(fontSize: 25),
          ),
        ),
      ),
    );
  }
}

class Record extends StatelessWidget {
  const Record({super.key});

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
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Text(
                          "text",
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  )),
              Flexible(
                  flex: 3,
                  fit: FlexFit.tight,
                  child: Card(
                    child: Center(child: Text("Date")),
                  ))
            ],
          ),
        ));
  }
}
