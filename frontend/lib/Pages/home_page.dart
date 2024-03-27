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

  void _showModal() {
    showModalBottomSheet(
            context: context, 
            builder: (BuildContext context) { //context is variable which stores information of current state
              return Container(
                height: MediaQuery.of(context).size.height / 2,
                color: Colors.grey,
                child: const Center(
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                          "Add new Item",
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: EdgeInsets.all(20.0),
                        child: TextField(
                          obscureText: true,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Title",
                          )
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(20.0),
                        child: TextField(
                          obscureText: true,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Description",
                          )
                        ),
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: null,
                        child: Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Text(
                            "Add",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                            )
                          ),
                        )
                      ),
                    ],
                  ),
                ),
              );
            },
          );
  }

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

  // ignore: non_constant_identifier_names
  void delete_todo(String id) async {
    try{
      // ignore: unused_local_variable
      http.Response response = await http.delete(Uri.parse("$api/$id")); //same as Uri.parse(api + "/" + id)
      setState(() { //calls the build method [line 74] again
        myTodos = [];
      }); 
      fetchData();
    }
    catch(e) {
      print(e);
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
                  onPress: () => delete_todo(e.id.toString()),
                  id: e.id, 
                  title: e.title, 
                  desc: e.desc, 
                  isDone: e.isDone,
                );
              }).toList(),
            )
          ]
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showModal();
        },
        child: const Icon(Icons.add)
      ),
    );
  }
}