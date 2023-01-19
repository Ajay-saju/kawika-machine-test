import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kawika/model/user_data_list.dart';
import 'package:kawika/model/user_list_model.dart';
import 'package:kawika/service/get_user_list_service.dart';

class HomeScreenController extends GetxController {
  final TextEditingController searchController = TextEditingController();
  var userData = [].obs;
  var userNames = [].obs;
  var searchedItems = [].obs;
  var searchItem = ''.obs;
  Rx<UserDataList> userDataList = UserDataList().obs;
  Rx<UserListModel> getUserDetails = UserListModel().obs;
  getUserList() async {
    final getUserListService = GetUserListService();
    try {
      var response = await getUserListService.getUserList();
      if (response.statusCode == 200) {
        getUserDetails.value = UserListModel.fromJson(response.data);
        userData.value = getUserDetails.value.data!;
        for (var i = 0; i < userData.length; i++) {
          userNames.add(userData.value[i].firstName);
        }
        print(userNames);
        print(userData.value[0].firstName.toString());
      }
    } catch (e) {
      print(e.toString());
    }
    update();
  }

  searchItemMethod() {
    print(userData.toString());
    searchedItems.value = userNames
        .where((element) =>
            element.toLowerCase().contains(searchItem.toLowerCase()))
        .toList();
    update();
  }
}
