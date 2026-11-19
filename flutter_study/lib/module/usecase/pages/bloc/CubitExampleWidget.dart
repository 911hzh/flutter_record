import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_study/module/usecase/pages/bloc/CounterCubit.dart';

class CubitExampleWidget extends StatelessWidget {
  const CubitExampleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CounterCubit(),
      child: Card.filled(
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 12,
            children: [
              Text('Cubit', style: Theme.of(context).textTheme.titleLarge),
              const Text('按钮直接调用 increment() 或 decrement()，方法里用 emit 发布新状态。'),
              BlocBuilder<CounterCubit, int>(
                builder: (context, count) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 12,
                  children: [
                    Text(
                      '$count',
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        FilledButton(
                          onPressed: () =>
                              context.read<CounterCubit>().increment(),
                          child: const Text('increment()'),
                        ),
                        OutlinedButton(
                          onPressed: () =>
                              context.read<CounterCubit>().decrement(),
                          child: const Text('decrement()'),
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
