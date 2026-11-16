/// Represents the data for a writing topic.
class WritingTopicData {
  /// The content of the writing topic.
  final String writingTopic;

  /// Creates a new WritingTopicData instance.
  WritingTopicData({required this.writingTopic});

  /// Creates a new WritingTopicData instance with the specified writing topic.
  WritingTopicData copyWith({String? writingTopic}) {
    return WritingTopicData(
      writingTopic: writingTopic ?? this.writingTopic,
    );
  }
}

/// Represents an item in a scrollable list.
///
/// The generic type T allows for flexibility in the type of data associated with each item.
class ScrollItemData<T> {
  /// The text to display for this item.
  final String text;

  /// Whether this item is currently selected.
  final bool isSelected;

  /// Additional data associated with this item.
  final T data;

  /// Creates a new ScrollItemData instance.
  ScrollItemData({
    required this.text,
    required this.isSelected,
    required this.data,
  });

  /// Creates a new ScrollItemData instance with the specified text, isSelected, and data.
  ScrollItemData<T> copyWith({
    String? text,
    bool? isSelected,
    T? data,
  }) {
    return ScrollItemData<T>(
      text: text ?? this.text,
      isSelected: isSelected ?? this.isSelected,
      data: data ?? this.data,
    );
  }
}
