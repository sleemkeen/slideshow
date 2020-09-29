import 'package:connectivity/connectivity.dart';
import 'package:sensors/sensors.dart' show AccelerometerEvent;

import '../video.controller.dart';

typedef TPlayingListenner = void Function(VideoController controller);
typedef TPlayEndListenner = void Function(VideoController controller);
typedef TFullScreenChangeListenner = void Function(
    VideoController controller, bool isFullScreen);
typedef TConnectivityChangedListenner = void Function(
    VideoController controller, ConnectivityResult result);

typedef TAccelerometerEventsListenner = void Function(
    VideoController controller, AccelerometerEvent event);

mixin VideoListennerMixin on BaseVideoController {
  TPlayEndListenner playEndListenner;

  TFullScreenChangeListenner fullScreenChangeListenner;

  TConnectivityChangedListenner connectivityChangedListenner;

  TAccelerometerEventsListenner accelerometerEventsListenner;

  addConnectivityChangedListener(TConnectivityChangedListenner listener) {
    connectivityChangedListenner = listener;
  }

  addPlayEndListener(TPlayEndListenner listener) => playEndListenner = listener;
  addFullScreenChangeListener(TFullScreenChangeListenner listener) =>
      fullScreenChangeListenner = listener;

  addListener(TPlayingListenner listener) {
    videoCtrl?.addListener(() => listener(this));
  }

  addAccelerometerEventsListenner(TAccelerometerEventsListenner listener) {
    accelerometerEventsListenner = listener;
  }
}
