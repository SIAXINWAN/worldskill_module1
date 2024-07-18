import 'package:flutter/material.dart';
import 'package:worldskill_module1/pages/RecordPage.dart';
import 'package:worldskill_module1/pages/TicketPage.dart';
import 'package:worldskill_module1/pages/eventPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Widget page = const EventPage();

  int currentIndex = 0;

  List<Widget>pages =[
    EventPage(),
    TicketPage(),
    RecordPage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        children: pages,
        index: currentIndex,
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index){
          setState(() {
            currentIndex=index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.event_note),label: 'Events'),
            BottomNavigationBarItem(icon: Icon(Icons.article),label: 'Tickets'),
            BottomNavigationBarItem(icon: Icon(Icons.note),label: 'Records')
        ],
      ),
      );
    
  }
}