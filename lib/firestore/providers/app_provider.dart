import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:restaurants/firestore/data/auth_helper.dart';
import 'package:restaurants/firestore/data/firestore_helper.dart';
import 'package:restaurants/firestore/data/router_helper.dart';
import 'package:restaurants/firestore/models/chat.dart';
import 'package:restaurants/firestore/models/gd_user.dart';
import 'package:restaurants/firestore/models/item.dart';
import 'package:restaurants/firestore/models/item_details.dart';
import 'package:restaurants/firestore/models/location.dart';
import 'package:restaurants/firestore/models/message.dart';
import 'package:restaurants/firestore/ui/add_product.dart';
import 'package:restaurants/firestore/ui/screen/LoginRegister/login_screen.dart';
import 'package:restaurants/firestore/ui/screen/admin_home.dart';
import 'package:restaurants/firestore/ui/screen/home_screen.dart';

class AppProvider extends ChangeNotifier {
  AppProvider() {
    getUsers();
    getAdmin();
  }
  GdUser loggedUser;
  XFile file;
  List<String> imgUrl;
  GoogleMapController controller;
  Set<Marker> markers = {};
  String imageUrl;
  List<ItemModel> allProducts;

  TextEditingController nameController = TextEditingController();
  TextEditingController statusController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController titleDetailsController = TextEditingController();
  TextEditingController locationController = TextEditingController();

  GdUser myUser;
  List<GdUser> users;
  GdUser admin;
  List<Chat> allMyChats;
  List<Chat> allMyChatsAd;
  pickNewImage() async {
    XFile file = await ImagePicker().pickImage(source: ImageSource.gallery);
    this.file = XFile(file.path);
    notifyListeners();
  }

  register(GdUser gdUser) async {
    try {
      String userId = await AuthHelper.authHelper
          .createNewAccount(gdUser.email, gdUser.password);
      gdUser.id = userId;
      await FirestoreHelper.firestoreHelper.createUserInFs(gdUser);
      this.loggedUser = gdUser;
      RouterHelper.routerHelper.routingToSpecificWidget(HomeScreen());
    } on Exception catch (e) {
      // TODO
    }
  }

  login(String email, String password) async {
    try {
      UserCredential userCredential =
          await AuthHelper.authHelper.signIn(email, password);
      await getUserFromFirebase();
      if (loggedUser.isAdmin) {
        RouterHelper.routerHelper.routingToSpecificWidget(AdminHome());
      } else {
        RouterHelper.routerHelper.routingToSpecificWidget(HomeScreen());
      }
    } on Exception catch (e) {
      // TODO
    }
  }

  getUserFromFirebase() async {
    String userId = FirebaseAuth.instance.currentUser.uid;
    this.loggedUser =
        await FirestoreHelper.firestoreHelper.getUserFromFs(userId);
    log(loggedUser.isAdmin.toString());
    notifyListeners();
  }

  logOut() async {
    this.loggedUser = null;
    await AuthHelper.authHelper.logout();

    RouterHelper.routerHelper.routingToSpecificWidget(LoginScreen());
  }
//////////////////Chat

  getUsers() async {
    List<QueryDocumentSnapshot<Map<String, dynamic>>> queries =
        await FirestoreHelper.firestoreHelper.getUsersFromFirestore();
    List<GdUser> userList =
        queries.map((e) => GdUser.fromMap(e.data())).toList();
    String myId = FirebaseAuth.instance.currentUser.uid;

    this.myUser = userList.where((element) => element.id == myId).first;
    userList.removeWhere((element) => element.id == myId);
    this.users = userList;
    notifyListeners();
  }

  getAdmin() async {
    List<QueryDocumentSnapshot<Map<String, dynamic>>> queries =
        await FirestoreHelper.firestoreHelper.getUsersFromFirestore();
    List<GdUser> userList =
        queries.map((e) => GdUser.fromMap(e.data())).toList();
    String myId = FirebaseAuth.instance.currentUser.uid;

    this.myUser = userList.where((element) => element.id == myId).first;
    for (int i = 0; i < userList.length; i++) {
      if (userList[i].isAdmin == true) {
        this.admin = userList[i];
      }
    }
    // userList.where((element) => element.isAdmin == true);
    // this.admin = userList[0];
    notifyListeners();
  }

  getChats() async {
    List<QueryDocumentSnapshot<Map<String, dynamic>>> list =
        await FirestoreHelper.firestoreHelper.getChats();
    List<Chat> chats = list.map((e) {
      String chatId = e.id;
      Map<String, dynamic> map = e.data();
      map['chatId'] = chatId;
      return Chat.fromJson(map);
    }).toList();
    this.allMyChats = chats;
    notifyListeners();
  }

  getChatsAdmin() async {
    List<QueryDocumentSnapshot<Map<String, dynamic>>> list =
        await FirestoreHelper.firestoreHelper.getChatsAdmin();
    List<Chat> chats = list.map((e) {
      String chatId = e.id;
      Map<String, dynamic> map = e.data();
      map['chatId'] = chatId;
      return Chat.fromJson(map);
    }).toList();
    this.allMyChatsAd = chats;
    notifyListeners();
  }

  sendMessage(Message message, GdUser otherUser) async {
    String chatId = message.chatId;
    bool x =
        await FirestoreHelper.firestoreHelper.checkCollectionExists(chatId);
    if (otherUser == null) {
      FirestoreHelper.firestoreHelper.sendMessage(message);
    } else {
      if (!x) {
        await createChat(chatId, otherUser);
        FirestoreHelper.firestoreHelper.sendMessage(message);
      } else {
        FirestoreHelper.firestoreHelper.sendMessage(message);
      }
    }
  }

  createChat(String chatId, GdUser otherUser) async {
    FirestoreHelper.firestoreHelper.createChat(chatId, this.myUser, otherUser);
  }

  createAdChat(String chatId) async {
    FirestoreHelper.firestoreHelper.createChat(chatId, this.myUser, admin);
  }

  getChatMessages(String chatId) async {}
/////////Admin
  List<XFile> sliderImages = [];
  ItemModel sliderImagesUrls = ItemModel();
  List<ItemDetails> items = [];

  Future<bool> addAllItemDetals() async {
    items.forEach((element) async {
      FirestoreHelper.firestoreHelper
          .uploadImageDetails(element.imageFile)
          .then((value) {
        print("photos.length details1 $value");
        items[items.indexOf(element)].imageUrl = value;
      });
      //  print("photos.length details$imgUrl");
    });
    return true;
  }

  Future<List<String>> loopOnFilesList() async {
    List<String> ph = [];
    var firstTime = true;
    sliderImages.forEach((element) async {
      FirestoreHelper.firestoreHelper.uploadImage(element).then((value) {
        ph.add(value);
        print("photos.length $value");
        print("photos.length  ph ${ph.length}");
        // this.sliderImagesUrls.photos != null
        //     ? this.sliderImagesUrls.photos.clear()
        //     : null;

        print("photos.length  sliderImagesUrls ${ph.length}");
        if (ph.length == sliderImages.length) {
          if (firstTime) {
            this.sliderImagesUrls.photos = ph;
            addProduct();
            firstTime = !firstTime;
          }
        }
      });
    });

    return ph;
  }

  LatLng position;
  pickLocation() async {
    GoogleMap(
      zoomControlsEnabled: false,
      onTap: (LatLng point) {
        print(point.latitude);
        print(point.longitude);
        this.markers.add(Marker(markerId: MarkerId('gaza'), position: point));
      },
      markers: markers,
      onMapCreated: (GoogleMapController controller) {
        this.controller = controller;
      },
      initialCameraPosition: CameraPosition(
        target: LatLng(31.416665, 34.333332),
        zoom: 11.0,
      ),
    );
    //code for pick locatopn
  }

  addProduct() async {
    // await loopOnFilesList();
    // await addAllItemDetals();

    ItemModel product = ItemModel(
        name: nameController.text,
        title: titleController.text,
        status: statusController.text,
        photos: sliderImagesUrls.photos,
        itemDetails: items,
        location: Location(
            addres: locationController.text, lag: 31.111, long: 31.111),
        price: num.parse(priceController.text));
    product.imgU = imageUrl;
    await FirestoreHelper.firestoreHelper.addNewProduct(product);
    getAllProducts();
    Navigator.of(RouterHelper.routerHelper.routerKey.currentState.context)
        .pop();
    // Navigator.of(RouterHelper.routerHelper.routerKey.currentState.context)
    //     .pop();
  }

  editProduct(String productiD) async {
    log(productiD ?? 'null');
    if (file != null) {
      this.imageUrl =
          await FirestoreHelper.firestoreHelper.uploadImage(this.file);
    }
    ItemModel product = ItemModel(
        id: productiD,
        name: nameController.text,
        title: titleController.text,
        status: statusController.text,
        price: num.parse(priceController.text));
    product.imgU = imageUrl;
    await FirestoreHelper.firestoreHelper.editProduct(product);
    getAllProducts();
    Navigator.of(RouterHelper.routerHelper.routerKey.currentState.context)
        .pop();
  }

  goToEditProduct(ItemModel product) {
    this.file = null;
    this.nameController.text = product.name;
    this.titleController.text = product.title;
    this.statusController.text = product.status;
    this.priceController.text = product.price.toString();
    this.imageUrl = product.imgU;
    notifyListeners();
    RouterHelper.routerHelper.routingToSpecificWidgetWithoutPop(AddNewProduct(
      isForEdit: true,
      productId: product.id,
    ));
  }

  getAllProducts() async {
    this.allProducts = await FirestoreHelper.firestoreHelper.getAllProducts();
    notifyListeners();
  }

  deleteProduct(String productiD) async {
    await FirestoreHelper.firestoreHelper.deleteProruct(productiD);
    getAllProducts();
  }
}
