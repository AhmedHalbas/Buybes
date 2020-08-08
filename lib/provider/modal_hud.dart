import 'package:flutter/cupertino.dart';

class ModalHud extends ChangeNotifier {
  bool isLoading = false;

  changeisLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }
}
