Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          centerTitle: true,
          title: const Text("Event's details")),
      body: ListView(children: [
        SizedBox(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                event["name"],
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              Image.asset(
                event["icon"],
                height: 50,
                width: 50,
              ),
            ],
          ),
        ),
        Text(event["description"]),
        Container(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: event["images"].length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          ImageZoomPage(imageUrl: event["images"][index]),
                    ),
                  );
                },
                child: Hero(
                  tag: 'imageHero$index',
                  child: Container(
                    height: 200.0, // Altezza dell'immagine nella lista
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(event["images"][index]),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        ElevatedButton(onPressed: () {}, child: const Text("join"))
      ]),
    );