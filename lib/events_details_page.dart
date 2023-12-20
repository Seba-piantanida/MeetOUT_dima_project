import 'package:flutter/material.dart';

class EventDetailsPage extends StatelessWidget {
  final dynamic event;
  const EventDetailsPage(this.event, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            floating: true,
            expandedHeight: 160,
            flexibleSpace: FlexibleSpaceBar(
              title: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                Image.asset(
                  event["icon"],
                  scale: 2,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(event["name"]),
                )
              ]),
              background: event["images"].isEmpty
                  ? Container(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                        Colors.indigo.shade900,
                        Colors.blue.shade800,
                      ],
                    )))
                  : Image.network(
                      event["images"][0],
                      fit: BoxFit.cover,
                    ),
            ),
          ),
          SliverList.list(children: <Widget>[
            Text(
              "Description",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Text(event["description"]),
            Container(
              height: 200,
              width: 100,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: event["images"].length,
                  itemBuilder: (context, index) {
                    return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.network(event["images"][index])));
                  }),
            ),
            Container(
              color: Colors.blue,
              height: 2000,
            )
          ])
        ],
      ),
    );
  }
}

class ImageZoomPage extends StatelessWidget {
  final String imageUrl;

  const ImageZoomPage({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Center(
          child: Hero(
            tag: 'imageHero${imageUrl.hashCode}',
            child: Image.network(imageUrl),
          ),
        ),
      ),
    );
  }
}
