import 'package:flutter/material.dart';
import 'package:note_keeper/screens/notedetails.dart';
import 'dart:async';
import 'package:note_keeper/models/note.dart';
import 'package:note_keeper/utils/database_helper.dart';
import 'package:sqflite/sqflite.dart';
class noteList extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return noteListState();
  }

}
class noteListState extends State<noteList>{
  int count=0;
  databaseHelper DBhelper = databaseHelper();
  List<note> NoteList;

  @override
  Widget build(BuildContext context) {
    if(NoteList==null){
      NoteList=List<note>();
      updateListView();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Notes")
      ),
      body: getNoteListView(),
      floatingActionButton: FloatingActionButton(
        onPressed:(){
          navigateTodetails(note('','',2),'Add Note');
        },
        tooltip: 'Add Note',
        child: Icon(Icons.add),
      ),
    );
  }
  ListView getNoteListView(){
    TextStyle titleStyle= Theme.of(context).textTheme.subhead;
    return ListView.builder(
        itemCount: count,
      itemBuilder: (BuildContext context,int position){
          return Card(
            color: Colors.white,
            elevation: 2.0,
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: getPriorityColor(this.NoteList[position].priority),
                child: getPriorityIcon(this.NoteList[position].priority),
              ),
              title: Text(this.NoteList[position].title,style: titleStyle,),
              subtitle: Text(this.NoteList[position].date),
              trailing: GestureDetector(
                child:Icon(Icons.delete,color: Colors.grey,),
                onTap: (){
                  _delete(context, NoteList[position]);
                },
              ),

              onTap: (){
                navigateTodetails(this.NoteList[position],'Edit Note');
              },
            ),
          );
      },

    );
  }
  void navigateTodetails(note _note,String title) async{
   bool result= await Navigator.push(context, MaterialPageRoute(builder: (context){
      return noteDetail(_note,title);
    }));
   if(result == true){
     updateListView();
   }
  }
  Color getPriorityColor(int priority){
    switch (priority){
      case 1:
        return Colors.red;
        break;
      case 2:
        return Colors.yellow;
        break;
      default:
        return Colors.yellow;
    }
  }

  Icon getPriorityIcon(int priority){
    switch (priority){
      case 1:
        return Icon(Icons.play_arrow);
        break;
      case 2:
        return Icon(Icons.keyboard_arrow_right);
        break;
      default:
        return Icon(Icons.keyboard_arrow_right);
    }
  }

  void _delete(BuildContext context, note _note) async{
    int result= await DBhelper.deleteNote(_note.id);
    if(result !=0){
      _showSnakeBar(context,'Note Deleted Successfully');
      updateListView();
    }
  }

  void _showSnakeBar(BuildContext context,String msg){
    final snackbar=SnackBar(content: Text(msg));
    Scaffold.of(context).showSnackBar(snackbar);
  }
void updateListView(){
    final Future<Database> dbFuture = DBhelper.initialiseDatabase();
    dbFuture.then((database){
      Future<List<note>> noteListFuture= DBhelper.getNoteList();
      noteListFuture.then((noteList) {
        setState(() {
          this.NoteList=noteList;
          this.count=noteList.length;
        });
      });

    });
}
}