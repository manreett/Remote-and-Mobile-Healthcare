class User {
  String name;
  String? email;
  String? password; // making password optional using null-safety feature
  List<int> bpm;
  List<DateTime> bpm_ts;
  List<int> ecg;
  List<DateTime> ecg_ts;
  List<int> ir_val;
  List<int> red_val;
  List<DateTime> ppg_time;

  User({
    required this.name,
    this.email,
    this.password, // making password optional using curly braces {}
    required this.bpm,
    required this.bpm_ts,
    required this.ecg,
    required this.ecg_ts,
    required this.ir_val,
    required this.red_val,
    required this.ppg_time,
  });
}
