class API {
  
  // static const hostName = "http://localhost:3000";
  static const hostName = "http://localhost:3000";
  
  static const pengguna     = "$hostName/pengguna";
  static const infoAplikasi = "$hostName/info_aplikasi";
  static const pengaduan    = "$hostName/pengaduan";
  static const contact      = "$hostName/contact";


  // PENGGUNA
  static const createPengguna         = "$pengguna/create.php";
  static const readPengguna           = "$pengguna/read.php";

  // INFO APLIKASI
  static const createInfoAplikasi     = "$infoAplikasi/create.php";
  static const readInfoAplikasi       = "$infoAplikasi/read.php";
  static const updateInfoAplikasi     = "$infoAplikasi/update.php";
  static const deleteInfoAplikasi     = "$infoAplikasi/delete.php";

  // PENGADUAN
  static const createPengaduan     = "$pengaduan/create.php";
  static const readPengaduan       = "$pengaduan/read.php";
  static const updatePengaduan     = "$pengaduan/update.php";
  static const deletePengaduan     = "$pengaduan/delete.php";

  // KONTAK
  static const createContact      = "$contact/create.php";
  static const readContact        = "$contact/read.php";
  static const readByIdContact    = "$contact/readByIdContact.php";
  static const updateContact      = "$contact/update.php";
  static const deleteAllContact   = "$contact/delete_all.php";
  static const deleteByIdContact  = "$contact/deleteByIdContact.php";
}