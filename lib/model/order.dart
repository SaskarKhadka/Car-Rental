class Order {
  late String docID;
  late String pickUpDate;
  late String dropOffDate;
  late String pickUpTime;
  late String dropOffTime;
  late String pickUpLocation;
  late String dropOffLocation;
  late String timeStamp;
  late String placedBy;
  // late String paidAmount;
  late String car;
  late String bargain;
  late String endBargain;

  Order.fromData(
      {required Map<String, dynamic> orderData, required String? id}) {
    docID = id!;
    car = orderData["car"];
    // paidAmount = orderData["paidAmount"] ?? "0";
    pickUpDate = orderData["pickUpDate"];
    dropOffDate = orderData["dropOffDate"];
    pickUpTime = orderData["pickUpTime"];
    dropOffTime = orderData["dropOffTime"];
    pickUpLocation = orderData["pickUpLocation"];
    dropOffLocation = orderData["dropOffLocation"];
    timeStamp = orderData["timestamp"];
    placedBy = orderData["placedBy"];
    bargain = orderData["bargain"] ?? "";
    endBargain = orderData["endBargain"] ?? "";
  }

  Order({
    required this.docID,
    required this.pickUpDate,
    required this.dropOffDate,
    required this.pickUpLocation,
    required this.dropOffLocation,
    required this.timeStamp,
    required this.placedBy,
    required this.bargain,
    required this.endBargain,
    required this.dropOffTime,
    required this.car,
    // required this.paidAmount,
    required this.pickUpTime,
  });

  Map<String, dynamic> get toJson => {
        "docID": docID,
        "pickUpDate": pickUpDate,
        "dropOffDate": dropOffDate,
        "pickUpLocation": pickUpLocation,
        "dropOffLocation": dropOffLocation,
        "timeStamp": timeStamp,
        "placedBy": placedBy,
        "bargain": bargain,
        "endBargain": endBargain,
        "car": car,
        "pickUpTime": pickUpTime,
        "dropOffTime": dropOffTime,
      };
}
