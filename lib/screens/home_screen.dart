import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:kawika/controller/home_screen_controller.dart';
import 'package:kawika/screens/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

HomeScreenController homeController = Get.put(HomeScreenController());
// Icon customIcon = const Icon(Icons.search);
Widget customSearchBar = const Text('Kawika ');

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    homeController.getUserList();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeScreenController>(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: customSearchBar,
        ),
        body: homeController.getUserDetails.value.data == null
            ? const Center(
                child: CircularProgressIndicator(color: Colors.black87),
              )
            : SafeArea(
                child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    SearchBar(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: homeController.searchedItems.isEmpty
                          ? const Center(
                              child: Text('No data found'),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              itemCount: homeController.searchedItems.length,
                              itemBuilder: (context, index) => ListTile(
                                    onTap: () => Get.defaultDialog(
                                        title: "",
                                        middleText: "",
                                        actions: [
                                          ElevatedButton(
                                              onPressed: () async {
                                                Get.to(ProifilePage(
                                                  index: index,
                                                ));
                                              },
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.black,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30),
                                                  )),
                                              child: Text(
                                                  "${homeController.getUserDetails.value.data![index].firstName} 's Profile")),
                                          ElevatedButton(
                                              onPressed: () async {},
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.black,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30),
                                                  )),
                                              child: Text(
                                                  "${homeController.getUserDetails.value.data![index].firstName} 's Repositories")),
                                        ]),
                                    title: Text(homeController
                                        .searchedItems[index]
                                        .toString()),
                                  )),
                    )
                  ],
                ),
              )),
      );
    });
  }
}

class SearchBar extends StatefulWidget {
  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  // final TextEditingController _searchController = TextEditingController();
  HomeScreenController homeController = Get.put(HomeScreenController());
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(221, 68, 56, 56),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: TextField(
          style: const TextStyle(
            color: Colors.white,
          ),
          cursorColor: Colors.white,
          decoration: const InputDecoration(
            contentPadding:
                EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
            hintText: "Search user...",
            hintStyle: TextStyle(
              color: Colors.white,
            ),
            border: InputBorder.none,
            suffixIcon: Icon(
              Icons.search,
              color: Colors.white,
            ),
          ),
          controller: homeController.searchController,
          onChanged: (value) {
            homeController.searchItem.value = value;
            homeController.searchItemMethod();
          },
        ),
      ),
    );
  }
}
