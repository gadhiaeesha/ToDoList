// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:frontend/Constants/api.dart';
import 'package:frontend/Models/todo.dart';
import 'package:frontend/Widgets/todo_container.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:frontend/Widgets/app_bar.dart';
import 'package:pie_chart/pie_chart.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int done = 0;
  
  List<Todo> myTodos = [];
  bool isLoading = true;

  void fetchData() async {
    try{
      http.Response response = await http.get(Uri.parse(api));
      var data = json.decode(response.body);
      data.forEach((todo) {
        Todo t = Todo(
          id: todo["id"],
          title: todo['title'],
          desc: todo['desc'],
          isDone: todo['isDone'],
          date: todo['date'],
        );

        if(todo['isDone']){
          done += 1;
        }
        myTodos.add(t);
      });

      print(myTodos.length);
      setState(() {
        isLoading = false;
      });
    }
    catch(e) {
      print("Error is $e");
    }
  }

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF001133),
      appBar: customAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            PieChart(
              dataMap: {
                "Done": done.toDouble(),
                "Incomplete": (myTodos.length - done).toDouble(),
              }
            ),
            isLoading ? const CircularProgressIndicator() : 
            Column(
              children: myTodos.map((e) {
                return TodoContainer(
                  id: e.id, 
                  title: e.title, 
                  desc: e.desc, 
                  isDone: e.isDone,
                );
              }).toList(),
            )
          ]
        ),
      )
    );
  }
}