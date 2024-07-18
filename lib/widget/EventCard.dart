import 'package:flutter/material.dart';
import 'package:worldskill_module1/model/event.dart';
import 'package:worldskill_module1/pages/event_detail_page.dart';
import 'package:worldskill_module1/services/ApiService.dart';

class EventCard extends StatelessWidget {
  final Event event;
  final Function func;
  const EventCard({super.key, required this.event,required this.func});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        height: MediaQuery.of(context).size.height*0.15,
        width: MediaQuery.of(context).size.width*0.75,
        child: GestureDetector(
          onTap: ()async{
            Navigator.push(context,
             MaterialPageRoute(builder: (context)=>EventDetailsPage(event:event,)));
             await ApiService.updateEvent(event);
             func();
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset('lib/assests/${event.image[0]}',
              height: 120,
              width: 120,
              fit: BoxFit.fitHeight,
              ),
            SizedBox(
              width: 30,
            ),
            Expanded(child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(event.title,
                style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold,
                backgroundColor: Colors.black12),),
                Text(event.desc +'asdasd adfjhahjkfkjdfasdhkdfkjasjkfhkashflkaksdfhjkasdhfkljasdfklasfkjghasdfdkhjgsaddfasdkjhfdasfjkasdhfjkladshfhasjkfdhkjashfhasdf',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(backgroundColor: Colors.black12),),
                Text(event.status)
              ],
            ))
            ],
          ),
        ),
      ),
    );
  }
}