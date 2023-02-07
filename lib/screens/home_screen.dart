import 'dart:io';
import 'package:al_downloader/al_downloader.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kawika/controller/home_screen_controller.dart';
import 'package:kawika/screens/image_screen.dart';
import 'package:kawika/screens/offline_download.dart';
import 'package:kawika/screens/play_screen.dart';
import 'package:kawika/screens/profile_screen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class HomeScreen extends StatefulWidget with WidgetsBindingObserver {
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
        floatingActionButton: ElevatedButton(
            child: const Text('Next'),
            onPressed: () {
              Get.to(OfflineDownloads());
            }),
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
                    ElevatedButton(
                        child: const Text('Download video'),
                        onPressed: () async {
                          await downloadVideo();
                          //  ALDownloader.download(
                          //     'http://techslides.com/demos/sample-videos/small.mp4',
                          //     downloaderHandlerInterface:
                          //         ALDownloaderHandlerInterface(
                          //             progressHandler: (progress) {
                          //       debugPrint(
                          //           "ALDownloader | download progress = $progress, url = $url\n");
                          //     }, succeededHandler: () {
                          //       debugPrint(
                          //           "ALDownloader | download succeeded, url = $url\n");
                          //     }, failedHandler: () {
                          //       debugPrint(
                          //           "ALDownloader | download failed, url = $url\n");
                          //     }, pausedHandler: () {
                          //       debugPrint(
                          //           "ALDownloader | download paused, url = $url\n");
                          //     }));
                        }),
                    ElevatedButton(
                        onPressed: () {}, child: const Text('Play video')),
                    ElevatedButton(
                        onPressed: () {
                          Get.to(const ImageScreen());
                        },
                        child: const Text('select multiple images')),
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

//   downloadVideo() async {
//     Directory tempDir = await getTemporaryDirectory();
// String tempPath = tempDir.path;
//     final taskId = await FlutterDownloader.enqueue(
//         url: 'http://techslides.com/demos/sample-videos/small.mp4 ',
//         savedDir: "$tempPath/video.mp4",
//         showNotification: true,
//         openFileFromNotification: true);
//   }
  var taskid;
  var url = 'http://techslides.com/demos/sample-videos/small.mp4';
//   Future<void> downloadVideo(
//       {required String url, required String name}) async {
//     final dir = await getApplicationDocumentsDirectory();
// //From path_provider package
//     var localPath = dir.path + name;
//     final savedDir = Directory(localPath);
//     await savedDir.create(recursive: true).then((value) async {

//         taskid = await FlutterDownloader.enqueue(
//           url: url,
//           fileName: name,
//           savedDir: localPath,
//           showNotification: true,
//           openFileFromNotification: false,
//           saveInPublicStorage: true,
//         );
//         print("----------------------$taskid");

//     });
//   }

  // void download() {
  //   downloadVideo(name: 'sample.mp4', url: url).then((_) {
  //     saveTaskId(taskid, url);
  //   });
  // }

  // Future<void> downloadVideo(
  //     {required String url, required String name}) async {
  //   final dir = await getApplicationDocumentsDirectory();
  //   var localPath = dir.path + name;
  //   final savedDir = Directory(localPath);
  //   print(savedDir.path);
  //   taskid = await FlutterDownloader.enqueue(
  //     url: url,
  //     savedDir: savedDir.path,
  //     showNotification: true,
  //     openFileFromNotification: true,
  //   );
  // }
  CancelToken cancelToken = CancelToken();
  cancelDownload(index) {
    cancelToken.cancel();
  }

// var path;
  bool? downloading;
  String? progressString;
  Future downloadVideo() async {
    // cmeProgramController.allCmeVideos.value!.videoList![index].isDownloading =
    //     true;

    var url = 'http://techslides.com/demos/sample-videos/small.mp4';

    Dio dio = Dio();
    try {
      var dir = await getApplicationDocumentsDirectory();
      print("path ${dir.path}");
      var path = "${dir.path}/$url";
      await dio.download(
        url,
        path,
        cancelToken: cancelToken,
        onReceiveProgress: (rec, total) {
          print("Rec: $rec , Total: $total");
          setState(() {
            downloading = true;
            progressString = ((rec / total) * 100).toStringAsFixed(0) + "%";
          });
          if (rec == 383631) {
            Get.to(VideoPlayerPage(
              file: File(path),
            )
            );
          }
        },
      );
    } catch (e) {
      // cmeProgramController.allCmeVideos.value!.videoList![index].isDownloading =
      //     false;
      print(e);
    }
    setState(() {
      downloading = false;
      progressString = "Completed";
      // cmeProgramController.allCmeVideos.value!.videoList![index].isDownloading =
      //     false;
    });

    print("Download completed");
  }

  void saveTaskId(String taskId, String url) async {
    final Database db = await openDatabase('downloads.db');
    await db.execute(
      'CREATE TABLE IF NOT EXISTS downloads (task_id TEXT PRIMARY KEY, url TEXT)',
    );
    await db.insert(
      'downloads',
      {'task_id': taskId, 'url': url},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    await db.close();
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
