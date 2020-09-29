import 'dart:async' show StreamSubscription, Timer;
import 'package:connectivity/connectivity.dart';
import 'package:sensors/sensors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobx/mobx.dart';
import 'package:video_player/video_player.dart'
    show DataSourceType, VideoPlayerController;
import 'mixin/animation_icon_mixin.dart';
import 'util.dart';
import 'mixin/custom_view_mixin.dart';
import 'mixin/video_listenner_mixin.dart';
import 'video_box.dart' show CustomFullScreen, KCustomFullScreen;
import 'video_state.dart';
part 'video.controller.g.dart';

extension VideoPlayerControllerExtensions on VideoPlayerController {
  VideoPlayerController copyWith() {
    switch (dataSourceType) {
      case DataSourceType.network:
        return VideoPlayerController.network(
          dataSource,
          formatHint: formatHint,
          closedCaptionFile: closedCaptionFile,
        );
      case DataSourceType.asset:
        return VideoPlayerController.asset(
          dataSource,
          package: package,
          closedCaptionFile: closedCaptionFile,
        );
      default:
        throw 'error';
    }
  }
}

class VideoController = _VideoController with _$VideoController;

void kAccelerometerEventsListenner(
  VideoController controller,
  AccelerometerEvent event,
) {
  if (!controller.isFullScreen) return;
  bool isHorizontal = event.x.abs() > event.y.abs(); // 横屏模式
  if (!isHorizontal) return;
  if (event.x > 1) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
  } else if (event.x < -1) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeRight]);
  }
}

class BaseVideoController {
  VideoPlayerController videoCtrl;
  Duration animetedIconDuration;
}

abstract class _VideoController extends BaseVideoController
    with Store, VideoListennerMixin, CustomViewMixin, AnimationIconMixin {
  @action
  _VideoController({
    VideoPlayerController source,
    this.skiptime = const Duration(seconds: 10),
    this.autoplay = false,
    this.looping = false,
    this.volume = 1.0,
    this.initPosition = const Duration(seconds: 0),
    this.cover,
    this.controllerWidgets = true,
    this.controllerLiveDuration = const Duration(seconds: 2),
    this.controllerLayerDuration = kTabScrollDuration,
    this.animetedIconDuration = kTabScrollDuration,
    this.options,
    EdgeInsets bottomPadding,
    Color background,
    Color color,
    Color bufferColor,
    Color inactiveColor,
    Color circularProgressIndicatorColor,
    Color barrierColor,
    Widget customLoadingWidget,
    Widget customBufferedWidget,
    CustomFullScreen customFullScreen,
    BottomViewBuilder bottomViewBuilder,
  }) {
    videoCtrl = source;
    this.barrierColor = barrierColor ?? Colors.black.withOpacity(0.6);
    this.customLoadingWidget = customLoadingWidget;
    this.customBufferedWidget = customBufferedWidget;
    this.customFullScreen = customFullScreen ?? const KCustomFullScreen();
    this.bottomViewBuilder = bottomViewBuilder;
    this.background = background ?? Colors.black;
    this.color = color ?? Colors.white;
    this.bufferColor = bufferColor ?? Colors.white38;
    this.inactiveColor = inactiveColor ?? Colors.white24;
    this.circularProgressIndicatorColor =
        circularProgressIndicatorColor ?? Colors.white;
    this.bottomPadding = bottomPadding ?? EdgeInsets.zero;
    if (this.accelerometerEventsListenner == null)
      addAccelerometerEventsListenner(kAccelerometerEventsListenner);
    _initStreams();
  }

  @override
  VideoPlayerController videoCtrl;

  bool _isDispose = false;

  _initStreams() {
    _streamSubscriptions$ ??=
        accelerometerEvents.listen(_streamSubscriptionsCallback);
    _connectivityChanged$ ??= Connectivity()
        .onConnectivityChanged
        .listen(_connectivityChangedCallBack);
  }

  StreamSubscription<dynamic> _streamSubscriptions$;
  void _streamSubscriptionsCallback(AccelerometerEvent event) =>
      accelerometerEventsListenner(this, event);

  ConnectivityResult _connectivityStatus;
  StreamSubscription<ConnectivityResult> _connectivityChanged$;
  void _connectivityChangedCallBack(ConnectivityResult result) {

    if (connectivityChangedListenner != null)
      connectivityChangedListenner(this, result);

    bool isReconnection = _connectivityStatus == ConnectivityResult.none &&
        result != ConnectivityResult.none &&
        isBfLoading &&
        videoCtrl.value.buffered.isEmpty;
    if (isReconnection) {
      setSource(videoCtrl.copyWith());
      videoCtrl
          .initialize()
          .then((_) => videoCtrl.seekTo(position ?? Duration.zero))
          .then((_) => videoCtrl
            ..addListener(_videoListenner)
            ..setLooping(looping)
            ..setVolume(volume))
          .then((_) => play());
    }

    _connectivityStatus = result;
  }
  final dynamic options;

  @observable
  double aspectRatio;
  @action
  void setAspectRatio(double v) => aspectRatio = v;

  @override
  final Duration animetedIconDuration;

  final Duration skiptime;
  final Duration controllerLayerDuration;

  @observable
  Color barrierColor;
  @action
  void setBarrierColor(Color v) => barrierColor = v;

  bool get isPlayEnd => position >= duration;
  Timer _controllerLayerTimer;

  @observable
  bool controllerWidgets;
  @action
  void setControllerWidgets(bool v) => controllerWidgets = v;

  @observable
  bool isBfLoading = false;
  @action
  void setIsBfLoading(bool v) => isBfLoading = v;

  Duration get _buffered {
    var value = videoCtrl.value;
    if (value.buffered?.isEmpty ?? true) return null;

    return value.buffered.last.end;
  }

  @action
  void _setVideoBuffer() {
    if (_buffered == null) {
      isBfLoading = false;
      return;
    }

    _setSliderBufferValue();

    if (videoCtrl.value.isPlaying) {
      isBfLoading = _buffered <= videoCtrl.value.position;
    }
  }

  /// cover
  @observable
  Widget cover;
  @action
  void setCover(Widget v) => cover = v;

  @computed
  bool get isShowCover {
    if (cover == null) return false;
    return position == initPosition || position == Duration.zero;
  }

  /// autoplay [false]
  bool autoplay;

  bool looping = false;
  void setLooping(bool loop) {
    this.looping = loop;
    videoCtrl?.setLooping(loop);
  }

  @observable
  double volume = 1.0;
  @action
  void setVolume(double v) {
    volume = v;
    videoCtrl?.setVolume(v);
  }

  bool get _hasCtrlValue => videoCtrl.value != null;

  @observable
  bool initialized = false;

  /// Initialize the play position
  Duration initPosition;

  /// Current position
  @observable
  Duration position;

  /// Total video duration
  @observable
  Duration duration;

  /// Whether to show the controller layer
  @observable
  bool controllerLayer = true;
  @action
  void setControllerLayer(bool v) {
    controllerLayer = v;
    if (!v) return;

    if (_controllerLayerTimer?.isActive ?? false) {
      return _controllerLayerTimer?.cancel();
    }

    _controllerLayerTimer = Timer(this.controllerLiveDuration, () {
      // Pause status does not close automatically
      if (videoCtrl.value.isPlaying) setControllerLayer(false);
    });
  }

  void toggleShowVideoCtrl() => setControllerLayer(!controllerLayer);

  /// Total duration
  @computed
  String get durationText => duration == null ? '' : durationString(duration);

  /// current time
  @computed
  String get positionText =>
      (videoCtrl == null) ? '' : durationString(position);

  @computed
  double get sliderValue =>
      (position?.inSeconds != null && duration?.inSeconds != null)
          ? position.inSeconds / duration.inSeconds
          : 0.0;

  @observable
  double sliderBufferValue = 0.0;

  @action
  void _setSliderBufferValue() {
    if (_buffered == null) return;
    sliderBufferValue = _buffered.inSeconds / duration.inSeconds;
  }

  /// Replace the currently playing video resource
  @action
  void setSource(VideoPlayerController source) {
    var oldCtrl = videoCtrl;
    Future.delayed(Duration(seconds: 1)).then((_) => oldCtrl?.dispose());
    videoCtrl = source;
  }

  /// Time to live after the controller layer is opened
  final Duration controllerLiveDuration;

  /// Initialize the viedo controller
  @action
  Future<void> initialize() async {
    assert(videoCtrl != null);
    if (_isDispose) return;
    initialized = false;
    isBfLoading = false;
    await videoCtrl.initialize();
    aspectRatio = videoCtrl.value.aspectRatio;
    videoCtrl
      ..setLooping(looping)
      ..setVolume(volume);
    if (autoplay) {
      setControllerLayer(false);
      await videoCtrl.play();
    }

    if (initPosition != null) seekTo(initPosition);
    position = initPosition ?? videoCtrl.value.position;
    duration = videoCtrl.value.duration;
    videoCtrl.addListener(_videoListenner);
    updateAnimetedIconState();
    initialized = true;
  }

  bool get _isNetDisconnect =>
      videoCtrl.value.position == Duration.zero &&
      _buffered == null &&
      _connectivityStatus == ConnectivityResult.none;

  @action
  void _videoListenner() {
    if (_isNetDisconnect) {
      isBfLoading = true;
      return;
    }
    if (videoCtrl.value.position != Duration.zero)
      position = videoCtrl.value.position;
    _setVideoBuffer();

    _videoPlayEndListenner();
  }

  void _videoPlayEndListenner() {
    if (isPlayEnd) {
      isBfLoading = false;
      if (playEndListenner != null) playEndListenner(this);
      setControllerLayer(true);
      updateAnimetedIconState();
    }
  }

  addListener(TPlayingListenner listener) {
    videoCtrl.addListener(() => listener(this));
  }

  /// Turn sound on or off
  void setOnSoundOrOff() {
    if (!_hasCtrlValue) return;
    double v = videoCtrl.value.volume > 0 ? 0.0 : 1.0;
    setVolume(v);
  }

  /// Play or pause
  Future<void> togglePlay() async {
    var __play = controllerWidgets ? play : videoCtrl.play;
    var __pause = controllerWidgets ? pause : videoCtrl.pause;

    // Wait for Icon animation to close
    if (videoCtrl.value.isPlaying) {
      await __pause();
    } else {
      await __play();
    }
  }

  Future<void> play() async {
    if (isPlayEnd) {
      await seekTo(Duration(seconds: 0));
    }

    await videoCtrl.play();
    updateAnimetedIconState();
    setControllerLayer(false);
  }

  Future<void> pause() async {
    await videoCtrl.pause();
    updateAnimetedIconState();
    setControllerLayer(true);
  }

  /// Controlling playback time position
  Future<void> seekTo(Duration d) => videoCtrl.seekTo(d);

  void fastForward([Duration st]) {
    if (!_hasCtrlValue) return;
    arrowIconLtRController?.forward();
    seekTo(videoCtrl.value.position + (st ?? skiptime));
  }

  void rewind([Duration st]) {
    if (!_hasCtrlValue) return;
    arrowIconRtLController?.forward();
    seekTo(videoCtrl.value.position - (st ?? skiptime));
  }

  /// Whether to play in full screen
  @observable
  bool isFullScreen = false;

  @action
  void _setFullScreen(bool v) {
    isFullScreen = v;
    if (fullScreenChangeListenner != null)
      fullScreenChangeListenner(this, isFullScreen);
  }

  /// Turn full screen on or off
  Future<void> onFullScreenSwitch(BuildContext context) async {
    if (isFullScreen) {
      customFullScreen.close(context, this);
    } else {
      _setFullScreen(true);
      await customFullScreen.open(context, this);
      _setFullScreen(false);
    }
  }

  void _animatedDispose() {
    animetedIconController?.dispose();
    arrowIconRtLController?.dispose();
    arrowIconLtRController?.dispose();
  }

  void _streamDispose() {
    _streamSubscriptions$?.cancel();
    _connectivityChanged$?.cancel();
  }

  void dispose() {
    _isDispose = true;
    _controllerLayerTimer?.cancel();
    _animatedDispose();
    _streamDispose();
    videoCtrl?.dispose();
  }

  VideoState get value => VideoState(
        autoplay: autoplay,
        skiptime: skiptime,
        positionText: positionText,
        durationText: durationText,
        sliderValue: sliderValue,
        initPosition: initPosition,
        dataSource: videoCtrl.dataSource,
        dataSourceType: videoCtrl.dataSourceType,
        size: videoCtrl.value.size,
        isLooping: videoCtrl.value.isLooping,
        isPlaying: videoCtrl.value.isPlaying,
        volume: videoCtrl.value.volume,
        position: videoCtrl.value.position,
        duration: videoCtrl.value.duration,
        aspectRatio: videoCtrl.value.aspectRatio,
      );

  @override
  String toString() => value.toString();
}
