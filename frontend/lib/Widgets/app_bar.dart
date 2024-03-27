import 'package:flutter/material.dart';

AppBar customAppBar() {
  return AppBar(
    title: const Text(
      "Django Todos",
      style: TextStyle(
        color: Colors.white,
      ),
    ),
    elevation: 0.0,
    backgroundColor: const Color(0xFF001133),
  );
}