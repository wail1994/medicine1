import 'dart:async';
import 'dart:typed_data';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:medicine/Models/todo.dart';
import 'package:medicine/Utils/Database_Helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class TodoDetail extends StatefulWidget {
  final String appBarTitle;
  final Todo todo;

  TodoDetail(this.todo, this.appBarTitle);

  @override
  State<StatefulWidget> createState() {
    return TodoDetailState(this.todo, this.appBarTitle);
  }
}

class TodoDetailState extends State<TodoDetail> {
  //static var _priorities = ['High', 'Low'];
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  DatabaseHelper helper = DatabaseHelper();

  String appBarTitle;
  Todo todo;

  TextEditingController nameMed = TextEditingController();
  TextEditingController dateStart = TextEditingController();
  TextEditingController dateEnd = TextEditingController();
  TextEditingController time = TextEditingController();

  TodoDetailState(this.todo, this.appBarTitle);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(0),
            child: AppBar(
              // Here we create one to set status bar color
              backgroundColor: Colors
                  .cyan, // Set any color of status bar you want; or it defaults to your theme's primary color
            )),
        body: new Container(
            height: 475,
            child: Padding(
                padding: EdgeInsets.only(top: 35.0, left: 15.0, right: 15.0),
                child: new Center(
                    child: new Theme(
                        data: new ThemeData(
                          primaryColor: Colors.blueGrey,
                          primaryColorDark: Colors.cyan,
                        ),
                        child: new Card(
                            child: Padding(
                          padding: EdgeInsets.only(
                              top: 15.0, left: 15.0, right: 15.0),
                          child: Column(
                            children: <Widget>[
                              new ListTile(
                                subtitle: new Center(
                                  child: new Text(
                                    'ادخل البيانات',
                                    style: TextStyle(
                                        fontSize: 25, color: Colors.blueGrey),
                                  ),
                                ),
                              ),
                              new ListTile(
                                leading: const Icon(
                                  FontAwesome5Solid.tablets,
                                  color: Colors.cyan,
                                ),
                                title: new TextField(
                                  controller: nameMed,
                                  decoration: new InputDecoration(
                                    border: new OutlineInputBorder(

                                      borderRadius: const BorderRadius.all(
                                        const Radius.circular(13.0)
                                      ),
                                    ),
                                    hintText: "اسم الدواء",
                                  ),
                                ),
                              ),
                              new ListTile(
                                onTap: () {
                                  startdate();
                                },
                                leading: const Icon(
                                  FontAwesome5Solid.calendar,
                                  color: Colors.amber,
                                ),
                                title: new TextField(
                                  controller: dateStart,
                                  enabled: false,
                                  decoration: new InputDecoration(
                                    hintText: "تاريخ اخذ الدواء",
                                  ),
                                ),
                              ),
                              new ListTile(
                                onTap: () {
                                  enddate();
                                },
                                leading: const Icon(
                                  FontAwesome5Solid.calendar,
                                  color: Colors.redAccent,
                                ),
                                title: new TextField(
                                  controller: dateEnd,
                                  enabled: false,
                                  decoration: new InputDecoration(
                                    hintText: "تاريخ نهاية اخذ الدواء ",
                                  ),
                                ),
                              ),
                              new ListTile(
                                onTap: () {
                                  timep();
                                },
                                leading: const Icon(
                                  Icons.access_alarms,
                                  color: Colors.blueGrey,
                                ),
                                title: new TextField(
                                  controller: time,
                                  enabled: false,
                                  decoration: new InputDecoration(
                                    hintText: 'وقت التذكير',
                                  ),
                                ),
                              ),
                              FlatButton(
                                color: Colors.white,
                                textColor: Colors.indigo,
                                disabledColor: Colors.white,
                                disabledTextColor: Colors.white,
                                padding: EdgeInsets.all(8.0),
                                splashColor: Colors.white,
                                onPressed: () {
                                  medn(nameMed.text);
                                  dates(dateStart.text, dateEnd.text);
                                  date(time.text);
                                  _save();
                                  String date2 = DateTime.now().toString();
                                  print('$date2');
                                  print('20'+dateStart.text+' '+time.text+':00.000000');


                                showNotification('20'+dateStart.text+' '+time.text+':00.000000');
                                },
                                child: Text(
                                  "حفظ",
                                  style: TextStyle(fontSize: 20.0),
                                ),
                              )
                            ],
                          ),
                        )))))));
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }

  // Convert the String priority in the form of integer before saving it to Database
  // void updatePriorityAsInt(String value) {
  // 	switch (value) {
  // 		case 'High':
  // 			todo.priority = 1;
  // 			break;
  // 		case 'Low':
  // 			todo.priority = 2;
  // 			break;
  // 	}
  // }

  // Convert int priority to String priority and display it to user in DropDown
  // String getPriorityAsString(int value) {
  // 	String priority;
  // 	switch (value) {
  // 		case 1:
  // 			priority = _priorities[0];  // 'High'
  // 			break;
  // 		case 2:
  // 			priority = _priorities[1];  // 'Low'
  // 			break;
  // 	}
  // 	return priority;
  // }

  // Update the title of todo object
  void updateTitle() {
    todo.title = nameMed.text;
  }

  void medn(String name) {
    todo.title = name;
  }

  void dates(String date1, String date2) {
    todo.description = date1 + ' to ' + date2;
  }

  void date(String time) {
    todo.date = time;
  }

  // Update the description of todo object
  void updateDescription() {
    todo.description = dateStart.text;
  }

  // Save data to database
  void _save() async {
    moveToLastScreen();
    int result;
    if (todo.id != null) {
      // Case 1: Update operation
      result = await helper.updateTodo(todo);
    } else {
      // Case 2: Insert Operation
      result = await helper.insertTodo(todo);
    }
    if (result != 0) {
      // Success
      _showAlertDialog('Status', 'Todo Saved Successfully');
    } else {
      // Failure
      _showAlertDialog('Status', 'Problem Saving Todo');
    }
  }

  void startdate() {
    DatePicker.showDatePicker(context, showTitleActions: true,
        onChanged: (sdate) {
      print('change $sdate in time zone ' +
          sdate.timeZoneOffset.inHours.toString());
    }, onConfirm: (sdate) {
      String month = sdate.month.toString();
      String day = sdate.day.toString();
      String y = sdate.year.toString();
      if (month.length == 2 && day.length == 2) {
        dateStart.text = y.substring(2) + '-' + month + '-' + day;
      }
      if (month.length == 1 && day.length == 2) {
        dateStart.text = y.substring(2) + '-0' + month + '-' + day;
      }
      if (month.length == 2 && day.length == 1) {
        dateStart.text = y.substring(2) + '-' + month + '-0' + day;
      }
      if (month.length == 1 && day.length == 1) {
        dateStart.text = y.substring(2) + '-0' + month + '-0' + day;
      }

      print('confirm $sdate');
    }, currentTime: DateTime.now(), locale: LocaleType.en);
  }

  void enddate() {
    DatePicker.showDatePicker(context, showTitleActions: true,
        onChanged: (edate) {
      print('change $edate in time zone ' +
          edate.timeZoneOffset.inHours.toString());
    }, onConfirm: (edate) {
      String month = edate.month.toString();
      String day = edate.day.toString();
      String y = edate.year.toString();

      if (month.length == 2 && day.length == 2) {
        dateEnd.text = y.substring(2) + '-' + month + '-' + day;
      }
      if (month.length == 1 && day.length == 2) {
        dateEnd.text = y.substring(2) + '-0' + month + '-' + day;
      }
      if (month.length == 2 && day.length == 1) {
        dateEnd.text = y.substring(2) + '-' + month + '-0' + day;
      }
      if (month.length == 1 && day.length == 1) {
        dateEnd.text = y.substring(2) + '-0' + month + '-0' + day;
      }

      print('confirm $edate');
    }, currentTime: DateTime.now(), locale: LocaleType.en);
  }

  void timep() {
    DatePicker.showTime12hPicker(context, showTitleActions: true,
        onChanged: (time2) {
      print('change $time in time zone ' +
          time2.timeZoneOffset.inHours.toString());
    }, onConfirm: (time2) {
      print('confirm $time2');

      String month = time2.hour.toString();
      String day = time2.minute.toString();

      if (month.length == 2 && day.length == 2) {
        time.text = month + ':' + day;
      }
      if (month.length == 1 && day.length == 2) {
        time.text = '0' + month + ':' + day;
      }
      if (month.length == 2 && day.length == 1) {
        time.text = month + ':0' + day;
      }
      if (month.length == 1 && day.length == 1) {
        time.text = '0' + month + ':0' + day;
      }
    }, currentTime: DateTime.now(), locale: LocaleType.en);
  }

  void _delete() async {
    moveToLastScreen();

    // Case 1: If user is trying to delete the NEW todo i.e. he has come to
    // the detail page by pressing the FAB of todoList page.
    if (todo.id == null) {
      _showAlertDialog('Status', 'No Todo was deleted');
      return;
    }

    // Case 2: User is trying to delete the old todo that already has a valid ID.
    int result = await helper.deleteTodo(todo.id);
    if (result != 0) {
      _showAlertDialog('Status', 'Todo Deleted Successfully');
    } else {
      _showAlertDialog('Status', 'Error Occured while Deleting Todo');
    }
  }

  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }

  showNotification(String DateStart ) async {
    var android = AndroidNotificationDetails(
        'channel id', 'channel name', 'channel description');
    var iOS = IOSNotificationDetails();
    var platform = NotificationDetails(android, iOS);
    final birthday = DateTime.parse('$DateStart');
    final date2 = DateTime.now();
    final difference = birthday.difference(date2).inMilliseconds;
    print('$difference');

    var scheduledNotificationDateTime =
    new DateTime.now().add(Duration(milliseconds: difference+1000));
String Now=DateTime.now( ).toString( );
if( Now==DateStart.toString()) {
  await flutterLocalNotificationsPlugin.schedule(
      difference, 'Title ', 'Body', scheduledNotificationDateTime, platform );

  print( new DateTime.now( ).toString( ) + 'pppp' );
  print( '$DateStart+pppp' );
}
   //var time = Time(11, 45, 0);

   //await flutterLocalNotificationsPlugin.showDailyAtTime(0, 'Title ', 'Body', time, platform);

  }

  @override
  void initState() {
    super.initState();
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    var android = AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOS = IOSInitializationSettings();
    var initSettings = InitializationSettings(android, iOS);
    flutterLocalNotificationsPlugin.initialize(initSettings,
        onSelectNotification: onSelectNotification);
  }
  Future onSelectNotification(String payload) {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text("ALERT"),
          content: Text("CONTENT: $payload"),
        ));
  }



}
