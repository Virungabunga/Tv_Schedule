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
        appBar: AppBar(
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
  List<dynamic> scheduleList = [];
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
      itemCount: scheduleList.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          leading: Image.network(scheduleList[index]["imageurltemplate"]),
          title: Text(scheduleList[index]["title"]),
          trailing: Text(
              dataHandler.timeConverter(scheduleList[index]["starttimeutc"])),
        );
      },
    );
  }
}

class DataHandler {
  List scheduleList = [];
  final dio = Dio();
  String url = "";
  DataHandler() {
    url =
        "https://api.sr.se/api/v2/scheduledepisodes?channelid=164&format=json";
  }

  Future<List<dynamic>?> getData() async {
    try {
      Response response;
      response = await dio.get(url);

      Map<String, dynamic> data = response.data;

      return scheduleList = data["schedule"];
    } catch (e) {
      print(e);
    }
  }

  String timeConverter(String timestamp) {
    var aStr = timestamp.replaceAll(new RegExp(r'[^0-9]'), '');
    int aIntMille = int.parse(aStr);

    final time = DateTime.fromMillisecondsSinceEpoch(aIntMille, isUtc: true);
    String formattedDate = DateFormat('kk:mm:ss \n EEE d MMM').format(time);

    return formattedDate;
  }
}
