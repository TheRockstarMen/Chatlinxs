import 'dart:async';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chatlinxs/constants/colors.dart';
import 'package:chatlinxs/getit.dart';
import 'package:chatlinxs/managers/local_db_manager/local_db.dart';
import 'package:chatlinxs/managers/navigation_manager/navigation_manager.dart';
import 'package:chatlinxs/models/user.dart';
import 'package:uuid/uuid.dart';
import 'package:chatlinxs/provider/auth_provider.dart';
import 'package:chatlinxs/provider/contact_provider.dart';
import 'package:chatlinxs/provider/home_provider.dart';
import 'package:chatlinxs/provider/message_provider.dart';
import 'models/location.dart';

User user = User(
    name: "Carlos Trejo",
    gender: "Male",
    phoneNumber: "+91 9999999999",
    birthDate: 498456350,
    location: Location(
        city: "Celaya",
        postcode: "124001",
        state: "Haryana",
        street: "New Street"),
    username: "yashmakan",
    firstName: "Yash",
    lastName: "Makan",
    title: "Full Stack Developer",
    firebaseToken:
        "e1E1sZR4T-ysib46L2idFq:APA91bFRtT1a2Q_HqIWMwN7iKX6TIt4nBHIum3sQPTl3lTYWYx0nSh1khX8Tg0ntOzTWlnZgsh_PowXEKl58MF_9tO2Sn5QFZ_6yRkdiU-B54EgwP680vozB4zfeIEi_vxI4IzOGWKcd",
    uuid: "9b1deb4d-3b7d-4bad-9bdd-2b0d7b3dcb6d",
    picture:
        "https://images.unsplash.com/photo-1453396450673-3fe83d2db2c4?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=387&q=80");

User rick = User(
    name: "Rick Rolland",
    gender: "Male",
    phoneNumber: "8888888888",
    birthDate: 498456351,
    location: Location(
        city: "Rohtak",
        postcode: "124001",
        state: "Haryana",
        street: "New Street"),
    username: "rickkk",
    firstName: "Rick",
    lastName: "Rolland",
    title: "Web Developer",
    firebaseToken:
        "dvj3V4o_RL6Pxzciibm6Kc:APA91bGEAwG27eHHsraJ-b_4K0DXaUpwcUVPyjvr0M7AKJeyoR-UzmG3ey7rTqKKwVm40ellYiD0ZYUhyclpIGXcb0XFdY_LhaNDwUP6ooy_BIYQl4Ae_scfdTyCu8-Ojg4Q7QsTdzj1",
    uuid: "b1deb4d-3b7d-4bad-9bdd-2b0d7b3dcb6a",
    picture:
        "https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2");

Future<void> myBackgroundMessageHandler(RemoteMessage event) async {
  Map message = event.toMap();
  print('backgroundMessage: message => ${message.toString()}');
  var payload = message['data'];
  var roomId = payload['room_id'] as String;
  var callerName = payload['caller_name'] as String;
  var uuid = payload['uuid'] as String?;
  var hasVideo = payload['has_video'] == "true";

  final callUUID = uuid ?? const Uuid().v4();

  AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 10,
        channelKey: 'basic_channel',
        title: '$callerName is calling...',
        body: 'Pick upppp!!!',
      ),
      actionButtons: [
        NotificationActionButton(
          label: 'Decline',
          enabled: false,
          isDangerousOption: true,
          actionType: ActionType.Default,
          key: 'decline',
        ),
        NotificationActionButton(
          label: 'Accept',
          enabled: true,
          actionType: ActionType.Default,
          key: 'accept-$roomId',
        )
      ]);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  LocalDB.initialize();
  AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
            channelGroupKey: 'basic_channel_group',
            channelKey: 'basic_channel',
            channelName: 'Whatsapp',
            channelDescription: 'Whatsapp calling',
            defaultColor: greenColor,
            ledColor: Colors.white)
      ],
      channelGroups: [
        NotificationChannelGroup(
            channelGroupKey: 'basic_channel_group',
            channelGroupName: 'Basic group')
      ],
      debug: true);
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);
  setup();
  runApp(const MyApp());
}

class ScrollGlowEffect extends ScrollBehavior {
  @override
  Widget buildViewportChrome( //corregido y cambiado por otro
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(
            create: (context) => AuthProvider()),
        ChangeNotifierProvider<HomeProvider>(
            create: (context) => HomeProvider()),
        ChangeNotifierProvider<ContactProvider>(
            create: (context) => ContactProvider()),
        ChangeNotifierProvider<MessageProvider>(
            create: (context) => MessageProvider()),
      ],
      child: MaterialApp(
        title: 'Chatlinxs',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.blue, fontFamily: "SFProText"),
        builder: (context, child) {
          return ScrollConfiguration(
              behavior: ScrollGlowEffect(), child: child!);
        },
        routes: NavigationManager.routes,
      ),
    );
  }
}
