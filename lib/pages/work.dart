import 'package:flutter/material.dart';
import 'package:pomogachi/widgets/taskviews.dart';
import 'package:pomogachi/handlers.dart';
import 'package:provider/provider.dart';
import 'package:pomogachi/models.dart';
import 'package:circle_progress_bar/circle_progress_bar.dart';
import 'package:pomogachi/widgets/utility.dart';

class workpage extends StatefulWidget {
  const workpage({super.key});

  @override
  State<workpage> createState() => _workState();
}

class _workState extends State<workpage> {


  
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<ProviderClass>().getTasks();
      context.read<ProviderClass>().getQueue();
    });
  }

  @override
  Widget build(BuildContext context) {
    List taskLists = context.watch<ProviderClass>().tasks;
    List queue = context.watch<ProviderClass>().queue;
    List tasks = queue
    .map((id) => taskLists.firstWhere((t) => t.id == id))
    .toList();
    
    Task? task = context.watch<TimerProvider>().currentTask;
    


    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: Center(child: Text(task == null ? "" : "Currently working on: \n${task.name}", style: Theme.of(context).textTheme.titleLarge, textAlign: TextAlign.center,
                )),),
            SliverToBoxAdapter(child: SizedBox(height: 15)),
            SliverToBoxAdapter(
          child: SizedBox(
            width: 250,
            child: Column(
              children: [
                MyTimerWidget(),
              ],
            ),
          )),
            SliverToBoxAdapter(child: SizedBox(height: 10,)),
            SliverReorderableList(              
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              return Column(
                key: ValueKey(tasks[index].id),
                children: [
                  taskTile2( index: index, task: tasks[index], onCollapse: () {},
                    ),
                  SizedBox(height: 10, child: Container(decoration: BoxDecoration(color: Colors.transparent),),)
                ],
              );
            },
            onReorder: (int oldIndex, int newIndex) {
              context.read<ProviderClass>().updateQueue(oldIndex, newIndex);
            },
                ),
          ],
        ),
      )
      );
    
  }
}


