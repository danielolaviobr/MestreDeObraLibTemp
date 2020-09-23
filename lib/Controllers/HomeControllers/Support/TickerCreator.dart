import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

// ! TODO Remove if not needed
class TickerCreator implements TickerProvider {
  @override
  Ticker createTicker(void Function(Duration elapsed) onTick) => Ticker(onTick);
}
