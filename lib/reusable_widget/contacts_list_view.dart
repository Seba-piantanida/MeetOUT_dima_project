import 'package:dima_project/profile_page.dart';
import 'package:flutter/material.dart';

class ContactsListView extends StatefulWidget {
  final List<dynamic> contacts;
  const ContactsListView(this.contacts, {super.key});

  @override
  State<ContactsListView> createState() => _ContactsListViewState();
}

class _ContactsListViewState extends State<ContactsListView> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: widget.contacts.length,
        itemBuilder: (constext, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ProfilePage(widget.contacts[index])));
            },
            child: Card(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 70,
                child: Row(children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10, right: 20),
                    child: SizedBox(
                        height: 60,
                        width: 60,
                        child: ClipOval(
                            child: Image.network(
                          widget.contacts[index]['profile-pic'],
                          fit: BoxFit.cover,
                        ))),
                  ),
                  Expanded(
                    child: Text(
                      widget.contacts[index]['username'],
                      style: Theme.of(context).textTheme.headlineMedium,
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                ]),
              ),
            )),
          );
        });
  }
}
