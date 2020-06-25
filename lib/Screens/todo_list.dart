import 'dart:async';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:medicine/Models/todo.dart';

import 'package:medicine/Screens/todo_detail.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medicine/Utils/database_helper.dart';
import 'package:sqflite/sqflite.dart';

class TodoList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return TodoListState();
  }
}

class TodoListState extends State<TodoList> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Todo> todoList;
  Todo todo;
  int count = 0;

  @override
  Widget build(BuildContext context) {
    if (todoList == null) {
      todoList = List<Todo>();
      updateListView();
    }

    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(0),
          child: AppBar(
            // Here we create one to set status bar color
            backgroundColor: Colors
                .cyanAccent, // Set any color of status bar you want; or it defaults to your theme's primary color
          )),
      body: getTodoListView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          debugPrint('FAB clicked');
          navigateToDetail(Todo('', '', ''), 'Add Todo');
        },
        tooltip: 'Add Todo',
        child: Icon(FontAwesome5Solid.book_medical),
        backgroundColor: Colors.cyan,
      ),
    );
  }

  ListView getTodoListView() {
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        return Card(
            color: Colors.white,
            elevation: 2.0,
            child: ListTile(
              leading: Padding(
                padding: EdgeInsets.only(top: 0.0, left: 0.0, bottom: 0.0),
                child: Icon(
                  FontAwesome5Solid.pills,
                  color: Colors.deepOrangeAccent,
                  size: 35.0,
                ),
              ),
              title: Padding(
                padding: EdgeInsets.only(top: 15.0, left: 10.0),
                child: Text(this.todoList[position].title,
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              subtitle: Padding(
                  padding: EdgeInsets.only(right: 0.0),
                  child: new Column(
                    children: <Widget>[
                      Chip(
                      backgroundColor: Colors.white30,
                      avatar: CircleAvatar(
                        backgroundColor: Colors.white30,
                        child: Icon(
                          Icons.date_range,
                          color: Colors.amber,
                        ),
                      ),
                      label: Text(this.todoList[position].description,
                          style: TextStyle(color: Colors.grey, fontSize: 12.0)),
                    ),
                      Chip(
                        backgroundColor: Colors.white30,
                        avatar: CircleAvatar(
                          backgroundColor: Colors.white30,
                          child: Icon(
                            Icons.date_range,
                            color: Colors.amber,
                          ),
                        ),
                        label: Text(this.todoList[position].description,
                            style: TextStyle(color: Colors.grey, fontSize: 12.0)),
                      )],


                  )),
              trailing: Padding(
                padding: EdgeInsets.only(top: 5.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Chip(
                          backgroundColor: Colors.white30,
                          avatar: CircleAvatar(
                            backgroundColor: Colors.white30,
                            child: Icon(
                              Icons.alarm_on,
                              color: Colors.blue,
                            ),
                          ),
                          label: Text(this.todoList[position].date,
                              style: TextStyle(color: Colors.grey)),
                        ),
                      ],
                    ),
                    GestureDetector(
                      child: Icon(
                        Icons.delete,
                        color: Colors.red,
                        size: 25.0,
                      ),
                      onTap: () {
                        _delete(context, todoList[position]);
                      },
                    ),
                  ],
                ),
              ),
            ));
      },
    );
  }

  getFirstLetter(String title) {
    return title.substring(0, 1);
  }

  void _delete(BuildContext context, Todo todo) async {
    int result = await databaseHelper.deleteTodo(todo.id);
    if (result != 0) {
      _showSnackBar(context, 'Todo Deleted Successfully');
      updateListView();
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  void navigateToDetail(Todo todo, String title) async {
    bool result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return TodoDetail(todo, title);
    }));

    if (result == true) {
      updateListView();
    }
  }

  void updateListView() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Todo>> todoListFuture =
          databaseHelper.getTodoList() as Future<List<Todo>>;
      todoListFuture.then((todoList) {
        setState(() {
          this.todoList = todoList;
          this.count = todoList.length;
        });
      });
    });
  }
}
