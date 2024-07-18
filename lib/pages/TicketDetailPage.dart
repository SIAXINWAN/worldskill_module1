import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart.';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';
import 'package:worldskill_module1/model/ticket.dart';
import 'package:worldskill_module1/services/NotificationService.dart';

class TicketDetail extends StatefulWidget {
  final Ticket ticket;
  const TicketDetail({super.key, required this.ticket});

  @override
  State<TicketDetail> createState() => _TicketDetailState();
}

class _TicketDetailState extends State<TicketDetail> {
  ScreenshotController screenshotController = ScreenshotController();

  String DateToString(DateTime date) {
    String twoDigit(int n) => n.toString().padLeft(2, '0');
    return '${date.year}-${twoDigit(date.month)}-${twoDigit(date.day)}${twoDigit(date.hour)}:${twoDigit(date.minute)}';
  }

  @override
  void initState() {
    super.initState();
    //add the notification pop up
    initializaNotifications();
  }

  Future<void> downloadImage() async {
    showNotification();
    PermissionStatus status = await Permission.storage.request();
    if (status.isGranted) {
      final image = await screenshotController.capture();
      if (image != null) {
        await ImageGallerySaver.saveImage(image);
      }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Storage permission denied')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Center(child: Text('Ticket Details')),
        ),
        body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 60),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Screenshot(
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.6,
                        width: MediaQuery.of(context).size.width * 0.8,
                        decoration: BoxDecoration(color: Colors.black12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.network(
                              widget.ticket.image,
                              height: MediaQuery.of(context).size.height * 0.25,
                              width: MediaQuery.of(context).size.width * 0.8,
                              fit: BoxFit.fill,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              'Ticket type: ' + widget.ticket.type,
                              style: TextStyle(fontSize: 16),
                            ),
                            Text(
                              "Audience's name: " + widget.ticket.name,
                              style: TextStyle(fontSize: 16),
                            ),
                            Text(
                              'Time: ' + DateToString(widget.ticket.created_at),
                              style: TextStyle(fontSize: 16),
                            ),
                            Text(
                              'Seat: ' + widget.ticket.seat,
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                      controller: screenshotController),
                  Expanded(
                    child: Align(
                        alignment: Alignment.center,
                        child: OutlinedButton(
                            onPressed: downloadImage,
                            child: Text(
                              'Download',
                              style: TextStyle(color: Colors.black),
                            ),
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: BorderSide(color: Colors.black),
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 75, vertical: 12),
                            ))),
                  ),
                ])));
  }
}
