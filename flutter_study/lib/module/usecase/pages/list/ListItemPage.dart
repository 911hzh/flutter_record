import 'package:flutter/material.dart';

/// 模式枚举
enum ListMode {
  normal, // 普通模式 - 状态丢失
  keepAlive, // KeepAlive 模式 - 内存占用高
  dataModel, // ✅ 数据模型模式 - 最佳实践
}

class ListItemPage extends StatefulWidget {
  const ListItemPage({super.key});

  @override
  State<ListItemPage> createState() => _ListItemPageState();
}

class _ListItemPageState extends State<ListItemPage> {
  ListMode _mode = ListMode.normal;

  // ✅ 数据模型列表 - 状态存储在这里，UI 可以自由回收复用
  late final List<ItemModel> _items = List.generate(
    30,
    (index) => ItemModel(id: index, title: 'Item $index'),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("ListView 状态演示")),
      body: Column(
        children: [
          Flexible(
            child: ListView.builder(
              itemCount: 30,
              prototypeItem: Text("Item 0"),
              itemBuilder: (context, index) {
                switch (index) {
                  case 0 when index % 2 == 0:
                    return Container(
                      color: Colors.red,
                      width: 100,
                      height: 100,
                    );
                  case 1 when index % 2 == 1:
                    return Container(
                      color: Colors.blue,
                      width: 100,
                      height: 100,
                    );
                  default:
                    return Text("Item $index");
                }
              },
            ),
          ),
          // 模式选择
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: SegmentedButton<ListMode>(
              segments: [
                ButtonSegment(value: ListMode.normal, label: Text('普通')),
                ButtonSegment(
                  value: ListMode.keepAlive,
                  label: Text('KeepAlive'),
                ),
                ButtonSegment(value: ListMode.dataModel, label: Text('数据模型✅')),
              ],
              selected: {_mode},
              onSelectionChanged: (s) => setState(() => _mode = s.first),
            ),
          ),
          Container(
            padding: EdgeInsets.all(16),
            color: _getModeColor(),
            child: Text(
              _getModeDescription(),
              style: TextStyle(fontSize: 14, color: Colors.brown),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 30,
              itemBuilder: (context, index) {
                switch (_mode) {
                  case ListMode.normal:
                    return CounterItem(key: ValueKey(index), index: index);
                  case ListMode.keepAlive:
                    return KeepAliveCounterItem(
                      key: ValueKey(index),
                      index: index,
                    );
                  case ListMode.dataModel:
                    // ✅ 最佳实践：传入数据模型，UI 无状态
                    return DataModelCounterItem(
                      key: ValueKey(_items[index].id),
                      model: _items[index],
                      onCountChanged: () => setState(() {}),
                    );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Color _getModeColor() {
    switch (_mode) {
      case ListMode.normal:
        return Colors.red.shade100;
      case ListMode.keepAlive:
        return Colors.amber.shade100;
      case ListMode.dataModel:
        return Colors.green.shade100;
    }
  }

  String _getModeDescription() {
    switch (_mode) {
      case ListMode.normal:
        return "❌ 普通模式\n状态存在 State 中，滚动后丢失";
      case ListMode.keepAlive:
        return "⚠️ KeepAlive 模式\n状态保持，但内存占用高（所有访问过的 item 都常驻内存）";
      case ListMode.dataModel:
        return "✅ 数据模型模式（最佳实践）\n状态存在数据对象中，UI 可自由回收复用";
    }
  }
}

// ========================================
// 数据模型 - 状态存储在这里
// ========================================

class ItemModel {
  final int id;
  final String title;
  int count; // ✅ 状态存在数据模型中，不会因 UI 回收而丢失

  ItemModel({required this.id, required this.title, this.count = 0});
}

/// 带有内部状态的列表项
/// 问题：当滚出屏幕被回收后，再次创建时状态会丢失
class CounterItem extends StatefulWidget {
  final int index;
  const CounterItem({super.key, required this.index});

  @override
  State<CounterItem> createState() => _CounterItemState();
}

class _CounterItemState extends State<CounterItem> {
  // ⚠️ 这个状态存储在 State 对象中
  // 当 Widget 被回收时，State 对象也会被销毁
  // 导致 _count 丢失
  int _count = 0;

  @override
  void initState() {
    super.initState();
    print('🔵 Item ${widget.index} initState - 被创建');
  }

  @override
  void dispose() {
    print('🔴 Item ${widget.index} dispose - 被回收，count=$_count 丢失!');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.white,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _count > 0 ? Colors.orange : Colors.grey,
          child: Text('${widget.index}'),
        ),
        title: Text('普通 Item ${widget.index}'),
        subtitle: Text(
          '计数: $_count ${_count > 0 ? "(滚动后会丢失!)" : ""}',
          style: TextStyle(
            color: _count > 0 ? Colors.red : Colors.grey,
            fontWeight: _count > 0 ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.remove, color: Colors.red),
              onPressed: () =>
                  setState(() => _count = (_count - 1).clamp(0, 99)),
            ),
            IconButton(
              icon: Icon(Icons.add, color: Colors.green),
              onPressed: () => setState(() => _count++),
            ),
          ],
        ),
      ),
    );
  }
}

/// ⚠️ 使用 AutomaticKeepAliveClientMixin 保持状态
/// 滚出屏幕后状态不会丢失，但内存占用高
class KeepAliveCounterItem extends StatefulWidget {
  final int index;
  const KeepAliveCounterItem({super.key, required this.index});

  @override
  State<KeepAliveCounterItem> createState() => _KeepAliveCounterItemState();
}

class _KeepAliveCounterItemState extends State<KeepAliveCounterItem>
    with AutomaticKeepAliveClientMixin {
  int _count = 0;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    print('🟡 KeepAlive Item ${widget.index} initState - 被创建');
  }

  @override
  void dispose() {
    print('🔴 KeepAlive Item ${widget.index} dispose - 被销毁');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.amber.shade50,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _count > 0 ? Colors.orange : Colors.grey,
          child: Text('${widget.index}'),
        ),
        title: Text('KeepAlive Item ${widget.index}'),
        subtitle: Text(
          '计数: $_count ${_count > 0 ? "(内存常驻)" : ""}',
          style: TextStyle(
            color: _count > 0 ? Colors.orange : Colors.grey,
            fontWeight: _count > 0 ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.remove, color: Colors.red),
              onPressed: () =>
                  setState(() => _count = (_count - 1).clamp(0, 99)),
            ),
            IconButton(
              icon: Icon(Icons.add, color: Colors.green),
              onPressed: () => setState(() => _count++),
            ),
          ],
        ),
      ),
    );
  }
}

// ========================================
// ✅ 最佳实践：数据模型驱动 UI
// ========================================

/// ✅ 数据模型版本 - 最佳实践
/// 状态存储在 ItemModel 中，UI 可以自由回收复用
class DataModelCounterItem extends StatelessWidget {
  final ItemModel model;
  final VoidCallback onCountChanged;

  const DataModelCounterItem({
    super.key,
    required this.model,
    required this.onCountChanged,
  });

  @override
  Widget build(BuildContext context) {
    print('🟢 DataModel Item ${model.id} build - UI 可复用');

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.green.shade50,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: model.count > 0 ? Colors.green : Colors.grey,
          child: Text('${model.id}'),
        ),
        title: Text('DataModel ${model.title}'),
        subtitle: Text(
          '计数: ${model.count} ${model.count > 0 ? "(状态在数据模型中)" : ""}',
          style: TextStyle(
            color: model.count > 0 ? Colors.green : Colors.grey,
            fontWeight: model.count > 0 ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.remove, color: Colors.red),
              onPressed: () {
                model.count = (model.count - 1).clamp(0, 99);
                onCountChanged();
              },
            ),
            IconButton(
              icon: Icon(Icons.add, color: Colors.green),
              onPressed: () {
                model.count++;
                onCountChanged();
              },
            ),
          ],
        ),
      ),
    );
  }
}
