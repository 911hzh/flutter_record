import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_study/testPage/TabPage/TabPageBloc.dart';
import 'package:flutter_study/testPage/TabPage/base/ScrollItemData.dart';
import 'package:flutter_study/testPage/TabPage/views/HorizontalScrollView.dart';
import 'package:flutter_study/testPage/TabPage/views/ContentView.dart';

/// A page that displays a list of tabs and their associated content.
class TabPage extends HookWidget {
  /// Creates a new TabPage instance.
  const TabPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = useMemoized(() => TabPageBloc(), []);
    useEffect(() {
      return bloc.close;
    }, [bloc]);

    return BlocProvider(
      create: (context) => bloc,
      child: BlocBuilder<TabPageBloc, List<ScrollItemData<WritingTopicData>>>(
        builder: (context, items) {
          final selectedItem = items.firstWhere((item) => item.isSelected, orElse: () => items.first);
          final selectedIndex = items.indexOf(selectedItem);

          return Scaffold(
            appBar: AppBar(title: const Text('Tab Page')),
            body: Column(
              children: [
                HorizontalScrollView(
                  items: items,
                  onItemSelected: bloc.selectItem,
                  onItemRemoved: items.length > 1 ? (int index) => bloc.deleteWritingTopic(index) : null,
                  onAddItem: bloc.addItem,
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: ContentView(
                    onChanged: bloc.changeWritingTopic,
                    writingTopic: selectedItem.data.writingTopic,
                    title: selectedItem.text,
                    onDelete: () => bloc.deleteWritingTopic(selectedIndex),
                  ),
                ),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: bloc.addItem,
              child: const Icon(Icons.add),
              backgroundColor: Colors.blue,
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          );
        },
      ),
    );
  }
}
