
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project/screen/vehicle.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:project/services/addvehicle.dart';

class NextScreen extends StatefulWidget {
  const NextScreen({super.key});

  @override
  NextScreenState createState() => NextScreenState();
}

class NextScreenState extends State<NextScreen> {
  File? _image;
  final _controllerUniqueID = TextEditingController();
  final _controllerVehicleNumber = TextEditingController();
  String uniqueId = '';
  String vehicleNumber = '';
  String capturedImagePath = '';
  bool allowPop = false;
  @override
  void initState() {
    super.initState();
  }

   _getImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  _showExitAlertDialog() async {
    bool exit = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: const Text("Are you sure you want to exit without saving?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text("Yes"),
            ),
          ],
        );
      },
    );

    if (exit) {
      Navigator.of(context).pop(true); // This will pop the current screen
    }
  }

  @override
  void dispose() {
    _controllerUniqueID.dispose();
    _controllerVehicleNumber.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: allowPop,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return SizedBox(
                          height: 150,
                          child: Column(
                            children: [
                              ListTile(
                                leading: const Icon(Icons.camera_alt),
                                title: const Text('Take a photo'),
                                onTap: () {
                                  Navigator.pop(context);
                                  _getImage(ImageSource.camera);
                                },
                              ),
                              ListTile(
                                leading: const Icon(Icons.photo),
                                title: const Text('Choose from gallery'),
                                onTap: () {
                                  Navigator.pop(context);
                                  _getImage(ImageSource.gallery);
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(top: 50),
                    alignment: Alignment.bottomCenter,
                    child: _image != null
                        ? Container(
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(1.0),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(1.0),
                        child: Image.file(
                          _image!,
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                        : Container(
                      height: 200,
                      padding: const EdgeInsets.all(60.0),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(1.0),
                      ),
                      child: const Column(
                        children: [
                          Icon(
                            Icons.qr_code,
                            size: 40,
                            color: Colors.black,
                          ),
                          SizedBox(height: 20),
                          Text(
                            'ADD QR & PHOTO',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      SizedBox(
                        width: 300,
                        child: Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _controllerUniqueID,
                                textAlign: TextAlign.center,
                                decoration: const InputDecoration(
                                  hintText: 'Unique ID',
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black),
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                _startQRScanner();
                              },
                              child: const Icon(
                                Icons.qr_code,
                                size: 30,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      SizedBox(
                        width: 300,
                        child: TextFormField(
                          controller: _controllerVehicleNumber,
                          textAlign: TextAlign.center,
                          decoration: const InputDecoration(
                            hintText: 'Vehicle Number',
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 80, horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 150,
                        child: TextButton(
                          onPressed: () async {
                            await _showExitAlertDialog();
                          },
                          style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(1),
                            ),
                            backgroundColor: Colors.grey[300],
                            padding: const EdgeInsets.all(20.0),
                          ),
                          child: const Text(
                            'BACK',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 150,
                        child: TextButton(
                          onPressed: () async {
                            if (_controllerVehicleNumber.text.isNotEmpty &&
                                _controllerUniqueID.text.isNotEmpty) {
                              await Service().getPosts(
                                  _controllerVehicleNumber.text,
                                  _controllerUniqueID.text);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const VehicleScreen(),
                                ),
                              );
                            } else {
                              // Show a message or handle the case where one or both TextFields are empty
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  content: const Text(
                                      'Please fill in both Unique ID and Vehicle Number.'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('OK'),
                                    ),
                                  ],
                                ),
                              );
                            }
                          },
                          style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(1),
                            ),
                            backgroundColor: Colors.grey[300],
                            padding: const EdgeInsets.all(20.0),
                          ),
                          child: const Text(
                            'ADD VEHICLE',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _startQRScanner() async {
    String? scannedValue = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QRViewExample(uniqueIdController: _controllerUniqueID),
      ),
    );

    if (scannedValue != null) {
      setState(() {
        _controllerUniqueID.text = scannedValue;
      });
    }
  }
}

// Inside your _QRViewExampleState class
class QRViewExample extends StatefulWidget {
  final TextEditingController uniqueIdController;

  const QRViewExample({super.key, required this.uniqueIdController});

  @override
  State<StatefulWidget> createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRViewExample> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  late QRViewController controller;
  bool isScanning = false;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
              overlay: QrScannerOverlayShape(
                borderColor: Colors.red,
                borderRadius: 10,
                borderLength: 30,
                borderWidth: 10,
                cutOutSize: 300,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  if (isScanning) {
                    controller.pauseCamera(); // Stop scanning
                  } else {
                    controller.resumeCamera(); // Start scanning
                  }
                  setState(() {
                    isScanning = !isScanning;
                  });
                },
                child: Text(isScanning ? 'Stop Scan' : 'Start Scan'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      String? numericValue = extractNumericValue(scanData.code!);

      if (numericValue != null) {
        setState(() {
          widget.uniqueIdController.text = numericValue;
        });

        Navigator.pop(context, numericValue);
      } else {
        // Handle the case when a numeric value is not found
      }
    });
  }

  String? extractNumericValue(String input) {
    RegExp regex = RegExp(r'\d+');
    Match? match = regex.firstMatch(input);
    return match?.group(0);
  }
}
