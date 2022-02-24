import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:uni_campus/user_crud.dart';

import '../../storage.dart';

final storageProvider = ChangeNotifierProvider((ref) {
  return Store();
});

class TodoList extends StatefulHookConsumerWidget {
  const TodoList({Key? key}) : super(key: key);

  @override
  TodoListState createState() => TodoListState();
}

class TodoListState extends ConsumerState<TodoList> {
  final _form = GlobalKey<FormState>();
  final _desFocusNode = FocusNode();
  late String title;
  late String description;
  int item = 0;
  List<Task> taskList = [];

  fetchTask() {
    //final v = ref.read(storageProvider);
    UserCrud().fetchUserProfile();
  }

  @override
  void initState() {
    super.initState();
    fetchTask();
    print("enter");
  }

  @override
  Widget build(BuildContext context) {
    final v = ref.watch(storageProvider);

    taskList = v.taskList;

    //fetchTask();

    //print("fkjnkj");
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const Text(
          "TODO",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: PopupMenuButton(
                onSelected: (item) => onSelected(context, item),
                itemBuilder: (context) {
                  return [
                    const PopupMenuItem(
                      value: 0,
                      child: Text("All"),
                    ),
                    const PopupMenuItem(
                      value: 1,
                      child: Text("Completed"),
                    ),
                    const PopupMenuItem(
                      value: 2,
                      child: Text("Pending"),
                    )
                  ];
                }),
          )
        ],
      ),
      body: taskList.length > 0
          ? ListView.builder(
              itemBuilder: (context, index) {
                //return TaskTile(v, taskList, index);
                // switch(item){
                //   default: taskList[index].status=="completed"?
                //   TaskTile(v, taskList, index):SizedBox(height: 0,);
                //   break;
                // }
                //
                if (item == 2) {
                  return taskList[index].status == "pending"
                      ? TaskTile(v, taskList, index)
                      : const SizedBox(
                          height: 0,
                        );
                } else if (item == 1) {
                  return taskList[index].status == "completed"
                      ? TaskTile(v, taskList, index)
                      : const SizedBox(
                          height: 0,
                        );
                } else {
                  return TaskTile(v, taskList, index);
                }
              },
              itemCount: taskList.length,
            )
          : const Center(
              child: Text("No Added Task"),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          bottomSheet();
        },
        label: const Text("Add Task"),
        icon: const Icon(Icons.add),
        backgroundColor: Colors.red,
      ),
    );
  }

  Future bottomSheet() {
    return showModalBottomSheet(
        //context: context,
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Form(
                    key: _form,
                    child: Column(
                      //mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                                child: Padding(
                                  padding: EdgeInsets.only(top: 8.0.h),
                                  child: const CircleAvatar(
                                      backgroundColor: Colors.red,
                                      child: Icon(Icons.clear)),
                                ),
                                onTap: () {
                                  Navigator.pop(context);
                                }),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 10.0.h),
                          child: Text(
                            "Add Task",
                            style: TextStyle(fontSize: 20.sp),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 15.h),
                          child: TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Title',
                              border: OutlineInputBorder(
                                //borderRadius: new BorderRadius.circular(25.0),
                                borderSide: BorderSide(),
                              ),
                            ),
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.text,
                            onFieldSubmitted: (_) {
                              FocusScope.of(context)
                                  .requestFocus(_desFocusNode);
                            },
                            onSaved: (value) {
                              title = value!;
                            },
                            validator: (value) {
                              if (value != null ? value.isEmpty : true) {
                                return 'Please provide a value.';
                              }
                              return null;
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: TextFormField(
                            //initialValue: _initValues['description'],
                            decoration: const InputDecoration(
                              labelText: 'Description',
                              border: OutlineInputBorder(
                                //borderRadius: new BorderRadius.circular(25.0),
                                borderSide: BorderSide(),
                              ),
                            ),
                            maxLines: 3,
                            keyboardType: TextInputType.multiline,
                            focusNode: _desFocusNode,
                            onSaved: (value) {
                              description = value!;
                            },
                            validator: (value) {
                              if (value != null ? value.isEmpty : true) {
                                return 'Please enter a description.';
                              }
                              if (value != null ? value.length < 10 : true) {
                                return 'Should be at least 10 characters long.';
                              }
                              return null;
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 15.0.h, bottom: 15.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                  onPressed: () {
                                    _saveForm(context);
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 20.0.h, horizontal: 10.w),
                                    child: const Text("ADD_TASK"),
                                  )),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future<void> _saveForm(context) async {
    try {
      final isValid = _form.currentState?.validate();
      if (!isValid!) {
        return;
      }
      _form.currentState?.save();

      // await Store().add(
      //
      // );

      final v = ref.watch(storageProvider);
      await v.add(Task(
        title: title,
        description: description,
      ));
    } catch (e) {
      Navigator.pop(context);
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Oops!'),
          content: const Text('Something went wrong'),
          actions: <Widget>[
            TextButton(
              child: const Text('Okay'),
              onPressed: () {
                Navigator.of(ctx).pop();
                //return;
              },
            )
          ],
        ),
      );
    }
    print("save 2 $title and description is $description");
    Navigator.pop(context);

    // Navigator.of(context).pop();
  }

  onSelected(BuildContext context, Object? i) {
    switch (i) {
      case 0:
        setState(() {
          item = 0;
        });
        break;
      case 1:
        setState(() {
          item = 1;
        });
        break;
      case 2:
        setState(() {
          item = 2;
        });
        break;
    }
  }
}

class TaskTile extends StatefulWidget {
  //const TaskTile({Key? key}) : super(key: key);
  var v;
  List<Task> taskList;
  int index;

  TaskTile(this.v, this.taskList, this.index);

  @override
  _TaskTileState createState() => _TaskTileState();
}

class _TaskTileState extends State<TaskTile> {
  @override
  Widget build(BuildContext context) {
    print("status of item is ${widget.taskList[widget.index].status}");
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
      child: Material(
        elevation: 7,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15))),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: ListTile(
            leading: widget.taskList[widget.index].status == "pending"
                ? GestureDetector(
                    onTap: () {
                      widget.v.completeTask(widget.index);
                      setState(() {});
                    },
                    child: const CircleAvatar(
                        backgroundColor: Colors.red,
                        child: Icon(
                          Icons.check,
                        )),
                  )
                : GestureDetector(
                    onTap: () {
                      widget.v.pendingTask(widget.index);
                      setState(() {});
                    },
                    child: const CircleAvatar(
                        backgroundColor: Colors.green,
                        child: Icon(
                          Icons.check,
                        )),
                  ),
            //child: Text("${widget.index+1}"),

            title: Text(widget.taskList[widget.index].title),
            subtitle: Text(widget.taskList[widget.index].description),
            trailing: GestureDetector(
              onTap: () async {
                widget.v.remove(widget.index);
              },
              child: const Icon(Icons.delete_forever),
            ),
          ),
        ),
      ),
    );
  }
}
