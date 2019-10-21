import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:note_keeper/models/note.dart';
import 'package:note_keeper/utils/database_helper.dart';
import 'package:sqflite/sqflite.dart';

class noteDetail extends StatefulWidget {
  final String appBarTitle;
  final note _note;

  noteDetail(this._note, this.appBarTitle);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return noteDetailState(this._note, this.appBarTitle);
  }
}

class noteDetailState extends State<noteDetail> {
  var priority = ['High', 'Low'];
  String appBarTitle;
  note _note;
  databaseHelper DBhelper = databaseHelper();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  noteDetailState(this._note, this.appBarTitle);

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.title;
    titleController.text = _note.title;
    descriptionController.text = _note.description;
    return WillPopScope(
        onWillPop: () {
          moveToLastScreen();
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(appBarTitle),
            leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  moveToLastScreen();
                }),
          ),
          body: Form(
              key: formKey,
              child: Padding(
                padding: EdgeInsets.only(top: 15.0, left: 15.0, right: 15.0),
                child: ListView(
                  children: <Widget>[
                    ListTile(
                      title: DropdownButton(
                        items: priority.map((String dropdownStringItem) {
                          return DropdownMenuItem<String>(
                            value: dropdownStringItem,
                            child: Text(dropdownStringItem),
                          );
                        }).toList(),
                        style: textStyle,
                        value: getPriorityAsString(_note.priority),
                        onChanged: (valueSelectedByUser) {
                          setState(() {
                            debugPrint('User selected $valueSelectedByUser');
                            updatePriorityAsInt(valueSelectedByUser);
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                      child: TextFormField(
                        controller: titleController,
                        validator: (String value) {
                          if (value.isEmpty) {
                            return "Please Enter Title";
                          }
                        },
                        style: textStyle,
                        onChanged: (value) {
                          debugPrint('Somthing Changed in Title');
                          updateTitle();
                        },
                        decoration: InputDecoration(
                            labelText: 'Title',
                            labelStyle: textStyle,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0))),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                      child: TextFormField(
                        controller: descriptionController,
                        validator: (String value) {
                          if (value.isEmpty) {
                            return "Please Enter Description";
                          }
                        },
                        style: textStyle,
                        onChanged: (value) {
                          debugPrint('Somthing Changed in Description');
                          updateDesc();
                        },
                        decoration: InputDecoration(
                            labelText: 'Description',
                            labelStyle: textStyle,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0))),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                              child: RaisedButton(
                            color: Theme.of(context).primaryColorDark,
                            textColor: Theme.of(context).primaryColorLight,
                            child: Text(
                              'Save',
                              textScaleFactor: 1.5,
                            ),
                            onPressed: () {
                              setState(() {
                                if (formKey.currentState.validate()) {
                                  debugPrint("Save Button Clicked");
                                  _save();
                                }
                              });
                            },
                          )),
                          Container(
                            width: 5.0,
                          ),
                          Expanded(
                              child: RaisedButton(
                            color: Theme.of(context).primaryColorDark,
                            textColor: Theme.of(context).primaryColorLight,
                            child: Text(
                              'Delete',
                              textScaleFactor: 1.5,
                            ),
                            onPressed: () {
                              setState(() {
                                debugPrint("Delete Button Clicked");
                                _delete();
                              });
                            },
                          ))
                        ],
                      ),
                    )
                  ],
                ),
              )),
        ));
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }

  void updatePriorityAsInt(String val) {
    switch (val) {
      case 'High':
        _note.priority = 1;
        break;
      case 'Low':
        _note.priority = 2;
        break;
    }
  }

  String getPriorityAsString(int val) {
    String prio;
    switch (val) {
      case 1:
        prio = priority[0]; //High
        break;
      case 2:
        prio = priority[1]; //LOW
        break;
    }
    return prio;
  }

  void updateTitle() {
    _note.title = titleController.text;
  }

  void updateDesc() {
    _note.decription = descriptionController.text;
  }

  void _save() async {
    moveToLastScreen();
    _note.date = DateFormat.yMMMd().format(DateTime.now());
    int result;
    if (_note.id != null) {
      //Update Operation
      result = await DBhelper.updateNote(_note);
    } else {
      //Insert Operation
      result = await DBhelper.insertNote(_note);
    }

    if (result != 0) {
      showAlertDialog('Status', 'Note Saved Succcessfully');
    } else {
      showAlertDialog('Status', 'Problem Saving Note');
    }
  }

  void _delete() async {
    moveToLastScreen();
    if (_note.id == null) {
      showAlertDialog('Status', 'No Note was deleted');
      return;
    }
    int result = await DBhelper.deleteNote(_note.id);
    if (result != 0) {
      showAlertDialog("Status", "Note Deleted Successfully");
    } else {
      showAlertDialog("status", "Error Occured while Deleting Note");
    }
  }

  void showAlertDialog(String title, String msg) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(msg),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }
}
