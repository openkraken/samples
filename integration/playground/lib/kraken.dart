import 'dart:io';
import 'dart:ui';
import 'dart:collection';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kraken/kraken.dart';
import 'package:kraken/widget.dart';

class KrakenPage extends StatelessWidget {
  KrakenPage(this.source, { bool showFPS = true, Key key }) : _showFPS = showFPS, super(key: key);

  final String source;
  final bool _showFPS;
  DateTime _startTime;

  @override
  Widget build(BuildContext context) {
    _startTime = DateTime.now();
    final MediaQueryData queryData = MediaQuery.of(context);
    final Size viewportSize = queryData.size;
    var kraken = Kraken(
      bundleURL: source,
      viewportWidth: viewportSize.width,
      viewportHeight: viewportSize.height,
      onLoad: _handleLoad,
    );
    if (_showFPS) {
      return Stack(
        children: [
          SafeArea(child: kraken),
          FPSInformation(),
        ],
      );
    } else {
      return kraken;
    }
  }

  void _handleLoad(KrakenController controller) async {
    DateTime current = DateTime.now();
    int cost = current.millisecondsSinceEpoch - _startTime.millisecondsSinceEpoch;
    print('LoadCost: ${cost}ms');
    _record(source, cost);
    if (kDebugMode || kProfileMode) {
      await Fluttertoast.showToast(
        msg: 'DevTool debugging address has been copied to your clipboard, paste on your Chrome to attach.',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        fontSize: 14.0,
        backgroundColor: Color.fromARGB(150, 0, 0, 0),
      );
    }
  }

  void _record(String bundleURL, int cost) async {
    var httpClient = HttpClient();
    var uri = Uri.https('gm.mmstat.com', '/gokraken.app.bundle_url', {
      'bundle_url': bundleURL,
      'cost': cost.toString(),
    });
    var request = await httpClient.getUrl(uri);
    await request.close();
  }
}

class FPSInformation extends StatefulWidget {
  @override
  _FPSState createState() => _FPSState();
}

class _FPSState extends State<FPSInformation> {
  static double _fps = 60;

  @override
  void initState() {
    super.initState();
    Fps.instance.start();
    Fps.instance.addFpsCallback(_fpsTick);
  }

  @override
  void dispose() {
    super.dispose();
    Fps.instance.removeFpsCallback(_fpsTick);
    Fps.instance.stop();
  }

  void _fpsTick(FpsInfo fpsInfo) {
    if (_fps != fpsInfo.fps) {
      _fps = fpsInfo.fps;
      RenderObject r = context.findRenderObject();
      r.markNeedsPaint();
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: FPSIndicator());
  }
}

class FPSIndicator extends CustomPainter {
  TextPainter _getTextPainter() {
    if (_FPSState._fps == null) return null;
    final String rate = _FPSState._fps.toStringAsFixed(1);
    final String text = '${rate}f/s';
    final TextStyle textStyle = TextStyle(
      color: _FPSState._fps > 50 ? Colors.greenAccent : Colors.redAccent,
      backgroundColor: Colors.white,
      fontSize: 14.0,
    );
    final TextSpan span = TextSpan(text: text, style: textStyle);
    final TextAlign _textAlign = TextAlign.start;
    final TextDirection _textDirection = TextDirection.ltr;
    return TextPainter(
      text: span,
      textAlign: _textAlign,
      textDirection: _textDirection,
    );
  }

  @override
  void paint(Canvas canvas, Size size) {
    final TextPainter textPainter = _getTextPainter();
    if (textPainter != null) {
      textPainter.layout();
      final double safeAreaLeft = window.viewPadding.left / window.devicePixelRatio + 14.0;
      final double safeAreaBottom = window.viewPadding.bottom / window.devicePixelRatio;
      final double top = window.physicalSize.height / window.devicePixelRatio
          - safeAreaBottom - textPainter.height;
      // The bottom left corner of the viewport.
      textPainter.paint(canvas, Offset(safeAreaLeft, top));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// Fps callback.
typedef FpsCallback = void Function(FpsInfo fpsInfo);

class Fps {
  Fps._();

  static Fps _instance;

  static Fps get instance {
    if (_instance == null) {
      _instance = Fps._();
    }
    return _instance;
  }

  /// 1000/60hz ≈ 16.6ms  1000/120hz ≈ 8.3ms
  Duration _thresholdPerFrame =
  Duration(microseconds: Duration.microsecondsPerSecond ~/ 60);

  double _refreshRate = 60;
  set refreshRate(double rate) {
    if (rate != _refreshRate && rate >= 60) {
      _refreshRate = rate;
      _thresholdPerFrame = Duration(
          microseconds: Duration.microsecondsPerSecond ~/ _refreshRate);
    }
  }

  bool _started = false;
  List<FpsCallback> _fpsCallbacks = [];

  static const int _queue_capacity = 120;
  final ListQueue framesQueue = ListQueue<FrameTiming>(_queue_capacity);

  void addFpsCallback(FpsCallback callback) {
    _fpsCallbacks.add(callback);
  }

  void removeFpsCallback(FpsCallback callback) {
    assert(_fpsCallbacks.contains(callback));
    _fpsCallbacks.remove(callback);
  }

  void start() async {
    if (!_started) {
      SchedulerBinding.instance.addTimingsCallback(_onTimingsCallback);
      _started = true;
    }
  }

  void stop() {
    if (_started) {
      SchedulerBinding.instance.removeTimingsCallback(_onTimingsCallback);
      _started = false;
    }
  }

  _onTimingsCallback(List<FrameTiming> timings) async {
    if (_fpsCallbacks.isNotEmpty) {
      for (FrameTiming timing in timings) {
        framesQueue.addFirst(timing);
      }
      while (framesQueue.length > _queue_capacity) {
        framesQueue.removeLast();
      }

      List<FrameTiming> drawFrames = [];
      for (FrameTiming timing in framesQueue) {
        if (drawFrames.isEmpty) {
          drawFrames.add(timing);
        } else {
          int lastStart =
          drawFrames.last.timestampInMicroseconds(FramePhase.vsyncStart);
          int interval = lastStart -
              timing.timestampInMicroseconds(FramePhase.rasterFinish);
          if (interval > (_thresholdPerFrame.inMicroseconds * 2)) {
            // maybe in different set
            break;
          }
          drawFrames.add(timing);
        }
      }
      framesQueue.clear();

      // compute total frames count.
      int totalCount = drawFrames.map((frame) {
        // If droppedCount > 0,
        int droppedCount =
            frame.totalSpan.inMicroseconds ~/ _thresholdPerFrame.inMicroseconds;
        return droppedCount + 1;
      }).fold(0, (a, b) => a + b);

      int drawFramesCount = drawFrames.length;
      int droppedCount = totalCount - drawFramesCount;
      double fps = drawFramesCount / totalCount * _refreshRate;
      FpsInfo fpsInfo = FpsInfo(fps, totalCount, droppedCount, drawFramesCount);
      _fpsCallbacks?.forEach((callBack) {
        callBack(fpsInfo);
      });
    }
  }
}

class FpsInfo {
  double fps;
  int totalFramesCount;
  int droppedFramesCount;
  int drawFramesCount;

  FpsInfo(this.fps, this.totalFramesCount, this.droppedFramesCount,
      this.drawFramesCount);

  @override
  String toString() {
    return 'FpsInfo{'
        'fps: $fps, '
        'totalFramesCount: $totalFramesCount, '
        'droppedFramesCount: $droppedFramesCount, '
        'drawFramesCount: $drawFramesCount}';
  }
}
