import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_optician/common_function/nav_functions.dart';
import 'package:smart_optician/model/search_model.dart';

class FetchShopData {
  static final CollectionReference _fireLens =
      FirebaseFirestore.instance.collection("Lens");

  static final CollectionReference _fireGoggles =
      FirebaseFirestore.instance.collection("Goggles");
  //
  static final CollectionReference _fireGlasses =
      FirebaseFirestore.instance.collection("Glasses");

  final List<String> _fireDocsLens = [];
  final List<String> _fireDocsGlasses = [];
  final List<String> _fireDocsGoggles = [];

  fetchData() async {
    getLens();
    getGlasses();
    getGoggles();
  }

  getLens() async {
    QuerySnapshot querySnapshotLens = await _fireLens.get();

    for (int i = 0; i < querySnapshotLens.docs.length; i++) {
      var a = querySnapshotLens.docs[i];
      _fireDocsLens.add(a.id);
    }

    for (int index = 0; index < _fireDocsLens.length; index++) {
      await _fireLens.doc(_fireDocsLens.elementAt(index)).get().then((value) {
        searchData.add(SearchModel(
            brand: value.get('brand'),
            type: value.get('category'),
            code: value.get('code'),
            desc: value.get('desc'),
            gender: value.get('gender'),
            image: value.get('image'),
            name: value.get('name'),
            ownerId: value.get('ownerId'),
            price: value.get('price')));
      });
    }

    print('data length => ${searchData.length}');
  }

  getGlasses() async {
    QuerySnapshot querySnapshotGlasses = await _fireGlasses.get();

    /// this loop is used to add data to _fireDocs list

    for (int i = 0; i < querySnapshotGlasses.docs.length; i++) {
      var a = querySnapshotGlasses.docs[i];
      _fireDocsGlasses.add(a.id);
    }

    for (int index = 0; index < _fireDocsGlasses.length; index++) {
      await _fireGlasses
          .doc(_fireDocsGlasses.elementAt(index))
          .get()
          .then((value) {
        searchData.add(SearchModel(
            brand: value.get('brand'),
            type: value.get('category'),
            code: value.get('code'),
            desc: value.get('desc'),
            gender: value.get('gender'),
            image: value.get('image'),
            name: value.get('name'),
            ownerId: value.get('ownerId'),
            price: value.get('price')));
      });
    }

    print('data length => ${searchData.length}');
  }

  getGoggles() async {
    QuerySnapshot querySnapshotGoggles = await _fireGoggles.get();

    for (int i = 0; i < querySnapshotGoggles.docs.length; i++) {
      var a = querySnapshotGoggles.docs[i];
      _fireDocsGoggles.add(a.id);
    }

    for (int index = 0; index < _fireDocsGoggles.length; index++) {
      await _fireGoggles
          .doc(_fireDocsGoggles.elementAt(index))
          .get()
          .then((value) {
        searchData.add(SearchModel(
            brand: value.get('brand'),
            type: value.get('category'),
            code: value.get('code'),
            desc: value.get('desc'),
            gender: value.get('gender'),
            image: value.get('image'),
            name: value.get('name'),
            ownerId: value.get('ownerId'),
            price: value.get('price')));
      });
    }

    print('data length => ${searchData.length}');
  }
}
