import 'package:dio/dio.dart';
import 'package:intl/intl.dart';

class DataHandler {
  final dio = Dio();
  String url = "";

  Future<List<dynamic>?> getInitialData(channelUrl, date) async {
    List<dynamic> scheduleData = [];
    url = channelUrl + "&date=" + date + "&format=json";
    var dataHandler = DataHandler();
    var todayDate = DateTime.now();
    final DateFormat formatter = DateFormat('yyyy-MM-dd');

    print(url);
    try {
      Response response;
      response = await dio.get(url);
      Map<String, dynamic> newScheduleData = response.data;
      var pagination = newScheduleData["pagination"];
      int totalpages = pagination["totalpages"];
      scheduleData.addAll(newScheduleData["schedule"]);

      String nextpage = pagination["nextpage"];
      if (nextpage != null) {
        response = await dio.get(nextpage);
      }
      scheduleData.addAll(newScheduleData["schedule"]);

      // for (var i = 1; i <= totalpages; i++) {
      //   String nextpage = pagination["nextpage"];
      //   if (nextpage == null) {
      //     break;
      //   }
      //   response = await dio.get(nextpage);
      //   newScheduleData = response.data;

      //   scheduleData.addAll(newScheduleData["schedule"]);
      //   pagination = newScheduleData["pagination"];
      // }
    } catch (e) {
      print(e);
    }

    return scheduleData;
  }

  Future<List<dynamic>?> getMoreData() async {}

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

    return channelData;
  }

  String timeConverter(String timestamp) {
    var aStr = timestamp.replaceAll(new RegExp(r'[^0-9]'), '');
    int aIntMille = int.parse(aStr);

    final time = DateTime.fromMillisecondsSinceEpoch(aIntMille, isUtc: true);
    String formattedDate = DateFormat('kk:mm \n EEE d MMM').format(time);

    return formattedDate;
  }
}
