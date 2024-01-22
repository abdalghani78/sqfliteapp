import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqfliteapp/widget/archivepage.dart';
import 'package:sqfliteapp/widget/defultfromfield.dart';
import 'package:sqfliteapp/widget/donepage.dart';
import 'package:sqfliteapp/widget/homepage.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

List<Widget> screens = [
  const HomePage(),
  const ArchivePage(),
  const DonePage(),
];

class _HomeState extends State<Home> {
  late Database database;
  int currentIndex = 0;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  bool isBottomSheet = false;
  IconData fabIcon = Icons.edit;
  @override
  void initState() {
    super.initState();
    initializeDatabase().then((value) {
      insertToDatabase();
    });
  }

  Future<void> initializeDatabase() async {
    try {
      database = await openDatabase(
        'todo.db',
        version: 1,
        onCreate: (db, version) {
          log('database created');
          db.execute(
              'CREATE TABLE tasks(id INTEGER PRIMARY KEY , title TEXT ,date TEXT , time TEXT ,status TEXT)');
        },
        onOpen: (db) {
          log(db.path);
          log('database opened');
        },
      );
      log('Database initialized successfully');
      // Now that the database is initialized, you can call insertToDatabase
    } catch (error) {
      log('Error initializing database: $error');
    }
  }

  Future<void> insertToDatabase() async {
    try {
      await database.transaction((txn) async {
        await txn.rawInsert(
            'INSERT INTO tasks(title,date,time,status) VALUES("second tasks" , "0220", "2024", "old" )');
        log('insert successfully');
      });
    } catch (error) {
      log('Error during insertion: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Scaffold(
        key: scaffoldKey,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (isBottomSheet) {
              Navigator.pop(context);
              isBottomSheet = false;
              setState(() {
                fabIcon = Icons.edit;
              });
            } else {
              scaffoldKey.currentState?.showBottomSheet((context) {
                return Container(
                  color: Colors.grey[200],
                  width: double.infinity,
                  height: 320,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      children: [
                        buildTextField(
                          context,
                          false,
                          'New Tasks',
                          const Icon(Icons.task),
                        ),
                        // customFromField(
                        //   controller: titleController,
                        //   type: TextInputType.text,
                        //   validate: (value) {
                        //     if (value == null) {
                        //       return 'the data is empty';
                        //     }
                        //     return '';
                        //   },
                        //   label: 'New Tasks',
                        //   prefix: const Icon(Icons.task),
                        // ),
                        const SizedBox(
                          height: 20,
                        ),
                        buildTextField(
                          context,
                          true,
                          'Time',
                          const Icon(Icons.lock_clock),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              //اذا في مشكلة
                            } else {
                              //اذا ما في مشكلة
                            }
                          },
                          child: const Text('Check'),
                        ),
                        // customFromField(
                        //   controller: timeController,
                        //   type: TextInputType.datetime,
                        //   onTap: () {
                        //     showTimePicker(
                        //             context: context,
                        //             initialTime: TimeOfDay.now())
                        //         .then((value) {
                        //       timeController.text =
                        //           value?.format(context) ?? '';
                        //     });
                        //   },
                        //   validate: (value) {
                        //     if (value == null || value.isEmpty) {
                        //       return 'the data is empty';
                        //     } else {
                        //       return 'a';
                        //     }
                        //   },
                        //   label: 'Time',
                        //   prefix: const Icon(Icons.lock_clock),
                        // ),
                      ],
                    ),
                  ),
                );
              });
              setState(() {
                fabIcon = Icons.add;
              });
              isBottomSheet = true;
            }
          },
          child: Icon(fabIcon),
        ),
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          title: const Text(
            'Sqflite',
            style: TextStyle(
              color: Colors.black,
              fontSize: 22.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (value) {
            setState(() {
              currentIndex = value;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.archive),
              label: 'Archive',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.done),
              label: 'Done',
            ),
          ],
        ),
        body: screens[currentIndex],
      ),
    );
  }

  TextFormField buildTextField(
    BuildContext context,
    bool isTap,
    String hint,
    Icon icon,
  ) {
    return TextFormField(
      controller: hint == 'Time' ? timeController : titleController,
      keyboardType: isTap ? TextInputType.datetime : TextInputType.text,
      onTap: isTap
          ? () {
              showTimePicker(context: context, initialTime: TimeOfDay.now())
                  .then((value) {
                if (value != null) {
                  timeController.text = value.format(context);
                } else {
                  formKey.currentState?.validate();
                }
              });
            }
          : null,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'the data is empty';
        }
        return null;
      },
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: hint,
        prefixIcon: icon,
      ),
    );
  }
}
