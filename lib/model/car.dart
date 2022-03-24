class Car {
  late String docID;
  late String type;
  late String brand;
  late String numberOfSeats;
  late String mileage;
  late String ratePerDay;
  late String registrationNumber;
  late String coverPicUrl;
  late List picsUrl;

  Car.fromData({required Map<String, dynamic> carData, required String? id}) {
    docID = id!;
    type = carData["type"];
    brand = carData["brand"];
    numberOfSeats = carData["numberOfSeats"];
    mileage = carData["mileage"];
    ratePerDay = carData["ratePerDay"];
    registrationNumber = carData["registrationNumber"];
    coverPicUrl = carData["coverPicUrl"];
    picsUrl = carData["picsUrl"];
  }

  Car({
    required this.docID,
    required this.type,
    required this.brand,
    required this.numberOfSeats,
    required this.mileage,
    required this.ratePerDay,
    required this.registrationNumber,
    required this.coverPicUrl,
    required this.picsUrl,
  });

  Map<String, dynamic> get toJson => {
        "docID": docID,
        "type": type,
        "brand": brand,
        "numberOfSeats": numberOfSeats,
        "mileage": mileage,
        "ratePerDay": ratePerDay,
        "registrationNumber": registrationNumber,
        "coverPicUrl": coverPicUrl,
        "picsUrl": picsUrl,
      };
}
