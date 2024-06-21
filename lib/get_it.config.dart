// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:td/game_controller/game_repository.dart' as _i4;
import 'package:td/ui/inventory/bloc/inventory_bloc.dart' as _i3;
import 'package:td/ui/stage_bar/bloc/stage_bar_cubit.dart' as _i5;

extension GetItInjectableX on _i1.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i1.GetIt init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    gh.factory<_i3.InventoryBloc>(() => _i3.InventoryBloc());
    gh.lazySingleton<_i4.GameRepository>(() => _i4.GameRepository());
    gh.factory<_i5.StageBarCubit>(
        () => _i5.StageBarCubit(gh<_i4.GameRepository>()));
    return this;
  }
}
