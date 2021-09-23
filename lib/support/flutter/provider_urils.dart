import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum ModelStatus {
  UNINITIALIZED,
  INITIALIZING,
  INITIALIZED,
}

abstract class ModelUtilMixin {
  ModelStatus status = ModelStatus.UNINITIALIZED;

  bool get initialized => ModelStatus.INITIALIZED == status;
}

mixin BatchSelectionNotifier<T> on ChangeNotifier {
  Iterable<T> get itemsSelectionSource;

  final Set<T> selectedItems = {};

  bool get isSelectingItems => selectedItems.isNotEmpty;

  bool get isAllItemsSelected =>
      selectedItems.length == itemsSelectionSource.length;

  bool isItemSelected(T item) {
    return selectedItems.contains(item);
  }

  void toggleSelectedItem(T item) {
    if (item == null) return;
    
    if (selectedItems.contains(item))
      selectedItems.remove(item);
    else
      selectedItems.add(item);

    notifyListeners();
  }

  void clearItemSelection() {
    selectedItems.clear();
    notifyListeners();
  }
}
