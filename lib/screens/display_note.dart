import 'package:flutter/material.dart';
import 'package:znotes/db/database_provider.dart';
import 'package:znotes/model/note_model.dart';

class ShowNote extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final NoteModel note =
        ModalRoute.of(context)!.settings.arguments as NoteModel;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text(
          'Your Notes',
          style: TextStyle(color: Colors.pink),
        ),
        actions: [
          IconButton(
            onPressed: () {
              DatabaseProvider.db.deleteNote(note.id);
              Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
            },
            icon: Icon(Icons.delete),
          )
        ],
      ),
      body: ListView(
          children: [
        Container(
          alignment: Alignment.topLeft,
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 10,
              ),
              Card(
                  color: Colors.amber,
                  child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      child: Text(
                        note.title,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ))),
              Divider(
                thickness: 1,
                color: Colors.pink,
              ),
              Container(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                  width: double.infinity,
                  child: Text(
                    note.body,
                    style: TextStyle(fontSize: 15, color: Colors.black),
                  )),
            ],
          ),
        ),
      ]),
    );
  }
}
