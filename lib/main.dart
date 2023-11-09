import 'dart:async';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:tv_schedule/routing/appRouter.dart';
import 'package:tv_schedule/screens/homeScreen.dart';

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

class ScheduleList extends StatefulWidget {
  String? id1;
  ScheduleList({super.key, this.id1});
  final controller = ScrollController();
  @override
  State<ScheduleList> createState() => _ScheduleListState();
}

class _ScheduleListState extends State<ScheduleList> {
  DateTime time = DateTime(2017, 9, 7, 17, 30);
  List<dynamic>? scheduleList = [];
  var dataHandler = DataHandler();

  @override
  void initState() {
    super.initState();
    _fetchData();
         }
    
  


  Future<void> _fetchData() async {
    List<dynamic>? data = await dataHandler.getData(widget.id1);

    if (data != null) {
      setState(() {
        scheduleList = data;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: scheduleList?.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
              color: Color(0xff004346),
              elevation: 20,
              child: ListTile(
                textColor: Color(0xff09BC8A),
                leading: Image.network(scheduleList?[index]
                        ["imageurltemplate"] ??
                    "https://cdn.lospec.com/gallery/lost-965723.png"),
                title: Text(scheduleList?[index]["title"] ?? "Missing info"),
                trailing: Text(dataHandler.timeConverter(
                    scheduleList?[index]["starttimeutc"] ?? "missing time")),
              ));
        });
  }
}

class DataHandler {
  final dio = Dio();
  String url = "";

  Future<List<dynamic>?> getData(channelUrl) async {
    List<dynamic> scheduleData = [];
    try {
      Response response;
      response = await dio.get(channelUrl+"&format=json");
      Map<String, dynamic> data = response.data;
      var pagination = data["pagination"];
      int totalpages = pagination["totalpages"];
      scheduleData.addAll(data["schedule"]);
      for (var i = 1; i <= totalpages; i++) {
        String nextpage = pagination["nextpage"];
        if (nextpage == null) {
          break;
        }

        response = await dio.get(nextpage);
        data = response.data;

        scheduleData.addAll(data["schedule"]);
        pagination = data["pagination"];
      }
    } catch (e) {
      print(e);
    }
    print(scheduleData.toString());

    return scheduleData;
  }

  Future<List<dynamic>?> getDataChannels() async {
    List<dynamic> channelData = [];
    try {
      Response response;
      response = await dio.get("https://api.sr.se/api/v2/channels?format=json");
      Map<String, dynamic> data = response.data;
      var pagination = data["pagination"];
      int totalpages = pagination["totalpages"];
      channelData.addAll(data["channels"]);
      for (var i = 1; i <= totalpages; i++) {
        String nextpage = pagination["nextpage"];
        if (nextpage == null) {
          break;
        }

        response = await dio.get(nextpage);
        data = response.data;

        channelData.addAll(data["channels"]);
        pagination = data["pagination"];
      }
    } catch (e) {
      print(e);
    }
    print(channelData.toString());

    return channelData;
  }

  String timeConverter(String timestamp) {
    var aStr = timestamp.replaceAll(new RegExp(r'[^0-9]'), '');
    int aIntMille = int.parse(aStr);

    final time = DateTime.fromMillisecondsSinceEpoch(aIntMille, isUtc: true);
    String formattedDate = DateFormat('kk:mm:ss \n EEE d MMM').format(time);

    return formattedDate;
  }
}
