import 'package:dima_project/reusable_widget/contacts_list_view.dart';
import 'package:dima_project/user_manager.dart';
import 'package:flutter/material.dart';

class SearchProfilePage extends StatefulWidget {
  const SearchProfilePage({super.key});

  @override
  State<SearchProfilePage> createState() => _SearchProfilePageState();
}

class _SearchProfilePageState extends State<SearchProfilePage> {
  Widget? userList;
  List<Map<String, dynamic>> users = [];
  final TextEditingController _searchInput = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(children: [
          SizedBox(
            height: 70,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back_ios)),
                  Expanded(
                    child: TextField(
                      onSubmitted: (value) async {
                        _getUserList(value);
                      },
                      controller: _searchInput,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.search),
                        hintText: 'Search...',
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
          ),
          userList == null ? const SizedBox.shrink() : userList!
        ]),
      ),
    );
  }

  _getUserList(String username) async {
    try {
      users = await getUsersByName(username);
      if (users.isEmpty) {
        userList = const Center(
          child: Text("No user found"),
        );
      } else {
        userList = Expanded(child: ContactsListView(users));
      }
    } catch (e) {
      userList = const Center(
        child: Text("error searching users"),
      );
    }
    setState(() {});
  }
}
