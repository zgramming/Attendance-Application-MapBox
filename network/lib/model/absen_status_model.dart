class AbsensiStatusModel {
  AbsensiStatusModel({
    this.tanggalAbsen,
    this.status,
  });
  factory AbsensiStatusModel.fromJson(Map<String, dynamic> json) {
    return AbsensiStatusModel(
      tanggalAbsen: DateTime.parse(json['tanggal_absen']),
      status: json['status'],
    );
  }
  DateTime tanggalAbsen;
  String status;

  Map<String, dynamic> toJson() => {
        'tanggal_absen':
            '${tanggalAbsen.year.toString().padLeft(4, '0')}-${tanggalAbsen.month.toString().padLeft(2, '0')}-${tanggalAbsen.day.toString().padLeft(2, '0')}',
        'status': status,
      };
}
