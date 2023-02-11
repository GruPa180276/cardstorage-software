import 'package:card_master/client/provider/size/size_manager.dart';

extension SizeManagerExtensions on double {
  double get fs => SizeManager.fs(this);
}
