import 'dart:convert';
import 'package:http/http.dart'as http;
import '../model_class/get_exit_vehicle.dart';
import '../model_class/exit_vehicledata.dart';


class ExitService {
  Future<ExitVehicle?> posts(
      String vehicleId) async {
    var client = http.Client();


    Map<String, dynamic> input = {
      "vehicle_id":vehicleId,
    };
    var uri ='https://lmckmrl.kokonet.in/customerservice/exitVehicleData';
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

        return ExitVehicle.fromJson(jsonDecode(response.body));
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

  Future<GetExitVehicle?> getExitDetails() async {


    var client = http.Client();
    Map input = {};
    var uri = 'https://lmckmrl.kokonet.in/customerservice/getExiedVehicleDetails';
    var url = Uri.parse(uri);

    try {
      var response = await client.post(
        url,
        body: json.encode(input),
        headers: {"Content-Type": "application/json"},
      );

      print(response.body);

      if (response.statusCode == 200) {

        return GetExitVehicle.fromJson(jsonDecode(response.body));
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



