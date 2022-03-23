class Order {
  late String docID;
  late String pickUpDate;
  late String dropOffDate;
  late String pickUpLocation;
  late String dropOffLocation;
  late String timeStamp;
  late String placedBy;
  late String paidAmount;
  late String car;

  Order.fromData(
      {required Map<String, dynamic> orderData, required String? id}) {
    docID = id!;
    car = orderData["car"];
    paidAmount = orderData["paidAmount"];
    pickUpDate = orderData["pickUpDate"];
    dropOffDate = orderData["dropOffDate"];
    pickUpLocation = orderData["pickUpLocation"];
    dropOffLocation = orderData["dropOffLocation"];
    timeStamp = orderData["timestamp"];
    placedBy = orderData["placedBy"];
  }

  Order({
    required this.docID,
    required this.pickUpDate,
    required this.dropOffDate,
    required this.pickUpLocation,
    required this.dropOffLocation,
    required this.timeStamp,
    required this.placedBy,
  });

  Map<String, dynamic> get toJson => {
        "docID": docID,
        "pickUpDate": pickUpDate,
        "dropOffDate": dropOffDate,
        "pickUpLocation": pickUpLocation,
        "dropOffLocation": dropOffLocation,
        "timeStamp": timeStamp,
        "placedBy": placedBy,
      };
}
