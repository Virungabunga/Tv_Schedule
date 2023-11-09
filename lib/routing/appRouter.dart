import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tv_schedule/main.dart';
import 'package:tv_schedule/routing/appRoutes.dart';
import 'package:tv_schedule/screens/homeScreen.dart';
import 'package:tv_schedule/screens/channels.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final GoRouter router =
    GoRouter(navigatorKey: _rootNavigatorKey, initialLocation: "/", routes: [
  GoRoute(
    path: "/",
    name: Approutes.root.name,
    builder: (context, state) => HomePage(),
    routes: [

      GoRoute(path: "channels",
        name:Approutes.channels.name,
        builder: (context, state) => Channels(),
      routes: [

        GoRoute(path: "channel/:id1",
          name: Approutes.channel.name,
          builder: (context, state) => ScheduleList(id1: state.pathParameters["id1"]),),

      ])
    ]
  )
]);
