import 'alarm_clock_module.dart';
import 'package:kraken/module.dart';
import 'my_plugin_qjsc.dart';

class MyKrakenPlugin {
  static void initialize() {
    registerMyPluginByteData();
    ModuleManager.defineModule(
        (moduleNamager) => AlarmClockModule(moduleNamager));
  }
}
