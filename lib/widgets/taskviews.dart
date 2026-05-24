import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pomogachi/models.dart';
import 'package:pomogachi/handlers.dart';
import 'package:provider/provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:pomogachi/styles.dart';

class taskList extends StatefulWidget {
  final Task task;
  final List tasks;
  const taskList({super.key, required this.task, required this.tasks});

  @override
  State<taskList> createState() => _tasklistState();
}

class _tasklistState extends State<taskList> {

  bool collapsed = true;

  void toggleCollapse() {
    setState(() {
      collapsed = !collapsed;
    });
  }

  @override
  Widget build(BuildContext context) {
    List subtaskList = widget.tasks.where((element) => widget.task.subtasks.contains(element.id)).toList();
    return Column(
      spacing: 3,
      children: [
        taskTile(task: widget.task, onCollapse: toggleCollapse, parent: true),
        (collapsed == false) ? Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
          child: Column(
            spacing: 3,
            children: [for (Task task in subtaskList) taskTile(task: task, onCollapse: toggleCollapse)],
          ),
        ) : SizedBox(),
        SizedBox(height: 20),
      ],
    );
    
    
  }
}

class taskTile extends StatefulWidget {
  final Task task;
  final bool parent;
  final VoidCallback onCollapse;
  const taskTile({super.key, required this.task, this.parent = false, required this.onCollapse});

  @override
  State<taskTile> createState() => _taskTileState();
}

class _taskTileState extends State<taskTile> {
  @override
  Widget build(BuildContext context) {
    return Slidable(
       //key: const ValueKey(0),
       startActionPane: ActionPane(
        motion: ScrollMotion(),
        children: [
                    SlidableAction(
            // An action can be bigger than the others.
            flex: 2,
            onPressed: (context) {
              showEditSheet(context, widget.task);
            },
            backgroundColor: Theme.of(context).colorScheme.secondary,
            foregroundColor: Theme.of(context).colorScheme.primary,
            icon: Icons.edit,
            label: '''
Edit''',
          ),  
                    SlidableAction(
            // An action can be bigger than the others.
            flex: 2,
            onPressed: (context) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return confirmDelete(task: widget.task);
                },
              );
            },
            backgroundColor: Color.fromARGB(255, 236, 181, 181),
            foregroundColor: Colors.white,
            icon: Icons.archive,
            label: '''
Archive''',
          ),
        ],),
    endActionPane:  ActionPane(
        motion: ScrollMotion(),
        children: [
          SlidableAction(
            // An action can be bigger than the others.
            flex: 2,
            onPressed: (context) {
              context.read<ProviderClass>().addToQueue(widget.task);
            },
            backgroundColor: Color.fromARGB(255, 230, 191, 210),
            foregroundColor: Colors.white,
            icon: Icons.archive,
            label: '''
Add to queue''',
          ),          

          if (widget.task.is_Standalone == true || widget.task.subtasks.isNotEmpty)  
            SlidableAction(
            flex: 2,
            onPressed: (context) {
              showCreateSubTaskSheet(context, widget.task);
            },
            backgroundColor: Color.fromARGB(255, 165, 218, 241),
            foregroundColor: Colors.white,
            icon: Icons.add,
            label: 'Add subtask 🫰',
          ) ,
        ],
      ),     
      child: Container(
        width: double.infinity,
        height: 90.8,
        decoration: BoxDecoration(
          color: (widget.parent == true) ? Theme.of(context).colorScheme.onPrimaryContainer : Theme.of(context).colorScheme.onSecondaryContainer,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Material(
                color: Colors.transparent,
                child: InkWell(
                  splashColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () async {
                    
                    context.read<ProviderClass>().toggleComplete(widget.task);
                    
                  },
                  child: Container(
                    width: 50.0,
                    height: 50.0,
                    decoration: BoxDecoration(
                      color: Colors.white
                
                    ),
                    child: (widget.task.is_Completed == true) ? Icon(Icons.check) : SizedBox(),
                  ),
                ),
              ),
      
              Container(
                width: 50.9,
                height: 50.0,
                decoration: BoxDecoration(
              
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 5, 10, 5),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.task.name,
                        style: Theme.of(context).textTheme.bodyMedium,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (widget.task.deadline.isNotEmpty) 
                      Text(
                        widget.task.deadline,
                        style: Theme.of(context).textTheme.bodySmall,
                              ),
                          
                            ],
                          ),
                      ),
              ),
            (widget.parent == true && widget.task.is_Standalone == false) ?           Material(
              color: Colors.transparent,
              child: InkWell(
                  splashColor: Colors.amber,
                  focusColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.amber,
                  onTap: () async {
                    widget.onCollapse();
                  },
                  child: Container(
                    width: 40.9,
                    height: 40.2,
                    
                    decoration: BoxDecoration(
                     
                    ),
                    child: Icon(Icons.arrow_drop_down),
                  ),
                ),
            ) : SizedBox()
      
      ]))),
    );
  }
}

class taskTile2 extends StatefulWidget {
  final Task task;
  final bool parent;
  final VoidCallback onCollapse;
  final int index;
  const taskTile2({
    super.key,
    required this.task,
    this.parent = false,
    required this.onCollapse,
    required this.index,
  });

  @override
  State<taskTile2> createState() => _taskTileState2();
}

class _taskTileState2 extends State<taskTile2> {
  @override
  Widget build(BuildContext context) {
    return Slidable(
   endActionPane:  ActionPane(
        motion: ScrollMotion(),
        children: [
       
         SlidableAction(
            // An action can be bigger than the others.
            flex: 2,
            onPressed: (context) {
               context.read<TimerProvider>().setMode(workMode);
              context.read<TimerProvider>().changeTask(widget.task);
             
              context.read<TimerProvider>().startTimer();
            },
            backgroundColor: Color.fromARGB(255, 230, 191, 210),
            foregroundColor: Colors.white,
            icon: Icons.start,
            label: "Start"
          ), 
          SlidableAction(
            // An action can be bigger than the others.
            flex: 2,
            onPressed: (context) {
              context.read<ProviderClass>().removeFromQueue(widget.task);
            },
            backgroundColor: Theme.of(context).colorScheme.onSecondaryContainer,
            foregroundColor: Colors.white,
            icon: Icons.remove,
            label: "Remove",
          ),         ]),      
      child: Container(
        width: double.infinity,
        height: 90.8,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onPrimaryContainer,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Material(
                color: Colors.transparent,
                child: InkWell(
                  splashColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () async {
                    context.read<ProviderClass>().toggleComplete(widget.task);
                    context.read<ProviderClass>().removeFromQueue(widget.task);
                  },
                  child: Container(
                    width: 50.0,
                    height: 50.0,
                    decoration: BoxDecoration(color: Colors.white),
                    child: (widget.task.is_Completed == true)
                        ? Icon(Icons.check)
                        : SizedBox(),
                  ),
                ),
              ),
      
              Container(width: 50.9, height: 50.0, decoration: BoxDecoration()),
              Expanded(
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 5, 10, 5),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.task.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (widget.task.deadline.isNotEmpty) 
                        Text(
                          widget.task.deadline, )
      
                    ],
                  ),
                ),
              ),
              (widget.parent == true && widget.task.is_Standalone == false)
                  ? Material(
                      color: Colors.transparent,
                      child: InkWell(
                        splashColor: Colors.amber,
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.amber,
                        onTap: () async {

                        },
                        child: Container(
                          width: 40.9,
                          height: 40.2,
      
                          decoration: BoxDecoration(),
                          child: Icon(Icons.arrow_drop_down),
                        ),
                      ),
                    )
                  : SizedBox(),
                Container(
                    width: 64,
                    height: 64,
                    child: ReorderableDragStartListener(
                      index: widget.index,
                      child: Icon(Icons.reorder)))
            ],
          ),
        ),
      ),
    );
  }
}

class addSubtask extends StatefulWidget {
  const addSubtask({super.key});

  @override
  State<addSubtask> createState() => _addSubtaskState();
}

class _addSubtaskState extends State<addSubtask> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class confirmDelete extends StatelessWidget {
  final Task task;
  const confirmDelete({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Confirm delete"),
      content: const Text("Are you sure you want to delete this task? It cannot be undone😓"),
      actions: [
        TextButton(
          onPressed: () {
            context.read<ProviderClass>().deleteTask(task);
            Navigator.pop(context);
          },
          child: Text("Delete"),),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text("Cancel"),)
      ],
    );
  }
}

class confirmDelete2 extends StatelessWidget {
  final List tasks;
  const confirmDelete2({super.key, required this.tasks});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      
      title: const Text("Confirm delete"),
      content: const Text(
        "Are you sure you want to delete all completed tasks? It cannot be undone😓",
      ),
      actions: [
        TextButton(
          onPressed: () {
            for (var task in tasks) {
              if (task.is_Completed == true) {
                context.read<ProviderClass>().removeCompletes();
                Navigator.pop(context);
              }
            }
            Navigator.pop(context);
          },
          child: Text("Delete"),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text("Cancel"),
        ),
      ],
    );
  }
}

Future<String?> showCreateTaskSheet(BuildContext context) {
  return showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true, // important for forms
    isDismissible: true,
    builder: (_) => addTask(),
  );
}

class addTask extends StatefulWidget {
  const addTask({super.key});

  @override
  State<addTask> createState() => _nameState();
}

class _nameState extends State<addTask> {
  DateTime? selectedDate;
  int timeId = DateTime.now().millisecondsSinceEpoch;
  final now = DateTime.now();
   
  Future<void> _selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 5),
    );

    setState(() {
      selectedDate = pickedDate;
    });
  }

  final TextEditingController nameCont = TextEditingController();
  final TextEditingController categoryCont = TextEditingController();

  @override
  void dispose() {
    nameCont.dispose();
    super.dispose();
  }
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<ProviderClass>().getTasks();
    });
  }
  
  @override
  Widget build(BuildContext context) {
      Task newTask = Task(
      id: timeId,
      name: "",
      category: "sample",
      deadline: selectedDate != null
              ? '${selectedDate!.year}-${selectedDate!.month}-${selectedDate!.day}' : "",
      subtasks: [],
      is_Completed: false,
      is_Standalone: true
    );

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;


     List taskLists = context.watch<ProviderClass>().tasks;
    Set<String> category = taskLists.map((e) => e.category.toString()).toSet();
    List<String> newCat = category.toList();  
    return Padding(padding: EdgeInsetsGeometry.all(20),  
    child: SizedBox(
      height: height * 0.35,
      child: Column(
        spacing: 5,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Create new task"),
          TextField(
            controller: nameCont,
            decoration: InputDecoration(
              hint: Text('Enter your task name here......')
            ),
          ),
            TextField(
              controller: categoryCont,
              autofillHints: newCat,
              decoration: InputDecoration(
                hint: Text('Enter your category name here......'),
                
              ),
            ),      
            OutlinedButton(
              onPressed: _selectDate,
              child: Text(
                newTask.deadline.isEmpty
                    ? "No deadline picked yet"
                    : "${newTask.deadline}",
              ),
            ),
      
          Expanded(child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OutlinedButton(onPressed: () {
                newTask.name = nameCont.text;
                newTask.deadline = newTask.deadline;
                newTask.category =  categoryCont.text;
                context.read<ProviderClass>().addTask(newTask);
                
                Navigator.pop(context);
              }, 
              child: Text("Submit"))
            ]
          ))
        ],
      
      ),
    )
    
    );
  }
}


///////
///
///
Future<String?> showCreateSubTaskSheet(BuildContext context, Task parentTask) {
  return showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true, // important for forms
    isDismissible: true,
    builder: (_) => addSubTask(parent: parentTask,),
  );
}

class addSubTask extends StatefulWidget {
  final Task parent;
  const addSubTask({super.key, required this.parent});

  @override
  State<addSubTask> createState() => _addSubtaskstate();
}

class _addSubtaskstate extends State<addSubTask> {
  DateTime? selectedDate;
  int timeId = DateTime.now().millisecondsSinceEpoch;
  final now = DateTime.now();
   
  Future<void> _selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 5),
    );

    setState(() {
      selectedDate = pickedDate;
    });
  }

  final TextEditingController nameCont = TextEditingController();

  @override
  void dispose() {
    nameCont.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
      Task newTask = Task(
      id: timeId,
      name: "",
      category: widget.parent.category,
      deadline: selectedDate != null
              ? '${selectedDate!.year}-${selectedDate!.month}-${selectedDate!.day}' : "",
      subtasks: [],
      is_Completed: false,
      is_Standalone: false
    );

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Padding(padding: EdgeInsetsGeometry.all(20),  
    child: SizedBox(
      height: height * 0.25,
      child: Column(
        spacing: 5,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Create new subtask"),
          TextField(
            controller: nameCont,
            decoration: InputDecoration(
              hint: Text('Enter your task name here......')
            ),
          ),
      
          
      
          OutlinedButton(
            onPressed: _selectDate,
            child: Text(
                newTask.deadline.isEmpty
                    ? "No deadline picked yet"
                    : "${newTask.deadline}",
              ),
          ),
      
          Expanded(child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OutlinedButton(onPressed: () {
                newTask.name = nameCont.text;
                newTask.deadline = newTask.deadline;
                context.read<ProviderClass>().addSubTask(widget.parent, newTask);
                
                Navigator.pop(context);
              }, 
              child: Text("Submit"))
            ]
          ))
        ],
      
      ),
    )
    
    );
  }
}



Future<String?> showEditSheet(BuildContext context, Task task) {
  return showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true, // important for forms
    isDismissible: true,
    builder: (_) => editTask(task: task),
  );
}

class editTask extends StatefulWidget {
  final Task task;
  const editTask({super.key, required this.task});

  @override
  State<editTask> createState() => _editTaskstate();
}

class _editTaskstate extends State<editTask> {
  DateTime? selectedDate;
  int timeId = DateTime.now().millisecondsSinceEpoch;
  final now = DateTime.now();

  Future<void> _selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 5),
    );

    setState(() {
      selectedDate = pickedDate;
    });
  }

  


  @override
  Widget build(BuildContext context) {
    final TextEditingController nameCont = TextEditingController(
      text: widget.task.name,
    );
    final TextEditingController categoryCont = TextEditingController(
      text: widget.task.category,
    );
    Task newTask = Task(
      id: widget.task.id,
      name: widget.task.name,
      category: widget.task.category,
      deadline: selectedDate != null
          ? '${selectedDate!.year}-${selectedDate!.month}-${selectedDate!.day}'
          : widget.task.deadline,
      subtasks: widget.task.subtasks,
      is_Completed: widget.task.is_Completed,
      is_Standalone: widget.task.is_Standalone,
    );

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Padding(
      padding: EdgeInsetsGeometry.all(20),
      child: SizedBox(
        height: height * 0.35,
        child: Column(
          spacing: 5,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Edit current task"),
            TextField(
              controller: nameCont,
              decoration: InputDecoration(
                hint: Text('Enter your task name here......'),
              ),
            ),
            TextField(
              controller: categoryCont,
              decoration: InputDecoration(
                hint: Text('Enter your category name here......'),
              ),
            ),
            OutlinedButton(
              onPressed: _selectDate,
              child: Text(
                newTask.deadline.isEmpty
                    ? "No deadline picked yet"
                    : "${newTask.deadline}",
              ),
            ),

            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      newTask.name = nameCont.text;
                      newTask.deadline = newTask.deadline;
                      newTask.category = categoryCont.text;
                      context.read<ProviderClass>().editTask(newTask);

                      Navigator.pop(context);
                    },
                    child: Text("Submit"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
