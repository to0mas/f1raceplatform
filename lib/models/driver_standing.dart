

class DriverStanding {

final int position;
final String driverCode;


DriverStanding({
  required this.position,
  required this.driverCode,

});

factory DriverStanding.fromJson(Map<String, dynamic> json) {
  return DriverStanding(
    position: int.parse(json['position']),
    driverCode: json['Driver']['code'],//název klíče v JSON odpovědi z API
  );

}
}