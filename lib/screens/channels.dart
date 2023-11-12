import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:tv_schedule/main.dart';
import 'package:tv_schedule/data_handler.dart';

class Channels extends StatefulWidget {
  const Channels({super.key});

  @override
  State<Channels> createState() => _ChannelsState();
}

class _ChannelsState extends State<Channels> {
  DateTime time = DateTime(2017, 9, 7, 17, 30);
  List<dynamic>? channelList = [];
  var dataHandler = DataHandler();
  

  @override
  void initState() {
    _fetchData();
    super.initState();
  }

  Future<void> _fetchData() async {

    List<dynamic>? data = await dataHandler.getDataChannels();
    if (data != null) {
      setState(() {
        channelList = data;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: channelList!.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
              color: Color(0xff004346),
              elevation: 20,
              child: ListTile(
                onTap: () {
                  var param1 = channelList![index]["scheduleurl"].toString();
                  print(param1.toString());
                  context.goNamed("channel", pathParameters: {'id1': param1});
                },
                textColor: Color.fromARGB(255, 13, 14, 14),
                leading: Image.network(channelList?[index]["image"] ??
                    "https://cdn.lospec.com/gallery/lost-965723.png"),
                title: Text(channelList?[index]["name"] ?? "Missing info"),
              ));
        });
    ;
  }
}
