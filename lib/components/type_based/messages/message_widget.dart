import 'package:circlesapp/services/component_service.dart';
import 'package:circlesapp/services/user_service.dart';
import 'package:circlesapp/shared/message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class MessageWidget extends StatelessWidget {
  const MessageWidget({
    super.key,
    required this.message,
    required this.margin,
    required this.replyFunction,
  });

  final Message message;
  final double margin;
  final Function replyFunction;

  final double ratio = 0.125;

  String getFormattedTime(DateTime time) {
    var timeFormat = DateFormat("h:mm");
    String timePortion = timeFormat.format(time);
    return timePortion;
  }

  @override
  Widget build(BuildContext context) {
    return Slidable(
      startActionPane: (message.userFKey != UserService.dataUser.fKey)
          ? ActionPane(
              extentRatio: ratio,
              motion: const BehindMotion(),
              children: [
                Flexible(
                  child: Padding(
                    padding: EdgeInsets.all(
                      ComponentService.convertWidth(
                        MediaQuery.of(context).size.width,
                        8,
                      ),
                    ),
                    child: Text(
                      getFormattedTime(message.dateSent!),
                    ),
                  ),
                ),
                // SlidableAction(
                //   onPressed: (context) => replyFunction(context),
                //   backgroundColor: Theme.of(context).canvasColor,
                //   foregroundColor: Colors.black,
                //   autoClose: true,
                //   icon: FontAwesome.reply,
                // )
              ],
            )
          : null,
      endActionPane: (message.userFKey == UserService.dataUser.fKey)
          ? ActionPane(
              extentRatio: ratio,
              motion: const BehindMotion(),
              children: [
                // SlidableAction(
                //   onPressed: (context) => replyFunction(context),
                //   backgroundColor: Theme.of(context).canvasColor,
                //   foregroundColor: Colors.black,
                //   autoClose: true,
                //   icon: FontAwesome.reply,
                // ),
                Flexible(
                  child: Padding(
                    padding: EdgeInsets.all(
                      ComponentService.convertWidth(
                        MediaQuery.of(context).size.width,
                        8,
                      ),
                    ),
                    child: Text(
                      getFormattedTime(message.dateSent!),
                    ),
                  ),
                ),
              ],
            )
          : null,
      child: Container(
        alignment: (message.userFKey != UserService.dataUser.fKey
            ? Alignment.topLeft
            : Alignment.topRight),
        padding: EdgeInsets.only(
          left: (message.userFKey != UserService.dataUser.fKey
              ? ComponentService.convertWidth(
                  MediaQuery.of(context).size.width,
                  5,
                )
              : ComponentService.convertWidth(
                  MediaQuery.of(context).size.width,
                  20,
                )),
          right: (message.userFKey != UserService.dataUser.fKey
              ? ComponentService.convertWidth(
                  MediaQuery.of(context).size.width,
                  20,
                )
              : ComponentService.convertWidth(
                  MediaQuery.of(context).size.width,
                  5,
                )),
          top: margin,
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: (message.userFKey != UserService.dataUser.fKey
                ? Colors.grey.shade200
                : Theme.of(context).primaryColor),
          ),
          padding: const EdgeInsets.all(16),
          child: Text(
            message.message!,
            style: TextStyle(
              fontSize: 15.sp,
              color: (message.userFKey != UserService.dataUser.fKey
                  ? Colors.black
                  : Theme.of(context).canvasColor),
            ),
          ),
        ),
      ),
    );
  }
}
