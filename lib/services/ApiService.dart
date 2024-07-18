import 'dart:io';

import 'package:worldskill_module1/model/event.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:worldskill_module1/model/ticket.dart';

class ApiService {
  static String baseUrl = '10.200.96.249:8080';

  static Future<List<Event>> getEvents() async {
    try {
      var url = Uri.http(baseUrl, '/api/events');

      var response = await http.get(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        var jsonList = convert.jsonDecode(response.body) as Map<String, dynamic>;
        var events = jsonList['events'] as List;
        var list = events.map((e) => Event.fromJson(e)).toList();
        return list;
      } else {
        return [];
      }
    } catch (e) {
      
      return [];
    }
  }

  static Future<int> updateEvent(Event event) async {
    try {
      String status = 'Read';
      var url = Uri.http(baseUrl, 'api/events/updateStatus/${event.id}/$status');

      var response = await http.put(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      return response.statusCode;
    } catch (e) {
      
      return 400;
    }
  }
  
  static Future<List<Ticket>> getTicket() async {
    try {
      var url = Uri.http(baseUrl, '/api/tickets');

      var response = await http.get(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        var jsonList = convert.jsonDecode(response.body) as Map<String, dynamic>;
        var events = jsonList['tickets'] as List;
        var list = events.map((e) => Ticket.fromJson(e)).toList();
        return list;
      } else {
        return [];
      }
    } catch (e) {
      
      return [];
    }
  }

  static Future<Ticket?> storeTicket(String type,String name,File image) async {
    try {
      var url = Uri.http(baseUrl, '/api/tickets/store');

      var request = http.MultipartRequest('POST',url);
      request.fields['name'] = name;
      request.fields['type']= type;

      request.files.add(await http.MultipartFile.fromPath('image',image.path));

      var response = await request.send();
      
      if (response.statusCode == 200) {
        final respStr = await response.stream.bytesToString();
        var jsonList = convert.jsonDecode(respStr) as Map<String, dynamic>;
        var t = jsonList['tickets'] as Map<String,dynamic>;
        return Ticket.fromJson(t);
        
      } else {
        return null;
      }
    } catch (e) {
      
      return null;
    }}

    static Future<int>deleteTicket(int id)async{
      try{
        var url = Uri.http(baseUrl,'/api/ticket/delete/$id');

        var response =await http.get(
          url,
          headers: <String,String>{
            'Content-Type':'application/json;cahrset = UTF-8',
          }
        );
        return response.statusCode;
      }catch(e){
        return 403;
      }
    }

}
