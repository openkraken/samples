import 'package:flutter/widgets.dart';
import 'alarm_clock_module.dart';
import 'package:kraken/module.dart';
import 'package:kraken/launcher.dart';
import 'package:kraken/bridge.dart';

class MyKrakenPlugin {
  static void initialize() {
    WidgetsFlutterBinding.ensureInitialized();
    ModuleManager.defineModule((moduleNamager) => AlarmClockModule(moduleNamager));
    KrakenBundle.getBundle('packages/my_kraken_plugin/assets/my_plugin.js').then((KrakenBundle bundle) {
      patchKrakenPolyfill(bundle.content, 'my_kraken_plugin://');
    });
  }
}
