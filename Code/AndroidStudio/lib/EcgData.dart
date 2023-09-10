// TODO Implement this library.
class EcgData {
  final String timestamp;
  final double ecgValue;

  EcgData(this.timestamp, this.ecgValue);
}

List<EcgData> ecgData = [
  EcgData("00:00", 1.0),
  EcgData("00:01", 2.0),
  EcgData("00:02", 1.5),
  EcgData("00:03", 3.0),
  EcgData("00:04", 2.5),
  EcgData("00:05", 2.0),
  EcgData("00:06", 1.5),
  EcgData("00:07", 2.0),
  EcgData("00:08", 2.5),
  EcgData("00:09", 1.0),
];
