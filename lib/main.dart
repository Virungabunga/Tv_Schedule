import 'dart:async';
import 'package:flutter/material.dart';
import 'package:tv_schedule/routing/appRouter.dart';
import 'package:tv_schedule/data_handler.dart';
import 'package:intl/intl.dart';
import 'package:tv_schedule/screens/channel_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
    );
  }
}

class TVSchedule extends StatelessWidget {
  const TVSchedule({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xff508991),
        appBar: AppBar(
          backgroundColor: Color(0xff508991),
          title: const Text("Tv Schedule"),
        ),
        body: Center(child: ScheduleList()));
  }
}

