import 'dart:async';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "Tv Schedule",
      home: TVSchedule(),
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
        body: const Center(child: ScheduleList()));
  }
}

class ScheduleList extends StatefulWidget {
  const ScheduleList({super.key});

  @override
  State<ScheduleList> createState() => _ScheduleListState();
}

class _ScheduleListState extends State<ScheduleList> {
  DateTime time = DateTime(2017, 9, 7, 17, 30);
  List<dynamic>? scheduleList = [];
  var dataHandler = DataHandler();

  @override
  void initState() {
    _fetchData();
    super.initState();
  }

  Future<void> _fetchData() async {
    List<dynamic>? data = await dataHandler.getData();
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
            margin: EdgeInsets.all(5),

             child: ListTile( 
              textColor: Color(0xff09BC8A), 
            leading: Image.network(scheduleList?[index]["imageurltemplate"] ?? "https://cdn.lospec.com/gallery/lost-965723.png"
              ),
            title: Text(scheduleList?[index]["title"] ?? "Missing info"),
            trailing: Text(dataHandler.timeConverter(
                scheduleList?[index]["starttimeutc"] ?? "missing time")),
          )
          );
        });
  }
}

class DataHandler {
  final dio = Dio();
  String url = "";
  DataHandler() {
    url =
        "https://api.sr.se/api/v2/scheduledepisodes?channelid=164&format=json";
  }

  Future<List<dynamic>?> getData() async {
    List<dynamic> scheduleData = [];
    try {
      Response response;
      response = await dio.get(url);
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

  String timeConverter(String timestamp) {
    var aStr = timestamp.replaceAll(new RegExp(r'[^0-9]'), '');
    int aIntMille = int.parse(aStr);

    final time = DateTime.fromMillisecondsSinceEpoch(aIntMille, isUtc: true);
    String formattedDate = DateFormat('kk:mm:ss \n EEE d MMM').format(time);

    return formattedDate;
  }
}
