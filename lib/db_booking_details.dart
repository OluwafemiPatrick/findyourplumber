class BookingDetails {
  String typeOfService;
  String location;
  String fitting;
  String description;
  String date;
  String time;
  String servicePrice;
  String maxPrice;
  String minPrice;

  BookingDetails(
      this.typeOfService,
      this.location,
      this.fitting,
      this.description,
      this.date,
      this.time,
      this.servicePrice,
      this.maxPrice,
      this.minPrice);

  Map<String, dynamic> toJson() => {
        'Service': typeOfService,
        'Location': location,
        'Fitting': fitting,
        'Description': description,
        'Date': date,
        'Time': time,
        'Estimated Price': servicePrice,
        'Max Price': maxPrice,
        'Min Price': minPrice,
      };
}
