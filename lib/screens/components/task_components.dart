import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:todo/bloc/todo_cubit.dart';


Widget buildTaskItem(Map task,context)
{
  return Padding(
    padding: const EdgeInsets.all(20.0),
    child: Row(
      children: [
        CircleAvatar(
          radius: 35,
          child: Text('${task['time']}'),
        ),
        const SizedBox(
          width: 20,
        ),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children:  [
              Text('${task['title']}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text('${task['date']}',
                style: const TextStyle(
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          width: 20,
        ),
        IconButton(
          onPressed:()
          {
            TodoCubit.get(context).updateData(status: 'done', id:task['id']);
          },
          icon: const Icon(
            Icons.check_box,
            color: Colors.green,
          ),
        ),
        IconButton(
          onPressed:()
          {
            TodoCubit.get(context).updateData(status: 'archive', id:task['id']);
          },
          icon: const Icon(
            Icons.archive,
            color: Colors.grey,
          ),
        ),
        IconButton(
          onPressed:()
          {
            TodoCubit.get(context).deleteData(id:task['id']);
          },
          icon: const Icon(
            Icons.delete_forever,
            color: Colors.redAccent,
          ),
        ),
      ],
    ),
  );
}

Widget taskBuilder({
  required List<Map> task
})
{
  return ConditionalBuilder(
    condition:task.isNotEmpty ,
    builder: (context)
    {
      return ListView.separated(
        itemBuilder: (context,index)
        {
          return buildTaskItem(task[index], context);
        },
        separatorBuilder: (context, index)
        {
          return Padding(
            padding: const EdgeInsetsDirectional.only(
              start: 30,
              end: 30,
            ),
            child: Container(
              width: double.infinity,
              height: 1,
              color: Colors.grey[300],
            ),
          );
        },
        itemCount: task.length,
      );
    },
    fallback: (context)
    {
      return Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.menu,
                color: Colors.grey,
                size: 100,
              ),
              SizedBox(
                height: 10,
              ),
              Text('No Tasks Yet, Please add some tasks',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),)
            ],
          ),
        ),
      );
    },
  );
}