import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_study/module/usecase/pages/bloc/CounterBloc.dart';

class BlocExampleWidget extends StatelessWidget {
  const BlocExampleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CounterBloc(),
      child: Card.filled(
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 12,
            children: [
              Text('Bloc', style: Theme.of(context).textTheme.titleLarge),
              const Text('按钮发送增加或减少事件，事件处理器用 emit 发布新状态。'),
              BlocBuilder<CounterBloc, int>(
                builder: (context, count) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 12,
                  children: [
                    Text(
                      '$count',
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                    ValueListenableBuilder<List<String>>(
                      valueListenable: context.read<CounterBloc>().transitions,
                      builder: (context, records, child) => Text(
                        records.isEmpty
                            ? '点击按钮，查看 event：旧状态 → 新状态'
                            : records.join('\n'),
                      ),
                    ),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        FilledButton(
                          onPressed: () => context.read<CounterBloc>().add(
                            CounterEvent.increment,
                          ),
                          child: const Text('add(CounterEvent.increment)'),
                        ),
                        OutlinedButton(
                          onPressed: () => context.read<CounterBloc>().add(
                            CounterEvent.decrement,
                          ),
                          child: const Text('add(CounterEvent.decrement)'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
