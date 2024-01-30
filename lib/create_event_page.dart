import 'dart:io';
import 'dart:math';

import 'package:dima_project/events_details_page.dart';
import 'package:dima_project/events_manager.dart';
import 'package:dima_project/reusable_widget/location_picker.dart';
import 'package:dima_project/reusable_widget/map_viewer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:dima_project/reusable_widget/image_selector.dart';

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

  DateTime? selectedDate;
  TimeOfDay selectedTime = const TimeOfDay(hour: 0, minute: 0);

  List<XFile?> _images = [];

  LatLng? _locationInput;

  String selectedIcon = "";

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
                                  selectedIcon = imageName;
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
                          child: selectedIcon == ""
                              ? const Icon(Icons.add_box_rounded)
                              : ClipOval(child: Image.asset(selectedIcon)),
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
                              selectedDate = pickedDate;
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
                                    selectedTime = pickedTime;
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
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: SizedBox.square(
                            dimension: 150,
                            child: MapView(
                              center: _locationInput!,
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                ],
              ),
              // Padding(
              //   padding: const EdgeInsets.all(15.0),
              //   child: Text(
              //     "Partecipants",
              //     style: Theme.of(context).textTheme.titleLarge,
              //   ),
              // ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  "Images",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              SizedBox(
                height: _images.isEmpty ? 50 : 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _images.length + 1,
                  itemBuilder: (context, index) {
                    if (index == _images.length) {
                      return IconButton(
                          onPressed: () async {
                            List<XFile?> pickedImages =
                                await ImagePicker().pickMultiImage();
                            _images.addAll(pickedImages);
                            setState(() {});
                          },
                          icon: const Icon(Icons.add_photo_alternate_outlined));
                    }
                    return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.file(
                          File(_images[index]!.path),
                          width: 100,
                          height: 100,
                        ));
                  },
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

  Future<void> _createEvent() async {
    if (nameInput.text.isEmpty ||
        descriptionInput.text.isEmpty ||
        _locationInput == null ||
        selectedDate == null ||
        selectedIcon == "") {
      // if one of the elements is null show error dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Fill out all the fields'),
            content: const Text(
                'Please make sure to fill out all the fields before creating the event.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }
    String id = '${Random().nextInt(9999999)}A';
    Map<String, dynamic> event = {
      'id': id,
      'name': nameInput.text,
      "description": descriptionInput.text,
      "location": {
        "lat": _locationInput!.latitude,
        "lng": _locationInput!.longitude
      },
      "date-time": DateTime(selectedDate!.year, selectedDate!.month,
          selectedDate!.day, selectedTime.hour, selectedTime.minute),
      "icon": selectedIcon,
      "all-day": allDay,
      "images": _images,
      'owner': FirebaseAuth.instance.currentUser?.uid
    };
    OverlayEntry overlayEntry = OverlayEntry(
        opaque: true,
        builder: (context) => const Positioned(
            child: Center(child: CircularProgressIndicator())));
    Overlay.of(context).insert(overlayEntry);
    try {
      await saveEvent(event);
      await addToMyEvents(id);
      overlayEntry.remove();
      var myEvent = await getEventById(id);
      _resetFields();
      // ignore: use_build_context_synchronously
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => EventDetailsPage(myEvent)));
    } catch (e) {
      overlayEntry.remove();
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Event cration failed'),
            content: const Text(
                'An error occured during the event creation please try again'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  _resetFields() {
    dateInput.clear();
    timeInput.clear();
    nameInput.clear();
    descriptionInput.clear();

    _images = [];

    _locationInput = null;

    selectedIcon = "";

    allDay = false;
    setState(() {});
  }
}
