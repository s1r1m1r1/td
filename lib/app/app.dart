import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../game/game_main.dart';
import '../game_controller/game_controller.dart';
import '../inventory/inventory_bar.dart';
import '../inventory/inventory_bloc.dart';
import '../inventory/stage_bar_cubit.dart';
import '../inventory/stage_bar_view.dart';
import '../inventory/weapon_type_cubit.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
        create: (context) => GameController(),
        child: MultiBlocProvider(
          providers: [
            BlocProvider(
              lazy: false,
              create: (_) => GetIt.I.get<InventoryCubit>()..init(),
            ),
            BlocProvider(
              lazy: false,
              create: (_) => GetIt.I.get<WeaponTypeCubit>()..init(),
            ),
            BlocProvider(
              create: (_) => GetIt.I.get<StageBarCubit>(),
            ),
          ],
          child: const MaterialApp(home: _AppView()),
        ));
  }
}

class _AppView extends StatefulWidget {
  // ignore: unused_element
  const _AppView({super.key});

  @override
  State<_AppView> createState() => _AppViewState();
}

class _AppViewState extends State<_AppView> {
  bool pause = true;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const StageBarView(),
      Expanded(
        child: GameWidget<GameMain>(
          game: GameMain(
            gameController: RepositoryProvider.of<GameController>(context),
          ),
          overlayBuilderMap: {
            'start': _pauseMenuBuilder,
          },
          initialActiveOverlays: const ['start'],
        ),
      ),
      const InventoryBar(),
    ]);
  }

  Widget _pauseMenuBuilder(BuildContext ctx, GameMain game) {
    return Center(
        child: Container(
      width: 100,
      height: 100,
      color: Colors.orange,
      child: Center(
          child: TextButton(
        style: TextButton.styleFrom(
          foregroundColor: Colors.white,
          padding: const EdgeInsets.all(16.0),
          textStyle: const TextStyle(fontSize: 20),
        ),
        onPressed: () {
          if (pause) {
            game.resumeEngine();
            game.start();
            game.overlays.remove('start');
          }
        },
        child: const Text('Start'),
      )),
    ));
  }
}
