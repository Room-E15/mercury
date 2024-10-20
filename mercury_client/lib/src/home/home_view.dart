import 'package:flutter/material.dart';
import 'group.dart';

class HomeView extends StatelessWidget {
  const HomeView({
    super.key,
    this.groups = const [
      Group(1, "Cal Poly Software", 36, 12, 0),
      Group(2, "Cal Poly Architecture", 36, 24, 0),
      Group(3, "U Chicago", 36, 36, 0),
      Group(3, "That Group", 36, 12, 1)
    ],
  });

  static const routeName = '/';

  final List<Group> groups;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MERCURY'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search Groups',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              restorationId: 'groupList',
              itemCount: groups.length, // Number of blank cards
              itemBuilder: (BuildContext context, int index) {
                final group = groups[index];
                final progress = group.responseCount / group.memberCount;
                final anyUnsafe = group.unsafe > 0;
                return Card(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    margin: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 16.0),
                    child: InkWell(
                      onTap: () {},
                      child: SizedBox(
                          height: 100.0, // Height of each blank card
                          child: Column(
                            children: [
                              Stack(
                                children: [
                                  LinearProgressIndicator(
                                    value: anyUnsafe ? 1 : progress,
                                    backgroundColor: const Color.fromARGB(
                                        255, 126, 126, 126),
                                    valueColor: anyUnsafe
                                        ? const AlwaysStoppedAnimation<Color>(
                                            Colors.red)
                                        : const AlwaysStoppedAnimation<Color>(
                                            Colors.green),
                                    minHeight: 20.0,
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        anyUnsafe ? Icons.error : Icons.check,
                                        color:
                                            const Color.fromARGB(128, 0, 0, 0),
                                      ),
                                      Text(
                                        anyUnsafe
                                            ? group.unsafe > 1
                                                ? "${group.unsafe} members are not safe!"
                                                : "${group.unsafe} member is not safe!"
                                            : "${group.responseCount} of ${group.memberCount} Members Safe",
                                        style: const TextStyle(
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.w900,
                                            color:
                                                Color.fromARGB(128, 0, 0, 0)),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    group.name,
                                    style: const TextStyle(
                                      fontSize: 24.0,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                    textAlign: TextAlign.start,
                                  ),
                                  const Spacer(),
                                  const Icon(Icons.chevron_right),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Expanded(
                                      child: ElevatedButton(
                                          onPressed: () {},
                                          child: const Text("Send Alert")))
                                ],
                              )
                            ],
                          )),
                    ));
              },
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: HomeView(),
  ));
}
