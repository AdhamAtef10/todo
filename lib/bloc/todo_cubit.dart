import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/screens/archived_tasks_screen.dart';
import 'package:todo/screens/new_tasks_screen.dart';
import '../screens/done_tasks_screen.dart';
part 'todo_state.dart';

class TodoCubit extends Cubit<TodoState> {
  TodoCubit() : super(TodoInitial());
  static TodoCubit get(context)=>BlocProvider.of(context);

  int currentIndex = 0;
  List<Widget> screens = [
    const NewTasksScreen(),
    const DoneTasksScreen(),
    const ArchivedTasksScreen(),
  ];
  List<String> titles = [
    'New Tasks',
    'Done Tasks',
    'Archived Tasks'
  ];

  void changeIndex(int index)
  {
    currentIndex=index;
    emit(TodoChangeBottomNavBarState());
  }

   Database? database;
  List<Map>?newTasks=[];
  List<Map>?doneTasks=[];
  List<Map>?archivedTasks=[];
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();
  bool isBottomSheetShown = false;
  IconData fabIcon = Icons.edit;
  void changeBottomSheetState({required bool isShow,required IconData icon})
  {
    isBottomSheetShown=isShow;
    fabIcon=icon;
    emit(AppChangeBottomSheetState());
  }

  void createDatabase()  {
    openDatabase('todo.db',
        version: 1, // low hazwod table msln hazwod l version a5leh 2 we hakza
        onCreate: (database, version) {
          if (kDebugMode) {
            print('database created');
          }
          database
              .execute(
              'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)')
              .then((value) {
            if (kDebugMode) {
              print('table created');
            }
          }).catchError((error) {
            if (kDebugMode) {
              print('Error when creating table${error.toString()}');
            }
          });
        }, onOpen: (database) {
          getDataFromDatabase(database);
          if (kDebugMode) {
            print('database opened');
          }
        }).then((value) {
          database=value;
          emit(AppCreateDataBaseState());
    });
  }

   insertToDatabase({
    required String title,
    required String time,
    required String date,
  }) async {
    await database!.transaction((txn) async
    {
      txn.rawInsert(
          'INSERT INTO tasks(title, date, time, status) VALUES("$title", "$date", "$time", "new")'
      )
          .then((value) {
        if (kDebugMode) {
          print('$value inserted successfully');
        }
        emit(AppInsertDataBaseState());
        getDataFromDatabase(database);
      }).catchError((error) {
        if (kDebugMode) {
          print('Error when inserting new record  $error');
        }
      });
    });
  }

  void getDataFromDatabase(database)
  {
    newTasks=[];
    doneTasks=[];
    archivedTasks=[];
    emit(AppGetDataBaseLoadingState());
     database!.rawQuery('SELECT * FROM tasks').then((value) {
      value.forEach((element)
      {
        if(element['status']=='new')
        {
          newTasks!.add(element);
        }
        else
          if(element['status']=='done')
          {
            doneTasks!.add(element);
          }
          else
          {
            archivedTasks!.add(element);
          }
      });
      emit(AppGetDataBaseState());
    });
  }

  void updateData({
    required String status,
    required int id,
  })async
  {
     database!.rawUpdate(
         'UPDATE tasks SET status =?  WHERE id =?',
        [status,id]
     ).then((value) {
       getDataFromDatabase(database);
       emit(AppUpdateDataBaseState());
     });
  }

  void deleteData(
  {
  required int id,
})async
  {
    database!.rawDelete(
        'DELETE FROM tasks WHERE id=?',[id]
    ).then((value) {
      getDataFromDatabase(database);
      emit(AppDeleteDataBaseState());
    });
  }
}
