class GetExitVehicle {
  int? statusCode;
  String? status;
  String? message;
  List<ExitVehicleList>? exitlist;

  GetExitVehicle({this.statusCode, this.status, this.message, this.exitlist});

  GetExitVehicle.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      exitlist = <ExitVehicleList>[];
      json['data'].forEach((v) {
        exitlist!.add(new ExitVehicleList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this.statusCode;
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.exitlist != null) {
      data['data'] = this.exitlist!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ExitVehicleList {
  String? driverName;
  String? outTime;
  String? uniqueId;
  String? inTime;
  String? vehicleNumber;
  int? driverUserId;
  int? id;
  String? entryDate;

  ExitVehicleList(
      {this.driverName,
        this.outTime,
        this.uniqueId,
        this.inTime,
        this.vehicleNumber,
        this.driverUserId,
        this.id,
        this.entryDate});

  ExitVehicleList.fromJson(Map<String, dynamic> json) {
    driverName = json['driver_name'];
    outTime = json['out_time'];
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
    data['out_time'] = this.outTime;
    data['unique_id'] = this.uniqueId;
    data['in_time'] = this.inTime;
    data['vehicle_number'] = this.vehicleNumber;
    data['driver_user_id'] = this.driverUserId;
    data['id'] = this.id;
    data['entry_date'] = this.entryDate;
    return data;
  }
}