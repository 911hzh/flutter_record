import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// A widget that displays and allows editing of a writing topic.
///
/// This widget is implemented using Flutter Hooks for efficient state management.
class ContentView extends HookWidget {
  /// Callback function triggered when the writing topic changes.
  final Function(String) onChanged;

  /// The current writing topic text.
  final String writingTopic;

  /// The title displayed at the top of the content view.
  final String title;

  /// Callback function triggered when the delete button is tapped.
  final VoidCallback onDelete;

  /// Constructs a ContentView widget.
  ///
  /// All parameters are required and must not be null.
  const ContentView({
    Key? key,
    required this.onChanged,
    required this.writingTopic,
    required this.title,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Create a TextEditingController with the initial text set to writingTopic
    final controller = useTextEditingController(text: writingTopic);

    // Effect to update the controller's text when writingTopic changes
    useEffect(() {
      controller.text = writingTopic;
      return null;
    }, [writingTopic]);

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Container(
        height: 80,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title and delete button row
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Title text
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                  // Delete button
                  GestureDetector(
                    onTap: onDelete,
                    child: Icon(
                      Icons.delete_outline,
                      color: Colors.grey.shade400,
                      size: 16,
                    ),
                  ),
                ],
              ),
            ),
            // "Writing Topic" label
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 2, 12, 2),
              child: Row(
                children: [
                  Text(
                    'Writing Topic',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                      fontSize: 11,
                    ),
                  ),
                  SizedBox(width: 4),
                  Text(
                    '*',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            // Text input field for writing topic
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 2, 12, 8),
                child: TextFormField(
                  controller: controller,
                  onChanged: onChanged,
                  style: TextStyle(fontSize: 13),
                  decoration: InputDecoration(
                    hintText: 'The writing topic has not been filled in',
                    hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
