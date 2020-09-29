// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video.controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$VideoController on _VideoController, Store {
  Computed<bool> _$isShowCoverComputed;

  @override
  bool get isShowCover =>
      (_$isShowCoverComputed ??= Computed<bool>(() => super.isShowCover)).value;
  Computed<String> _$durationTextComputed;

  @override
  String get durationText =>
      (_$durationTextComputed ??= Computed<String>(() => super.durationText))
          .value;
  Computed<String> _$positionTextComputed;

  @override
  String get positionText =>
      (_$positionTextComputed ??= Computed<String>(() => super.positionText))
          .value;
  Computed<double> _$sliderValueComputed;

  @override
  double get sliderValue =>
      (_$sliderValueComputed ??= Computed<double>(() => super.sliderValue))
          .value;

  final _$aspectRatioAtom = Atom(name: '_VideoController.aspectRatio');

  @override
  double get aspectRatio {
    _$aspectRatioAtom.context.enforceReadPolicy(_$aspectRatioAtom);
    _$aspectRatioAtom.reportObserved();
    return super.aspectRatio;
  }

  @override
  set aspectRatio(double value) {
    _$aspectRatioAtom.context.conditionallyRunInAction(() {
      super.aspectRatio = value;
      _$aspectRatioAtom.reportChanged();
    }, _$aspectRatioAtom, name: '${_$aspectRatioAtom.name}_set');
  }

  final _$barrierColorAtom = Atom(name: '_VideoController.barrierColor');

  @override
  Color get barrierColor {
    _$barrierColorAtom.context.enforceReadPolicy(_$barrierColorAtom);
    _$barrierColorAtom.reportObserved();
    return super.barrierColor;
  }

  @override
  set barrierColor(Color value) {
    _$barrierColorAtom.context.conditionallyRunInAction(() {
      super.barrierColor = value;
      _$barrierColorAtom.reportChanged();
    }, _$barrierColorAtom, name: '${_$barrierColorAtom.name}_set');
  }

  final _$controllerWidgetsAtom = Atom(name: '_VideoController.controllerWidgets');

  @override
  bool get controllerWidgets {
    _$controllerWidgetsAtom.context.enforceReadPolicy(_$controllerWidgetsAtom);
    _$controllerWidgetsAtom.reportObserved();
    return super.controllerWidgets;
  }

  @override
  set controllerWidgets(bool value) {
    _$controllerWidgetsAtom.context.conditionallyRunInAction(() {
      super.controllerWidgets = value;
      _$controllerWidgetsAtom.reportChanged();
    }, _$controllerWidgetsAtom, name: '${_$controllerWidgetsAtom.name}_set');
  }

  final _$isBfLoadingAtom = Atom(name: '_VideoController.isBfLoading');

  @override
  bool get isBfLoading {
    _$isBfLoadingAtom.context.enforceReadPolicy(_$isBfLoadingAtom);
    _$isBfLoadingAtom.reportObserved();
    return super.isBfLoading;
  }

  @override
  set isBfLoading(bool value) {
    _$isBfLoadingAtom.context.conditionallyRunInAction(() {
      super.isBfLoading = value;
      _$isBfLoadingAtom.reportChanged();
    }, _$isBfLoadingAtom, name: '${_$isBfLoadingAtom.name}_set');
  }

  final _$coverAtom = Atom(name: '_VideoController.cover');

  @override
  Widget get cover {
    _$coverAtom.context.enforceReadPolicy(_$coverAtom);
    _$coverAtom.reportObserved();
    return super.cover;
  }

  @override
  set cover(Widget value) {
    _$coverAtom.context.conditionallyRunInAction(() {
      super.cover = value;
      _$coverAtom.reportChanged();
    }, _$coverAtom, name: '${_$coverAtom.name}_set');
  }

  final _$volumeAtom = Atom(name: '_VideoController.volume');

  @override
  double get volume {
    _$volumeAtom.context.enforceReadPolicy(_$volumeAtom);
    _$volumeAtom.reportObserved();
    return super.volume;
  }

  @override
  set volume(double value) {
    _$volumeAtom.context.conditionallyRunInAction(() {
      super.volume = value;
      _$volumeAtom.reportChanged();
    }, _$volumeAtom, name: '${_$volumeAtom.name}_set');
  }

  final _$initializedAtom = Atom(name: '_VideoController.initialized');

  @override
  bool get initialized {
    _$initializedAtom.context.enforceReadPolicy(_$initializedAtom);
    _$initializedAtom.reportObserved();
    return super.initialized;
  }

  @override
  set initialized(bool value) {
    _$initializedAtom.context.conditionallyRunInAction(() {
      super.initialized = value;
      _$initializedAtom.reportChanged();
    }, _$initializedAtom, name: '${_$initializedAtom.name}_set');
  }

  final _$positionAtom = Atom(name: '_VideoController.position');

  @override
  Duration get position {
    _$positionAtom.context.enforceReadPolicy(_$positionAtom);
    _$positionAtom.reportObserved();
    return super.position;
  }

  @override
  set position(Duration value) {
    _$positionAtom.context.conditionallyRunInAction(() {
      super.position = value;
      _$positionAtom.reportChanged();
    }, _$positionAtom, name: '${_$positionAtom.name}_set');
  }

  final _$durationAtom = Atom(name: '_VideoController.duration');

  @override
  Duration get duration {
    _$durationAtom.context.enforceReadPolicy(_$durationAtom);
    _$durationAtom.reportObserved();
    return super.duration;
  }

  @override
  set duration(Duration value) {
    _$durationAtom.context.conditionallyRunInAction(() {
      super.duration = value;
      _$durationAtom.reportChanged();
    }, _$durationAtom, name: '${_$durationAtom.name}_set');
  }

  final _$controllerLayerAtom = Atom(name: '_VideoController.controllerLayer');

  @override
  bool get controllerLayer {
    _$controllerLayerAtom.context.enforceReadPolicy(_$controllerLayerAtom);
    _$controllerLayerAtom.reportObserved();
    return super.controllerLayer;
  }

  @override
  set controllerLayer(bool value) {
    _$controllerLayerAtom.context.conditionallyRunInAction(() {
      super.controllerLayer = value;
      _$controllerLayerAtom.reportChanged();
    }, _$controllerLayerAtom, name: '${_$controllerLayerAtom.name}_set');
  }

  final _$sliderBufferValueAtom =
      Atom(name: '_VideoController.sliderBufferValue');

  @override
  double get sliderBufferValue {
    _$sliderBufferValueAtom.context.enforceReadPolicy(_$sliderBufferValueAtom);
    _$sliderBufferValueAtom.reportObserved();
    return super.sliderBufferValue;
  }

  @override
  set sliderBufferValue(double value) {
    _$sliderBufferValueAtom.context.conditionallyRunInAction(() {
      super.sliderBufferValue = value;
      _$sliderBufferValueAtom.reportChanged();
    }, _$sliderBufferValueAtom, name: '${_$sliderBufferValueAtom.name}_set');
  }

  final _$isFullScreenAtom = Atom(name: '_VideoController.isFullScreen');

  @override
  bool get isFullScreen {
    _$isFullScreenAtom.context.enforceReadPolicy(_$isFullScreenAtom);
    _$isFullScreenAtom.reportObserved();
    return super.isFullScreen;
  }

  @override
  set isFullScreen(bool value) {
    _$isFullScreenAtom.context.conditionallyRunInAction(() {
      super.isFullScreen = value;
      _$isFullScreenAtom.reportChanged();
    }, _$isFullScreenAtom, name: '${_$isFullScreenAtom.name}_set');
  }

  final _$initializeAsyncAction = AsyncAction('initialize');

  @override
  Future<void> initialize() {
    return _$initializeAsyncAction.run(() => super.initialize());
  }

  final _$_VideoControllerActionController =
      ActionController(name: '_VideoController');

  @override
  void setAspectRatio(double v) {
    final _$actionInfo = _$_VideoControllerActionController.startAction();
    try {
      return super.setAspectRatio(v);
    } finally {
      _$_VideoControllerActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setBarrierColor(Color v) {
    final _$actionInfo = _$_VideoControllerActionController.startAction();
    try {
      return super.setBarrierColor(v);
    } finally {
      _$_VideoControllerActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setControllerWidgets(bool v) {
    final _$actionInfo = _$_VideoControllerActionController.startAction();
    try {
      return super.setControllerWidgets(v);
    } finally {
      _$_VideoControllerActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setIsBfLoading(bool v) {
    final _$actionInfo = _$_VideoControllerActionController.startAction();
    try {
      return super.setIsBfLoading(v);
    } finally {
      _$_VideoControllerActionController.endAction(_$actionInfo);
    }
  }

  @override
  void _setVideoBuffer() {
    final _$actionInfo = _$_VideoControllerActionController.startAction();
    try {
      return super._setVideoBuffer();
    } finally {
      _$_VideoControllerActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setCover(Widget v) {
    final _$actionInfo = _$_VideoControllerActionController.startAction();
    try {
      return super.setCover(v);
    } finally {
      _$_VideoControllerActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setVolume(double v) {
    final _$actionInfo = _$_VideoControllerActionController.startAction();
    try {
      return super.setVolume(v);
    } finally {
      _$_VideoControllerActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setControllerLayer(bool v) {
    final _$actionInfo = _$_VideoControllerActionController.startAction();
    try {
      return super.setControllerLayer(v);
    } finally {
      _$_VideoControllerActionController.endAction(_$actionInfo);
    }
  }

  @override
  void _setSliderBufferValue() {
    final _$actionInfo = _$_VideoControllerActionController.startAction();
    try {
      return super._setSliderBufferValue();
    } finally {
      _$_VideoControllerActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSource(VideoPlayerController source) {
    final _$actionInfo = _$_VideoControllerActionController.startAction();
    try {
      return super.setSource(source);
    } finally {
      _$_VideoControllerActionController.endAction(_$actionInfo);
    }
  }

  @override
  void _videoListenner() {
    final _$actionInfo = _$_VideoControllerActionController.startAction();
    try {
      return super._videoListenner();
    } finally {
      _$_VideoControllerActionController.endAction(_$actionInfo);
    }
  }

  @override
  void _setFullScreen(bool v) {
    final _$actionInfo = _$_VideoControllerActionController.startAction();
    try {
      return super._setFullScreen(v);
    } finally {
      _$_VideoControllerActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    final string =
        'aspectRatio: ${aspectRatio.toString()},barrierColor: ${barrierColor.toString()},controllerWidgets: ${controllerWidgets.toString()},isBfLoading: ${isBfLoading.toString()},cover: ${cover.toString()},volume: ${volume.toString()},initialized: ${initialized.toString()},position: ${position.toString()},duration: ${duration.toString()},controllerLayer: ${controllerLayer.toString()},sliderBufferValue: ${sliderBufferValue.toString()},isFullScreen: ${isFullScreen.toString()},isShowCover: ${isShowCover.toString()},durationText: ${durationText.toString()},positionText: ${positionText.toString()},sliderValue: ${sliderValue.toString()}';
    return '{$string}';
  }
}
