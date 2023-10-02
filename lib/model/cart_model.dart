class ListCart {
  final String rowid;
  final String mshh;
  final String tenhh;
  final String giagoc;
  final String dvt;
  final String soluong;
  final String thanhtien;
  final String ptgiam;
  final String thanhtienvat;
  final String path_image;
  final String spctkm;

  ListCart({
    required this.rowid,
    required this.mshh,
    required this.tenhh,
    required this.giagoc,
    required this.dvt,
    required this.soluong,
    required this.thanhtien,
    required this.ptgiam,
    required this.thanhtienvat,
    required this.path_image,
    required this.spctkm,
  });
}

class TienTichLuy {
  final String sotien;

  TienTichLuy({
    required this.sotien,
  });
}

class ListVoucher {
  final String mavoucher;
  final String tenvoucher;
  final String sotien;
  final String mabaomat;
  final String loai;
  final String trangthai;

  ListVoucher({
    required this.mavoucher,
    required this.tenvoucher,
    required this.sotien,
    required this.mabaomat,
    required this.loai,
    required this.trangthai,
  });
}
