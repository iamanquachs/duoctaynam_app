class Filter {
  List groupproduct;
  List producer;
  List country;
  List standard;
  Filter(
      {required this.groupproduct,
      required this.producer,
      required this.country,required this.standard});
  Map<String, dynamic> toJson() {
    return {
      "groupproduct": groupproduct,
      "producer": producer,
      "country": country,
      "standard": standard,
    };
  }
}
