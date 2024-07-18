import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:worldskill_module1/services/ApiService.dart';

class CreateTicketPage extends StatefulWidget {
  const CreateTicketPage({super.key});

  @override
  State<CreateTicketPage> createState() => _CreateTicketPageState();
}

class _CreateTicketPageState extends State<CreateTicketPage> {
  List<String> typeList = [
    'Opening Ceremony Tickets',
    'Closing Ceremony Tickets'
  ];
  String selectType = '';
  TextEditingController nameController = TextEditingController();

  File? image;
  @override
  void initState() {
    super.initState();
    selectType = typeList[0];
    setState(() {});
  }

  Future<void> pickImage() async {
    ImagePicker ip = ImagePicker();
    var temp = await ip.pickImage(source: ImageSource.gallery);
    if (temp != null) {
      image = File(temp.path);
      setState(() {});
    }
  }

  Future<void> createTicket() async {
    String type = selectType;
    String name = nameController.text;

    if (name.isEmpty || image == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('You need to fill all data')));
      return;
    }

    var ticket = await ApiService.storeTicket(type, name, image!);
    if (ticket == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error')));
      return;
    }
    Navigator.pop(context, ticket);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text('Ticket Create'),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 90),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: DropdownButton(
                    value: selectType,
                    icon: Icon(Icons.keyboard_arrow_down),
                    items: typeList.map((String items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text(items),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectType = newValue!;
                      });
                    },
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: nameController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(hintText: 'Input your name'),
                ),
                SizedBox(
                  height: 20,
                ),
                OutlinedButton(
                  onPressed: pickImage,
                  child: Text('Choose one picture',
                      style: TextStyle(color: Colors.black)),
                  style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      side: BorderSide(color: Colors.black),
                      padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 12)),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: 200,
                  width: 300,
                  child: image != null ? Image.file(image!) : SizedBox(),
                ),
                SizedBox(
                  height: 150,
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: OutlinedButton(
                    onPressed: createTicket,
                    child: Text(
                      'Create',
                      style: TextStyle(color: Colors.black),
                    ),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      side: BorderSide(color: Colors.black),
                      padding:
                          EdgeInsets.symmetric(horizontal: 75, vertical: 12),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                )
              ],
            ),
          ),
        ));
  }
}
