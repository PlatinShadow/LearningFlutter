import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.black,
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
          child: 
            ListView(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              padding: const EdgeInsets.all(8),
              physics: ClampingScrollPhysics(),
              children: <Widget>[
                Container(
                  height: 50,
                  child: const Center(child: Text('music')),
                ),
                Container(
                  height: 50,
                  child: const Center(child: Text('videos')),
                ),
                Container(
                  height: 50,
                  child: const Center(child: Text('pictures')),
                ),
                Container(
                  height: 50,
                  child: const Center(child: Text('radio')),
                ),
                Container(
                  height: 50,
                  child: const Center(child: Text('marketplace')),
                ),
                Container(
                  height: 50,
                  child: const Center(child: Text('social')),
                ),
                Container(
                  height: 50,
                  child: const Center(child: Text('podcasts')),
                ),
                Container(
                  height: 50,
                  child: const Center(child: Text('internet')),
                ),
                Container(
                  height: 50,
                  child: const Center(child: Text('apps')),
                ),
                Container(
                  height: 50,
                  child: const Center(child: Text('settings')),
                ),
              ],
            )
      );
  }
}
