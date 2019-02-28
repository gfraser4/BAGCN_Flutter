import 'package:cloud_firestore/cloud_firestore.dart';

class AddClass {
  //QUERY FOR CLASS NAME SEARCH
  static Stream<QuerySnapshot> nameSearch(String _classNameController, Stream<QuerySnapshot> stream) {
    if (_classNameController.length > 0) { //CHECK IF THERE IS INPUT IN CLASS NAME SEARCH
      stream = Firestore.instance
          .collection('class')
          .where('clsName', isEqualTo: _classNameController.toUpperCase()) //WHERE CLASS NAME IS EQUAL TO THE INPUT
          .snapshots();
      return stream;
    } else {
      return stream =
          Firestore.instance.collection('class').orderBy('clsName').snapshots(); //ELSE DEFAULT QUERY
    }
  }

   static Stream<QuerySnapshot> codeSearch(String _classCodeController, Stream<QuerySnapshot> stream) {
    if (_classCodeController.length > 0) { //CHECK IF THERE IS INPUT IN CLASS CODE SEARCH
      stream = Firestore.instance
          .collection('class')
          .where('code', isEqualTo: int.parse(_classCodeController)) //WHERE CLASS CODE IS EQUAL TO THE INPUT
          .snapshots();
      return stream;
    } else {
      return stream =
          Firestore.instance.collection('class').orderBy('clsName').snapshots(); //ELSE DEFAULT QUERY
    }
  }

//CLEAR BUTTON CLEARS INPUTS AND SETS QUERY BACK TO DEFAULT TO LIST ALL CLASSES
  static Stream<QuerySnapshot> clear(String _selected, _classNameController, String _classCodeController, Stream<QuerySnapshot> stream, List<String> _dropitems) {
    _selected = _dropitems[0];
    _classNameController = '';
    _classCodeController = '';
    stream =
        Firestore.instance.collection('class').orderBy('clsName').snapshots();
    print('cleared');
    return stream;
  }

//DROPDOWN LIST QUERY --> WHERE CLASS IS EQUAL TO SELECTED DROPWDOWN ITEM
 static Stream<QuerySnapshot> ddlClassSearch(String _selected, Stream<QuerySnapshot> stream) {
    if (_selected == 'Class Name') {
      stream = Firestore.instance.collection('class').snapshots();
    } else {
      stream = Firestore.instance
          .collection('class')
          .where('clsName', isEqualTo: _selected)
          .snapshots();
    }
    return stream;
  }


}