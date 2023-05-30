import 'package:flutter/material.dart';
import 'start_page.dart';
void main() {
  return (runApp(const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ACİL İLAÇ',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('ACİL İLAÇ'),
        ),
        body: const Center(
            child: StartWidget(),
            ),
      ),
    );
  }
}
