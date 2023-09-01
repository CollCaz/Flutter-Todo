import 'package:flutter/material.dart';
import 'package:todo/widgets/todo.dart';

void main() {
  runApp(const TodoApp());
}

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo',
      theme: ThemeData.dark(useMaterial3: true),
      home: const TodoList(title: 'Todo'),
    );
  }
}

class TodoList extends StatefulWidget {
  const TodoList({super.key, required this.title});

  final String title;

  @override
  State<TodoList> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  String todoText = "";
  List<String> todos = [];
  void _addTodoItem() {
    setState(() {
      todoText == "" ? DoNothingAction() : todos.add(todoText);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Stack(
        children: [
          Center(
            child: ListView(
              children: <Widget>[
                // ignore: avoid_print
                for (String item in todos.reversed) TodoItem(todoText: item),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: TextField(
              onChanged: (value) => todoText = value,
              onSubmitted: (value) => _addTodoItem(),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTodoItem,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
