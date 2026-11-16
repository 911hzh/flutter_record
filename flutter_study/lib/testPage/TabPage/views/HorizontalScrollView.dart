import 'package:flutter/material.dart';
import 'package:flutter_study/testPage/TabPage/base/ScrollItemData.dart';

/// A horizontal scrollable list of items with an add button at the end.
class HorizontalScrollView extends StatelessWidget {
  /// The list of items to display.
  final List<ScrollItemData> items;

  /// Callback function when an item is selected.
  final Function(int) onItemSelected;

  /// Callback function when an item is removed. Can be null if removal is not allowed.
  final Function(int)? onItemRemoved;

  /// Callback function when the add button is tapped.
  final VoidCallback onAddItem;

  /// Creates a new HorizontalScrollView instance.
  HorizontalScrollView({
    required this.items,
    required this.onItemSelected,
    this.onItemRemoved,
    required this.onAddItem,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50, // Adjust height to fit your design
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: items.length + 1, // Add 1 for the add button
        itemBuilder: (context, index) {
          if (index == items.length) {
            // Add button
            return GestureDetector(
              onTap: onAddItem,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 4),
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(20)),
                child: Container(width: 20, height: 20, child: Icon(Icons.add)),
              ),
            );
          }
          // Item in the list
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 4),
            child: GestureDetector(
              onTap: () => onItemSelected(index),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: items[index].isSelected ? Colors.blue : Colors.grey[200],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      items[index].text,
                      style: TextStyle(
                        color: items[index].isSelected ? Colors.white : Colors.black,
                        fontWeight: items[index].isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    SizedBox(width: 30),
                    if (items.length > 1 && onItemRemoved != null)
                      GestureDetector(
                        onTap: () => onItemRemoved!(index),
                        child: Container(
                          padding: EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: items[index].isSelected ? Colors.white.withOpacity(0.3) : Colors.grey[300],
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.close,
                            size: 14,
                            color: items[index].isSelected ? Colors.white : Colors.black54,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
