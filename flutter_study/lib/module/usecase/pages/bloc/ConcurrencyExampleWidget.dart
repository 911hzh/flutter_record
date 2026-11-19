import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_study/module/usecase/pages/bloc/TaskBloc.dart';

class ConcurrencyExampleWidget extends StatefulWidget {
  const ConcurrencyExampleWidget({
    super.key,
    required this.title,
    required this.description,
    required this.transformer,
  });

  final String title;
  final String description;
  final EventTransformer<int> transformer;

  @override
  State<ConcurrencyExampleWidget> createState() =>
      _ConcurrencyExampleWidgetState();
}

class _ConcurrencyExampleWidgetState extends State<ConcurrencyExampleWidget> {
  late final TaskBloc _bloc;
  bool _submitted = false;

  @override
  void initState() {
    super.initState();
    _bloc = TaskBloc(transformer: widget.transformer);
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card.filled(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 12,
          children: [
            Text(widget.title, style: Theme.of(context).textTheme.titleLarge),
            Text(widget.description),
            const Text('模拟上传三张照片。照片 1、3 需 1.2 秒，照片 2 需 0.3 秒。'),
            FilledButton.icon(
              onPressed: _submitted
                  ? null
                  : () {
                      setState(() => _submitted = true);
                      _bloc.add(1);
                      _bloc.add(2);
                      _bloc.add(3);
                    },
              icon: const Icon(Icons.cloud_upload_outlined),
              label: const Text('上传三张照片'),
            ),
            BlocBuilder<TaskBloc, List<String>>(
              bloc: _bloc,
              builder: (context, records) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 8,
                children: [
                  for (var id = 1; id <= 3; id++)
                    Row(
                      children: [
                        const Icon(Icons.image_outlined, size: 20),
                        const SizedBox(width: 8),
                        Text('照片 $id'),
                        const Spacer(),
                        Text(
                          records.contains('照片 $id 上传完成')
                              ? '上传完成'
                              : records.contains('照片 $id 开始上传')
                              ? '已开始'
                              : _submitted
                              ? '未开始'
                              : '待提交',
                        ),
                      ],
                    ),
                  const Divider(),
                  Text(
                    records.isEmpty ? '提交后观察每张照片开始和完成的顺序。' : records.join('\n'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
