import 'dart:convert';
import 'package:http/http.dart'as http;
import 'package:intl/intl.dart';
import '../model_class/add_vehicle_responses.dart';
import '../model_class/get_vehicle_responses.dart';

 class Service {
   Future<AddVehicle?> getPosts(String vehicleNumber,
       String uniqueId,) async {
     var client = http.Client();
     var inTime = DateFormat('yyyy-MM-ddTHH:mm:ss').format(DateTime.now());

     Map<String, dynamic> input = {
       "vehicle_no": vehicleNumber,
       "unique_id": uniqueId,
       "in_time": inTime,
       "driver_user_id": "49"
     };
     var uri = 'https://lmckmrl.kokonet.in/customerservice/addVehicleData';
     var url = Uri.parse(uri);
     print(input);
     try {
       var response = await client.post(
         url,
         body: json.encode(input),
         headers: {"Content-Type": "application/json"},
       );

       print(response.body);

       if (response.statusCode == 200) {
         // print('service1');
         // Assuming AddVehicle is your model class, replace it with your actual class
         return AddVehicle.fromJson(jsonDecode(response.body));
       } else {
         // Handle non-200 status code here
         print('Error: ${response.statusCode}');
         return null;
       }
     } catch (e) {
       // Handle network-related errors
       print('Error: $e');
       return null;
     } finally {
       client.close();
     }
   }


   Future<GetVehicle?> getDetails() async {


     var client = http.Client();
     Map input = {};
     var uri = 'https://lmckmrl.kokonet.in/customerservice/getVehicleDetails';
     var url = Uri.parse(uri);

     try {
       var response = await client.post(
         url,
         body: json.encode(input),
         headers: {"Content-Type": "application/json"},
       );

       print(response.body);

       if (response.statusCode == 200) {
         // print('service2');

         return GetVehicle.fromJson(jsonDecode(response.body));
       } else {
         print('Error: ${response.statusCode}');
         return null;
       }
     } catch (e) {
       print('Error: $e');
       return null;
     } finally {
       client.close();
     }
   }
 }
