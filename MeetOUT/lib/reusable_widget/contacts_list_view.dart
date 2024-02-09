import 'package:dima_project/profile_page.dart';
import 'package:flutter/material.dart';

class ContactsListView extends StatefulWidget {
  final List<dynamic> contacts;
  final Function? onPopCallback;
  const ContactsListView(this.contacts, {this.onPopCallback, super.key});

  @override
  State<ContactsListView> createState() => _ContactsListViewState();
}

class _ContactsListViewState extends State<ContactsListView> {
  bool flag = false;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: widget.contacts.length,
        itemBuilder: (constext, index) {
          return GestureDetector(
            onTap: () async {
              if (!flag) {
                flag = true;
                await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ProfilePage(widget.contacts[index])));

                if (widget.onPopCallback != null) {
                  //widget.onPopCallback!();
                }
              }
            },
            child: Card(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 70,
                child: Row(children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10, right: 20),
                    child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.3),
                            shape: BoxShape.circle),
                        height: 60,
                        width: 60,
                        child: ClipOval(
                            child: widget.contacts[index]['profile-pic'] == ''
                                ? Center(
                                    child: Text(
                                        widget.contacts[index]["username"][0]))
                                : Image.network(
                                    widget.contacts[index]['profile-pic'],
                                    fit: BoxFit.cover,
                                  ))),
                  ),
                  Expanded(
                    child: Text(
                      widget.contacts[index]['username'],
                      style: Theme.of(context).textTheme.headlineSmall,
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
