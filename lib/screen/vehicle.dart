
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../model_class/get_exit_vehicle.dart';

import '../services/exit_history.dart';

import '../model_class/get_vehicle_responses.dart' ;
import '../services/addvehicle.dart';
import 'add.dart';

class VehicleScreen extends StatefulWidget {
  const VehicleScreen({super.key});

  @override
  VehicleScreenState createState() => VehicleScreenState();
}

class VehicleScreenState extends State<VehicleScreen> {
  List<GetVehicleList>? vehicleList;
  List<ExitVehicleList>? exitlist;
  var isLoaded = false;
  var isLoading = false;
  String inTabSearchQuery = '';
  String outTabSearchQuery = '';

  @override
  void initState() {
    super.initState();
    getDetails();
    getExitDetails();
  }





    getDetails() async {
     setState(() {
       isLoaded = true;
     });
       try {
         GetVehicle? response = await Service().getDetails();
         if (response != null) {
           setState(() {
             vehicleList = response.VehicleList;
           });
         }
       } catch (e) {
         print('Error fetching details: $e');
       }
       finally{
         setState(() {
           isLoaded = false;
         });
       }
     }


    exitVehicle(int index) async {
    try {
       var response = await ExitService().posts(vehicleList![index].id.toString());
      if (response != null) {
      setState(() {
        getDetails();
        getExitDetails();
      });
      }
    } catch (e) {
      print('Error exiting vehicle: $e');
    }
  }
  getExitDetails() async {

    setState(() {
      isLoading = true;
    });
    try {

      var response = await ExitService ().getExitDetails();

      if (response != null) {

        setState(() {
          exitlist = response.exitlist;
        });
      }
    }
    catch (e) {
      print('Error: $e');
    }
    finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: DefaultTabController(
          length: 2,
          child: Column(
            children: [
              const TabBar(
                padding: EdgeInsets.symmetric(vertical: 20),
                labelColor: Colors.black,
                labelStyle: TextStyle(fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,

                ),
                tabs: [
                  Tab(text: 'VEHICLE IN'),
                  Tab(text: 'VEHICLE OUT'),

                ],

              ),
              Expanded(
                child: TabBarView(

                  children: [
                    // Vehicle IN tab
                    isLoaded
                    ? const Center(child: CircularProgressIndicator())

                    :Column(
                      children: [
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical:1,horizontal: 20),
                          child: TextField(
                            style: const TextStyle(fontSize: 12),
                            onChanged: (value) {
                              setState(() {
                                inTabSearchQuery = value;
                              });
                            },
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 70),
                              filled: true,
                              fillColor: Colors.grey[200],
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(1.0),
                                borderSide: BorderSide.none,
                              ),
                              labelText: 'Search Vehicle Number',
                              labelStyle: const TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Expanded(
                          child: ListView.builder(
                            itemCount: vehicleList?.length ,
                            itemBuilder: (BuildContext context,int index) {
                              if (inTabSearchQuery.isNotEmpty &&
                                  !vehicleList![index].vehicleNumber!.contains(inTabSearchQuery)) {
                                return Container();
                              }


                              return Slidable(
                                actionPane: const SlidableDrawerActionPane(),
                                actionExtentRatio: 0.25,
                                secondaryActions: [
                                  IconSlideAction(
                                    caption: 'Exit',
                                    foregroundColor: Colors.grey.shade400,

                                    icon: Icons.exit_to_app,
                                    onTap: () {
                                      exitVehicle(index);
                                      Fluttertoast.showToast(
                                          msg: "vehicle exited",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.CENTER,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor: Colors.red,
                                          textColor: Colors.white,
                                          fontSize: 16.0
                                      );
                                    },
                                  ),
                                ],
                                child: Container(
                                  margin: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(1.0),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Vehicle Number: ${vehicleList?[index].vehicleNumber.toString()}',
                                              style: const TextStyle(
                                                  color: Colors.black),
                                            ),
                                            const SizedBox(height: 10),
                                            Text(
                                              'In Time:  ${vehicleList?[index].inTime.toString()}',
                                              style: const TextStyle(
                                                  color: Colors.black),
                                            ),
                                          ],
                                        ),
                                        const Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                          children: [
                                            Text('Image',
                                                style: TextStyle(
                                                    color: Colors.black)),
                                            SizedBox(height: 20),
                                            Text('Driver',
                                                style: TextStyle(
                                                    color: Colors.black)),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(
                                0, 8, 30, 10),
                            child: TextButton(
                              onPressed: () {

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const NextScreen(),
                                  ),
                                );

                              },
                              style: TextButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(29),
                                ),backgroundColor: Colors.grey,

                                padding: const EdgeInsets.symmetric(
                                    vertical: 20, horizontal: 40),
                              ),
                              child: const Text(
                                'ADD',
                                style: TextStyle(fontSize: 15,
                                  color: Colors.black,
                                ),
                              ),

                            ),
                          ),
                        ),
                      ],
                    ),

                    //Vehicle OUT tab
                    isLoading
                    ? const Center(child: CircularProgressIndicator())

                          :Column(
                            children: [
                              const SizedBox(height: 10),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                child: TextField(
                                  style: const TextStyle(fontSize: 12),
                                  onChanged: (value) {
                                    setState(() {
                                      outTabSearchQuery = value;
                                    });
                                  },
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(
                                      vertical: 10,
                                      horizontal: 70,
                                    ),
                                    filled: true,
                                    fillColor: Colors.grey[200],
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(1.0),
                                      borderSide: BorderSide.none,
                                    ),
                                    labelText: 'Search Vehicle Number',
                                    labelStyle: const TextStyle(color: Colors.black),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),

                                      Expanded(
                                      child: ListView.builder(
                                        itemCount: exitlist?.length ,
                                        itemBuilder: ( BuildContext context,int index) {
                                          if (outTabSearchQuery.isNotEmpty &&
                                              !exitlist![index].vehicleNumber!.contains(outTabSearchQuery)) {
                                            return Container();
                                          }


                                          return Container(
                                            margin: const EdgeInsets.all(20),
                                            decoration: BoxDecoration(
                                              color: Colors.grey[200],
                                              borderRadius: BorderRadius.circular(1.0),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        'Vehicle Number: ${exitlist?[index].vehicleNumber.toString()}',
                                                        style: const TextStyle(color: Colors.black),
                                                      ),
                                                      const SizedBox(height: 20),
                                                      Text(
                                                        'Out Time: ${exitlist?[index].outTime.toString()}',
                                                        style: const TextStyle(color: Colors.black),
                                                      ),
                                                    ],
                                                  ),
                                                  const Column(
                                                    crossAxisAlignment: CrossAxisAlignment.end,
                                                    children: [
                                                      Text('Image', style: TextStyle(color: Colors.black)),
                                                      SizedBox(height: 20),
                                                      Text('Driver', style: TextStyle(color: Colors.black)),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                      ),
                            ],
                          ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}