// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:cloud_firestore/cloud_firestore.dart' as _i974;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../features/product/data/i_product_facade.dart' as _i656;
import '../../features/product/repo/i_product_impl.dart' as _i417;
import '../../features/review/data/i_review_facade.dart' as _i115;
import '../../features/review/repo/review_impl.dart' as _i1045;
import 'injectable_module.dart' as _i109;

// initializes the registration of main-scope dependencies inside of GetIt
Future<_i174.GetIt> init(
  _i174.GetIt getIt, {
  String? environment,
  _i526.EnvironmentFilter? environmentFilter,
}) async {
  final gh = _i526.GetItHelper(
    getIt,
    environment,
    environmentFilter,
  );
  final injectableModule = _$InjectableModule();
  await gh.factoryAsync<_i109.FirebaseServices>(
    () => injectableModule.firebaseServices,
    preResolve: true,
  );
  gh.lazySingleton<_i974.FirebaseFirestore>(
      () => injectableModule.firebaseFirestore);
  gh.lazySingleton<_i115.IReviewFacade>(
      () => _i1045.ReviewImpl(gh<_i974.FirebaseFirestore>()));
  gh.lazySingleton<_i656.IProductFacade>(
      () => _i417.IProductImpl(firestore: gh<_i974.FirebaseFirestore>()));
  return getIt;
}

class _$InjectableModule extends _i109.InjectableModule {}
