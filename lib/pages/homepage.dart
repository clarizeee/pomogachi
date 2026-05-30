import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pomogachi/widgets/taskviews.dart';
import 'package:pomogachi/handlers.dart';
import 'package:provider/provider.dart';
import 'package:pomogachi/models.dart';
import 'package:intl/intl.dart';
import 'package:home_widget/home_widget.dart';

const String appGroupId = '<YOUR APP GROUP>'; // Add from here
const String iOSWidgetName = 'NewsWidgets';
const String androidWidgetName = 'NewsWidget';

class homepage extends StatefulWidget {
  const homepage({super.key});

  @override
  State<homepage> createState() => _homeState();
}

class _homeState extends State<homepage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      print("hello...");
      context.read<ProviderClass>().getTasks();
    });
  }
   String selectedCategory = "All";
  @override
  Widget build(BuildContext context) {

    List taskLists = context.watch<ProviderClass>().tasks;
    Set<String> category = taskLists.map((e) => e.category.toString()).toSet();
    List<String> newCat = category.toList();
    newCat.remove("");
    newCat.insert(0, "Today");
    newCat.insert(0, "All");
    final now = DateTime.now();
    final dateOnly = DateUtils.dateOnly(now);
    print(dateOnly);
    // all child IDs
    final filteredProducts = selectedCategory == "All"
    ? taskLists : selectedCategory == "Today" ? taskLists.where((element) => element.deadline == "${now.year}-${now.month}-${now.day}",) 
    : taskLists.where((p) {
        return p.category == selectedCategory;
      }).toList();

    // parents (have subtasks)
    final onlyParent = filteredProducts
        .where((e) => e.subtasks.isNotEmpty ||  e.is_Standalone).toList();

    // standalone (not parent + not child)

    return Scaffold(
      appBar: AppBar(),
       body: Padding(
         padding: const EdgeInsets.all(10.0),
         child: SafeArea(
           child: CustomScrollView(
            
            slivers: [
           
              SliverToBoxAdapter(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Hi girl u have ${onlyParent.length} tasks today", style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Row(
                      children: [
           
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            splashColor: Colors.amber,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () async {
                              showCreateTaskSheet(context);
                            },
                            child: Container(
                              width: 50.9,
                              height: 50.2,
                              decoration: BoxDecoration(),
                              child: Icon(Icons.add),
                            ),
                          ),
                        ),
                                            Material(
                          color: Colors.transparent,
                          child: InkWell(
                            splashColor: Colors.amber,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () async {
                              showDialog(context: context, builder: (BuildContext context) {
                                return confirmDelete2(tasks: taskLists);
                              });
                            },
                            child: Container(
                              width: 50.9,
                              height: 50.2,
                              decoration: BoxDecoration(),
                              child: Icon(Icons.delete),
                            ),
                          ),
                        ),
                      ],
                    )
           
                  ],
                )
              ),
                          SliverToBoxAdapter(
                child: SizedBox(
                  width: 50,
                  child: DropdownButtonFormField<String>(
                    value: selectedCategory,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 14,
                      ),
                    ),
                    items: newCat.map((e) {
                      return DropdownMenuItem(value: e, child: Text(e));
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedCategory = value!;
                      });
                    },
                  )
                ),
              ),
              SliverToBoxAdapter(child: SizedBox(height: 10,),),
                 SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {                
                              if (index >= onlyParent.length) {
                    return const SizedBox();
                  }   
                        return taskList(task: onlyParent[index], tasks: taskLists);
                      }, childCount: onlyParent.length),
                    )
                 ,
           
            ]
           ),
         ),
       ),
    );
  }
}