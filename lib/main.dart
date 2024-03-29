// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/NewEntry.dart';

void main() async {
  runApp(
    MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Diary",
        home: const Home(),
        theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.brown,
              brightness: Brightness.dark,
            ))),
  );
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
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
        body: const Column(
          children: [QuoteWidget(), MomentsList()],
        ),
        floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(_createMoment());
            }));
  }

  Route _createMoment() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => NewMomentPage(
        title: '',
      ),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.ease;
        final tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        final offsetAnimation = animation.drive(tween);
        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
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

class MomentsList extends StatefulWidget {
  const MomentsList({super.key});

  @override
  State<MomentsList> createState() => _MomentsListState();
}

List getdata() {
  var x = [];
  for (int i = 0; i <= 30; i++) {
    var s = i.toString();
    x.add(s);
  }
  return x;
}

class _MomentsListState extends State<MomentsList> {
  final items = getdata();
  var visiblity = false;
  int currindex = 0;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Stack(
        children: [
          ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return InkWell(
                  splashColor: ThemeData.dark().splashColor,
                  onTap: () {
                    Navigator.of(context).push(_createRoute(items[index]));
                  },
                  onLongPress: () {
                    setState(() {
                      showDialog(
                          context: context, builder: (_) => DeletePopUp());
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('This is a snackbar')));
                  },
                  child: Record(text: item));
            },
          ),
        ],
      ),
    );
  }

  Route _createRoute(String title) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => NewMomentPage(
        title: title,
      ),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.ease;
        final tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        final offsetAnimation = animation.drive(tween);
        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }
}

class DeletePopUp extends StatefulWidget {
  const DeletePopUp({super.key});

  @override
  State<DeletePopUp> createState() => _DeletePopUpState();
}

class _DeletePopUpState extends State<DeletePopUp>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> scaleAnimation;

  @override
  void initState() {
    super.initState();

    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 450));
    scaleAnimation = CurvedAnimation(parent: controller, curve: Curves.ease);

    controller.addListener(() {
      setState(() {});
    });

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return ScaleTransition(
      scale: scaleAnimation,
      child: AlertDialog(
          title: const Text('Delete'),
          content: const Text("Do you want to delete this Moment?"),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Delete'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ]),
    );
  }
}

class Record extends StatefulWidget {
  String text;
  Record({required this.text, super.key});

  @override
  State<Record> createState() => _RecordState();
}

class _RecordState extends State<Record> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SizedBox(
        height: size.height * 0.1,
        width: size.width,
        child: Card(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Flexible(
                  flex: 7,
                  fit: FlexFit.tight,
                  child: GestureDetector(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(
                          widget.text,
                          style: const TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  )),
              const Flexible(
                  flex: 3,
                  fit: FlexFit.tight,
                  child: Center(child: Text("Date")))
            ],
          ),
        ));
  }
}
