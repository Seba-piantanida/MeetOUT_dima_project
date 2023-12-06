import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CreateEventPage extends StatefulWidget {
  const CreateEventPage({super.key});

  @override
  State<CreateEventPage> createState() => _CreateEventPageState();
}

class _CreateEventPageState extends State<CreateEventPage> {
  TextEditingController dateInput = TextEditingController();
  TextEditingController timeInput = TextEditingController();

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
                      child: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.amber),
                      ),
                    ),
                    const Flexible(
                      child: TextField(
                        decoration: InputDecoration(
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
              const TextField(
                minLines: 4,
                maxLines: 5,
                decoration: InputDecoration(
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
                  const SizedBox.square(dimension: 150, child: Map()),
                  ElevatedButton(
                      onPressed: () {
                        print("pick location");
                      },
                      child: const Row(
                        children: [Icon(Icons.pin_drop), Text("Pick location")],
                      )),
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
                    onPressed: () {},
                    child: Text(
                      "Create",
                      style: Theme.of(context).textTheme.titleMedium,
                    )),
              )
            ],
          ),
        ));
  }
}

class Map extends StatefulWidget {
  const Map({super.key});

  @override
  State<Map> createState() => _FindPageState();
}

class _FindPageState extends State<Map> {
  late GoogleMapController mapController;

  final LatLng _center = const LatLng(45.46427, 9.18951);

  Future<void> _onMapCreated(GoogleMapController controller) async {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
        liteModeEnabled: true,
        zoomControlsEnabled: false,
        zoomGesturesEnabled: false,
        mapToolbarEnabled: false,
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(target: _center, zoom: 11));
  }
}
