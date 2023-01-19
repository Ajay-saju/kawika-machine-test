import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:kawika/controller/home_screen_controller.dart';

class ProifilePage extends StatelessWidget {
  final index;
  ProifilePage({super.key, required this.index});

  final homeController = Get.find<HomeScreenController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            '${homeController.getUserDetails.value.data![index].firstName!} ${homeController.getUserDetails.value.data![index].lastName}'),
      ),
      body: SafeArea(
          child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 30,
            ),
            CircleAvatar(
              radius: 90,
              backgroundImage: NetworkImage(homeController
                  .getUserDetails.value.data![index].avatar
                  .toString()),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              height: 300,
              width: 300,
              decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 225, 219, 194)),
              child: Column(children: [
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text(
                        'Id :',
                        style: TextStyle(fontSize: 18),
                      ),
                      Text(
                        homeController.getUserDetails.value.data![index].id
                            .toString(),
                        maxLines: 2,
                        style: const TextStyle(fontSize: 17),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text(
                        'First Name :',
                        style: TextStyle(fontSize: 18),
                      ),
                      Text(
                        homeController
                            .getUserDetails.value.data![index].firstName
                            .toString(),
                        style: const TextStyle(fontSize: 17),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text(
                        'Last Name :',
                        style: TextStyle(fontSize: 18),
                      ),
                      Text(
                        homeController
                            .getUserDetails.value.data![index].lastName
                            .toString(),
                        style: const TextStyle(fontSize: 17),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text(
                        'Email :',
                        style: TextStyle(fontSize: 18),
                      ),
                      Text(
                        homeController.getUserDetails.value.data![index].email
                            .toString(),
                        maxLines: 2,
                        style: const TextStyle(fontSize: 17),
                      ),
                    ],
                  ),
                ),
              ]),
            )
          ],
        ),
      )),
    );
  }
}
