import 'dart:async';
import 'dart:math' as math;

import 'package:awake/theme/app_colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

const Duration _kDialAnimateDuration = Duration(milliseconds: 200);
const double _kTwoPi = 2 * math.pi;
const Duration _kVibrateCommitDelay = Duration(milliseconds: 100);

const double _kTimePickerHeaderLandscapeWidth = 216;
const double _kTimePickerInnerDialOffset = 28;
const double _kTimePickerDialMinRadius = 50;
const double _kTimePickerDialPadding = 28;

class TimePickerWidget extends StatefulWidget {
  const TimePickerWidget({
    super.key,
    required this.initialTime,
    required this.onTimeChanged,
    this.cancelText,
    this.confirmText,
    this.helpText,
    this.errorInvalidText,
    this.hourLabelText,
    this.minuteLabelText,
    this.restorationId,
    this.initialEntryMode = TimePickerEntryMode.dial,
    this.orientation,
    this.onEntryModeChanged,
  });

  final TimeOfDay initialTime;

  final String? cancelText;

  final String? confirmText;

  final String? helpText;

  final String? errorInvalidText;

  final String? hourLabelText;

  final String? minuteLabelText;

  final String? restorationId;

  final TimePickerEntryMode initialEntryMode;

  final Orientation? orientation;

  final EntryModeChangeCallback? onEntryModeChanged;

  final Function(TimeOfDay time) onTimeChanged;

  @override
  State<TimePickerWidget> createState() => _TimePickerWidgetState();
}

class _TimePickerWidgetState extends State<TimePickerWidget>
    with RestorationMixin, WidgetsBindingObserver {
  late final RestorableEnum<TimePickerEntryMode> _entryMode =
      RestorableEnum<TimePickerEntryMode>(
        widget.initialEntryMode,
        values: TimePickerEntryMode.values,
      );
  late final RestorableTimeOfDay _selectedTime = RestorableTimeOfDay(
    widget.initialTime,
  );
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final RestorableEnum<AutovalidateMode> _autovalidateMode =
      RestorableEnum<AutovalidateMode>(
        AutovalidateMode.disabled,
        values: AutovalidateMode.values,
      );
  late final RestorableEnumN<Orientation> _orientation =
      RestorableEnumN<Orientation>(
        widget.orientation,
        values: Orientation.values,
      );

  bool _keyboardVisible = false;

  static const Size _kTimePickerPortraitSize = Size(310, 468);
  static const Size _kTimePickerLandscapeSize = Size(524, 342);
  static const Size _kTimePickerInputSize = Size(312, 216);

  static const Size _kTimePickerMinPortraitSize = Size(238, 326);
  static const Size _kTimePickerMinLandscapeSize = Size(416, 248);
  static const Size _kTimePickerMinInputSize = Size(312, 196);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _keyboardVisible =
        WidgetsBinding
            .instance
            .platformDispatcher
            .views
            .first
            .viewInsets
            .bottom >
        0;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _selectedTime.dispose();
    _entryMode.dispose();
    _autovalidateMode.dispose();
    _orientation.dispose();
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    final bool nowVisible =
        WidgetsBinding
            .instance
            .platformDispatcher
            .views
            .first
            .viewInsets
            .bottom >
        0;

    if (nowVisible == _keyboardVisible) return;
    _keyboardVisible = nowVisible;

    if (_keyboardVisible && _entryMode.value == TimePickerEntryMode.dial) {
      _setEntryMode(TimePickerEntryMode.input);
    } else if (!_keyboardVisible &&
        _entryMode.value == TimePickerEntryMode.input) {
      _setEntryMode(TimePickerEntryMode.dial);
    }
  }

  @override
  String? get restorationId => widget.restorationId;

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_selectedTime, 'selected_time');
    registerForRestoration(_entryMode, 'entry_mode');
    registerForRestoration(_autovalidateMode, 'autovalidate_mode');
    registerForRestoration(_orientation, 'orientation');
  }

  void _handleTimeChanged(TimeOfDay value) {
    if (value != _selectedTime.value) {
      setState(() {
        _selectedTime.value = value;
      });
      widget.onTimeChanged.call(value);
    }
  }

  void _handleEntryModeChanged(TimePickerEntryMode value) {
    if (value != _entryMode.value) {
      setState(() {
        switch (_entryMode.value) {
          case TimePickerEntryMode.dial:
            _autovalidateMode.value = AutovalidateMode.disabled;
          case TimePickerEntryMode.input:
            _formKey.currentState!.save();
          case TimePickerEntryMode.dialOnly:
            break;
          case TimePickerEntryMode.inputOnly:
            break;
        }
        _entryMode.value = value;
        widget.onEntryModeChanged?.call(value);
      });
    }
  }

  void _setEntryMode(TimePickerEntryMode entryMode) {
    switch (entryMode) {
      case TimePickerEntryMode.dial:
        _handleEntryModeChanged(TimePickerEntryMode.dial);
      case TimePickerEntryMode.input:
        _handleEntryModeChanged(TimePickerEntryMode.input);
      default:
        break;
    }
  }

  Size _minDialogSize(BuildContext context) {
    final Orientation orientation =
        _orientation.value ?? MediaQuery.orientationOf(context);

    switch (_entryMode.value) {
      case TimePickerEntryMode.dial:
      case TimePickerEntryMode.dialOnly:
        return switch (orientation) {
          Orientation.portrait => _kTimePickerMinPortraitSize,
          Orientation.landscape => _kTimePickerMinLandscapeSize,
        };
      case TimePickerEntryMode.input:
      case TimePickerEntryMode.inputOnly:
        final MaterialLocalizations localizations = MaterialLocalizations.of(
          context,
        );
        final TimeOfDayFormat timeOfDayFormat = localizations.timeOfDayFormat(
          alwaysUse24HourFormat: MediaQuery.alwaysUse24HourFormatOf(context),
        );
        final double timePickerWidth;
        switch (timeOfDayFormat) {
          case TimeOfDayFormat.HH_colon_mm:
          case TimeOfDayFormat.HH_dot_mm:
          case TimeOfDayFormat.frenchCanadian:
          case TimeOfDayFormat.H_colon_mm:
            final _TimePickerDefaults defaultTheme = _TimePickerDefaultsM3(
              context,
            );
            timePickerWidth =
                _kTimePickerMinInputSize.width -
                defaultTheme.dayPeriodPortraitSize.width -
                12;
          case TimeOfDayFormat.a_space_h_colon_mm:
          case TimeOfDayFormat.h_colon_mm_space_a:
            timePickerWidth = _kTimePickerMinInputSize.width - 32;
        }
        return Size(timePickerWidth, _kTimePickerMinInputSize.height);
    }
  }

  Size _dialogSize(BuildContext context) {
    final Orientation orientation =
        _orientation.value ?? MediaQuery.orientationOf(context);

    const double fontSizeToScale = 14.0;
    final double textScaleFactor =
        MediaQuery.textScalerOf(
          context,
        ).clamp(maxScaleFactor: 1.1).scale(fontSizeToScale) /
        fontSizeToScale;

    final Size timePickerSize;
    switch (_entryMode.value) {
      case TimePickerEntryMode.dial:
      case TimePickerEntryMode.dialOnly:
        switch (orientation) {
          case Orientation.portrait:
            timePickerSize = _kTimePickerPortraitSize;
          case Orientation.landscape:
            timePickerSize = Size(
              _kTimePickerLandscapeSize.width * textScaleFactor,
              _kTimePickerLandscapeSize.height,
            );
        }
      case TimePickerEntryMode.input:
      case TimePickerEntryMode.inputOnly:
        final MaterialLocalizations localizations = MaterialLocalizations.of(
          context,
        );
        final TimeOfDayFormat timeOfDayFormat = localizations.timeOfDayFormat(
          alwaysUse24HourFormat: MediaQuery.alwaysUse24HourFormatOf(context),
        );
        final double timePickerWidth;
        switch (timeOfDayFormat) {
          case TimeOfDayFormat.HH_colon_mm:
          case TimeOfDayFormat.HH_dot_mm:
          case TimeOfDayFormat.frenchCanadian:
          case TimeOfDayFormat.H_colon_mm:
            final _TimePickerDefaults defaultTheme = _TimePickerDefaultsM3(
              context,
            );
            timePickerWidth =
                _kTimePickerInputSize.width -
                defaultTheme.dayPeriodPortraitSize.width -
                12;
          case TimeOfDayFormat.a_space_h_colon_mm:
          case TimeOfDayFormat.h_colon_mm_space_a:
            timePickerWidth = _kTimePickerInputSize.width - 32;
        }
        timePickerSize = Size(timePickerWidth, _kTimePickerInputSize.height);
    }
    return Size(timePickerSize.width, timePickerSize.height * textScaleFactor);
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMediaQuery(context));
    final ThemeData theme = Theme.of(context);
    final TimePickerThemeData pickerTheme = TimePickerTheme.of(context);
    final _TimePickerDefaults defaultTheme = _TimePickerDefaultsM3(context);
    final Offset tapTargetSizeOffset = switch (theme.materialTapTargetSize) {
      MaterialTapTargetSize.padded => Offset.zero,

      MaterialTapTargetSize.shrinkWrap => const Offset(0, -12),
    };
    final Size dialogSize = _dialogSize(context) + tapTargetSizeOffset;
    final Size minDialogSize = _minDialogSize(context) + tapTargetSizeOffset;
    return Padding(
      padding: pickerTheme.padding ?? defaultTheme.padding,
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final Size constrainedSize = constraints.constrain(dialogSize);
          final Size allowedSize = Size(
            constrainedSize.width < minDialogSize.width
                ? minDialogSize.width
                : constrainedSize.width,
            constrainedSize.height < minDialogSize.height
                ? minDialogSize.height
                : constrainedSize.height,
          );
          return SingleChildScrollView(
            restorationId: 'time_picker_scroll_view_horizontal',
            scrollDirection: Axis.horizontal,
            child: SingleChildScrollView(
              restorationId: 'time_picker_scroll_view_vertical',
              child: SizedBox(
                width: allowedSize.width,
                height: allowedSize.height,
                child: Form(
                  key: _formKey,
                  autovalidateMode: _autovalidateMode.value,
                  child: _TimePicker(
                    time: widget.initialTime,
                    onTimeChanged: _handleTimeChanged,
                    errorInvalidText: widget.errorInvalidText,
                    hourLabelText: widget.hourLabelText,
                    minuteLabelText: widget.minuteLabelText,
                    restorationId: 'time_picker',
                    entryMode: _entryMode.value,
                    orientation: widget.orientation,
                    onEntryModeChanged: _handleEntryModeChanged,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _TimePicker extends StatefulWidget {
  const _TimePicker({
    required this.time,
    required this.onTimeChanged,
    this.errorInvalidText,
    this.hourLabelText,
    this.minuteLabelText,
    this.restorationId,
    this.entryMode = TimePickerEntryMode.dial,
    this.orientation,
    this.onEntryModeChanged,
  });

  final String? errorInvalidText;

  final String? hourLabelText;

  final String? minuteLabelText;

  final String? restorationId;

  final TimePickerEntryMode entryMode;

  final TimeOfDay time;

  final ValueChanged<TimeOfDay>? onTimeChanged;

  final Orientation? orientation;

  final EntryModeChangeCallback? onEntryModeChanged;

  @override
  State<_TimePicker> createState() => _TimePickerState();
}

class _TimePickerState extends State<_TimePicker> with RestorationMixin {
  Timer? _vibrateTimer;
  late MaterialLocalizations localizations;
  final RestorableEnum<_HourMinuteMode> _hourMinuteMode =
      RestorableEnum<_HourMinuteMode>(
        _HourMinuteMode.hour,
        values: _HourMinuteMode.values,
      );
  final RestorableEnumN<_HourMinuteMode> _lastModeAnnounced =
      RestorableEnumN<_HourMinuteMode>(null, values: _HourMinuteMode.values);
  final RestorableBoolN _autofocusHour = RestorableBoolN(null);
  final RestorableBoolN _autofocusMinute = RestorableBoolN(null);
  final RestorableBool _announcedInitialTime = RestorableBool(false);
  late final RestorableEnumN<Orientation> _orientation =
      RestorableEnumN<Orientation>(
        widget.orientation,
        values: Orientation.values,
      );
  RestorableTimeOfDay get selectedTime => _selectedTime;
  late final RestorableTimeOfDay _selectedTime = RestorableTimeOfDay(
    widget.time,
  );

  @override
  void dispose() {
    _vibrateTimer?.cancel();
    _vibrateTimer = null;
    _orientation.dispose();
    _selectedTime.dispose();
    _hourMinuteMode.dispose();
    _lastModeAnnounced.dispose();
    _autofocusHour.dispose();
    _autofocusMinute.dispose();
    _announcedInitialTime.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    localizations = MaterialLocalizations.of(context);
    _announceInitialTimeOnce();
    _announceModeOnce();
  }

  @override
  void didUpdateWidget(_TimePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.orientation != widget.orientation) {
      _orientation.value = widget.orientation;
    }
    if (oldWidget.time != widget.time) {
      _selectedTime.value = widget.time;
    }
  }

  void _setEntryMode(TimePickerEntryMode mode) {
    widget.onEntryModeChanged?.call(mode);
  }

  @override
  String? get restorationId => widget.restorationId;

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_hourMinuteMode, 'hour_minute_mode');
    registerForRestoration(_lastModeAnnounced, 'last_mode_announced');
    registerForRestoration(_autofocusHour, 'autofocus_hour');
    registerForRestoration(_autofocusMinute, 'autofocus_minute');
    registerForRestoration(_announcedInitialTime, 'announced_initial_time');
    registerForRestoration(_selectedTime, 'selected_time');
    registerForRestoration(_orientation, 'orientation');
  }

  void _vibrate() {
    switch (Theme.of(context).platform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        _vibrateTimer?.cancel();
        _vibrateTimer = Timer(_kVibrateCommitDelay, () {
          unawaited(HapticFeedback.vibrate());
          _vibrateTimer = null;
        });
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        break;
    }
  }

  void _handleHourMinuteModeChanged(_HourMinuteMode mode) {
    _vibrate();
    setState(() {
      _hourMinuteMode.value = mode;
      _announceModeOnce();
    });
  }

  void _handleEntryModeToggle() {
    setState(() {
      TimePickerEntryMode newMode = widget.entryMode;
      switch (widget.entryMode) {
        case TimePickerEntryMode.dial:
          newMode = TimePickerEntryMode.input;
        case TimePickerEntryMode.input:
          _autofocusHour.value = false;
          _autofocusMinute.value = false;
          newMode = TimePickerEntryMode.dial;
        case TimePickerEntryMode.dialOnly:
        case TimePickerEntryMode.inputOnly:
          FlutterError('Can not change entry mode from ${widget.entryMode}');
      }
      _setEntryMode(newMode);
    });
  }

  void _announceModeOnce() {
    if (_lastModeAnnounced.value == _hourMinuteMode.value) {
      return;
    }

    switch (_hourMinuteMode.value) {
      case _HourMinuteMode.hour:
        unawaited(
          _announceToAccessibility(
            context,
            localizations.timePickerHourModeAnnouncement,
          ),
        );
      case _HourMinuteMode.minute:
        unawaited(
          _announceToAccessibility(
            context,
            localizations.timePickerMinuteModeAnnouncement,
          ),
        );
    }
    _lastModeAnnounced.value = _hourMinuteMode.value;
  }

  void _announceInitialTimeOnce() {
    if (_announcedInitialTime.value) {
      return;
    }

    final MaterialLocalizations localizations = MaterialLocalizations.of(
      context,
    );
    unawaited(
      _announceToAccessibility(
        context,
        localizations.formatTimeOfDay(
          _selectedTime.value,
          alwaysUse24HourFormat: MediaQuery.alwaysUse24HourFormatOf(context),
        ),
      ),
    );
    _announcedInitialTime.value = true;
  }

  void _handleTimeChanged(TimeOfDay value) {
    _vibrate();
    setState(() {
      _selectedTime.value = value;
      widget.onTimeChanged?.call(value);
    });
  }

  void _handleHourDoubleTapped() {
    _autofocusHour.value = true;
    _handleEntryModeToggle();
  }

  void _handleMinuteDoubleTapped() {
    _autofocusMinute.value = true;
    _handleEntryModeToggle();
  }

  void _handleHourSelected() {
    setState(() {
      _hourMinuteMode.value = _HourMinuteMode.minute;
    });
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMediaQuery(context));
    final TimeOfDayFormat timeOfDayFormat = localizations.timeOfDayFormat(
      alwaysUse24HourFormat: MediaQuery.alwaysUse24HourFormatOf(context),
    );
    final ThemeData theme = Theme.of(context);
    final _TimePickerDefaults defaultTheme = _TimePickerDefaultsM3(
      context,
      entryMode: widget.entryMode,
    );
    final Orientation orientation =
        _orientation.value ?? MediaQuery.orientationOf(context);
    final HourFormat timeOfDayHour = hourFormat(of: timeOfDayFormat);
    final _HourDialType hourMode = switch (timeOfDayHour) {
      HourFormat.HH || HourFormat.H when theme.useMaterial3 =>
        _HourDialType.twentyFourHourDoubleRing,
      HourFormat.HH || HourFormat.H => _HourDialType.twentyFourHour,
      HourFormat.h => _HourDialType.twelveHour,
    };

    final Widget picker;
    switch (widget.entryMode) {
      case TimePickerEntryMode.dial:
      case TimePickerEntryMode.dialOnly:
        final EdgeInsetsGeometry dialPadding = switch (orientation) {
          Orientation.portrait => EdgeInsets.zero,
          Orientation.landscape => const EdgeInsetsDirectional.only(start: 64),
        };
        final Widget dial = Padding(
          padding: dialPadding,
          child: ExcludeSemantics(
            child: SizedBox.fromSize(
              size: defaultTheme.dialSize,
              child: AspectRatio(
                aspectRatio: 1,
                child: _Dial(
                  hourMinuteMode: _hourMinuteMode.value,
                  hourDialType: hourMode,
                  selectedTime: _selectedTime.value,
                  onChanged: _handleTimeChanged,
                  onHourSelected: _handleHourSelected,
                ),
              ),
            ),
          ),
        );
        switch (orientation) {
          case Orientation.portrait:
            picker = Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [Expanded(child: dial)],
                  ),
                ),
                const _TimePickerHeader(),
              ],
            );
          case Orientation.landscape:
            picker = Column(
              children: [
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const _TimePickerHeader(),
                      Expanded(child: dial),
                    ],
                  ),
                ),
              ],
            );
        }
      case TimePickerEntryMode.input:
      case TimePickerEntryMode.inputOnly:
        picker = Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _TimePickerInput(
              initialSelectedTime: _selectedTime.value,
              errorInvalidText: widget.errorInvalidText,
              hourLabelText: widget.hourLabelText,
              minuteLabelText: widget.minuteLabelText,
              autofocusHour: _autofocusHour.value,
              autofocusMinute: _autofocusMinute.value,
              restorationId: 'time_picker_input',
            ),
          ],
        );
    }
    return _TimePickerModel(
      entryMode: widget.entryMode,
      selectedTime: _selectedTime.value,
      hourMinuteMode: _hourMinuteMode.value,
      orientation: orientation,
      onHourMinuteModeChanged: _handleHourMinuteModeChanged,
      onHourDoubleTapped: _handleHourDoubleTapped,
      onMinuteDoubleTapped: _handleMinuteDoubleTapped,
      hourDialType: hourMode,
      onSelectedTimeChanged: _handleTimeChanged,
      use24HourFormat: MediaQuery.alwaysUse24HourFormatOf(context),
      theme: TimePickerTheme.of(context),
      defaultTheme: defaultTheme,
      child: picker,
    );
  }
}

class _DialPainter extends CustomPainter {
  _DialPainter({
    required this.primaryLabels,
    required this.selectedLabels,
    required this.backgroundColor,
    required this.handColor,
    required this.handWidth,
    required this.dotColor,
    required this.dotRadius,
    required this.centerRadius,
    required this.theta,
    required this.radius,
    required this.textDirection,
    required this.selectedValue,
  }) : super(repaint: PaintingBinding.instance.systemFonts) {
    assert(debugMaybeDispatchCreated('material', '_DialPainter', this));
  }

  final List<_TappableLabel> primaryLabels;
  final List<_TappableLabel> selectedLabels;
  final Color backgroundColor;
  final Color handColor;
  final double handWidth;
  final Color dotColor;
  final double dotRadius;
  final double centerRadius;
  final double theta;
  final double radius;
  final TextDirection textDirection;
  final int selectedValue;

  void dispose() {
    assert(debugMaybeDispatchDisposed(this));
    for (final _TappableLabel label in primaryLabels) {
      label.painter.dispose();
    }
    for (final _TappableLabel label in selectedLabels) {
      label.painter.dispose();
    }
    primaryLabels.clear();
    selectedLabels.clear();
  }

  @override
  void paint(Canvas canvas, Size size) {
    final double dialRadius = clampDouble(
      size.shortestSide / 2,
      _kTimePickerDialMinRadius + dotRadius,
      double.infinity,
    );
    final double labelRadius = clampDouble(
      dialRadius - _kTimePickerDialPadding,
      _kTimePickerDialMinRadius,
      double.infinity,
    );
    final double innerLabelRadius = clampDouble(
      labelRadius - _kTimePickerInnerDialOffset,
      0,
      double.infinity,
    );
    final double handleRadius = clampDouble(
      labelRadius - (radius < 0.5 ? 1 : 0) * (labelRadius - innerLabelRadius),
      _kTimePickerDialMinRadius,
      double.infinity,
    );
    final Offset center = Offset(size.width / 2, size.height / 2);
    final Offset centerPoint = center;
    canvas.drawCircle(
      centerPoint,
      dialRadius,
      Paint()..color = backgroundColor,
    );

    Offset getOffsetForTheta(double theta, double radius) {
      return center +
          Offset(radius * math.cos(theta), -radius * math.sin(theta));
    }

    void paintLabels(List<_TappableLabel> labels, double radius) {
      if (labels.isEmpty) {
        return;
      }
      final double labelThetaIncrement = -_kTwoPi / labels.length;
      double labelTheta = math.pi / 2;

      for (final _TappableLabel label in labels) {
        final TextPainter labelPainter = label.painter;
        final Offset labelOffset = Offset(
          -labelPainter.width / 2,
          -labelPainter.height / 2,
        );
        labelPainter.paint(
          canvas,
          getOffsetForTheta(labelTheta, radius) + labelOffset,
        );
        labelTheta += labelThetaIncrement;
      }
    }

    void paintInnerOuterLabels(List<_TappableLabel>? labels) {
      if (labels == null) {
        return;
      }

      paintLabels(
        labels.where((_TappableLabel label) => !label.inner).toList(),
        labelRadius,
      );
      paintLabels(
        labels.where((_TappableLabel label) => label.inner).toList(),
        innerLabelRadius,
      );
    }

    paintInnerOuterLabels(primaryLabels);

    final Paint selectorPaint = Paint()..color = handColor;
    final Offset focusedPoint = getOffsetForTheta(theta, handleRadius);
    canvas.drawCircle(centerPoint, centerRadius, selectorPaint);
    canvas.drawCircle(focusedPoint, dotRadius, selectorPaint);
    selectorPaint.strokeWidth = handWidth;
    canvas.drawLine(centerPoint, focusedPoint, selectorPaint);

    final double labelThetaIncrement = -_kTwoPi / primaryLabels.length;
    if (theta % labelThetaIncrement > 0.1 &&
        theta % labelThetaIncrement < 0.45) {
      canvas.drawCircle(focusedPoint, 2, selectorPaint..color = dotColor);
    }

    final Rect focusedRect = Rect.fromCircle(
      center: focusedPoint,
      radius: dotRadius,
    );
    canvas
      ..save()
      ..clipPath(Path()..addOval(focusedRect));
    paintInnerOuterLabels(selectedLabels);
    canvas.restore();
  }

  @override
  bool shouldRepaint(_DialPainter oldPainter) {
    return oldPainter.primaryLabels != primaryLabels ||
        oldPainter.selectedLabels != selectedLabels ||
        oldPainter.backgroundColor != backgroundColor ||
        oldPainter.handColor != handColor ||
        oldPainter.theta != theta;
  }
}

class _Dial extends StatefulWidget {
  const _Dial({
    required this.selectedTime,
    required this.hourMinuteMode,
    required this.hourDialType,
    required this.onChanged,
    required this.onHourSelected,
  });

  final TimeOfDay selectedTime;
  final _HourMinuteMode hourMinuteMode;
  final _HourDialType hourDialType;
  final ValueChanged<TimeOfDay>? onChanged;
  final VoidCallback? onHourSelected;

  @override
  _DialState createState() => _DialState();
}

class _DialState extends State<_Dial> with SingleTickerProviderStateMixin {
  late ThemeData themeData;
  late MaterialLocalizations localizations;
  _DialPainter? painter;
  late AnimationController _animationController;
  late Tween<double> _thetaTween;
  late Animation<double> _theta;
  late Tween<double> _radiusTween;
  late Animation<double> _radius;
  bool _dragging = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: _kDialAnimateDuration,
      vsync: this,
    );
    _thetaTween = Tween<double>(begin: _getThetaForTime(widget.selectedTime));
    _radiusTween = Tween<double>(begin: _getRadiusForTime(widget.selectedTime));
    _theta = _animationController
      .drive(CurveTween(curve: Easing.standard))
      .drive(_thetaTween)..addListener(
      () => setState(() {
        /* _theta.value has changed */
      }),
    );
    _radius = _animationController
      .drive(CurveTween(curve: Easing.standard))
      .drive(_radiusTween)..addListener(
      () => setState(() {
        /* _radius.value has changed */
      }),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    assert(debugCheckHasMediaQuery(context));
    themeData = Theme.of(context);
    localizations = MaterialLocalizations.of(context);
  }

  @override
  void didUpdateWidget(_Dial oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.hourMinuteMode != oldWidget.hourMinuteMode ||
        widget.selectedTime != oldWidget.selectedTime) {
      if (!_dragging) {
        _animateTo(
          _getThetaForTime(widget.selectedTime),
          _getRadiusForTime(widget.selectedTime),
        );
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    painter?.dispose();
    super.dispose();
  }

  static double _nearest(double target, double a, double b) {
    return ((target - a).abs() < (target - b).abs()) ? a : b;
  }

  void _animateTo(double targetTheta, double targetRadius) {
    void animateToValue({
      required double target,
      required Animation<double> animation,
      required Tween<double> tween,
      required AnimationController controller,
      required double min,
      required double max,
    }) {
      double beginValue = _nearest(target, animation.value, max);
      beginValue = _nearest(target, beginValue, min);
      tween
        ..begin = beginValue
        ..end = target;
      controller
        ..value = 0
        ..forward();
    }

    animateToValue(
      target: targetTheta,
      animation: _theta,
      tween: _thetaTween,
      controller: _animationController,
      min: _theta.value - _kTwoPi,
      max: _theta.value + _kTwoPi,
    );
    animateToValue(
      target: targetRadius,
      animation: _radius,
      tween: _radiusTween,
      controller: _animationController,
      min: 0,
      max: 1,
    );
  }

  double _getRadiusForTime(TimeOfDay time) {
    switch (widget.hourMinuteMode) {
      case _HourMinuteMode.hour:
        return switch (widget.hourDialType) {
          _HourDialType.twentyFourHourDoubleRing => time.hour >= 12 ? 0 : 1,
          _HourDialType.twentyFourHour || _HourDialType.twelveHour => 1,
        };
      case _HourMinuteMode.minute:
        return 1;
    }
  }

  double _getThetaForTime(TimeOfDay time) {
    final int hoursFactor = switch (widget.hourDialType) {
      _HourDialType.twentyFourHour => TimeOfDay.hoursPerDay,
      _HourDialType.twentyFourHourDoubleRing => TimeOfDay.hoursPerPeriod,
      _HourDialType.twelveHour => TimeOfDay.hoursPerPeriod,
    };
    final double fraction = switch (widget.hourMinuteMode) {
      _HourMinuteMode.hour => (time.hour / hoursFactor) % hoursFactor,
      _HourMinuteMode.minute =>
        (time.minute / TimeOfDay.minutesPerHour) % TimeOfDay.minutesPerHour,
    };
    return (math.pi / 2 - fraction * _kTwoPi) % _kTwoPi;
  }

  TimeOfDay _getTimeForTheta(
    double theta, {
    bool roundMinutes = false,
    required double radius,
  }) {
    final double fraction = (0.25 - (theta % _kTwoPi) / _kTwoPi) % 1;
    switch (widget.hourMinuteMode) {
      case _HourMinuteMode.hour:
        int newHour;
        switch (widget.hourDialType) {
          case _HourDialType.twentyFourHour:
            newHour =
                (fraction * TimeOfDay.hoursPerDay).round() %
                TimeOfDay.hoursPerDay;
          case _HourDialType.twentyFourHourDoubleRing:
            newHour =
                (fraction * TimeOfDay.hoursPerPeriod).round() %
                TimeOfDay.hoursPerPeriod;
            if (radius < 0.5) {
              newHour = newHour + TimeOfDay.hoursPerPeriod;
            }
          case _HourDialType.twelveHour:
            newHour =
                (fraction * TimeOfDay.hoursPerPeriod).round() %
                TimeOfDay.hoursPerPeriod;
            newHour = newHour + widget.selectedTime.periodOffset;
        }
        return widget.selectedTime.replacing(hour: newHour);
      case _HourMinuteMode.minute:
        int minute =
            (fraction * TimeOfDay.minutesPerHour).round() %
            TimeOfDay.minutesPerHour;
        if (roundMinutes) {
          minute = ((minute + 2) ~/ 5) * 5 % TimeOfDay.minutesPerHour;
        }
        return widget.selectedTime.replacing(minute: minute);
    }
  }

  TimeOfDay _notifyOnChangedIfNeeded({bool roundMinutes = false}) {
    final TimeOfDay current = _getTimeForTheta(
      _theta.value,
      roundMinutes: roundMinutes,
      radius: _radius.value,
    );
    if (widget.onChanged == null) {
      return current;
    }
    if (current != widget.selectedTime) {
      widget.onChanged!(current);
    }
    return current;
  }

  void _updateThetaForPan({bool roundMinutes = false}) {
    setState(() {
      final Offset offset = _position! - _center!;
      final double labelRadius =
          _dialSize!.shortestSide / 2 - _kTimePickerDialPadding;
      final double innerRadius = labelRadius - _kTimePickerInnerDialOffset;
      double angle = (math.atan2(offset.dx, offset.dy) - math.pi / 2) % _kTwoPi;
      final double radius = clampDouble(
        (offset.distance - innerRadius) / _kTimePickerInnerDialOffset,
        0,
        1,
      );
      if (roundMinutes) {
        angle = _getThetaForTime(
          _getTimeForTheta(angle, roundMinutes: roundMinutes, radius: radius),
        );
      }
      _thetaTween
        ..begin = angle
        ..end = angle;
      _radiusTween
        ..begin = radius
        ..end = radius;
    });
  }

  Offset? _position;
  Offset? _center;
  Size? _dialSize;

  void _handlePanStart(DragStartDetails details) {
    assert(!_dragging);
    _dragging = true;
    final RenderBox box = context.findRenderObject()! as RenderBox;
    _position = box.globalToLocal(details.globalPosition);
    _dialSize = box.size;
    _center = _dialSize!.center(Offset.zero);
    _updateThetaForPan();
    _notifyOnChangedIfNeeded();
  }

  void _handlePanUpdate(DragUpdateDetails details) {
    _position = _position! + details.delta;
    _updateThetaForPan();
    _notifyOnChangedIfNeeded();
  }

  void _handlePanEnd(DragEndDetails details) {
    assert(_dragging);
    _dragging = false;
    _position = null;
    _center = null;
    _dialSize = null;
    _animateTo(
      _getThetaForTime(widget.selectedTime),
      _getRadiusForTime(widget.selectedTime),
    );
    if (widget.hourMinuteMode == _HourMinuteMode.hour) {
      widget.onHourSelected?.call();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    final RenderBox box = context.findRenderObject()! as RenderBox;
    _position = box.globalToLocal(details.globalPosition);
    _center = box.size.center(Offset.zero);
    _dialSize = box.size;
    _updateThetaForPan(roundMinutes: true);
    final TimeOfDay newTime = _notifyOnChangedIfNeeded(roundMinutes: true);
    if (widget.hourMinuteMode == _HourMinuteMode.hour) {
      switch (widget.hourDialType) {
        case _HourDialType.twentyFourHour:
        case _HourDialType.twentyFourHourDoubleRing:
          unawaited(
            _announceToAccessibility(
              context,
              localizations.formatDecimal(newTime.hour),
            ),
          );
        case _HourDialType.twelveHour:
          unawaited(
            _announceToAccessibility(
              context,
              localizations.formatDecimal(newTime.hourOfPeriod),
            ),
          );
      }
      widget.onHourSelected?.call();
    } else {
      unawaited(
        _announceToAccessibility(
          context,
          localizations.formatDecimal(newTime.minute),
        ),
      );
    }
    final TimeOfDay time = _getTimeForTheta(
      _theta.value,
      roundMinutes: true,
      radius: _radius.value,
    );
    _animateTo(_getThetaForTime(time), _getRadiusForTime(time));
    _dragging = false;
    _position = null;
    _center = null;
    _dialSize = null;
  }

  void _selectHour(int hour) {
    unawaited(
      _announceToAccessibility(context, localizations.formatDecimal(hour)),
    );
    final TimeOfDay time;

    TimeOfDay getAmPmTime() {
      return switch (widget.selectedTime.period) {
        DayPeriod.am => TimeOfDay(
          hour: hour,
          minute: widget.selectedTime.minute,
        ),
        DayPeriod.pm => TimeOfDay(
          hour: hour + TimeOfDay.hoursPerPeriod,
          minute: widget.selectedTime.minute,
        ),
      };
    }

    switch (widget.hourMinuteMode) {
      case _HourMinuteMode.hour:
        switch (widget.hourDialType) {
          case _HourDialType.twentyFourHour:
          case _HourDialType.twentyFourHourDoubleRing:
            time = TimeOfDay(hour: hour, minute: widget.selectedTime.minute);
          case _HourDialType.twelveHour:
            time = getAmPmTime();
        }
      case _HourMinuteMode.minute:
        time = getAmPmTime();
    }
    final double angle = _getThetaForTime(time);
    _thetaTween
      ..begin = angle
      ..end = angle;
    _notifyOnChangedIfNeeded();
  }

  void _selectMinute(int minute) {
    unawaited(
      _announceToAccessibility(context, localizations.formatDecimal(minute)),
    );
    final TimeOfDay time = TimeOfDay(
      hour: widget.selectedTime.hour,
      minute: minute,
    );
    final double angle = _getThetaForTime(time);
    _thetaTween
      ..begin = angle
      ..end = angle;
    _notifyOnChangedIfNeeded();
  }

  static const List<TimeOfDay> _amHours = <TimeOfDay>[
    TimeOfDay(hour: 12, minute: 0),
    TimeOfDay(hour: 1, minute: 0),
    TimeOfDay(hour: 2, minute: 0),
    TimeOfDay(hour: 3, minute: 0),
    TimeOfDay(hour: 4, minute: 0),
    TimeOfDay(hour: 5, minute: 0),
    TimeOfDay(hour: 6, minute: 0),
    TimeOfDay(hour: 7, minute: 0),
    TimeOfDay(hour: 8, minute: 0),
    TimeOfDay(hour: 9, minute: 0),
    TimeOfDay(hour: 10, minute: 0),
    TimeOfDay(hour: 11, minute: 0),
  ];

  static const List<TimeOfDay> _twentyFourHours = <TimeOfDay>[
    TimeOfDay(hour: 0, minute: 0),
    TimeOfDay(hour: 1, minute: 0),
    TimeOfDay(hour: 2, minute: 0),
    TimeOfDay(hour: 3, minute: 0),
    TimeOfDay(hour: 4, minute: 0),
    TimeOfDay(hour: 5, minute: 0),
    TimeOfDay(hour: 6, minute: 0),
    TimeOfDay(hour: 7, minute: 0),
    TimeOfDay(hour: 8, minute: 0),
    TimeOfDay(hour: 9, minute: 0),
    TimeOfDay(hour: 10, minute: 0),
    TimeOfDay(hour: 11, minute: 0),
    TimeOfDay(hour: 12, minute: 0),
    TimeOfDay(hour: 13, minute: 0),
    TimeOfDay(hour: 14, minute: 0),
    TimeOfDay(hour: 15, minute: 0),
    TimeOfDay(hour: 16, minute: 0),
    TimeOfDay(hour: 17, minute: 0),
    TimeOfDay(hour: 18, minute: 0),
    TimeOfDay(hour: 19, minute: 0),
    TimeOfDay(hour: 20, minute: 0),
    TimeOfDay(hour: 21, minute: 0),
    TimeOfDay(hour: 22, minute: 0),
    TimeOfDay(hour: 23, minute: 0),
  ];

  _TappableLabel _buildTappableLabel({
    required TextStyle? textStyle,
    required int selectedValue,
    required int value,
    required bool inner,
    required String label,
    required VoidCallback onTap,
  }) {
    return _TappableLabel(
      value: value,
      inner: inner,
      painter: TextPainter(
        text: TextSpan(style: textStyle, text: label),
        textDirection: TextDirection.ltr,
        textScaler: MediaQuery.textScalerOf(context).clamp(maxScaleFactor: 2.0),
      )..layout(),
      onTap: onTap,
    );
  }

  List<_TappableLabel> _build24HourRing({
    required TextStyle? textStyle,
    required int selectedValue,
  }) {
    return <_TappableLabel>[
      for (final TimeOfDay timeOfDay in _twentyFourHours)
        _buildTappableLabel(
          textStyle: textStyle,
          selectedValue: selectedValue,
          inner: timeOfDay.hour >= 12,
          value: timeOfDay.hour,
          label:
              timeOfDay.hour != 0
                  ? '${timeOfDay.hour}'
                  : localizations.formatHour(
                    timeOfDay,
                    alwaysUse24HourFormat: true,
                  ),
          onTap: () {
            _selectHour(timeOfDay.hour);
          },
        ),
    ];
  }

  List<_TappableLabel> _build12HourRing({
    required TextStyle? textStyle,
    required int selectedValue,
  }) {
    return <_TappableLabel>[
      for (final TimeOfDay timeOfDay in _amHours)
        _buildTappableLabel(
          textStyle: textStyle,
          selectedValue: selectedValue,
          inner: false,
          value: timeOfDay.hour,
          label: localizations.formatHour(
            timeOfDay,
            alwaysUse24HourFormat: MediaQuery.alwaysUse24HourFormatOf(context),
          ),
          onTap: () {
            _selectHour(timeOfDay.hour);
          },
        ),
    ];
  }

  List<_TappableLabel> _buildMinutes({
    required TextStyle? textStyle,
    required int selectedValue,
  }) {
    const List<TimeOfDay> minuteMarkerValues = <TimeOfDay>[
      TimeOfDay(hour: 0, minute: 0),
      TimeOfDay(hour: 0, minute: 5),
      TimeOfDay(hour: 0, minute: 10),
      TimeOfDay(hour: 0, minute: 15),
      TimeOfDay(hour: 0, minute: 20),
      TimeOfDay(hour: 0, minute: 25),
      TimeOfDay(hour: 0, minute: 30),
      TimeOfDay(hour: 0, minute: 35),
      TimeOfDay(hour: 0, minute: 40),
      TimeOfDay(hour: 0, minute: 45),
      TimeOfDay(hour: 0, minute: 50),
      TimeOfDay(hour: 0, minute: 55),
    ];

    return <_TappableLabel>[
      for (final TimeOfDay timeOfDay in minuteMarkerValues)
        _buildTappableLabel(
          textStyle: textStyle,
          selectedValue: selectedValue,
          inner: false,
          value: timeOfDay.minute,
          label: localizations.formatMinute(timeOfDay),
          onTap: () {
            _selectMinute(timeOfDay.minute);
          },
        ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final TimePickerThemeData timePickerTheme = TimePickerTheme.of(context);
    final _TimePickerDefaults defaultTheme = _TimePickerDefaultsM3(context);
    final Color backgroundColor =
        timePickerTheme.dialBackgroundColor ?? defaultTheme.dialBackgroundColor;
    const Color dialHandColor = AppColors.primary;
    final TextStyle labelStyle =
        timePickerTheme.dialTextStyle ?? defaultTheme.dialTextStyle;
    final Color dialTextUnselectedColor = WidgetStateProperty.resolveAs<Color>(
      timePickerTheme.dialTextColor ?? defaultTheme.dialTextColor,
      <WidgetState>{},
    );
    final Color dialTextSelectedColor = WidgetStateProperty.resolveAs<Color>(
      Colors.white,
      <WidgetState>{WidgetState.selected},
    );
    final TextStyle resolvedUnselectedLabelStyle = labelStyle.copyWith(
      color: dialTextUnselectedColor,
    );
    final TextStyle resolvedSelectedLabelStyle = labelStyle.copyWith(
      color: dialTextSelectedColor,
    );
    final Color dotColor = dialTextSelectedColor;

    List<_TappableLabel> primaryLabels;
    List<_TappableLabel> selectedLabels;
    final int selectedDialValue;
    final double radiusValue;
    switch (widget.hourMinuteMode) {
      case _HourMinuteMode.hour:
        switch (widget.hourDialType) {
          case _HourDialType.twentyFourHour:
          case _HourDialType.twentyFourHourDoubleRing:
            selectedDialValue = widget.selectedTime.hour;
            primaryLabels = _build24HourRing(
              textStyle: resolvedUnselectedLabelStyle,
              selectedValue: selectedDialValue,
            );
            selectedLabels = _build24HourRing(
              textStyle: resolvedSelectedLabelStyle,
              selectedValue: selectedDialValue,
            );
            radiusValue = _radius.value;
          case _HourDialType.twelveHour:
            selectedDialValue = widget.selectedTime.hourOfPeriod;
            primaryLabels = _build12HourRing(
              textStyle: resolvedUnselectedLabelStyle,
              selectedValue: selectedDialValue,
            );
            selectedLabels = _build12HourRing(
              textStyle: resolvedSelectedLabelStyle,
              selectedValue: selectedDialValue,
            );
            radiusValue = 1;
        }
      case _HourMinuteMode.minute:
        selectedDialValue = widget.selectedTime.minute;
        primaryLabels = _buildMinutes(
          textStyle: resolvedUnselectedLabelStyle,
          selectedValue: selectedDialValue,
        );
        selectedLabels = _buildMinutes(
          textStyle: resolvedSelectedLabelStyle,
          selectedValue: selectedDialValue,
        );
        radiusValue = 1;
    }
    painter?.dispose();
    painter = _DialPainter(
      selectedValue: selectedDialValue,
      primaryLabels: primaryLabels,
      selectedLabels: selectedLabels,
      backgroundColor: backgroundColor,
      handColor: dialHandColor,
      handWidth: defaultTheme.handWidth,
      dotColor: dotColor,
      dotRadius: defaultTheme.dotRadius,
      centerRadius: defaultTheme.centerRadius,
      theta: _theta.value,
      radius: radiusValue,
      textDirection: Directionality.of(context),
    );

    return GestureDetector(
      excludeFromSemantics: true,
      onPanStart: _handlePanStart,
      onPanUpdate: _handlePanUpdate,
      onPanEnd: _handlePanEnd,
      onTapUp: _handleTapUp,
      child: CustomPaint(
        key: const ValueKey<String>('time-picker-dial'),
        painter: painter,
      ),
    );
  }
}

class _TimePickerInput extends StatefulWidget {
  const _TimePickerInput({
    required this.initialSelectedTime,
    required this.errorInvalidText,
    required this.hourLabelText,
    required this.minuteLabelText,
    required this.autofocusHour,
    required this.autofocusMinute,
    this.restorationId,
  });

  final TimeOfDay initialSelectedTime;

  final String? errorInvalidText;

  final String? hourLabelText;

  final String? minuteLabelText;

  final bool? autofocusHour;

  final bool? autofocusMinute;

  final String? restorationId;

  @override
  _TimePickerInputState createState() => _TimePickerInputState();
}

class _TimePickerInputState extends State<_TimePickerInput>
    with RestorationMixin {
  late final RestorableTimeOfDay _selectedTime = RestorableTimeOfDay(
    widget.initialSelectedTime,
  );
  final RestorableBool hourHasError = RestorableBool(false);
  final RestorableBool minuteHasError = RestorableBool(false);

  @override
  void dispose() {
    _selectedTime.dispose();
    hourHasError.dispose();
    minuteHasError.dispose();
    super.dispose();
  }

  @override
  String? get restorationId => widget.restorationId;

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_selectedTime, 'selected_time');
    registerForRestoration(hourHasError, 'hour_has_error');
    registerForRestoration(minuteHasError, 'minute_has_error');
  }

  int? _parseHour(String? value) {
    if (value == null) {
      return null;
    }

    int? newHour = int.tryParse(value);
    if (newHour == null) {
      return null;
    }

    if (MediaQuery.alwaysUse24HourFormatOf(context)) {
      if (newHour >= 0 && newHour < 24) {
        return newHour;
      }
    } else {
      if (newHour > 0 && newHour < 13) {
        if ((_selectedTime.value.period == DayPeriod.pm && newHour != 12) ||
            (_selectedTime.value.period == DayPeriod.am && newHour == 12)) {
          newHour =
              (newHour + TimeOfDay.hoursPerPeriod) % TimeOfDay.hoursPerDay;
        }
        return newHour;
      }
    }
    return null;
  }

  int? _parseMinute(String? value) {
    if (value == null) {
      return null;
    }

    final int? newMinute = int.tryParse(value);
    if (newMinute == null) {
      return null;
    }

    if (newMinute >= 0 && newMinute < 60) {
      return newMinute;
    }
    return null;
  }

  void _handleHourSavedSubmitted(String? value) {
    final int? newHour = _parseHour(value);
    if (newHour != null) {
      _selectedTime.value = TimeOfDay(
        hour: newHour,
        minute: _selectedTime.value.minute,
      );
      _TimePickerModel.setSelectedTime(context, _selectedTime.value);
      FocusScope.of(context).requestFocus();
    }
  }

  void _handleHourChanged(String value) {
    final int? newHour = _parseHour(value);
    if (newHour != null && value.length == 2) {
      FocusScope.of(context).nextFocus();
    }
  }

  void _handleMinuteSavedSubmitted(String? value) {
    final int? newMinute = _parseMinute(value);
    if (newMinute != null) {
      _selectedTime.value = TimeOfDay(
        hour: _selectedTime.value.hour,
        minute: int.parse(value!),
      );
      _TimePickerModel.setSelectedTime(context, _selectedTime.value);
      FocusScope.of(context).unfocus();
    }
  }

  void _handleDayPeriodChanged(TimeOfDay value) {
    _selectedTime.value = value;
    _TimePickerModel.setSelectedTime(context, _selectedTime.value);
  }

  String? _validateHour(String? value) {
    final int? newHour = _parseHour(value);
    setState(() {
      hourHasError.value = newHour == null;
    });

    return newHour == null ? '' : null;
  }

  String? _validateMinute(String? value) {
    final int? newMinute = _parseMinute(value);
    setState(() {
      minuteHasError.value = newMinute == null;
    });

    return newMinute == null ? '' : null;
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMediaQuery(context));
    final TimeOfDayFormat timeOfDayFormat = MaterialLocalizations.of(
      context,
    ).timeOfDayFormat(
      alwaysUse24HourFormat: _TimePickerModel.use24HourFormatOf(context),
    );
    final bool use24HourDials = hourFormat(of: timeOfDayFormat) != HourFormat.h;
    final ThemeData theme = Theme.of(context);
    final TimePickerThemeData timePickerTheme = _TimePickerModel.themeOf(
      context,
    );
    final _TimePickerDefaults defaultTheme = _TimePickerModel.defaultThemeOf(
      context,
    );
    final TextStyle hourMinuteStyle =
        timePickerTheme.hourMinuteTextStyle ?? defaultTheme.hourMinuteTextStyle;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!use24HourDials &&
                timeOfDayFormat == TimeOfDayFormat.a_space_h_colon_mm) ...[
              Padding(
                padding: const EdgeInsetsDirectional.only(end: 12),
                child: _DayPeriodControl(
                  onPeriodChanged: _handleDayPeriodChanged,
                ),
              ),
            ],
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,

                textDirection: TextDirection.ltr,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: _HourTextField(
                            restorationId: 'hour_text_field',
                            selectedTime: _selectedTime.value,
                            style: hourMinuteStyle,
                            inputAction: TextInputAction.next,
                            validator: _validateHour,
                            onSavedSubmitted: _handleHourSavedSubmitted,
                            onChanged: _handleHourChanged,
                            hourLabelText: widget.hourLabelText,
                          ),
                        ),
                        if (!hourHasError.value && !minuteHasError.value)
                          ExcludeSemantics(
                            child: Text(
                              widget.hourLabelText ??
                                  MaterialLocalizations.of(
                                    context,
                                  ).timePickerHourLabel,
                              style: theme.textTheme.bodySmall,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                      ],
                    ),
                  ),
                  _TimeSelectorSeparator(timeOfDayFormat: timeOfDayFormat),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: _MinuteTextField(
                            restorationId: 'minute_text_field',
                            selectedTime: _selectedTime.value,
                            style: hourMinuteStyle,
                            inputAction: TextInputAction.done,
                            validator: _validateMinute,
                            onSavedSubmitted: _handleMinuteSavedSubmitted,
                            minuteLabelText: widget.minuteLabelText,
                          ),
                        ),
                        if (!hourHasError.value && !minuteHasError.value)
                          ExcludeSemantics(
                            child: Text(
                              widget.minuteLabelText ??
                                  MaterialLocalizations.of(
                                    context,
                                  ).timePickerMinuteLabel,
                              style: theme.textTheme.bodySmall,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (!use24HourDials &&
                timeOfDayFormat != TimeOfDayFormat.a_space_h_colon_mm) ...[
              Padding(
                padding: const EdgeInsetsDirectional.only(start: 12),
                child: _DayPeriodControl(
                  onPeriodChanged: _handleDayPeriodChanged,
                ),
              ),
            ],
          ],
        ),
        if (hourHasError.value || minuteHasError.value)
          Text(
            widget.errorInvalidText ??
                MaterialLocalizations.of(context).invalidTimeLabel,
            style: theme.textTheme.bodyMedium!.copyWith(
              color: theme.colorScheme.error,
            ),
          )
        else
          const SizedBox(height: 2),
      ],
    );
  }
}

class _HourTextField extends StatelessWidget {
  const _HourTextField({
    required this.selectedTime,
    required this.style,
    required this.inputAction,
    required this.validator,
    required this.onSavedSubmitted,
    required this.onChanged,
    required this.hourLabelText,
    this.restorationId,
  });

  final TimeOfDay selectedTime;
  final TextStyle style;
  final TextInputAction inputAction;
  final FormFieldValidator<String> validator;
  final ValueChanged<String?> onSavedSubmitted;
  final ValueChanged<String> onChanged;
  final String? hourLabelText;
  final String? restorationId;

  @override
  Widget build(BuildContext context) {
    return _HourMinuteTextField(
      restorationId: restorationId,
      selectedTime: selectedTime,
      isHour: true,
      inputAction: inputAction,
      style: style,
      semanticHintText:
          hourLabelText ??
          MaterialLocalizations.of(context).timePickerHourLabel,
      validator: validator,
      onSavedSubmitted: onSavedSubmitted,
      onChanged: onChanged,
    );
  }
}

class _MinuteTextField extends StatelessWidget {
  const _MinuteTextField({
    required this.selectedTime,
    required this.style,
    required this.inputAction,
    required this.validator,
    required this.onSavedSubmitted,
    required this.minuteLabelText,
    this.restorationId,
  });

  final TimeOfDay selectedTime;
  final TextStyle style;
  final TextInputAction inputAction;
  final FormFieldValidator<String> validator;
  final ValueChanged<String?> onSavedSubmitted;
  final String? minuteLabelText;
  final String? restorationId;

  @override
  Widget build(BuildContext context) {
    return _HourMinuteTextField(
      restorationId: restorationId,
      selectedTime: selectedTime,
      isHour: false,
      inputAction: inputAction,
      style: style,
      semanticHintText:
          minuteLabelText ??
          MaterialLocalizations.of(context).timePickerMinuteLabel,
      validator: validator,
      onSavedSubmitted: onSavedSubmitted,
    );
  }
}

class _HourMinuteTextField extends StatefulWidget {
  const _HourMinuteTextField({
    required this.selectedTime,
    required this.isHour,
    required this.inputAction,
    required this.style,
    required this.semanticHintText,
    required this.validator,
    required this.onSavedSubmitted,
    this.restorationId,
    this.onChanged,
  });

  final TimeOfDay selectedTime;
  final bool isHour;
  final TextInputAction inputAction;
  final TextStyle style;
  final String semanticHintText;
  final FormFieldValidator<String> validator;
  final ValueChanged<String?> onSavedSubmitted;
  final ValueChanged<String>? onChanged;
  final String? restorationId;

  @override
  _HourMinuteTextFieldState createState() => _HourMinuteTextFieldState();
}

class _HourMinuteTextFieldState extends State<_HourMinuteTextField>
    with RestorationMixin {
  final RestorableTextEditingController controller =
      RestorableTextEditingController();
  final RestorableBool controllerHasBeenSet = RestorableBool(false);
  late FocusNode focusNode;

  @override
  void initState() {
    super.initState();
    focusNode =
        FocusNode()..addListener(() {
          setState(() {});
        });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!controllerHasBeenSet.value) {
      controllerHasBeenSet.value = true;
      controller.value.value = TextEditingValue(text: _formattedValue);
    }
  }

  @override
  void dispose() {
    controller.dispose();
    controllerHasBeenSet.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  String? get restorationId => widget.restorationId;

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(controller, 'text_editing_controller');
    registerForRestoration(controllerHasBeenSet, 'has_controller_been_set');
  }

  String get _formattedValue {
    final bool alwaysUse24HourFormat = MediaQuery.alwaysUse24HourFormatOf(
      context,
    );
    final MaterialLocalizations localizations = MaterialLocalizations.of(
      context,
    );
    return !widget.isHour
        ? localizations.formatMinute(widget.selectedTime)
        : localizations.formatHour(
          widget.selectedTime,
          alwaysUse24HourFormat: alwaysUse24HourFormat,
        );
  }

  @override
  Widget build(BuildContext context) {
    final TimePickerThemeData timePickerTheme = TimePickerTheme.of(context);
    final _TimePickerDefaults defaultTheme = _TimePickerDefaultsM3(context);
    final bool alwaysUse24HourFormat = MediaQuery.alwaysUse24HourFormatOf(
      context,
    );

    final InputDecorationTheme inputDecorationTheme =
        timePickerTheme.inputDecorationTheme ??
        defaultTheme.inputDecorationTheme;
    InputDecoration inputDecoration = InputDecoration(
      errorStyle: defaultTheme.inputDecorationTheme.errorStyle,
    ).applyDefaults(inputDecorationTheme);

    final String? hintText = focusNode.hasFocus ? null : _formattedValue;

    final Set<WidgetState> states = <WidgetState>{
      if (focusNode.hasFocus) WidgetState.focused,
      if (focusNode.hasFocus) WidgetState.selected,
    };

    final Color startingFillColor =
        timePickerTheme.inputDecorationTheme?.fillColor ??
        timePickerTheme.hourMinuteColor ??
        defaultTheme.hourMinuteColor;
    final Color fillColor = WidgetStateProperty.resolveAs<Color>(
      WidgetStateColor.resolveWith((state) {
        if (state.contains(WidgetState.focused)) {
          return AppColors.primary;
        }
        return startingFillColor;
      }),
      states,
    );

    final Color effectiveTextColor = WidgetStateProperty.resolveAs<Color>(
      WidgetStateColor.resolveWith((state) {
        if (state.contains(WidgetState.focused)) {
          return Colors.white;
        }
        return timePickerTheme.hourMinuteTextColor ??
            defaultTheme.hourMinuteTextColor;
      }),
      states,
    );

    inputDecoration = inputDecoration.copyWith(
      hintText: hintText,
      fillColor: fillColor,
    );

    final TextStyle effectiveStyle = WidgetStateProperty.resolveAs<TextStyle>(
      widget.style,
      states,
    ).copyWith(color: effectiveTextColor);

    return SizedBox.fromSize(
      size:
          alwaysUse24HourFormat
              ? defaultTheme.hourMinuteInputSize24Hour
              : defaultTheme.hourMinuteInputSize,
      child: MediaQuery.withNoTextScaling(
        child: UnmanagedRestorationScope(
          bucket: bucket,
          child: Semantics(
            label: widget.semanticHintText,
            child: TextFormField(
              restorationId: 'hour_minute_text_form_field',
              expands: true,
              maxLines: null,
              inputFormatters: <TextInputFormatter>[
                LengthLimitingTextInputFormatter(2),
              ],
              focusNode: focusNode,
              textAlign: TextAlign.center,
              textInputAction: widget.inputAction,
              keyboardType: TextInputType.number,
              style: effectiveStyle,
              controller: controller.value,
              decoration: inputDecoration,
              validator: widget.validator,
              onEditingComplete:
                  () => widget.onSavedSubmitted(controller.value.text),
              onSaved: widget.onSavedSubmitted,
              onFieldSubmitted: widget.onSavedSubmitted,
              onChanged: widget.onChanged,
            ),
          ),
        ),
      ),
    );
  }
}

class _TimePickerModel extends InheritedModel<_TimePickerAspect> {
  const _TimePickerModel({
    required this.entryMode,
    required this.hourMinuteMode,
    required this.onHourMinuteModeChanged,
    required this.onHourDoubleTapped,
    required this.onMinuteDoubleTapped,
    required this.selectedTime,
    required this.onSelectedTimeChanged,
    required this.use24HourFormat,
    required this.hourDialType,
    required this.orientation,
    required this.theme,
    required this.defaultTheme,
    required super.child,
  });

  final TimePickerEntryMode entryMode;
  final _HourMinuteMode hourMinuteMode;
  final ValueChanged<_HourMinuteMode> onHourMinuteModeChanged;
  final GestureTapCallback onHourDoubleTapped;
  final GestureTapCallback onMinuteDoubleTapped;
  final TimeOfDay selectedTime;
  final ValueChanged<TimeOfDay> onSelectedTimeChanged;
  final bool use24HourFormat;
  final _HourDialType hourDialType;
  final Orientation orientation;
  final TimePickerThemeData theme;
  final _TimePickerDefaults defaultTheme;

  static _TimePickerModel of(
    BuildContext context, [
    _TimePickerAspect? aspect,
  ]) => InheritedModel.inheritFrom<_TimePickerModel>(context, aspect: aspect)!;
  static TimePickerEntryMode entryModeOf(BuildContext context) =>
      of(context, _TimePickerAspect.entryMode).entryMode;
  static _HourMinuteMode hourMinuteModeOf(BuildContext context) =>
      of(context, _TimePickerAspect.hourMinuteMode).hourMinuteMode;
  static TimeOfDay selectedTimeOf(BuildContext context) =>
      of(context, _TimePickerAspect.selectedTime).selectedTime;
  static bool use24HourFormatOf(BuildContext context) =>
      of(context, _TimePickerAspect.use24HourFormat).use24HourFormat;
  static _HourDialType hourDialTypeOf(BuildContext context) =>
      of(context, _TimePickerAspect.hourDialType).hourDialType;
  static Orientation orientationOf(BuildContext context) =>
      of(context, _TimePickerAspect.orientation).orientation;
  static TimePickerThemeData themeOf(BuildContext context) =>
      of(context, _TimePickerAspect.theme).theme;
  static _TimePickerDefaults defaultThemeOf(BuildContext context) =>
      of(context, _TimePickerAspect.defaultTheme).defaultTheme;

  static void setSelectedTime(BuildContext context, TimeOfDay value) => of(
    context,
    _TimePickerAspect.onSelectedTimeChanged,
  ).onSelectedTimeChanged(value);
  static void setHourMinuteMode(BuildContext context, _HourMinuteMode value) =>
      of(
        context,
        _TimePickerAspect.onHourMinuteModeChanged,
      ).onHourMinuteModeChanged(value);

  @override
  bool updateShouldNotifyDependent(
    _TimePickerModel oldWidget,
    Set<_TimePickerAspect> dependencies,
  ) {
    if (use24HourFormat != oldWidget.use24HourFormat &&
        dependencies.contains(_TimePickerAspect.use24HourFormat)) {
      return true;
    }
    if (entryMode != oldWidget.entryMode &&
        dependencies.contains(_TimePickerAspect.entryMode)) {
      return true;
    }
    if (hourMinuteMode != oldWidget.hourMinuteMode &&
        dependencies.contains(_TimePickerAspect.hourMinuteMode)) {
      return true;
    }
    if (onHourMinuteModeChanged != oldWidget.onHourMinuteModeChanged &&
        dependencies.contains(_TimePickerAspect.onHourMinuteModeChanged)) {
      return true;
    }
    if (onHourMinuteModeChanged != oldWidget.onHourDoubleTapped &&
        dependencies.contains(_TimePickerAspect.onHourDoubleTapped)) {
      return true;
    }
    if (onHourMinuteModeChanged != oldWidget.onMinuteDoubleTapped &&
        dependencies.contains(_TimePickerAspect.onMinuteDoubleTapped)) {
      return true;
    }
    if (hourDialType != oldWidget.hourDialType &&
        dependencies.contains(_TimePickerAspect.hourDialType)) {
      return true;
    }
    if (selectedTime != oldWidget.selectedTime &&
        dependencies.contains(_TimePickerAspect.selectedTime)) {
      return true;
    }
    if (onSelectedTimeChanged != oldWidget.onSelectedTimeChanged &&
        dependencies.contains(_TimePickerAspect.onSelectedTimeChanged)) {
      return true;
    }
    if (orientation != oldWidget.orientation &&
        dependencies.contains(_TimePickerAspect.orientation)) {
      return true;
    }
    if (theme != oldWidget.theme &&
        dependencies.contains(_TimePickerAspect.theme)) {
      return true;
    }
    if (defaultTheme != oldWidget.defaultTheme &&
        dependencies.contains(_TimePickerAspect.defaultTheme)) {
      return true;
    }
    return false;
  }

  @override
  bool updateShouldNotify(_TimePickerModel oldWidget) {
    return use24HourFormat != oldWidget.use24HourFormat ||
        entryMode != oldWidget.entryMode ||
        hourMinuteMode != oldWidget.hourMinuteMode ||
        onHourMinuteModeChanged != oldWidget.onHourMinuteModeChanged ||
        onHourDoubleTapped != oldWidget.onHourDoubleTapped ||
        onMinuteDoubleTapped != oldWidget.onMinuteDoubleTapped ||
        hourDialType != oldWidget.hourDialType ||
        selectedTime != oldWidget.selectedTime ||
        onSelectedTimeChanged != oldWidget.onSelectedTimeChanged ||
        orientation != oldWidget.orientation ||
        theme != oldWidget.theme ||
        defaultTheme != oldWidget.defaultTheme;
  }
}

class _TimePickerHeader extends StatelessWidget {
  const _TimePickerHeader();

  @override
  Widget build(BuildContext context) {
    final TimeOfDayFormat timeOfDayFormat = MaterialLocalizations.of(
      context,
    ).timeOfDayFormat(
      alwaysUse24HourFormat: _TimePickerModel.use24HourFormatOf(context),
    );

    final _HourDialType hourDialType = _TimePickerModel.hourDialTypeOf(context);
    switch (_TimePickerModel.orientationOf(context)) {
      case Orientation.portrait:
        return Row(
          textDirection:
              timeOfDayFormat == TimeOfDayFormat.a_space_h_colon_mm
                  ? TextDirection.rtl
                  : TextDirection.ltr,
          spacing: 12,
          children: [
            Expanded(
              child: Row(
                textDirection: TextDirection.ltr,
                children: [
                  const Expanded(child: _HourControl()),
                  _TimeSelectorSeparator(timeOfDayFormat: timeOfDayFormat),
                  const Expanded(child: _MinuteControl()),
                ],
              ),
            ),
            if (hourDialType == _HourDialType.twelveHour)
              const _DayPeriodControl(),
          ],
        );
      case Orientation.landscape:
        return SizedBox(
          width: _kTimePickerHeaderLandscapeWidth,
          child: Column(
            verticalDirection:
                timeOfDayFormat == TimeOfDayFormat.a_space_h_colon_mm
                    ? VerticalDirection.up
                    : VerticalDirection.down,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 12,
            children: [
              Row(
                textDirection: TextDirection.ltr,
                children: [
                  const Expanded(child: _HourControl()),
                  _TimeSelectorSeparator(timeOfDayFormat: timeOfDayFormat),
                  const Expanded(child: _MinuteControl()),
                ],
              ),
              if (hourDialType == _HourDialType.twelveHour)
                const _DayPeriodControl(),
            ],
          ),
        );
    }
  }
}

Future<void> _announceToAccessibility(
  BuildContext context,
  String message,
) async {
  await SemanticsService.announce(message, Directionality.of(context));
}

class _HourMinuteControl extends StatelessWidget {
  const _HourMinuteControl({
    required this.text,
    required this.onTap,
    required this.onDoubleTap,
    required this.isSelected,
  });

  final String text;
  final GestureTapCallback onTap;
  final GestureTapCallback onDoubleTap;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final TimePickerThemeData timePickerTheme = _TimePickerModel.themeOf(
      context,
    );
    final _TimePickerDefaults defaultTheme = _TimePickerModel.defaultThemeOf(
      context,
    );

    final Set<WidgetState> states = <WidgetState>{
      if (isSelected) WidgetState.selected,
    };
    final Color backgroundColor = WidgetStateProperty.resolveAs<Color>(
      WidgetStateColor.resolveWith((Set<WidgetState> states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.primary;
        }
        return timePickerTheme.hourMinuteColor ?? defaultTheme.hourMinuteColor;
      }),
      states,
    );
    final ShapeBorder shape =
        timePickerTheme.hourMinuteShape ?? defaultTheme.hourMinuteShape;

    final Color effectiveTextColor = WidgetStateProperty.resolveAs<Color>(
      WidgetStateColor.resolveWith((Set<WidgetState> states) {
        if (states.contains(WidgetState.selected)) {
          return Colors.white;
        }
        return _TimePickerModel.themeOf(context).hourMinuteTextColor ??
            _TimePickerModel.defaultThemeOf(context).hourMinuteTextColor;
      }),
      states,
    );
    final TextStyle effectiveStyle = WidgetStateProperty.resolveAs<TextStyle>(
      timePickerTheme.hourMinuteTextStyle ?? defaultTheme.hourMinuteTextStyle,
      states,
    ).copyWith(color: effectiveTextColor);

    final double height;
    switch (_TimePickerModel.entryModeOf(context)) {
      case TimePickerEntryMode.dial:
      case TimePickerEntryMode.dialOnly:
        height = defaultTheme.hourMinuteSize.height;
      case TimePickerEntryMode.input:
      case TimePickerEntryMode.inputOnly:
        height = defaultTheme.hourMinuteInputSize.height;
    }

    return SizedBox(
      height: height,
      child: Material(
        color: WidgetStateProperty.resolveAs(backgroundColor, states),
        clipBehavior: Clip.antiAlias,
        shape: shape,
        child: InkWell(
          onTap: onTap,
          onDoubleTap: isSelected ? onDoubleTap : null,
          child: Center(
            child: Text(
              text,
              style: effectiveStyle,
              textScaler: TextScaler.noScaling,
            ),
          ),
        ),
      ),
    );
  }
}

class _HourControl extends StatelessWidget {
  const _HourControl();

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMediaQuery(context));
    final bool alwaysUse24HourFormat = MediaQuery.alwaysUse24HourFormatOf(
      context,
    );
    final TimeOfDay selectedTime = _TimePickerModel.selectedTimeOf(context);
    final MaterialLocalizations localizations = MaterialLocalizations.of(
      context,
    );
    final String formattedHour = localizations.formatHour(
      selectedTime,
      alwaysUse24HourFormat: _TimePickerModel.use24HourFormatOf(context),
    );

    TimeOfDay hoursFromSelected(int hoursToAdd) {
      switch (_TimePickerModel.hourDialTypeOf(context)) {
        case _HourDialType.twentyFourHour:
        case _HourDialType.twentyFourHourDoubleRing:
          final int selectedHour = selectedTime.hour;
          return selectedTime.replacing(
            hour: (selectedHour + hoursToAdd) % TimeOfDay.hoursPerDay,
          );
        case _HourDialType.twelveHour:
          final int periodOffset = selectedTime.periodOffset;
          final int hours = selectedTime.hourOfPeriod;
          return selectedTime.replacing(
            hour:
                periodOffset + (hours + hoursToAdd) % TimeOfDay.hoursPerPeriod,
          );
      }
    }

    final TimeOfDay nextHour = hoursFromSelected(1);
    final String formattedNextHour = localizations.formatHour(
      nextHour,
      alwaysUse24HourFormat: alwaysUse24HourFormat,
    );
    final TimeOfDay previousHour = hoursFromSelected(-1);
    final String formattedPreviousHour = localizations.formatHour(
      previousHour,
      alwaysUse24HourFormat: alwaysUse24HourFormat,
    );

    return Semantics(
      value: '${localizations.timePickerHourModeAnnouncement} $formattedHour',
      excludeSemantics: true,
      increasedValue: formattedNextHour,
      onIncrease: () {
        _TimePickerModel.setSelectedTime(context, nextHour);
      },
      decreasedValue: formattedPreviousHour,
      onDecrease: () {
        _TimePickerModel.setSelectedTime(context, previousHour);
      },
      child: _HourMinuteControl(
        isSelected:
            _TimePickerModel.hourMinuteModeOf(context) == _HourMinuteMode.hour,
        text: formattedHour,
        onTap:
            Feedback.wrapForTap(
              () => _TimePickerModel.setHourMinuteMode(
                context,
                _HourMinuteMode.hour,
              ),
              context,
            )!,
        onDoubleTap:
            _TimePickerModel.of(
              context,
              _TimePickerAspect.onHourDoubleTapped,
            ).onHourDoubleTapped,
      ),
    );
  }
}

class _TimeSelectorSeparator extends StatelessWidget {
  const _TimeSelectorSeparator({required this.timeOfDayFormat});

  final TimeOfDayFormat timeOfDayFormat;

  String _timeSelectorSeparatorValue(TimeOfDayFormat timeOfDayFormat) {
    switch (timeOfDayFormat) {
      case TimeOfDayFormat.h_colon_mm_space_a:
      case TimeOfDayFormat.a_space_h_colon_mm:
      case TimeOfDayFormat.H_colon_mm:
      case TimeOfDayFormat.HH_colon_mm:
        return ':';
      case TimeOfDayFormat.HH_dot_mm:
        return '.';
      case TimeOfDayFormat.frenchCanadian:
        return 'h';
    }
  }

  @override
  Widget build(BuildContext context) {
    final TimePickerThemeData timePickerTheme = TimePickerTheme.of(context);
    final _TimePickerDefaults defaultTheme = _TimePickerDefaultsM3(context);
    final Set<WidgetState> states = <WidgetState>{};

    final Color effectiveTextColor = WidgetStateProperty.resolveAs<Color>(
      timePickerTheme.timeSelectorSeparatorColor?.resolve(states) ??
          timePickerTheme.hourMinuteTextColor ??
          defaultTheme.timeSelectorSeparatorColor?.resolve(states) ??
          defaultTheme.hourMinuteTextColor,
      states,
    );
    final TextStyle effectiveStyle = WidgetStateProperty.resolveAs<TextStyle>(
      timePickerTheme.timeSelectorSeparatorTextStyle?.resolve(states) ??
          timePickerTheme.hourMinuteTextStyle ??
          defaultTheme.timeSelectorSeparatorTextStyle?.resolve(states) ??
          defaultTheme.hourMinuteTextStyle,
      states,
    ).copyWith(color: effectiveTextColor);

    final double height;
    switch (_TimePickerModel.entryModeOf(context)) {
      case TimePickerEntryMode.dial:
      case TimePickerEntryMode.dialOnly:
        height = defaultTheme.hourMinuteSize.height;
      case TimePickerEntryMode.input:
      case TimePickerEntryMode.inputOnly:
        height = defaultTheme.hourMinuteInputSize.height;
    }

    return ExcludeSemantics(
      child: SizedBox(
        width: timeOfDayFormat == TimeOfDayFormat.frenchCanadian ? 36 : 24,
        height: height,
        child: Text(
          _timeSelectorSeparatorValue(timeOfDayFormat),
          style: effectiveStyle,
          textScaler: TextScaler.noScaling,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class _MinuteControl extends StatelessWidget {
  const _MinuteControl();

  @override
  Widget build(BuildContext context) {
    final MaterialLocalizations localizations = MaterialLocalizations.of(
      context,
    );
    final TimeOfDay selectedTime = _TimePickerModel.selectedTimeOf(context);
    final String formattedMinute = localizations.formatMinute(selectedTime);
    final TimeOfDay nextMinute = selectedTime.replacing(
      minute: (selectedTime.minute + 1) % TimeOfDay.minutesPerHour,
    );
    final String formattedNextMinute = localizations.formatMinute(nextMinute);
    final TimeOfDay previousMinute = selectedTime.replacing(
      minute: (selectedTime.minute - 1) % TimeOfDay.minutesPerHour,
    );
    final String formattedPreviousMinute = localizations.formatMinute(
      previousMinute,
    );

    return Semantics(
      excludeSemantics: true,
      value:
          '${localizations.timePickerMinuteModeAnnouncement} $formattedMinute',
      increasedValue: formattedNextMinute,
      onIncrease: () {
        _TimePickerModel.setSelectedTime(context, nextMinute);
      },
      decreasedValue: formattedPreviousMinute,
      onDecrease: () {
        _TimePickerModel.setSelectedTime(context, previousMinute);
      },
      child: _HourMinuteControl(
        isSelected:
            _TimePickerModel.hourMinuteModeOf(context) ==
            _HourMinuteMode.minute,
        text: formattedMinute,
        onTap:
            Feedback.wrapForTap(
              () => _TimePickerModel.setHourMinuteMode(
                context,
                _HourMinuteMode.minute,
              ),
              context,
            )!,
        onDoubleTap:
            _TimePickerModel.of(
              context,
              _TimePickerAspect.onMinuteDoubleTapped,
            ).onMinuteDoubleTapped,
      ),
    );
  }
}

class _DayPeriodControl extends StatelessWidget {
  const _DayPeriodControl({this.onPeriodChanged});

  final ValueChanged<TimeOfDay>? onPeriodChanged;

  void _togglePeriod(BuildContext context) {
    final TimeOfDay selectedTime = _TimePickerModel.selectedTimeOf(context);
    final int newHour =
        (selectedTime.hour + TimeOfDay.hoursPerPeriod) % TimeOfDay.hoursPerDay;
    final TimeOfDay newTime = selectedTime.replacing(hour: newHour);
    if (onPeriodChanged != null) {
      onPeriodChanged!(newTime);
    } else {
      _TimePickerModel.setSelectedTime(context, newTime);
    }
  }

  void _setAm(BuildContext context) {
    final TimeOfDay selectedTime = _TimePickerModel.selectedTimeOf(context);
    if (selectedTime.period == DayPeriod.am) {
      return;
    }
    switch (Theme.of(context).platform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        unawaited(
          _announceToAccessibility(
            context,
            MaterialLocalizations.of(context).anteMeridiemAbbreviation,
          ),
        );
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        break;
    }
    _togglePeriod(context);
  }

  void _setPm(BuildContext context) {
    final TimeOfDay selectedTime = _TimePickerModel.selectedTimeOf(context);
    if (selectedTime.period == DayPeriod.pm) {
      return;
    }
    switch (Theme.of(context).platform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        unawaited(
          _announceToAccessibility(
            context,
            MaterialLocalizations.of(context).postMeridiemAbbreviation,
          ),
        );
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        break;
    }
    _togglePeriod(context);
  }

  @override
  Widget build(BuildContext context) {
    final MaterialLocalizations materialLocalizations =
        MaterialLocalizations.of(context);
    final TimePickerThemeData timePickerTheme = _TimePickerModel.themeOf(
      context,
    );
    final _TimePickerDefaults defaultTheme = _TimePickerModel.defaultThemeOf(
      context,
    );
    final TimeOfDay selectedTime = _TimePickerModel.selectedTimeOf(context);
    final bool amSelected = selectedTime.period == DayPeriod.am;
    final bool pmSelected = !amSelected;
    final BorderSide resolvedSide =
        timePickerTheme.dayPeriodBorderSide ?? defaultTheme.dayPeriodBorderSide;
    final OutlinedBorder resolvedShape = (timePickerTheme.dayPeriodShape ??
            defaultTheme.dayPeriodShape)
        .copyWith(side: resolvedSide);

    final Widget amButton = _AmPmButton(
      selected: amSelected,
      onPressed: () => _setAm(context),
      label: materialLocalizations.anteMeridiemAbbreviation,
    );

    final Widget pmButton = _AmPmButton(
      selected: pmSelected,
      onPressed: () => _setPm(context),
      label: materialLocalizations.postMeridiemAbbreviation,
    );

    Size dayPeriodSize;
    final Orientation orientation;
    switch (_TimePickerModel.entryModeOf(context)) {
      case TimePickerEntryMode.dial:
      case TimePickerEntryMode.dialOnly:
        orientation = _TimePickerModel.orientationOf(context);
        dayPeriodSize = switch (orientation) {
          Orientation.portrait => defaultTheme.dayPeriodPortraitSize,
          Orientation.landscape => defaultTheme.dayPeriodLandscapeSize,
        };
      case TimePickerEntryMode.input:
      case TimePickerEntryMode.inputOnly:
        orientation = Orientation.portrait;
        dayPeriodSize = defaultTheme.dayPeriodInputSize;
    }

    final Widget result;
    switch (orientation) {
      case Orientation.portrait:
        result = _DayPeriodInputPadding(
          minSize: dayPeriodSize,
          orientation: orientation,
          child: SizedBox.fromSize(
            size: dayPeriodSize,
            child: Material(
              clipBehavior: Clip.antiAlias,
              color: Colors.transparent,
              shape: resolvedShape,
              child: Column(
                children: [
                  Expanded(child: amButton),
                  Container(
                    decoration: BoxDecoration(
                      border: Border(top: resolvedSide),
                    ),
                    height: 1,
                  ),
                  Expanded(child: pmButton),
                ],
              ),
            ),
          ),
        );
      case Orientation.landscape:
        result = _DayPeriodInputPadding(
          minSize: dayPeriodSize,
          orientation: orientation,
          child: SizedBox(
            height: dayPeriodSize.height,
            child: Material(
              clipBehavior: Clip.antiAlias,
              color: Colors.transparent,
              shape: resolvedShape,
              child: Row(
                children: [
                  Expanded(child: amButton),
                  Container(
                    decoration: BoxDecoration(
                      border: Border(left: resolvedSide),
                    ),
                    width: 1,
                  ),
                  Expanded(child: pmButton),
                ],
              ),
            ),
          ),
        );
    }
    return result;
  }
}

class _AmPmButton extends StatelessWidget {
  const _AmPmButton({
    required this.onPressed,
    required this.selected,
    required this.label,
  });

  final bool selected;
  final VoidCallback onPressed;
  final String label;

  @override
  Widget build(BuildContext context) {
    final Set<WidgetState> states = <WidgetState>{
      if (selected) WidgetState.selected,
    };
    final TimePickerThemeData timePickerTheme = _TimePickerModel.themeOf(
      context,
    );
    final _TimePickerDefaults defaultTheme = _TimePickerModel.defaultThemeOf(
      context,
    );
    final Color resolvedBackgroundColor = WidgetStateProperty.resolveAs<Color>(
      WidgetStateColor.resolveWith((Set<WidgetState> states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.primary;
        }
        return Colors.transparent;
      }),
      states,
    );
    final Color resolvedTextColor = WidgetStateProperty.resolveAs<Color>(
      WidgetStateColor.resolveWith((Set<WidgetState> states) {
        if (states.contains(WidgetState.selected)) {
          return Colors.white;
        }
        return timePickerTheme.dayPeriodTextColor ??
            defaultTheme.dayPeriodTextColor;
      }),
      states,
    );
    final TextStyle? resolvedTextStyle =
        WidgetStateProperty.resolveAs<TextStyle?>(
          timePickerTheme.dayPeriodTextStyle ?? defaultTheme.dayPeriodTextStyle,
          states,
        )?.copyWith(color: resolvedTextColor);
    final TextScaler buttonTextScaler = MediaQuery.textScalerOf(
      context,
    ).clamp(maxScaleFactor: 2.0);

    return Material(
      color: resolvedBackgroundColor,
      child: InkWell(
        onTap: Feedback.wrapForTap(onPressed, context),
        child: Semantics(
          checked: selected,
          inMutuallyExclusiveGroup: true,
          button: true,
          child: Center(
            child: Text(
              label,
              style: resolvedTextStyle,
              textScaler: buttonTextScaler,
            ),
          ),
        ),
      ),
    );
  }
}

class _DayPeriodInputPadding extends SingleChildRenderObjectWidget {
  const _DayPeriodInputPadding({
    required Widget super.child,
    required this.minSize,
    required this.orientation,
  });

  final Size minSize;
  final Orientation orientation;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderInputPadding(minSize, orientation);
  }

  @override
  void updateRenderObject(
    BuildContext context,
    covariant _RenderInputPadding renderObject,
  ) {
    renderObject
      ..minSize = minSize
      ..orientation = orientation;
  }
}

class _RenderInputPadding extends RenderShiftedBox {
  _RenderInputPadding(this._minSize, this._orientation, [RenderBox? child])
    : super(child);

  Size get minSize => _minSize;
  Size _minSize;
  set minSize(Size value) {
    if (_minSize == value) {
      return;
    }
    _minSize = value;
    markNeedsLayout();
  }

  Orientation get orientation => _orientation;
  Orientation _orientation;
  set orientation(Orientation value) {
    if (_orientation == value) {
      return;
    }
    _orientation = value;
    markNeedsLayout();
  }

  @override
  double computeMinIntrinsicWidth(double height) {
    if (child != null) {
      return math.max(child!.getMinIntrinsicWidth(height), minSize.width);
    }
    return 0;
  }

  @override
  double computeMinIntrinsicHeight(double width) {
    if (child != null) {
      return math.max(child!.getMinIntrinsicHeight(width), minSize.height);
    }
    return 0;
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    if (child != null) {
      return math.max(child!.getMaxIntrinsicWidth(height), minSize.width);
    }
    return 0;
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    if (child != null) {
      return math.max(child!.getMaxIntrinsicHeight(width), minSize.height);
    }
    return 0;
  }

  Size _computeSize({
    required BoxConstraints constraints,
    required ChildLayouter layoutChild,
  }) {
    if (child != null) {
      final Size childSize = layoutChild(child!, constraints);
      final double width = math.max(childSize.width, minSize.width);
      final double height = math.max(childSize.height, minSize.height);
      return constraints.constrain(Size(width, height));
    }
    return Size.zero;
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    return _computeSize(
      constraints: constraints,
      layoutChild: ChildLayoutHelper.dryLayoutChild,
    );
  }

  @override
  double? computeDryBaseline(
    covariant BoxConstraints constraints,
    TextBaseline baseline,
  ) {
    final RenderBox? child = this.child;
    if (child == null) {
      return null;
    }
    final double? result = child.getDryBaseline(constraints, baseline);
    if (result == null) {
      return null;
    }
    final Size childSize = child.getDryLayout(constraints);
    return result +
        Alignment.center
            .alongOffset(getDryLayout(constraints) - childSize as Offset)
            .dy;
  }

  @override
  void performLayout() {
    size = _computeSize(
      constraints: constraints,
      layoutChild: ChildLayoutHelper.layoutChild,
    );
    if (child != null) {
      final BoxParentData childParentData = child!.parentData! as BoxParentData;
      childParentData.offset = Alignment.center.alongOffset(
        size - child!.size as Offset,
      );
    }
  }

  @override
  bool hitTest(BoxHitTestResult result, {required Offset position}) {
    if (super.hitTest(result, position: position)) {
      return true;
    }

    if (position.dx < 0 ||
        position.dx > math.max(child!.size.width, minSize.width) ||
        position.dy < 0 ||
        position.dy > math.max(child!.size.height, minSize.height)) {
      return false;
    }

    Offset newPosition = child!.size.center(Offset.zero);
    newPosition += switch (orientation) {
      Orientation.portrait when position.dy > newPosition.dy => const Offset(
        0,
        1,
      ),
      Orientation.landscape when position.dx > newPosition.dx => const Offset(
        1,
        0,
      ),
      Orientation.portrait => const Offset(0, -1),
      Orientation.landscape => const Offset(-1, 0),
    };

    return result.addWithRawTransform(
      transform: MatrixUtils.forceToPoint(newPosition),
      position: newPosition,
      hitTest: (BoxHitTestResult result, Offset position) {
        assert(position == newPosition);
        return child!.hitTest(result, position: newPosition);
      },
    );
  }
}

class _TappableLabel {
  _TappableLabel({
    required this.value,
    required this.inner,
    required this.painter,
    required this.onTap,
  });

  final int value;

  final bool inner;

  final TextPainter painter;

  final VoidCallback onTap;
}

enum _HourDialType { twentyFourHour, twentyFourHourDoubleRing, twelveHour }

enum _HourMinuteMode { hour, minute }

enum _TimePickerAspect {
  use24HourFormat,
  entryMode,
  hourMinuteMode,
  onHourMinuteModeChanged,
  onHourDoubleTapped,
  onMinuteDoubleTapped,
  hourDialType,
  selectedTime,
  onSelectedTimeChanged,
  orientation,
  theme,
  defaultTheme,
}

abstract class _TimePickerDefaults extends TimePickerThemeData {
  @override
  Color get backgroundColor;

  @override
  ButtonStyle get cancelButtonStyle;

  @override
  ButtonStyle get confirmButtonStyle;

  @override
  BorderSide get dayPeriodBorderSide;

  @override
  Color get dayPeriodColor;

  @override
  OutlinedBorder get dayPeriodShape;

  Size get dayPeriodInputSize;
  Size get dayPeriodLandscapeSize;
  Size get dayPeriodPortraitSize;

  @override
  Color get dayPeriodTextColor;

  @override
  TextStyle get dayPeriodTextStyle;

  @override
  Color get dialBackgroundColor;

  @override
  Color get dialHandColor;

  Size get dialSize;
  double get handWidth;
  double get dotRadius;
  double get centerRadius;

  @override
  Color get dialTextColor;

  @override
  TextStyle get dialTextStyle;

  @override
  double get elevation;

  @override
  Color get entryModeIconColor;

  @override
  TextStyle get helpTextStyle;

  @override
  Color get hourMinuteColor;

  @override
  ShapeBorder get hourMinuteShape;

  Size get hourMinuteSize;
  Size get hourMinuteSize24Hour;
  Size get hourMinuteInputSize;
  Size get hourMinuteInputSize24Hour;

  @override
  Color get hourMinuteTextColor;

  @override
  TextStyle get hourMinuteTextStyle;

  @override
  InputDecorationTheme get inputDecorationTheme;

  @override
  EdgeInsetsGeometry get padding;

  @override
  ShapeBorder get shape;
}

class _TimePickerDefaultsM3 extends _TimePickerDefaults {
  _TimePickerDefaultsM3(
    this.context, {
    this.entryMode = TimePickerEntryMode.dial,
  });

  final BuildContext context;
  final TimePickerEntryMode entryMode;

  late final ColorScheme _colors = Theme.of(context).colorScheme;
  late final TextTheme _textTheme = Theme.of(context).textTheme;

  @override
  Color get backgroundColor {
    return _colors.surfaceContainerHigh;
  }

  @override
  ButtonStyle get cancelButtonStyle {
    return TextButton.styleFrom();
  }

  @override
  ButtonStyle get confirmButtonStyle {
    return TextButton.styleFrom();
  }

  @override
  BorderSide get dayPeriodBorderSide {
    return BorderSide(color: _colors.outline);
  }

  @override
  Color get dayPeriodColor {
    return WidgetStateColor.resolveWith((Set<WidgetState> states) {
      if (states.contains(WidgetState.selected)) {
        return _colors.tertiaryContainer;
      }

      return Colors.transparent;
    });
  }

  @override
  OutlinedBorder get dayPeriodShape {
    return const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(8.0)),
    ).copyWith(side: dayPeriodBorderSide);
  }

  @override
  Size get dayPeriodPortraitSize {
    return const Size(52, 80);
  }

  @override
  Size get dayPeriodLandscapeSize {
    return const Size(216, 38);
  }

  @override
  Size get dayPeriodInputSize {
    return Size(dayPeriodPortraitSize.width, dayPeriodPortraitSize.height - 8);
  }

  @override
  Color get dayPeriodTextColor {
    return WidgetStateColor.resolveWith((Set<WidgetState> states) {
      if (states.contains(WidgetState.selected)) {
        if (states.contains(WidgetState.focused)) {
          return _colors.onTertiaryContainer;
        }
        if (states.contains(WidgetState.hovered)) {
          return _colors.onTertiaryContainer;
        }
        if (states.contains(WidgetState.pressed)) {
          return _colors.onTertiaryContainer;
        }
        return _colors.onTertiaryContainer;
      }
      if (states.contains(WidgetState.focused)) {
        return _colors.onSurfaceVariant;
      }
      if (states.contains(WidgetState.hovered)) {
        return _colors.onSurfaceVariant;
      }
      if (states.contains(WidgetState.pressed)) {
        return _colors.onSurfaceVariant;
      }
      return _colors.onSurfaceVariant;
    });
  }

  @override
  TextStyle get dayPeriodTextStyle {
    return _textTheme.titleMedium!.copyWith(color: dayPeriodTextColor);
  }

  @override
  Color get dialBackgroundColor {
    return _colors.surfaceContainerHighest;
  }

  @override
  Color get dialHandColor {
    return _colors.primary;
  }

  @override
  Size get dialSize {
    return const Size.square(256.0);
  }

  @override
  double get handWidth {
    return const Size(2, double.infinity).width;
  }

  @override
  double get dotRadius {
    return const Size.square(48.0).width / 2;
  }

  @override
  double get centerRadius {
    return const Size.square(8.0).width / 2;
  }

  @override
  Color get dialTextColor {
    return WidgetStateColor.resolveWith((Set<WidgetState> states) {
      if (states.contains(WidgetState.selected)) {
        return _colors.onPrimary;
      }
      return _colors.onSurface;
    });
  }

  @override
  TextStyle get dialTextStyle {
    return _textTheme.bodyLarge!;
  }

  @override
  double get elevation {
    return 6.0;
  }

  @override
  Color get entryModeIconColor {
    return _colors.onSurface;
  }

  @override
  TextStyle get helpTextStyle {
    return WidgetStateTextStyle.resolveWith((Set<WidgetState> states) {
      final TextStyle textStyle = _textTheme.labelMedium!;
      return textStyle.copyWith(color: _colors.onSurfaceVariant);
    });
  }

  @override
  EdgeInsetsGeometry get padding {
    return const EdgeInsets.all(24);
  }

  @override
  Color get hourMinuteColor {
    return WidgetStateColor.resolveWith((Set<WidgetState> states) {
      if (states.contains(WidgetState.selected)) {
        Color overlayColor = _colors.primaryContainer;
        if (states.contains(WidgetState.pressed)) {
          overlayColor = _colors.onPrimaryContainer;
        } else if (states.contains(WidgetState.hovered)) {
          const double hoverOpacity = 0.08;
          overlayColor = _colors.onPrimaryContainer.withValues(
            alpha: hoverOpacity,
          );
        } else if (states.contains(WidgetState.focused)) {
          const double focusOpacity = 0.1;
          overlayColor = _colors.onPrimaryContainer.withValues(
            alpha: focusOpacity,
          );
        }
        return Color.alphaBlend(overlayColor, _colors.primaryContainer);
      } else {
        Color overlayColor = _colors.surfaceContainerHighest;
        if (states.contains(WidgetState.pressed)) {
          overlayColor = _colors.onSurface;
        } else if (states.contains(WidgetState.hovered)) {
          const double hoverOpacity = 0.08;
          overlayColor = _colors.onSurface.withValues(alpha: hoverOpacity);
        } else if (states.contains(WidgetState.focused)) {
          const double focusOpacity = 0.1;
          overlayColor = _colors.onSurface.withValues(alpha: focusOpacity);
        }
        return Color.alphaBlend(overlayColor, _colors.surfaceContainerHighest);
      }
    });
  }

  @override
  ShapeBorder get hourMinuteShape {
    return const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(8.0)),
    );
  }

  @override
  Size get hourMinuteSize {
    return const Size(96, 80);
  }

  @override
  Size get hourMinuteSize24Hour {
    return Size(const Size(114, double.infinity).width, hourMinuteSize.height);
  }

  @override
  Size get hourMinuteInputSize {
    return Size(hourMinuteSize.width, hourMinuteSize.height - 8);
  }

  @override
  Size get hourMinuteInputSize24Hour {
    return Size(hourMinuteSize24Hour.width, hourMinuteSize24Hour.height - 8);
  }

  @override
  Color get hourMinuteTextColor {
    return WidgetStateColor.resolveWith((Set<WidgetState> states) {
      return _hourMinuteTextColor.resolve(states);
    });
  }

  WidgetStateProperty<Color> get _hourMinuteTextColor {
    return WidgetStateProperty.resolveWith((Set<WidgetState> states) {
      if (states.contains(WidgetState.selected)) {
        if (states.contains(WidgetState.pressed)) {
          return _colors.onPrimaryContainer;
        }
        if (states.contains(WidgetState.hovered)) {
          return _colors.onPrimaryContainer;
        }
        if (states.contains(WidgetState.focused)) {
          return _colors.onPrimaryContainer;
        }
        return _colors.onPrimaryContainer;
      } else {
        if (states.contains(WidgetState.pressed)) {
          return _colors.onSurface;
        }
        if (states.contains(WidgetState.hovered)) {
          return _colors.onSurface;
        }
        if (states.contains(WidgetState.focused)) {
          return _colors.onSurface;
        }
        return _colors.onSurface;
      }
    });
  }

  @override
  TextStyle get hourMinuteTextStyle {
    return WidgetStateTextStyle.resolveWith((Set<WidgetState> states) {
      return switch (entryMode) {
        TimePickerEntryMode.dial || TimePickerEntryMode.dialOnly => _textTheme
            .displayLarge!
            .copyWith(color: _hourMinuteTextColor.resolve(states)),
        TimePickerEntryMode.input || TimePickerEntryMode.inputOnly => _textTheme
            .displayMedium!
            .copyWith(color: _hourMinuteTextColor.resolve(states)),
      };
    });
  }

  @override
  InputDecorationTheme get inputDecorationTheme {
    final BorderRadius selectorRadius = const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(8.0)),
    ).borderRadius.resolve(Directionality.of(context));
    return InputDecorationTheme(
      contentPadding: EdgeInsets.zero,
      filled: true,

      fillColor: hourMinuteColor,

      focusColor: _colors.primaryContainer,
      enabledBorder: OutlineInputBorder(
        borderRadius: selectorRadius,
        borderSide: const BorderSide(color: Colors.transparent),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: selectorRadius,
        borderSide: BorderSide(color: _colors.error, width: 2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: selectorRadius,
        borderSide: BorderSide(color: _colors.primary, width: 2),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: selectorRadius,
        borderSide: BorderSide(color: _colors.error, width: 2),
      ),
      hintStyle: hourMinuteTextStyle.copyWith(
        color: _colors.onSurface.withValues(alpha: 0.36),
      ),

      errorStyle: const TextStyle(fontSize: 0),
    );
  }

  @override
  ShapeBorder get shape {
    return const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(28.0)),
    );
  }

  @override
  WidgetStateProperty<Color?>? get timeSelectorSeparatorColor {
    return WidgetStatePropertyAll<Color>(_colors.onSurface);
  }

  @override
  WidgetStateProperty<TextStyle?>? get timeSelectorSeparatorTextStyle {
    return WidgetStatePropertyAll<TextStyle?>(_textTheme.displayLarge);
  }
}
