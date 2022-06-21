import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

late final List<Widget> ticMarks;

void main() => runApp(MyApp());

// This Widget is the main application widget.
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: _MySliderApp(),
    );
  }
}

class _MySliderApp extends StatefulWidget {
  const _MySliderApp({Key? key}) : super(key: key);

  @override
  _MySliderAppState createState() => _MySliderAppState();
}

class _MySliderAppState extends State<_MySliderApp> {
  final _sliderExponentialValues = <int>[];
  double _floatIndexSlider = 0;
  String _dollarsSlider = '\$0';

  final _thumbValues = <int>[];
  int _valueThumb = 6;
  String _dollarsThumb = '\$0';

  bool isExponentialScale = true;

  void setSliderValues({required bool isExponentialScale}) {
    _sliderExponentialValues.clear();
    _sliderExponentialValues.add(0);
    final List<int> sliderExponentialValues;
    if (isExponentialScale) {
      sliderExponentialValues = _generateExponentialValues(increment: 1000);
    } else {
      sliderExponentialValues = _generateFixedValues(increment: 100000);
    }
    _sliderExponentialValues.addAll(sliderExponentialValues);
    _floatIndexSlider = 0;
    _updateDollarSlider();
  }

  void setThumbValues() {
    // thumb wheel
    _thumbValues.clear();
    List<int> thumbValues = _generateExponentialValues(increment: 100);
    _thumbValues.addAll(thumbValues);
    int ticCount = _thumbValues.length;
    ticMarks = List.generate(ticCount, (index) => Text(' | ', style: TextStyle(fontSize: 30)));
  }

  void _onSwitch(bool value) {
    setState(() {
      isExponentialScale = !isExponentialScale;
    });
    setSliderValues(isExponentialScale: isExponentialScale);
  }

  void _updateDollarSlider() {
    int value = _sliderExponentialValues[_floatIndexSlider.toInt()];
    _dollarsSlider = NumberFormat('\$#,###,###').format(value);
  }

  List<int> _generateExponentialValues({required int increment}) {
    final values = List.generate(10, (index) => index * 100);
    int start = 1000;
    int end = 10000;
    while (start < 10000000) {
      for (int j = start; j < end; j += increment) {
        values.add(j);
      }
      increment *= 10;
      start *= 10;
      end *= 10;
    }
    values.add(start);
    return values;
  }

  List<int> _generateFixedValues({required int increment}) {
    int count = (10000000 / increment).round() + 1;
    return List.generate(count, (index) => index * increment);
  }

  @override
  void initState() {
    super.initState();
    setSliderValues(isExponentialScale: isExponentialScale);
    setThumbValues();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NWC Slider Demo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Center(
          child: Column(
              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              // mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  _dollarsSlider,
                  textAlign: TextAlign.center,
                  // overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 60, fontWeight: FontWeight.bold),
                ),
                Slider(
                    value: _floatIndexSlider,
                    min: 0.0,
                    max: _sliderExponentialValues.length.toDouble() - 1,
                    divisions: _sliderExponentialValues.length,
                    activeColor: Colors.black,
                    inactiveColor: Colors.grey,
                    // label: '${_floatIndex.toInt()} $_dollars',
                    onChanged: (double newValue) {
                      setState(() {
                        _floatIndexSlider = newValue;
                        _updateDollarSlider();
                      });
                    },
                    semanticFormatterCallback: (double newValue) {
                      return '${newValue.round()} dollars';
                    }),
                Text(
                  _dollarsThumb,
                  textAlign: TextAlign.center,
                  // overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 60, fontWeight: FontWeight.bold),
                ),
                CarouselSlider(
                  items: ticMarks,
                  options: CarouselOptions(
                    // autoPlay: true,
                    // height: 40,
                    // aspectRatio: 100.0,
                    // enlargeCenterPage: true,
                    // enableInfiniteScroll: false,
                    onPageChanged: (int index, CarouselPageChangedReason _) {
                      final valueIndex = _thumbValues.length - index - 1;
                      setState(() {
                        _valueThumb = _thumbValues[valueIndex];
                        _dollarsThumb = NumberFormat('\$#,###,###').format(_valueThumb);
                      });
                    },
                    pageSnapping: false,
                    viewportFraction: .02,
                  ),
                ),
                Row(
                  children: [
                    Spacer(),
                    Text('FIXED'),
                    Switch(
                      value: isExponentialScale,
                      onChanged: _onSwitch,
                    ),
                    Text('EXPONENTIAL'),
                    Spacer(),
                  ],
                ),
              ]),
        ),
      ),
    );
  }
}
