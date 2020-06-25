import 'package:flutter/material.dart';
import 'package:medicine/Models/todo.dart';
import 'package:medicine/Screens/todo_detail.dart';
import 'package:medicine/Screens/todo_list.dart';
void main() => runApp(new MaterialApp(home: new MyApp(),));


class MyApp extends StatelessWidget{
  @override
   String appBarTitle;
   Todo todo;

  Widget build(BuildContext context) {
    TextEditingController _name;
    return new MaterialApp(
      title: 'Navigation main',
      routes: <String , WidgetBuilder>{
        '/First': (BuildContext  context) => new TodoList(),
        '/Second': (BuildContext  context) => new TodoDetail(this.todo,this.appBarTitle),

      },
      home: new TodoList(),
    );
  }


}