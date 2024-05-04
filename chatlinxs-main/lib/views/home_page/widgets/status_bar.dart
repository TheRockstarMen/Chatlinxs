import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:chatlinxs/constants/colors.dart';
import 'package:chatlinxs/models/user.dart';
import 'package:chatlinxs/views/home_page/widgets/story_widget.dart';
import 'package:chatlinxs/views/status_page/status_page.dart';
import 'package:chatlinxs/widgets/gradient_icon_button.dart';

class StatusBar extends StatelessWidget {
  final List<User> statusList;
  final GestureTapCallback? onNewStatusClicked;
  final bool addWidget;
  final bool seeAllWidget;

  const StatusBar({
    super.key,
    required this.statusList,
    this.onNewStatusClicked,
    this.addWidget = true,
    this.seeAllWidget = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const ValueKey<int>(1),
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: SizedBox(
            height: 100,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(left: 16),
              children: [
                addWidget
                    ? GestureDetector(
                        onTap: onNewStatusClicked,
                        child: const GradientIconButton(
                          size: 60,
                          iconData: Icons.add,
                          text: "New Status",
                        ),
                      )
                    : const SizedBox(),
                addWidget
                    ? const SizedBox(
                        width: 8,
                      )
                    : const SizedBox(),
                SizedBox(
                  height: 100,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: statusList.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(CupertinoPageRoute(
                            builder: (context) => const StatusPage(),
                          ));
                        },
                        child: StoryWidget(
                          size: 60,
                          showGreenStrip:
                              addWidget && (index == 2 || index == 3),
                          user: statusList[index],
                        ),
                      );
                    },
                  ),
                ),
                seeAllWidget
                    ? const SizedBox(
                        width: 10,
                      )
                    : const SizedBox(),
                seeAllWidget
                    ? const Icon(
                        LineIcons.arrowRight,
                        color: greenColor,
                      )
                    : const SizedBox(),
                seeAllWidget
                    ? const SizedBox(
                        width: 10,
                      )
                    : const SizedBox(),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        const Divider(
          height: 0,
          thickness: 0.6,
        ),
      ],
    );
  }
}
