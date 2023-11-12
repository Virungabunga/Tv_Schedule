import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tv_schedule/data_handler.dart';

class ScheduleList extends StatefulWidget {
  String? id1;
  ScheduleList({super.key, this.id1});
  final controller = ScrollController();
  @override
  State<ScheduleList> createState() => _ScheduleListState();
}

class _ScheduleListState extends State<ScheduleList> {
  final controller = ScrollController();

  DateTime time = DateTime(2017, 9, 7, 17, 30);
  List<dynamic>? scheduleList = [];
  var dataHandler = DataHandler();
  var todayDate = DateTime.now();

  final DateFormat formatter = DateFormat('yyyy-MM-dd');

  @override
  void initState() {
    super.initState();
    _fetchData();
    controller.addListener(() {
      if (controller.position.pixels == controller.position.maxScrollExtent) {
        var nextDayDate = todayDate.add(const Duration(days: 1));
        var previousdayDate = todayDate.subtract(const Duration(days: 1));
      }
      // else if {controller.position == };
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> _fetchData() async {
    final String formatted = formatter.format(todayDate);

    List<dynamic>? data =
        await dataHandler.getInitialData(widget.id1, formatted);

    if (data != null) {
      setState(() {
        scheduleList = data;
        //set state for next day
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        controller: controller,
        itemCount: scheduleList!.length + 1,
        itemBuilder: (BuildContext context, int index) {
          if (index < scheduleList!.length) {
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
          } else {
            return const Padding(
                padding: EdgeInsets.symmetric(vertical: 32),
                child: Center(child: CircularProgressIndicator()));
          }
        });
  }
}
