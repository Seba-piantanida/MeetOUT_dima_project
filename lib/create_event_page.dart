import 'dart:ffi';

import 'package:dima_project/events_manager.dart';
import 'package:dima_project/location_picker.dart';
import 'package:dima_project/map_viewer.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:dima_project/image_selector.dart';

class CreateEventPage extends StatefulWidget {
  const CreateEventPage({super.key});

  @override
  State<CreateEventPage> createState() => _CreateEventPageState();
}

class _CreateEventPageState extends State<CreateEventPage> {
  TextEditingController dateInput = TextEditingController();
  TextEditingController timeInput = TextEditingController();
  TextEditingController nameInput = TextEditingController();
  TextEditingController descriptionInput = TextEditingController();

  LatLng? _locationInput;

  String selectedImage = "";

  bool allDay = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "New event",
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 15, right: 15),
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 15),
                      child: GestureDetector(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return ImageSelectionDialog(
                                    onImageSelected: (String imageName) {
                                  selectedImage = imageName;
                                  setState(() {});

                                  // Handle the selected image
                                });
                              });
                        },
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade600),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: selectedImage == ""
                              ? const Icon(Icons.add_box_rounded)
                              : ClipOval(child: Image.asset(selectedImage)),
                        ),
                      ),
                    ),
                    Flexible(
                      child: TextField(
                        controller: nameInput,
                        decoration: const InputDecoration(
                          hintText: 'Event name',
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          contentPadding: EdgeInsets.all(8.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  "Description",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              TextField(
                controller: descriptionInput,
                minLines: 4,
                maxLines: 5,
                decoration: const InputDecoration(
                  hintText: 'Write a description of your event',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  contentPadding: EdgeInsets.all(8.0),
                ),
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(
                      "Date-time",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      "All day",
                      textAlign: TextAlign.right,
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ),
                  Switch(
                      value: allDay,
                      onChanged: (bool value) {
                        setState(() {
                          allDay = value;
                        });
                      })
                ],
              ),
              Row(
                mainAxisAlignment: allDay
                    ? MainAxisAlignment.start
                    : MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 150,
                    child: TextField(
                        controller: dateInput,
                        textAlign: TextAlign.center,
                        readOnly: true,
                        decoration: const InputDecoration(
                          hintText: 'Pick a date',
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          contentPadding: EdgeInsets.all(8.0),
                        ),
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2100));
                          if (pickedDate != null) {
                            setState(() {
                              dateInput.text =
                                  DateFormat('dd-MM-yyyy').format(pickedDate);
                            });
                          }

                          print(pickedDate);
                        }),
                  ),
                  !allDay
                      ? SizedBox(
                          //padding: const EdgeInsets.only(top: 15),
                          width: 150,
                          child: Center(
                            child: TextField(
                                controller: timeInput,
                                textAlign: TextAlign.center,
                                readOnly: true,
                                decoration: const InputDecoration(
                                  hintText: 'Pick time',
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
                                  contentPadding: EdgeInsets.all(8.0),
                                ),
                                onTap: () async {
                                  TimeOfDay? pickedTime = await showTimePicker(
                                    initialTime: TimeOfDay.now(),
                                    context: context,
                                  );
                                  if (pickedTime != null) {
                                    String formattedTime =
                                        DateFormat('hh:mm').format(
                                      DateTime(2020, 1, 1, pickedTime.hour,
                                          pickedTime.minute),
                                    );
                                    setState(() {
                                      timeInput.text = formattedTime;
                                    });
                                  }

                                  print(pickedTime);
                                }),
                          ),
                        )
                      : const SizedBox.shrink(),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  "Location",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  ElevatedButton(
                      onPressed: () async {
                        dynamic returnedLocation = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LocationPicker()));
                        if (returnedLocation != null) {
                          _locationInput = returnedLocation;
                          setState(() {});
                        }
                      },
                      child: const Row(
                        children: [Icon(Icons.pin_drop), Text("Pick location")],
                      )),
                  _locationInput != null
                      ? SizedBox.square(
                          dimension: 150,
                          child: MapView(
                            center: _locationInput!,
                          ),
                        )
                      : const SizedBox.shrink(),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  "Partecipants",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  "Images",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: ElevatedButton(
                    onPressed: _createEvent,
                    child: Text(
                      "Create",
                      style: Theme.of(context).textTheme.titleMedium,
                    )),
              )
            ],
          ),
        ));
  }

  void _createEvent() {
    Map<String, dynamic> event = {
      'id': '${dateInput.text}-${TimeOfDay.now()}',
      'name': nameInput.text,
      "description": descriptionInput.text,
      "location": _locationInput,
      "date-time": DateTime(2023, 12, 7, 15, 30),
      "icon": selectedImage,
    };
    addEvent(event);
  }
}
