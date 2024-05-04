import 'dart:async';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:hidable/hidable.dart';
import 'package:line_icons/line_icons.dart';
import 'package:chatlinxs/constants/colors.dart';
import 'package:chatlinxs/models/size_config.dart';
import 'package:chatlinxs/main.dart';
import 'package:chatlinxs/views/profile_page/main_profile_page.dart';
import 'call_page/call_list_page.dart';
import 'home_page/home_page.dart';

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  int selectedIndex = 1;
  final ScrollController scrollController = ScrollController();
  StreamSubscription<ReceivedAction>? _actionStreamSubscription;

  void listen() async {
    await _actionStreamSubscription?.cancel();

    // _actionStreamSubscription =
    //     AwesomeNotifications().actionStream.listen((message) {
    //   if (message.buttonKeyPressed.startsWith("accept")) {
    //     Navigator.of(context).push(CupertinoPageRoute(
    //         builder: (context) => CallAcceptDeclinePage(
    //               user: user,
    //               callStatus: DuringCallStatus.accepted,
    //               roomId: message.buttonKeyPressed.replaceAll("accept-", ""),
    //             )));
    //   } else if (message.buttonKeyPressed == "decline") {
    //     // decline call
    //   }
    // });
  }

  @override
  void initState() {
    listen();
    FirebaseMessaging.instance.getToken().then((token) {
      debugPrint('[FCM] token => ${token!}');
    });
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      myBackgroundMessageHandler(message);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
        backgroundColor: backgroundColor(context),
        body: getBody(),
        bottomNavigationBar: Hidable(
          controller: scrollController,
          child: bottomNavigationBar(),
        ));
  }

  Widget getBody() {
    switch (selectedIndex) {
      case 0:
        return CallListPage(
          scrollController: scrollController,
        );
      case 1:
        return HomePage(
          scrollController: scrollController,
        );
      case 2:
        return MainProfilePage(
          scrollController: scrollController,
        );
      default:
        return HomePage(
          scrollController: scrollController,
        );
    }
  }

  Widget bottomNavigationBar() {
    return CustomNavigationBar(
      iconSize: 24.0,
      selectedColor: greenColor,
      strokeColor: greenGradient.lightShade.withOpacity(0.6),
      unSelectedColor: const Color(0xff6c788a),
      backgroundColor: backgroundColor(context),
      items: [
        CustomNavigationBarItem(
          icon: const Icon(
            LineIcons.phone,
            size: 24,
          ),
        ),
        CustomNavigationBarItem(
          icon: const Icon(
            LineIcons.sms,
            size: 24,
          ),
        ),
        CustomNavigationBarItem(
          icon: const Icon(
            LineIcons.user,
            size: 24,
          ),
        ),
      ],
      currentIndex: selectedIndex,
      onTap: (index) {
        setState(() {
          selectedIndex = index;
        });
      },
    );
  }
}
