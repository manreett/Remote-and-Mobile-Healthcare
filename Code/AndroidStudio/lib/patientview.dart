import 'package:flutter/material.dart';
import 'package:greaterhealth/main.dart';
import 'LoginPage.dart';
import 'user.dart';
import 'package:http/http.dart' as http;
import 'package:mysql1/mysql1.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class BloodOxygenLevelGraph extends StatelessWidget {
  final List<int> irValues;
  final List<int> redValues;
  final List<DateTime> timestamps;

  BloodOxygenLevelGraph({
    required this.irValues,
    required this.redValues,
    required this.timestamps,
  });

  @override
  Widget build(BuildContext context) {
    final data = <BloodOxygenLevel>[];

    double sum = 0;
    for (int i = 0; i < irValues.length; i++) {
      final oxygenLevel = calculateOxygenLevel(irValues[i], redValues[i]);
      sum += oxygenLevel;
      data.add(BloodOxygenLevel(timestamps[i], oxygenLevel));
    }

    final avg = sum / irValues.length;

    final seriesList = <charts.Series<BloodOxygenLevel, DateTime>>[
      charts.Series<BloodOxygenLevel, DateTime>(
        id: 'Blood Oxygen Level',
        colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
        domainFn: (BloodOxygenLevel level, _) => level.timestamp,
        measureFn: (BloodOxygenLevel level, _) => level.oxygenLevel,
        data: data,
      ),
    ];
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    final chartHeight = screenHeight * 0.4; // adjust this as needed
    final chartWidth = screenWidth * 0.9;
    return SizedBox(
      height: chartHeight,
      width: chartWidth,
      child: Stack(
        children: [
          charts.TimeSeriesChart(
            seriesList,
            animate: true,
            dateTimeFactory: const charts.LocalDateTimeFactory(),
            defaultRenderer: charts.LineRendererConfig(
              includeArea: true,
              stacked: true,
            ),
            primaryMeasureAxis: charts.NumericAxisSpec(
              tickProviderSpec: const charts.BasicNumericTickProviderSpec(
                zeroBound: false,
                dataIsInWholeNumbers: false,
              ),
            ),
            behaviors: [
              charts.ChartTitle(
                'Time',
                behaviorPosition: charts.BehaviorPosition.bottom,
                titleOutsideJustification:
                    charts.OutsideJustification.middleDrawArea,
                innerPadding: 18,
              ),
              charts.ChartTitle(
                ' Blood Oxygen %',
                behaviorPosition: charts.BehaviorPosition.start,
                titleOutsideJustification:
                    charts.OutsideJustification.middleDrawArea,
                innerPadding: 18,
              ),
            ],
          ),
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              margin: const EdgeInsets.all(8),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4,
                  )
                ],
              ),
              child: Text(
                'Average: ${avg.toStringAsFixed(2)}%',
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  double calculateOxygenLevel(int irValue, int redValue) {
    // Implementation of oxygen level calculation
    final ratio = redValue / irValue;
    if (ratio > 1) {
      return -1.0;
    } else {
      return (1 - ratio) * 100;
    }
  }
}

class BloodOxygenLevel {
  final DateTime timestamp;
  final double oxygenLevel;

  BloodOxygenLevel(this.timestamp, this.oxygenLevel);
}

class ECGChart extends StatelessWidget {
  final List<int> ecgData;
  final List<DateTime> ecgTimestamps;

  ECGChart({required this.ecgData, required this.ecgTimestamps});

  @override
  Widget build(BuildContext context) {
    List<charts.Series<EcgDataPoint, DateTime>> seriesList = [
      charts.Series<EcgDataPoint, DateTime>(
        id: 'ECG',
        colorFn: (_, __) => charts.MaterialPalette.deepOrange.shadeDefault,
        domainFn: (datum, _) => datum.time,
        measureFn: (datum, _) => datum.value,
        data: List.generate(
          ecgData.length,
          (i) => EcgDataPoint(
            time: ecgTimestamps[i],
            value: ecgData[i].toDouble(),
          ),
        ),
      ),
    ];
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;

    final chartHeight = screenHeight * 0.4; // adjust this as needed
    final chartWidth = screenWidth * 0.9; // adjust this as needed

    final DateTime firstDate = ecgTimestamps.first;
    final DateTime lastDate = ecgTimestamps.last;

    return SizedBox(
      height: chartHeight,
      width: chartWidth,
      child: charts.TimeSeriesChart(
        seriesList,
        animate: true,
        primaryMeasureAxis: charts.NumericAxisSpec(
          tickProviderSpec: charts.BasicNumericTickProviderSpec(
            zeroBound: false,
            dataIsInWholeNumbers: false,
          ),
        ),
        behaviors: [
          charts.ChartTitle(
            'Time (Dates)',
            behaviorPosition: charts.BehaviorPosition.bottom,
            titleOutsideJustification:
                charts.OutsideJustification.middleDrawArea,
            innerPadding: 18,
          ),
          charts.ChartTitle(
            'ECG (mV)',
            behaviorPosition: charts.BehaviorPosition.start,
            titleOutsideJustification:
                charts.OutsideJustification.middleDrawArea,
            innerPadding: 18,
          ),
        ],
        domainAxis: charts.DateTimeAxisSpec(
          tickFormatterSpec: charts.AutoDateTimeTickFormatterSpec(
            day: charts.TimeFormatterSpec(
              format: 'd',
              transitionFormat: 'MM/dd',
            ),
            hour: charts.TimeFormatterSpec(
              format: 'H',
              transitionFormat: 'MM/dd H',
            ),
            minute: charts.TimeFormatterSpec(
              format: 'm',
              transitionFormat: 'MM/dd H:m',
            ),
          ),
          viewport: charts.DateTimeExtents(
            start: firstDate,
            end: lastDate,
          ),
        ),
      ),
    );
  }
}

class EcgDataPoint {
  final DateTime time;
  final double value;

  EcgDataPoint({required this.time, required this.value});
}

class patientview extends StatefulWidget {
  // change to StatefulWidget
  final User user;

  const patientview({Key? key, required this.user}) : super(key: key);

  @override
  _PatientViewState createState() => _PatientViewState();
}

class _PatientViewState extends State<patientview> {
  late List<EcgDataPoint> _ecgDataPoints;

  bool _showLastThreeDays = true;

  List<int> get _ecgData {
    if (_showLastThreeDays) {
      return widget.user.ecg.sublist(widget.user.ecg.length - 5);
    } else {
      return widget.user.ecg;
    }
  }

  List<DateTime> get _ecgTimestamps {
    if (_showLastThreeDays) {
      return widget.user.ecg_ts.sublist(widget.user.ecg_ts.length - 5);
    } else {
      return widget.user.ecg_ts;
    }
  }

  @override
  void initState() {
    super.initState();
    _ecgDataPoints = _generateEcgDataPoints(_ecgData, _ecgTimestamps);
  }

  @override
  Widget build(BuildContext context) {
    double avgBPM =
        widget.user.bpm.reduce((a, b) => a + b) / widget.user.bpm.length;

    double oxygenSaturation = 0.0;
    void calculateOxygenSaturation() {
      setState(() {});
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Patient View"),
      ),
      body: Column(
        children: [
          Text(
            "Patient Name: ${widget.user.name}",
            style: TextStyle(fontSize: 16),
          ),
          InkWell(
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return Container(
                    height: 400,
                    child: Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            itemCount: widget.user.bpm.length,
                            itemBuilder: (BuildContext context, int index) {
                              return ListTile(
                                title: Text(
                                    'BPM ${widget.user.bpm_ts[index]}  |  ${widget.user.bpm[index]}'),
                              );
                            },
                          ),
                        ),
                        SizedBox(
                          height: 50,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text('Exit'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
            child: Text(
              'Average BPM: ${avgBPM.toStringAsFixed(0)}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 10),
          BloodOxygenLevelGraph(
            irValues: widget.user.ir_val,
            redValues: widget.user.red_val,
            timestamps: widget.user.ppg_time,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () {
                  setState(() {
                    _showLastThreeDays = true;
                    _ecgDataPoints =
                        _generateEcgDataPoints(_ecgData, _ecgTimestamps);
                  });
                },
                child: Text("Last 3 days"),
              ),
              SizedBox(width: 20),
              TextButton(
                onPressed: () {
                  setState(() {
                    _showLastThreeDays = false;
                    _ecgDataPoints =
                        _generateEcgDataPoints(_ecgData, _ecgTimestamps);
                  });
                },
                child: Text("Whole week"),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return Container(
                        height: 400,
                        child: Column(
                          children: [
                            Expanded(
                              child: ListView.builder(
                                itemCount: widget.user.ir_val.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return ListTile(
                                    title: Text(
                                        'IR ${widget.user.ir_val[index]}  |  RED ${widget.user.red_val[index]}'),
                                  );
                                },
                              ),
                            ),
                            SizedBox(
                              height: 50,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text('Exit'),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
                child: Text("BO Readings"),
              ),
              SizedBox(width: 20),
              TextButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return Container(
                        height: 400,
                        child: Column(
                          children: [
                            Expanded(
                              child: ListView.builder(
                                itemCount: widget.user.ecg.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return ListTile(
                                    title: Text(
                                        'ECG ${widget.user.ecg_ts[index]}  |  ${widget.user.ecg[index]}'),
                                  );
                                },
                              ),
                            ),
                            SizedBox(
                              height: 50,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text('Exit'),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
                child: Text("ECG Readings"),
              ),
            ],
          ),
          Expanded(
            child: Column(
              children: [
                Container(
                  height: 50, // or any other desired height
                  child: Center(),
                ),
                Expanded(
                  child: ECGChart(
                    ecgData: _ecgData,
                    ecgTimestamps: _ecgTimestamps,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<EcgDataPoint> _generateEcgDataPoints(
      List<int> ecgData, List<DateTime> ecgTimestamps) {
    List<EcgDataPoint> ecgDataPoints = [];
    for (int i = 0; i < ecgData.length; i++) {
      ecgDataPoints.add(
          EcgDataPoint(time: ecgTimestamps[i], value: ecgData[i].toDouble()));
    }
    return ecgDataPoints;
  }
}
