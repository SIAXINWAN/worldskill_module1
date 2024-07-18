import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:worldskill_module1/model/ticket.dart';
import 'package:worldskill_module1/pages/TicketCreatePage.dart';
import 'package:worldskill_module1/services/ApiService.dart';
import 'package:worldskill_module1/widget/ticketRow.dart';

class TicketTabPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Navigator(
        onGenerateRoute: (settings) {
          return MaterialPageRoute(builder: (context)=>const TicketPage());
        },
      ),
    );
  }
}

class TicketPage extends StatefulWidget {
  const TicketPage({super.key});

  @override
  State<TicketPage> createState() => _TicketPageState();
}

class _TicketPageState extends State<TicketPage> {

  List<Ticket>ticketList=[];
  
  Future<void>getTicketList()async{
    ticketList = await ApiService.getTicket();
    var position = await Ticket.getPosition();
    if(position.length !=0){
      ticketList.sort((a, b) {
        return position.indexOf(a.id) - position.indexOf(b.id);
      },);
    }
    setState(() {
    });
  }

  Future<void>redirectCreatePage()async{
    Ticket? ticket = await Navigator.of(context)
    .push(MaterialPageRoute(builder: (context)=> CreateTicketPage()));

    if(ticket == null)return;

    ticketList.add(ticket);
    await Ticket.storedPosition(ticketList);
    await getTicketList();
  }

  @override
  void initState() {
    super.initState();
    getTicketList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Ticket List')),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
              child: ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 222, 216, 162)),
                  onPressed: redirectCreatePage,
                  child: Text('Created  a new ticket',style: TextStyle(fontSize: 16,color: Colors.black),))),
                  SizedBox(height: 20,),
                  Text('Opening Ceremony Ticket',style: TextStyle(fontSize: 24),),
        Expanded(
          child: ReorderableListView(
             onReorder: (oldIndex,newIndex){
              if(newIndex > oldIndex){
                newIndex -= 1;
              }
              final Ticket item = ticketList.removeAt(oldIndex);
              ticketList.insert(newIndex,item);
              setState(() {
              }); 
              Ticket.storedPosition(ticketList);
            },
            children: 
              ticketList
              .where((ticket) => ticket.type == 'Opening Ceremony Tickets' ).map((item){
                return TicketRow(
                  ticket: item, func: getTicketList,
                  key : ValueKey(item),
                );
              }).toList()),
            ),
            SizedBox(
              height: 20,
            ),
             Text('Closing Ceremony Ticket',style: TextStyle(fontSize: 24),),
             Expanded(
          child: ReorderableListView(
             onReorder: (oldIndex,newIndex){
              if(newIndex > oldIndex){
                newIndex -= 1;
              }
              final Ticket item = ticketList.removeAt(oldIndex);
              ticketList.insert(newIndex,item);
              setState(() {
              }); 
              Ticket.storedPosition(ticketList);
            },
            children: 
              ticketList.where((ticket) => ticket.type == 'Closing Ceremony Tickets' ).map((item){
                return TicketRow(
                  ticket : item,
                  func: getTicketList,
                  key : ValueKey(item),
                );
              }).toList()),
            ),

        
        ],
      ),
    );
  }
}
