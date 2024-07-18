import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:worldskill_module1/model/ticket.dart';
import 'package:worldskill_module1/pages/TicketDetailPage.dart';
import 'package:worldskill_module1/services/ApiService.dart';

class TicketRow extends StatelessWidget {
  final Ticket ticket;
  final Function func;
  const TicketRow({super.key, required this.ticket, required this.func});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context)=> TicketDetail(ticket : ticket)));
        },
        child: Dismissible(
          onDismissed: (direction)async{
            int code = await ApiService.deleteTicket(ticket.id);

            if(code == 200){
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Delete ticket successfully')));
            }else{
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error')));
            }
            func();
          },
          key: Key(ticket.name),
          direction: DismissDirection.horizontal,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black12
            ),
            margin: EdgeInsets.all(8),
            width: MediaQuery.of(context).size.width*0.6,
            height: MediaQuery.of(context).size.height*0.08,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(ticket.name,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 24),)
                  ],
                ),
                Row(mainAxisAlignment: MainAxisAlignment.end,
                children: [Text(ticket.seat)],)
              ],
            ),
          )),
      ),
    );
  }
}