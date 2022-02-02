import 'package:easy_text_field/easy_text_field.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Easy Text Field'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            EasyTextField<DataModel>(
              itemBuilder: (context, data) {
                return ListTile(
                  leading: const Icon(Icons.shopping_cart),
                  title: Text(data.name),
                  subtitle: Text('\$${data.id}'),
                );
              },
              suggestionsCallback: (string) {
                return List.generate(3, (index) => DataModel(index, "$string search"));
              },
              parseObjectToString: (data) {
                return data.toString();
              },
              onSuggestionSelected: (data) {},
              onDeleted: (data) {},
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class DataModel {
  final int id;
  final String name;

  DataModel(this.id, this.name);

  @override
  String toString() {
    return name;
  }
}
