class GetVehicle {
  int? statusCode;
  String? status;
  String? message;
  List<GetVehicleList>? VehicleList;

  GetVehicle({this.statusCode, this.status, this.message, this.VehicleList});

  GetVehicle.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      VehicleList = <GetVehicleList>[];
      json['data'].forEach((v) {
        VehicleList!.add(new GetVehicleList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this.statusCode;
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.VehicleList != null) {
      data['data'] = this.VehicleList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class GetVehicleList {
  String? driverName;
  String? uniqueId;
  String? inTime;
  String? vehicleNumber;
  int? driverUserId;
  int? id;
  String? entryDate;

  GetVehicleList(
      {this.driverName,
        this.uniqueId,
        this.inTime,
        this.vehicleNumber,
        this.driverUserId,
        this.id,
        this.entryDate});

  GetVehicleList.fromJson(Map<String, dynamic> json) {
    driverName = json['driver_name'];
    uniqueId = json['unique_id'];
    inTime = json['in_time'];
    vehicleNumber = json['vehicle_number'];
    driverUserId = json['driver_user_id'];
    id = json['id'];
    entryDate = json['entry_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['driver_name'] = this.driverName;
    data['unique_id'] = this.uniqueId;
    data['in_time'] = this.inTime;
    data['vehicle_number'] = this.vehicleNumber;
    data['driver_user_id'] = this.driverUserId;
    data['id'] = this.id;
    data['entry_date'] = this.entryDate;
    return data;
  }
}
