import 'package:flutter/material.dart';
import 'package:znotes/db/database_provider.dart';
import 'package:znotes/model/note_model.dart';
import 'package:znotes/screens/display_note.dart';
import '../screens/add_note.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: "/",
      routes: {
        '/': (context) => HomeScreen(),
        "/AddNote": (context) => AddNotes(),
        "/ShowNote": (context) => ShowNote(),
      },
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //getting all notes
  getNotes() async {
    final notes = await DatabaseProvider.db.getNotes();
    return notes;
  }

  @override
  Widget build(BuildContext context) {
    int count = 1;
    return Scaffold(
      // creating future builder to display the element
      appBar: AppBar(
        title: Text(
          'Your Notes',
          style: TextStyle(color: Colors.pink),
        ),
        backgroundColor: Colors.amber,
      ),
      body: FutureBuilder(
        future: getNotes(),
        builder: (context, AsyncSnapshot snapshot) {
          var data = snapshot.data;
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            case ConnectionState.done:
              {
                // check if we didnt get a null
                if (snapshot.data == Null) {
                  return Center(
                    child: Text('You Don\'t have any notes yet,create one :)'),
                  );
                } else {
                  return Padding(
                    padding: EdgeInsets.all(15),
                    child: snapshot.data == null
                        ? Center(
                            child:
                                Text('You Don\'t have any notes yet,create :)'),
                          )
                        : ListView.builder(
                            itemCount: data.length,
                            itemBuilder: (context, index) {
                              String title = snapshot.data![index]['title'];
                              String body = snapshot.data![index]['body'];
                              String creation_date =
                                  snapshot.data![index]['creation_date'];
                              int id = snapshot.data![index]['id'];
                              return Dismissible(
                                onDismissed: (direction) {
                                  DatabaseProvider.db.deleteNote(id);
                                  Navigator.pushNamedAndRemoveUntil(
                                      context, '/', (route) => false);
                                },
                                background: Container(
                                  color: Theme.of(context).errorColor,
                                  child: Icon(
                                    Icons.delete,
                                    color: Colors.white,
                                    size: 40,
                                  ),
                                  alignment: Alignment.centerRight,
                                  padding: EdgeInsets.only(right: 20),
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 4),
                                ),
                                direction: DismissDirection.endToStart,
                                key: ValueKey(id),
                                child: Card(
                                  color: Colors.pink,
                                  child: ListTile(
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 7),
                                    trailing: Icon(Icons.remove_red_eye),
                                    leading: Text((index+1).toString(),style: TextStyle(color: Colors.white,fontSize: 18),),
                                    onTap: () {
                                      Navigator.pushNamed(context, "/ShowNote",
                                          arguments: NoteModel(
                                              id: id,
                                              title: title,
                                              body: body,
                                              creation_date: DateTime.parse(
                                                  creation_date)));
                                    },
                                    title: Text(
                                      title,
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.amberAccent),
                                    ),
                                    subtitle: Text(
                                      body,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                      ),
                                      maxLines: 2,
                                    ),
                                  ),
                                ),
                              );
                            }),
                  );
                }
              }
          }
          return Text('');
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.pink,
        child: Icon(Icons.note_add),
        onPressed: () {
          Navigator.pushNamed(context, '/AddNote');
        },
      ),
    );
  }
}
