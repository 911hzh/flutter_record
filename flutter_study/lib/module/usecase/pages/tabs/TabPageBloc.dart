import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_study/module/usecase/pages/tabs/base/ScrollItemData.dart';

/// Manages the state and business logic for the TabPage.
///
/// This bloc handles operations such as selecting, adding, removing items,
/// and managing writing topics.
class TabPageBloc extends Cubit<List<ScrollItemData<WritingTopicData>>> {
  /// Creates a TabPageBloc with initial items.
  TabPageBloc()
    : super([
        ScrollItemData(text: "Item 1", isSelected: true, data: WritingTopicData(writingTopic: "")),
        ScrollItemData(text: "Item 2", isSelected: false, data: WritingTopicData(writingTopic: "")),
        ScrollItemData(text: "Item 3", isSelected: false, data: WritingTopicData(writingTopic: "")),
      ]);

  /// Selects an item at the given index.
  ///
  /// Updates the [isSelected] state of all items, ensuring only one is selected.
  void selectItem(int index) {
    final newItems =
        state.map((item) {
          return ScrollItemData(
            text: item.text,
            isSelected: state.indexOf(item) == index,
            data: WritingTopicData(writingTopic: item.data.writingTopic),
          );
        }).toList();
    emit(newItems);
  }

  /// Removes an item at the given index.
  ///
  /// If the removed item was selected, selects the first item.
  /// Does nothing if there's only one item left.
  void removeItem(int index) {
    if (state.length <= 1) return;
    final newItems = List<ScrollItemData<WritingTopicData>>.from(state)..removeAt(index);
    if (newItems.indexWhere((item) => item.isSelected) == -1) {
      newItems[0] = ScrollItemData(
        text: newItems[0].text,
        isSelected: true,
        data: WritingTopicData(writingTopic: newItems[0].data.writingTopic),
      );
    }
    emit(newItems);
  }

  /// Adds a new item to the list.
  ///
  /// The new item is not selected by default.
  void addItem() {
    final newItems = List<ScrollItemData<WritingTopicData>>.from(state)..add(
      ScrollItemData(text: "Reading ${state.length + 1}", isSelected: false, data: WritingTopicData(writingTopic: "")),
    );
    emit(newItems);
  }

  /// Changes the writing topic of the currently selected item.
  ///
  /// If no item is selected, this method does nothing.
  void changeWritingTopic(String value) {
    final selectedIndex = state.indexWhere((item) => item.isSelected);
    if (selectedIndex != -1) {
      final newItems = List<ScrollItemData<WritingTopicData>>.from(state);
      newItems[selectedIndex] = ScrollItemData(
        text: newItems[selectedIndex].text,
        isSelected: true,
        data: WritingTopicData(writingTopic: value),
      );
      emit(newItems);
    }
  }

  /// Deletes the currently selected writing topic.
  ///
  /// If there's only one item left, this method does nothing.
  /// After deletion, selects the previous item or the first item if the deleted item was the first.
  void deleteWritingTopic(int index) {
    if (state.length <= 1) {
      // 不允许删除最后一个项目
      return;
    }

    final newState = List<ScrollItemData<WritingTopicData>>.from(state);
    newState.removeAt(index);

    // 如果删除的是当前选中的项目，选择新的项目
    if (newState.every((item) => !item.isSelected)) {
      final newSelectedIndex = index >= newState.length ? newState.length - 1 : index;
      newState[newSelectedIndex] = newState[newSelectedIndex].copyWith(isSelected: true);
    }

    emit(newState);
  }
}
