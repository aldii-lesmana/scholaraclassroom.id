-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Waktu pembuatan: 30 Agu 2026 pada 18.27
-- Versi server: 10.4.32-MariaDB
-- Versi PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `sistem_penjualan`
--

-- --------------------------------------------------------

--
-- Struktur dari tabel `detail_pesanan`
--

CREATE TABLE `detail_pesanan` (
  `id` int(11) NOT NULL,
  `pesanan_id` int(11) NOT NULL,
  `produk_id` int(11) NOT NULL,
  `jumlah` int(11) NOT NULL,
  `harga_satuan` decimal(15,2) NOT NULL,
  `subtotal` decimal(15,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `detail_pesanan`
--

INSERT INTO `detail_pesanan` (`id`, `pesanan_id`, `produk_id`, `jumlah`, `harga_satuan`, `subtotal`) VALUES
(4, 4, 49, 1, 10000.00, 10000.00),
(5, 5, 103, 1, 10000.00, 10000.00);

-- --------------------------------------------------------

--
-- Struktur dari tabel `kategori`
--

CREATE TABLE `kategori` (
  `id` int(11) NOT NULL,
  `nama` varchar(50) NOT NULL,
  `deskripsi` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `notifikasi`
--

CREATE TABLE `notifikasi` (
  `id` int(11) NOT NULL,
  `pelanggan_id` int(11) NOT NULL,
  `pesanan_id` int(11) NOT NULL,
  `no_pesanan` varchar(20) DEFAULT NULL,
  `pesan` varchar(255) DEFAULT NULL,
  `status_baru` varchar(30) DEFAULT NULL,
  `is_read` tinyint(1) DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `notifikasi`
--

INSERT INTO `notifikasi` (`id`, `pelanggan_id`, `pesanan_id`, `no_pesanan`, `pesan`, `status_baru`, `is_read`, `created_at`) VALUES
(1, 5, 4, 'ORD20260821232505', 'Pesanan kamu sedang diproses oleh toko! ⚙️', 'diproses', 1, '2026-08-21 17:42:46'),
(2, 5, 4, 'ORD20260821232505', 'Pesanan kamu sedang diproses oleh toko! ⚙️', 'diproses', 1, '2026-08-21 17:51:55'),
(3, 5, 4, 'ORD20260821232505', 'Pesanan kamu sedang diproses oleh toko! ⚙️', 'diproses', 1, '2026-08-21 18:05:33'),
(4, 5, 4, 'ORD20260821232505', 'Pesanan kamu sedang diproses oleh toko! ⚙️', 'diproses', 1, '2026-08-21 18:13:48'),
(5, 5, 4, 'ORD20260821232505', 'Pesanan kamu sedang diproses oleh toko! ⚙️', 'diproses', 1, '2026-08-21 18:19:27'),
(6, 5, 4, 'ORD20260821232505', 'Pesanan kamu telah sampai! 🎉 Terima kasih sudah belanja di sini.', 'selesai', 0, '2026-08-22 16:25:18');

-- --------------------------------------------------------

--
-- Struktur dari tabel `pelanggan`
--

CREATE TABLE `pelanggan` (
  `id` int(11) NOT NULL,
  `kode_pelanggan` varchar(20) NOT NULL,
  `nama` varchar(100) NOT NULL,
  `email` varchar(100) DEFAULT NULL,
  `telepon` varchar(20) DEFAULT NULL,
  `alamat` text DEFAULT NULL,
  `kota` varchar(50) DEFAULT NULL,
  `status` enum('aktif','tidak_aktif') DEFAULT 'aktif',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `google_id` varchar(100) DEFAULT NULL,
  `foto_profil` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `pelanggan`
--

INSERT INTO `pelanggan` (`id`, `kode_pelanggan`, `nama`, `email`, `telepon`, `alamat`, `kota`, `status`, `created_at`, `updated_at`, `google_id`, `foto_profil`) VALUES
(5, 'PLG-FC7B95', 'Vina Garutt', 'vinagarutt315@gmail.com', '087856643707', 'jln limau 2 ', 'bandung.braga', 'aktif', '2026-08-21 07:13:34', '2026-08-22 16:05:34', '111930416637498259938', 'https://lh3.googleusercontent.com/a/ACg8ocItH0fuoP6xNtwE7gHTX06yl60J8QEKcQT74BjAGW71RIWRwQ=s96-c'),
(6, 'PLG-EF7BFD', 'AGAM AL HAKIM HASIBUAN•', 'agamal2455201016.mhs@universitaspahlawan.ac.id', '087856643707', 'jln limau 2 ', 'kampar riau', 'aktif', '2026-08-21 18:42:53', '2026-08-23 14:34:09', '113035866708706583351', 'pelanggan_6_malam.png'),
(7, 'PLG-4C9584', 'AGAM AL•', 'agam06614@gmail.com', 'None', 'None', 'None', 'aktif', '2026-08-22 15:59:14', '2026-08-29 16:54:36', '106023711195816317594', 'https://lh3.googleusercontent.com/a/ACg8ocJ7OAJx4kGhsxPgU2Y9T6f_kIQ6lmaYLgG0jsK0ywG9B58_aSkU=s96-c'),
(8, 'PLG-C44D06', 'AGam Al', 'alagam594@gmail.com', '082349223727', 'jln limau 2 ', 'kampar riau', 'aktif', '2026-08-23 16:23:49', '2026-08-23 16:24:44', '101269203732525992747', 'pelanggan_8_57a68ed9-9f65-4e09-8bfb-535dadedbf46.png');

-- --------------------------------------------------------

--
-- Struktur dari tabel `pesanan`
--

CREATE TABLE `pesanan` (
  `id` int(11) NOT NULL,
  `no_pesanan` varchar(20) NOT NULL,
  `pelanggan_id` int(11) NOT NULL,
  `tanggal_pesan` date NOT NULL,
  `tanggal_kirim` date DEFAULT NULL,
  `status` enum('pending','diproses','dikirim','selesai','dibatalkan') DEFAULT 'pending',
  `total_harga` decimal(15,2) DEFAULT 0.00,
  `diskon` decimal(5,2) DEFAULT 0.00,
  `total_bayar` decimal(15,2) DEFAULT 0.00,
  `catatan` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `metode_bayar` varchar(30) DEFAULT 'cod'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `pesanan`
--

INSERT INTO `pesanan` (`id`, `no_pesanan`, `pelanggan_id`, `tanggal_pesan`, `tanggal_kirim`, `status`, `total_harga`, `diskon`, `total_bayar`, `catatan`, `created_at`, `updated_at`, `metode_bayar`) VALUES
(4, 'ORD20260821232505', 5, '2026-08-21', '2026-08-22', 'selesai', 10000.00, 0.00, 10000.00, 'Nama: AGam Al | Telp: 087856643707 | Alamat: jln limau 2 ', '2026-08-21 16:25:05', '2026-08-22 16:25:18', 'dana'),
(5, 'ORD20260824212757', 7, '2026-08-24', '2026-08-24', 'diproses', 10000.00, 0.00, 10000.00, 'Nama: AGam Al | Telp: 082349223727 | Alamat: jln limau 2', '2026-08-24 14:27:57', '2026-08-24 14:29:01', 'cod');

-- --------------------------------------------------------

--
-- Struktur dari tabel `produk`
--

CREATE TABLE `produk` (
  `id` int(11) NOT NULL,
  `kode_produk` varchar(20) NOT NULL,
  `nama` varchar(100) NOT NULL,
  `kategori_id` int(11) DEFAULT NULL,
  `harga` decimal(15,2) NOT NULL,
  `stok` int(11) DEFAULT 0,
  `stok_minimum` int(11) DEFAULT 5,
  `satuan` varchar(20) DEFAULT 'pcs',
  `deskripsi` text DEFAULT NULL,
  `gambar` varchar(255) DEFAULT NULL,
  `status` enum('aktif','tidak_aktif') DEFAULT 'aktif',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `mapel` varchar(100) DEFAULT NULL,
  `penerbit` varchar(100) DEFAULT NULL,
  `kurikulum` varchar(100) DEFAULT NULL,
  `kelas` varchar(50) DEFAULT NULL,
  `semester` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `produk`
--

INSERT INTO `produk` (`id`, `kode_produk`, `nama`, `kategori_id`, `harga`, `stok`, `stok_minimum`, `satuan`, `deskripsi`, `gambar`, `status`, `created_at`, `updated_at`, `mapel`, `penerbit`, `kurikulum`, `kelas`, `semester`) VALUES
(1, 'PRD-001', 'topi sd', NULL, 5000.00, 30, 5, 'pcs', 'tersedia topi SD ', 'topi sd.jpg', 'aktif', '2026-03-17 16:30:59', '2026-08-28 18:29:43', NULL, NULL, NULL, NULL, NULL),
(2, 'PRD-002', 'TOPI SMP', NULL, 5000.00, 30, 5, 'pcs', 'TERSEDIA TOPI SMP PUTIH BIRU', 'TOPI SMP.jpg', 'aktif', '2026-03-17 16:32:14', '2026-08-28 18:29:27', NULL, NULL, NULL, NULL, NULL),
(3, 'PRD-003', 'DASI SD', NULL, 2000.00, 30, 5, 'pcs', 'DASI SD TERSEDIA berbagai jenis (cewek/cowok)', 'DASI sd.jpg', 'aktif', '2026-03-17 16:33:47', '2026-08-28 18:27:12', NULL, NULL, NULL, NULL, NULL),
(5, 'PRD-005', 'DASI SMA/SMK', NULL, 5000.00, 30, 5, 'pcs', 'DASI SMA/SMK TERSEDIA', 'DASI SMA-SMK.jpg', 'aktif', '2026-03-17 16:36:27', '2026-08-28 18:25:55', NULL, NULL, NULL, NULL, NULL),
(7, 'PRD-007', 'PENA CAIR', NULL, 6000.00, 30, 5, 'pcs', 'TERSEDIA Berbagai Warna', 'PENA CAIR.jpg', 'aktif', '2026-03-17 16:39:56', '2026-08-28 18:24:33', NULL, NULL, NULL, NULL, NULL),
(8, 'PRD-008', 'PENA PILOT HITAM', NULL, 3000.00, 30, 5, 'pcs', 'Ballpoint Pilot BPT-P dengan mata pena Stainless Steel Tip 0.7. Tinta dapat menggalir dengan lancar dan tanpa beleber. Dibandingkan dengan pulpen sejenis merk lainnya (telah diuji dengan Writing Test Machine), isi tinta Pilot BPT-P dapat digunakan untuk menulis lebih panjang dan lama.', 'pena pilot.jpg', 'aktif', '2026-03-17 16:40:44', '2026-08-28 18:22:37', NULL, NULL, NULL, NULL, NULL),
(10, 'PRD-010', 'TIP-EX CAIR', NULL, 5000.00, 30, 5, 'pcs', 'TERSEDIA', 'tip-ex cair.jpg', 'aktif', '2026-03-17 16:42:30', '2026-08-28 18:22:53', NULL, NULL, NULL, NULL, NULL),
(11, 'PRD-011', 'TIP-EX KERTAS', NULL, 10000.00, 30, 5, 'pcs', 'Correction Tape Penghapus Pulpen Tipe X Kertas Alat Tulis Sekolah Perlengkapan Kantor 12m, 30m NOTE : KAMI KIRIM KAN WARNA SECARA RANDOM, ANDA HANYA DAPAT MEMILIH VARIAN SAJA. Pita koreksi merupakan salah satu alat tulis penting bagi pelajar dan pekerja kantoran. Pita koreksi ini kecil dan ringan, mudah dibawa dan digunakan. Tampilannya yang stylish dan minimalis sangat cocok dengan gaya estetika masyarakat modern. Baik digunakan di sekolah, kantor, atau rumah, dapat memenuhi berbagai kebutuhan anda. Spesifikasi : Warna Tinta : Putih Bahan : Plastik Varian : 13m, 30m dan pack isi 2 (30m) Ukuran : 9.2 X 4.7 1.3 Cm Kelebihan :  Bahan Aman Casing luar terbuat dari plastik tahan lama dan pita putih terbuat dari resin dan titanium dioksida, tidak berbaya dan tidak berbau sehingga aman digunakan', 'TIP-EX KERTAS.jpg', 'aktif', '2026-03-17 16:43:03', '2026-08-28 18:20:45', NULL, NULL, NULL, NULL, NULL),
(13, 'PRD-013', 'STAPLER BESAR', NULL, 12000.00, 40, 5, 'pcs', 'TERSEDIA', 'STAPLER BESAR.jpg', 'aktif', '2026-03-17 16:44:15', '2026-08-28 18:19:30', NULL, NULL, NULL, NULL, NULL),
(18, 'PRD-018', 'BINDER KULIAH A5,A4', NULL, 23000.00, 70, 5, 'pcs', 'TERSEDIA BEBRBAGAI JENIS', 'BINDER KULIAH A5,A4.jpg', 'aktif', '2026-03-17 16:50:13', '2026-08-28 18:17:45', NULL, NULL, NULL, NULL, NULL),
(19, 'PRD-019', 'PENSIL 2B FABERCASTELL', NULL, 5000.00, 30, 5, 'pcs', 'Pensil 2B Faber-Castell 9000 Bisa digunakan untuk melengkapi kebutuhan menulis anak² sekolah dan kantor. * Produk dijamin Asli merk FABER-CASTELL * Dijual lusinan - 1 kotak isi 12 batang pensil * Pensil tipe 2B hitam pekat sehingga cocok digunakan untuk ujian sekolah dengan sistem pengecekan komputerisasi KETENTUAN OPERASIONAL‼️ * Pengiriman setiap hari Senin s\\d Sabtu. * Pengiriman Instant dari Jam 9.00 WIB s\\d 17.00 WIB. * Hari Minggu & Libur Nasional tetap menerima orderan, dan pengiriman Instant akan di proses di hari Kerja Toko. * Silahkan chat admin toko untuk info belanja partai grosiran. Selamat berbelanja dijamin kualitas bagus & produk sesuai foto etalase. Terima kasih.\r\n', 'PESIL 2B FABERCASTELL.jpg', 'aktif', '2026-03-17 16:50:52', '2026-08-28 18:16:50', NULL, NULL, NULL, NULL, NULL),
(22, 'PRD-022', 'BUSUR ', NULL, 1000.00, 10, 5, 'pcs', 'TERSEDIA', 'busur.jpg', 'aktif', '2026-03-17 16:52:57', '2026-08-28 18:14:13', NULL, NULL, NULL, NULL, NULL),
(24, 'PRD-024', 'Penggaris T/T-Square 60cm (Teknik)', NULL, 30000.00, 30, 5, 'pcs', 'Tingkatkan presisi saat menggambar dan berkarya dengan Acurit Detachable T-Square, alat yang wajib dimiliki oleh arsitek, seniman, maupun penggiat kerajinan tangan. Penggaris T yang dirancang dengan cermat ini menawarkan akurasi setara penggaris T konvensional, namun dilengkapi dengan keunggulan praktis berupa kepala yang dapat dilepas-pasang. Baik Anda seorang arsitek profesional, ilustrator, maupun penghobi, penggaris T ini merupakan tambahan serbaguna untuk perlengkapan kerja Anda. Acurit Detachable T-Square memiliki bilah akrilik bening yang menjamin transparansi dan presisi dalam pengerjaan proyek Anda. Pilihan panjang bilah—24 inci dan 36 inci—memenuhi kebutuhan berbagai ukuran proyek, menjadikannya alat gambar yang fleksibel untuk tugas berskala kecil yang mendetail maupun proyek berskala besar. Skala ukuran dalam inci dan sentimeter terukir dengan jelas, memberikan akurasi yang tepat.', 'Penggaris TT-Square 60cm (Teknik).jpg', 'aktif', '2026-03-17 16:55:43', '2026-08-28 18:13:13', NULL, NULL, NULL, NULL, NULL),
(25, 'PRD-025', 'PENGGARIS SEGITIGA TEKNIK', NULL, 10000.00, 30, 5, 'pcs', '', 'PENGGARIS SEGITIGA TEKNIK.jpg', 'aktif', '2026-03-17 16:56:38', '2026-08-28 18:13:41', NULL, NULL, NULL, NULL, NULL),
(26, 'PRD-026', 'Laptop Asus VivoBook 14 I5 GEN 13', NULL, 9000000.00, 10, 5, 'pcs', '💻 ASUS Vivobook 14 (2025) — Tangguh & Portabel! Sedang mencari laptop ramping untuk kuliah, produktivitas, coding, pekerjaan kantor, dan penggunaan sehari-hari? ASUS Vivobook 14 hadir dengan prosesor Intel Core Ultra 5 225H, RAM 16GB, dan SSD PCIe 4.0 512GB. ✨ Fitur Utama: • Intel Core Ultra 5 225H • RAM 16GB DDR5 • SSD 512GB • Layar 14\" FHD+ 16:10 • Keyboard dengan lampu latar (backlit) • AI PC dengan Intel AI Boost • Office 2024 + Microsoft 365 Basic* • Windows 11 Home Pilihan serbaguna yang tepat bagi pelajar dan profesional yang menginginkan performa tinggi dalam desain ringkas berukuran 14 inci.', 'Laptop Asus VivoBook 14 I5 GEN 13.jpg', 'aktif', '2026-03-17 17:30:27', '2026-08-28 18:10:23', NULL, NULL, NULL, NULL, NULL),
(27, 'PRD-027', 'LAPTOP MSI MODERN I7', NULL, 16000000.00, 10, 5, 'pcs', 'Sebelum berbelanja pastikan sudah membaca spesifikasi dibawah ini ya :) Kelengkapan : > Unit Laptop NEW > Charger > Tas > Box / Dus Laptop GARANSI : o Resmi Indonesia 2 Tahun o Tukar unit 5 Hari dari penerimaan barang (wajib menyertakan video unboxing) SPESIFIKASI : Processor :13th Gen Intel® Core™ i7-1355U processor Display : 14″ FHD (1920*1080), 60Hz 45%NTSC IPS-Level Memory : 16GB (8GB*2 DDR4 RAM 3200MHz) Storage : 512GB NVMe PCIe SSD Gen4x4 Graphics : Intel® Xe Graphics Keyboard :Single Backlit Keyboard (White), with Copilot Key Wireless : 802.11 ax Wi-Fi 6E + Bluetooth v5.3 Ports : 3x Type-A USB3.2 Gen1, 1x RJ45, 1x Micro SD Card Reader, 1x HDMI™ (4K @ 30Hz) 1x Type-C (USB3.2 Gen2 / DisplayPort™/ Power Delivery 3.0)', 'LAPTOP MSI MODERN I7.jpg', 'aktif', '2026-03-17 17:32:48', '2026-08-28 18:09:15', NULL, NULL, NULL, NULL, NULL),
(28, 'PRD-028', 'ACER APIRE GO 14', NULL, 11000000.00, 10, 5, 'unit', 'Tingkatkan pengalaman komputasi harian Anda dengan Acer Aspire 3 💻 Ditenagai oleh prosesor Intel Core 3/i3 Generasi ke-14, RAM 8GB, dan SSD 512GB yang cepat, laptop 14 inci ini dirancang untuk kelancaran berbagai aktivitas sehari-hari—mulai dari belajar, pekerjaan kantor, browsing, hiburan, hingga produktivitas. Dilengkapi dengan Windows 11 Home, desain elegan, engsel 180°, penutup privasi kamera, serta bobot ringan 1,45 kg, laptop ini menjadi pilihan praktis bagi pelajar maupun profesional.', 'ACER APIRE GO 14.jpg', 'aktif', '2026-03-17 17:35:05', '2026-08-28 18:07:33', NULL, NULL, NULL, NULL, NULL),
(29, 'PRD-029', 'HP PAVILION 15', NULL, 14000000.00, 10, 5, 'unit', 'TERSEDIA BERBAGAI WARNA,PROSSESOR,DAN RAM', 'HP PAVILION 15.jpg', 'aktif', '2026-03-17 17:37:04', '2026-08-28 18:07:57', NULL, NULL, NULL, NULL, NULL),
(30, 'PRD-030', 'LENOVO IDEAPAD SLIM 3', NULL, 12000000.00, 10, 5, 'unit', 'Spesifikasi Utama:, Warna: Luna Grey, Ukuran Layar: 15,3 inci, Tipe Layar: 15,3″ WUXGA, Prosesor: Snapdragon® X X1-26-100, Grafis: GPU Qualcomm® Adreno™ Terintegrasi, Sistem Operasi: Windows, Memori: 16 GB, Hard Drive: 512 GB. Kenali komputer yang bisa diajak bicara—tingkatkan kemampuan Anda ke level berikutnya. Kini dilengkapi AI. Komputasi cerdas dengan kekuatan prosesor seri Snapdragon® X & Copilot+ PC. Amankan proyek & file media dengan penyimpanan SSD yang dapat ditingkatkan. Layar luas & visual tajam untuk kerja sama tim virtual yang lancar. Produk bermerek Snapdragon adalah produk dari Qualcomm Technologies, Inc. dan/atau anak perusahaannya.', 'LENOVO IDEAPAD SLIM 3.jpg', 'aktif', '2026-03-17 17:38:39', '2026-08-28 18:01:57', NULL, NULL, NULL, NULL, NULL),
(31, 'PRD-031', 'ASUS ROG STRIX G16', NULL, 24000000.00, 10, 5, 'unit', 'Spesifikasi : Processor : AMD Ryzen 9 8940HX Processor 2.4GHz (80MB Cache, up to 5.3GHz, 16 cores, 32 Threads) Display : ROG Nebula Display 16-inch 2.5K (2560 x 1600, WQXGA) 16:10 aspect ratio, IPS-level anti-glare display DCI-P3:100%, Refresh Rate:300Hz, Response Time:3ms G-Sync Pantone Validated MUX Switch + NVIDIA Advanced Optimus Graphics : NVIDIA GeForce RTX 5060 Laptop GPU ROG Boost:1610MHz at 115W (1560MHz Boost Clock+50MHz OC, 100W+15W Dynamic Boost) 8GB GDDR7 Memory : 16GB DDR5-5200 SO-DIMM, Max Capacity:64GB, Support dual channel memory Storage : 512GB PCIe 4.0 NVMe M.2 SSD Expansion Slots (includes used): 2x DDR5 SO-DIMM slots; 2x M.2 PCIe Keyboard : Backlit Chiclet Keyboard 4-Zone RGB Touchpad With Copilot key Wireless : Wi-Fi 6E(802.11ax) (Triple band) 2*2 + Bluetooth 5.3 Wirles', 'ASUS ROG STRIX G16.jpg', 'aktif', '2026-03-17 17:40:23', '2026-08-28 18:00:34', NULL, NULL, NULL, NULL, NULL),
(32, 'PRD-032', 'LENOVO LEGION 5 / 5i (i7, RTX 5050/5060)', NULL, 20000000.00, 10, 5, 'unit', 'LENOVO LEGION 5 16 ULTRA 9 275HX RTX5060 8GB/ 32GB 1TB W11 16.0QHD 240HZ Spesifikasi : • Intel Core Ultra 9 275HX, 24C (8P + 16E) / 24T, Max Turbo up to 5.4GHz, 36MB • 32GB SO-DIMM DDR5-5600 • 1TB SSD M.2 2242 PCIe 4.0x4 NVMe • NVIDIA GeForce RTX 5060 8GB GDDR7, Boost Clock 2497MHz, TGP 105W, 572 AI TOPS • 16\"QHD • Windows 11 Home, English KELENGKAPAN : UNIT ONLY : UNIT ONLY +ANTIGORES : UNIT + ANTIGORES (LANGSUNG KAMI BANTU PASANG) +AKSESORIS : UNIT + ANTIGORES (LANGSUNG KAMI BANTU PASANG) + AKSESORIS (MOUSE, MOUSEPAD, SLEEVECASE) +UP WINDOWS PRO : UNIT + ANTIGORES (LANGSUNG KAMI BANTU PASANG) + AKSESORIS (MOUSE, MOUSEPAD, SLEEVECASE) + UPGRADE WINDOWS PRO GARANSI : 1 TAHUN', 'LENOVO LEGION 5.jpg', 'aktif', '2026-03-17 17:46:05', '2026-08-28 17:59:17', NULL, NULL, NULL, NULL, NULL),
(33, 'PRD-033', 'SEPATU VANS SK8HIGH', NULL, 200000.00, 20, 5, 'liter', 'Sk8-Hi diperkenalkan pada tahun 1978—awalnya bernama Style 38—dan menampilkan Vans Sidestripe yang kini ikonik pada siluet *high-top* baru yang inovatif. Sebagai model kedua yang menampilkan ciri khas tersebut (yang sebelumnya dikenal sebagai \"jazz stripe\"), Sk8-Hi menghadirkan tampilan yang benar-benar baru bagi keluarga Vans. Sebagai penghormatan terhadap model *high-top* orisinal yang legendaris itu, Classic Sk8-Hi hadir dengan bagian atas berbahan *suede* hitam dan kanvas yang awet, Sidestripe berbahan kulit putih, serta dinding samping karet berwarna putih. Sepatu bertali ini juga dilengkapi dengan pelindung jari kaki yang diperkuat, bantalan kerah yang suportif, serta sol luar karet bermotif *waffle* khas merek ini. • Sepatu *high-top* legendaris dengan Vans Sidestripe • Bagian atas berbahan *suede* dan kanvas yang awet • Penutup model tali • Pelindung jari kaki yang diperkuat • Bantalan kerah yang suportif • Sol luar karet bermotif *waffle* khas', 'SEPATU VANS SK8HIGH.jpg', 'aktif', '2026-03-17 17:47:17', '2026-08-28 17:57:20', NULL, NULL, NULL, NULL, NULL),
(34, 'PRD-034', 'SEPATU  WEWALK FOOTWEAR', NULL, 189000.00, 20, 5, 'box', 'WEWALK menggunakan material yang sangat awet, memberikan kepuasan melalui desain yang simpel dan orisinal, serta menawarkan kenyamanan dan kegunaan serbaguna. * 100% Produk Orisinal WEWALK. Panduan Ukuran: 37 (23,8 cm), 38 (24,5 cm), 39 (24,8 cm), 40 (25,0 cm), 41 (26,5 cm), 42 (27,0 cm), 43 (28,0 cm). Kelengkapan: Sepatu WEWALK orisinal, kotak WEWALK orisinal, stiker WEWALK, tag orisinal WEWALK, dan kaus kaki. Bahan: Kain kanvas, outsole karet (rubber), foxing karet (rubber).', 'SEPATU WEWALK FOOTWEAR.jpg', 'aktif', '2026-03-17 17:48:22', '2026-08-28 17:56:09', NULL, NULL, NULL, NULL, NULL),
(35, 'PRD-035', 'PENGRAUT PENSIL', NULL, 25000.00, 9, 5, 'pcs', 'Maksimalkan efisiensi mengasah pensil dengan Bantex Rotary Sharpener BE1011! Dirancang untuk memberikan hasil rautan sempurna dan stabilitas ekstra, rautan putar ini dilengkapi fitur penjepit pensil yang kokoh. Dengan kemampuan mengakomodasi pensil berdiameter besar dan fitur satu tombol pelepas inti, rautan ini adalah solusi ideal untuk di sekolah maupun di rumah. Keunggulan Produk: - Rautan ini dilengkapi dengan mekanisme penjepit pensil yang kuat, memastikan pensil terpasang erat dan tidak bergeser saat diasah. Hasilnya adalah ujung pensil yang presisi dan konsisten setiap saat. - Diameter lubang besar (φ 6.9-11mm) untuk mengakomodasi berbagai jenis pensil, mulai dari pensil standar hingga pensil berdiameter lebih besar (6.9mm hingga 11mm).', 'PENGRAUT PENSIL.jpg', 'aktif', '2026-03-17 18:00:11', '2026-08-28 17:52:01', NULL, NULL, NULL, NULL, NULL),
(36, 'PRD-036', 'PENGHAPUS Hitam', NULL, 15000.00, 40, 5, 'pcs', 'TERSEDIA BERBAGAI WARNA DAN UKURAN', 'PENGHAPUS JOYKO.jpg', 'aktif', '2026-03-17 18:04:38', '2026-08-28 17:54:07', NULL, NULL, NULL, NULL, NULL),
(37, 'PRD-037', 'PENGHAPUS PAPAN TULIS', NULL, 10000.00, 10, 5, 'pcs', 'TERSEDIA', 'pengahpus papan tulis.jpg', 'aktif', '2026-03-17 18:05:57', '2026-08-28 17:53:32', NULL, NULL, NULL, NULL, NULL),
(38, 'PRD-038', 'PENA MERAH', NULL, 5000.00, 10, 5, 'pcs', 'TERSEDIA BERBAGAI MERK', 'pena merah.jpg', 'aktif', '2026-03-17 18:07:49', '2026-08-28 17:52:48', NULL, NULL, NULL, NULL, NULL),
(39, 'NEW-34DEFA', 'Penggaris Besi 20cm', NULL, 8000.00, 10, 5, 'pcs', '', 'penggaris besi pendek.jpg', 'aktif', '2026-08-19 20:15:12', '2026-08-28 17:47:58', NULL, NULL, NULL, NULL, NULL),
(40, 'NEW-47978E', 'Spidol Merah', NULL, 10000.00, 10, 5, 'pcs', '', 'spidol merah.jpg', 'aktif', '2026-08-19 20:15:12', '2026-08-28 17:53:06', NULL, NULL, NULL, NULL, NULL),
(43, 'NEW-763EC8', 'Buku Kampus', NULL, 580000.00, 10, 5, 'pcs', '', 'buku kampus.jpg', 'aktif', '2026-08-19 20:15:12', '2026-08-28 17:46:55', NULL, NULL, NULL, NULL, NULL),
(47, 'NEW-3C9C2A', 'Busur Bulat/Lingkaran', NULL, 5000.00, 10, 5, 'pcs', '', 'Busur Bulat-Lingkaran.jpg', 'aktif', '2026-08-19 20:15:12', '2026-08-28 17:45:52', NULL, NULL, NULL, NULL, NULL),
(48, 'NEW-C66F07', 'Buku Kas (Qwarto)', NULL, 20000.00, 10, 5, 'pcs', '', 'buku kas qwarto.jpg', 'aktif', '2026-08-19 20:15:12', '2026-08-28 17:44:19', NULL, NULL, NULL, NULL, NULL),
(49, 'NEW-70FD2D', 'Note Book A5', NULL, 25000.00, 9, 5, 'pcs', '', 'note book A5.png', 'aktif', '2026-08-19 20:15:12', '2026-08-28 17:43:09', NULL, NULL, NULL, NULL, NULL),
(51, 'NEW-12B73B', 'Dasi SMP Cewek/Cowok', NULL, 5000.00, 10, 5, 'pcs', '', 'dasi smp.jpg', 'aktif', '2026-08-19 20:15:12', '2026-08-28 17:40:43', NULL, NULL, NULL, NULL, NULL),
(59, 'NEW-CF57CC', 'Penggaris Plastik', NULL, 5000.00, 10, 5, 'pcs', '', 'Penggaris Plastik.jpg', 'aktif', '2026-08-19 20:15:12', '2026-08-28 17:35:01', NULL, NULL, NULL, NULL, NULL),
(61, 'NEW-F1A035', 'Buku Gambar (Sidu A4)', NULL, 5000.00, 10, 5, 'pcs', '', 'Buku Gambar (Sidu A4).jpg', 'aktif', '2026-08-19 20:15:12', '2026-08-28 17:34:34', NULL, NULL, NULL, NULL, NULL),
(62, 'NEW-2CD2E5', 'Pena Snowman', NULL, 8000.00, 10, 5, 'pcs', '', 'Pena Snowman.jpg', 'aktif', '2026-08-19 20:15:12', '2026-08-28 17:34:13', NULL, NULL, NULL, NULL, NULL),
(64, 'NEW-6166AD', 'Pensil Faber castell ', NULL, 10000.00, 10, 5, 'pcs', '', 'Pensil Faber castell.jpg', 'aktif', '2026-08-19 20:15:12', '2026-08-28 17:33:52', NULL, NULL, NULL, NULL, NULL),
(65, 'NEW-43D053', 'Tinta Spidol Permanen', NULL, 5000.00, 10, 5, 'pcs', '', 'tinta spidol permanen.jpg', 'aktif', '2026-08-19 20:15:12', '2026-08-28 17:29:51', NULL, NULL, NULL, NULL, NULL),
(67, 'NEW-37A596', 'Note Book A4', NULL, 36000.00, 10, 5, 'pcs', '', 'Note Book A4.jpg', 'aktif', '2026-08-19 20:15:12', '2026-08-28 17:28:31', NULL, NULL, NULL, NULL, NULL),
(68, 'NEW-6E7F92', 'Stabilo', NULL, 5000.00, 10, 5, 'pcs', '', 'Stabilo.jpg', 'aktif', '2026-08-19 20:15:12', '2026-08-28 17:27:48', NULL, NULL, NULL, NULL, NULL),
(70, 'NEW-896F19', 'Binder Clip (UK 280)', NULL, 2000.00, 10, 5, 'pcs', '', 'Binder Clip (UK 280).jpg', 'aktif', '2026-08-19 20:15:12', '2026-08-28 17:27:25', NULL, NULL, NULL, NULL, NULL),
(71, 'NEW-409252', 'binder clip Kecil', NULL, 500.00, 10, 5, 'pcs', '', 'binder klip.jpg', 'aktif', '2026-08-19 20:15:12', '2026-08-28 17:25:10', NULL, NULL, NULL, NULL, NULL),
(73, 'NEW-FBA5C2', 'pena klik (Biru)', NULL, 10000.00, 10, 5, 'pcs', '', 'pulpen klik biru.jpg', 'aktif', '2026-08-19 20:15:12', '2026-08-29 15:56:16', NULL, NULL, NULL, NULL, NULL),
(76, 'NEW-E068BC', 'Tinta Spidol Merah', NULL, 10000.00, 10, 5, 'pcs', '', 'tinta spidol merah.jpg', 'aktif', '2026-08-19 20:15:12', '2026-08-28 17:23:18', NULL, NULL, NULL, NULL, NULL),
(77, 'NEW-FD7584', 'Staples kecil', NULL, 5000.00, 10, 5, 'pcs', '', 'staples kecil.png', 'aktif', '2026-08-19 20:15:12', '2026-08-28 17:23:04', NULL, NULL, NULL, NULL, NULL),
(81, 'NEW-ECC0F7', 'Buku Tulis Sidu (58 Lembar)', NULL, 10000.00, 10, 5, 'buku', 'Kertas Putih Bersih & Cerah: Memiliki tingkat keputihan tinggi yang membuat setiap goresan pulpen atau pensil terlihat kontras, jelas, dan sangat nyaman di mata saat dibaca ulang.Tekstur Kertas Halus: Permukaan kertas sangat lembut dan konstan, memberikan sensasi menulis yang lancar (smooth writing) tanpa membuat mata pena terasa tersendat.Tinta Tidak Tembus: Ketebalan kertas dirancang optimal sehingga tidak mudah membekas atau tembus (bleed-through) ke halaman belakang saat menggunakan pulpen tinta biasa.Garis Grid Akurat & Rapi: Cetakan garis pembantu berwarna biru tipis yang presisi, sangat membantu anak-anak melatih kerapian tulisan tangan agar tetap lurus.Cover Buku Variatif & Edukatif: Hadir dengan sampul depan bermotif kreatif, penuh warna, dan edukatif yang disukai anak-anak untuk meningkatkan semangat Belajar', 'buku tulis sidu 58 lembar.jpg', 'aktif', '2026-08-19 20:15:12', '2026-08-28 17:10:48', NULL, NULL, NULL, NULL, NULL),
(85, 'NEW-3A2BB7', 'Kertas HVS(A2)', NULL, 10000.00, 10, 5, 'pcs', 'Ukuran A2 Standar Presisi: Dimensi luas yang pas untuk menyajikan detail denah bangunan, potongan mekanis, atau diagram alur tanpa mengorbankan keterbacaan teks kecil.Permukaan Ultra-Putih & Halus: Memiliki tingkat keputihan tinggi (high whiteness) dan permukaan yang rata, memastikan hasil cetak garis hitam maupun warna terlihat sangat tajam, bersih, dan profesional.Kompatibilitas Mesin Plotter Tinggi: Dirancang khusus agar bersahabat dengan roller mesin cetak besar/plotter (seperti HP DesignJet, Epson, dll.) tanpa risiko kertas tersangkut (paper jam).Daya Serap Tinta Maksimal: Formula kertas mampu menyerap tinta printer (inkjet/laser) maupun tinta rapido dengan cepat, sehingga hasil cetak langsung kering dan bebas noda meluber (smudge-free).', 'kertas hvs A2.png', 'aktif', '2026-08-19 20:15:12', '2026-08-28 17:08:01', NULL, NULL, NULL, NULL, NULL),
(87, 'NEW-F41DCA', 'Spidol Permanen', NULL, 10000.00, 10, 5, 'pcs', 'Melekat di Segala Permukaan: Dapat menulis dengan lancar di atas berbagai media sulit seperti kardus, plastik licin, kayu, kaca, logam, kain, hingga kulit.Formula Cepat Kering & Anti-Air: Menggunakan tinta khusus yang langsung kering dalam hitungan detik setelah digoreskan, waterproof (anti-air), serta tidak luntur atau meluber akibat gesekan tangan.Ujung Serat (Fiber Tip) Kokoh: Mata spidol terbuat dari bahan serat padat berkualitas tinggi yang tidak mudah mekar atau mendelep meskipun ditekan kuat pada permukaan kasar.Tahan Pudar Jangka Panjang: Hasil goresan memiliki daya tahan tinggi terhadap paparan sinar matahari langsung maupun kelembapan ruangan, menjaga tulisan tetap terbaca jelas dalam waktu lama.', 'spidol permanen.jpg', 'aktif', '2026-08-19 20:15:12', '2026-08-28 17:07:12', NULL, NULL, NULL, NULL, NULL),
(89, 'NEW-935E3D', 'Pensil 2B Teknik', NULL, 10000.00, 10, 5, 'pcs', 'Kepadatan Grafit Konsisten: Formula karbon pilihan menghasilkan tingkat kegelapan 2B yang pas, homogen, tidak berminyak, dan sangat mudah dihapus bersih tanpa meninggalkan noda samar.Teknologi Anti-Patah Premium: Inti pensil dilekatkan dengan teknologi khusus sepanjang badan kayu (SV Bonding atau sejenisnya), membuatnya sangat kokoh, tahan benturan, dan tidak mudah patah di dalam saat diraut.Kayu Berkualitas Tinggi: Menggunakan bahan kayu lunak pilihan yang padat namun sangat ringan, sehingga mata pensil mudah diraut tajam secara simetris tanpa macet atau merusak kayu.Akurasi Garis Presisi: Sangat ideal untuk pengerjaan garis teknik tipis, pembuatan arsir bayangan (shading), hingga pembacaan lembar jawaban komputer (LJK) secara akurat.', 'pensil 2b teknik.jpg', 'aktif', '2026-08-19 20:15:12', '2026-08-28 17:05:23', NULL, NULL, NULL, NULL, NULL),
(90, 'NEW-A556D4', 'Penggaris Besi Panjang', NULL, 10000.00, 10, 5, 'pcs', 'Bahan Stainless Steel Tebal: Terbuat dari material baja anti-karat yang kokoh, tidak mudah bengkok, dan sangat tahan lama menghadapi benturan atau gesekan alat potong.Skala Ukur Grafir Permanen: Garis angka dan milimeter dicetak menggunakan metode grafir/ukir (engraved) yang dalam, sehingga angka tidak akan pudar atau hilang walau dipakai bertahun-tahun.Dual Satuan Ukur Akurat: Dilengkapi dengan dua sistem pengukuran sekaligus, yaitu Sentimeter (cm/mm) di satu sisi dan Inci (inch) di sisi lainnya untuk fleksibilitas kerja.Sisi Belakang Fungsional: Bagian belakang penggaris dilengkapi dengan tabel konversi ukuran fungsional untuk mempermudah konversi metrik secara instan di area kerja.Aman & Praktis: Dilengkapi lubang gantung di bagian ujung untuk memudahkan penyimpanan, serta sudut yang halus agar tidak melukai tangan saat digunakan.', 'penggaris besi panjang.jpg', 'aktif', '2026-08-19 20:15:12', '2026-08-28 17:04:35', NULL, NULL, NULL, NULL, NULL),
(97, 'NEW-B3CBD8', 'pena klik (hitam)', NULL, 10000.00, 10, 5, 'pcs', 'Mekanisme Klik Praktis: Desain retractable (cetrek) yang efisien, melindungi mata pena dari risiko kering atau bocor tanpa perlu repot menyimpan tutup pulpen.Tinta Gel Pekat & Cepat Kering: Menggunakan formula tinta gel berkualitas tinggi yang menghasilkan warna hitam legam, mengalir lancar, dan cepat kering di atas kertas sehingga bebas noda blobor (aman untuk pengguna kidal).Grip Ergonomis Anti-Pegat: Dilengkapi karet genggaman lembut (soft rubber grip) di bagian ujung badan pulpen yang mencegah slip dan mengurangi rasa lelah pada jari saat menulis dalam durasi lama.Mata Pena Presisi: Ujung pena fine/semi-needle tip berukuran 0.5 mm - 0.7 mm yang menghasilkan goresan garis tulisan yang sangat rapi, tajam, dan konsisten.', 'pulpen klik.jpg', 'aktif', '2026-08-19 20:15:12', '2026-08-29 15:56:02', NULL, NULL, NULL, NULL, NULL),
(99, 'NEW-D77F27', 'Mouse Bluethot', NULL, 10000.00, 10, 5, 'pcs', 'Koneksi Nirkabel Tanpa Dongle: Terhubung langsung melalui jaringan Bluetooth bawaan laptop, PC, tablet, hingga smartphone tanpa perlu mengorbankan slot USB (beberapa varian dilengkapi dual-mode dengan receiver 2.4G).Fitur Silent Click (Klik Senyap): Menggunakan teknologi switches senyap yang meredam suara klik hingga 90%. Sangat ideal untuk bekerja di perpustakaan, kafe, kantor, atau ruangan yang tenang tanpa mengganggu orang sekitar.Desain Ergonomis & Portabel: Bentuk bodi yang pas di tangan (ambidextrous atau ergonomic contour) mengurangi ketegangan pada pergelangan tangan untuk penggunaan durasi lama. Desainnya yang ramping juga mudah diselipkan ke dalam tas laptop.Sensor Optik Presisi & DPI Dapat Diatur: Dilengkapi dengan sensitivitas sensor (DPI) yang tinggi dan dapat disesuaikan untuk pergerakan kursor yang mulus, akurat, dan responsif di berbagai jenis permukaan meja.Konsumsi Daya Efisien: Sistem manajemen daya pintar yang secara otomatis masuk ke mode tidur (auto-sleep) saat tidak digunakan, membuat daya tahan baterai menjadi sangat awet berbulan-bulan.', 'mouse_bluethoot.png', 'aktif', '2026-08-19 20:15:12', '2026-08-28 16:57:15', NULL, NULL, NULL, NULL, NULL),
(101, 'NEW-F36272', 'Sepatu SD ', NULL, 10000.00, 10, 5, 'box', 'Bahan Upper Ringan & Bernapas: Menggunakan kombinasi material kanvas premium, kulit sintetis, atau mesh berpori yang sirkulasi udaranya baik, sehingga kaki anak tidak mudah gerah atau bau meski dipakai seharian.Sol Dalam (Insole) Empuk: Dilengkapi bantalan busa (foam) yang tebal dan lembut untuk meredam benturan saat anak berlari, bermain, atau berolahraga di lapangan sekolah.Sol Luar (Outsole) Anti-Slip: Terbuat dari karet alami (rubber) berkualitas tinggi dengan tekstur gerigi yang cengkeramannya kuat. Menjaga anak tetap aman dari risiko terpeleset di lantai sekolah yang licin.Jahitan & Lem Ekstra Kuat: Konstruksi sepatu diproduksi dengan standar tinggi agar awet, tidak mudah jebol, dan tahan lama menghadapi aktivitas aktif anak-anak dasar.', 'sepatu sd.jpg', 'aktif', '2026-08-19 20:15:12', '2026-08-28 17:22:24', NULL, NULL, NULL, NULL, NULL),
(102, 'NEW-2F38CB', 'Jam tangan Pria', NULL, 10000.00, 10, 5, 'unit', 'Desain Ergonomis & Kokoh: Konstruksi bodi dirancang kokoh namun tetap nyaman melingkar di pergelangan tangan pria untuk penggunaan seharian penuh.Material Premium Tahan Lama: Menggunakan material pilihan terbaik seperti Stainless Steel anti-karat, kulit asli (Genuine Leather) yang elegan, atau karet sintetis (Rubber/Resin) yang lentur dan tangguh.Kaca Anti-Gores: Dilengkapi dengan pelindung kaca (Mineral Glass atau Sapphire Crystal) yang jernih dan memiliki daya tahan tinggi terhadap benturan serta goresan ringan.Fitur Water Resistant (Tahan Air): Aman digunakan saat mencuci tangan, terkena cipratan air hujan, hingga aktivitas berenang (tingkat ketahanan air menyesuaikan spesifikasi varian ATM).\r\nFitur Tambahan Fungsional: Mengintegrasikan fitur canggih seperti Chronograph (stopwatch jarum), tampilan kalender otomatis, lampu LED iluminator, hingga format waktu digital ganda.', 'jam tangan.png', 'aktif', '2026-08-19 20:15:12', '2026-08-28 17:22:11', NULL, NULL, NULL, NULL, NULL),
(103, 'NEW-A0C224', 'Buku Gambar Teknik A3', NULL, 10000.00, 25, 37, 'buku', 'Ukuran A3 Presisi: Dimensi luas yang ideal untuk menggambar denah, cetak biru (blueprint), perspektif, potongan bangunan, hingga draf detail mekanis.\r\n\r\nKertas Tebal Berkualitas: Menggunakan kertas pilihan dengan gramatur tebal (150 - 200 GSM) yang kokoh, tidak mudah tembus saat menggunakan tinta, dan tidak bergelombang.\r\n\r\nTahan Gesekan Penghapus: Permukaan kertas memiliki jalinan serat yang padat sehingga tidak mudah mengelupas atau rusak meskipun terkena gesekan karet penghapus berulang kali saat merevisi draf.\r\n\r\nPilihan Tipe Jilid Fleksibel: Tersedia dalam sistem jilid lem atas (glue pad) yang mudah disobek rapi saat tugas ingin dikumpulkan, maupun jilid spiral (wire-bound) yang kokoh agar kertas tidak mudah tercecer.', 'buku gambar teknik.jpg', 'aktif', '2026-08-19 20:15:12', '2026-08-28 17:22:02', NULL, NULL, NULL, NULL, NULL),
(107, 'NEW-9D3F27', 'Pensil Warna (fabercastel)', NULL, 10000.00, 10, 5, 'pcs', 'Warna Cemerlang & Pekat: Pigmen warna berkualitas tinggi menghasilkan goresan yang cerah, padat, dan sangat mudah menempel di atas kertas.\r\n\r\nTeknologi SV Bonding (Anti-Patah): Dilengkapi dengan sistem perekatan khusus (Secural Bonding) di sepanjang badan pensil, membuat isi grafit/timbalnya sangat kokoh, tidak mudah hancur saat diraut, atau patah saat ditekan kuat.\r\n\r\nFormula Aman & Non-Toxic: Terbuat dari bahan alami yang ramah lingkungan dan bersertifikasi aman untuk anak-anak (safe for children).\r\n\r\nKayu Berkualitas Tinggi: Menggunakan bahan kayu dari hutan bersertifikasi berkelanjutan (eco-pencil), sangat halus dan mudah diraut tanpa macet.\r\n\r\nKreativitas Tanpa Batas: Sangat ideal untuk teknik mencampur warna (blending), membuat gradasi halus, hingga teknik mengarsir tebal.', 'pensil warna.jpg', 'aktif', '2026-08-19 20:15:12', '2026-08-28 17:21:51', NULL, NULL, NULL, NULL, NULL),
(109, 'PRD-039', 'Buku agama kelas 1 SD ', NULL, 35000.00, 90, 121, 'pcs', 'buku mapel agama islam untuk kelas 1 SD (k13)', 'Islam-BS-KLS-I-Cover.png', 'aktif', '2026-08-24 03:19:12', '2026-08-28 17:21:40', NULL, NULL, NULL, NULL, NULL),
(110, 'PRD-040', 'Note Book Premium', NULL, 30.00, 17, 5, 'pcs', '', 'note book premium.jpg', 'aktif', '2026-08-28 17:39:43', '2026-08-28 17:39:43', NULL, NULL, NULL, NULL, NULL),
(111, 'PRD-041', 'TOPI SMA/SMK', NULL, 5000.00, 20, 5, 'pcs', 'TERSEDIA', 'TOPI SMP.jpg', 'aktif', '2026-08-28 18:30:24', '2026-08-28 18:30:24', NULL, NULL, NULL, NULL, NULL),
(112, 'PRD-042', 'jangka ', NULL, 25000.00, 16, 5, 'pcs', 'jangka set isi 9 pcs 1 pensil 2 serutan 3 busur 4 penggaris segitiga 5. penghapus 6 jangka 7 penggaris lurus 8 penggaris segitga 9 penggaris segitga', 'jangka.jpg', 'aktif', '2026-08-28 18:35:16', '2026-08-28 18:35:16', NULL, NULL, NULL, NULL, NULL),
(113, 'PRD-043', 'kertas double folio', NULL, 2000.00, 24, 5, 'pcs', '', 'kertas double folio.jpg', 'aktif', '2026-08-28 18:45:13', '2026-08-28 18:45:13', NULL, NULL, NULL, NULL, NULL),
(114, 'PRD-044', 'Jangka Sorong Manual/Besi (Analog)', NULL, 55000.00, 24, 5, 'box', 'Alat ukur mekanis konvensional berbahan stainless steel padat dengan finis satin krom yang elegan dan tahan korosi. Produk ini dilengkapi dengan rahang ukur ganda yang presisi, batang pengukur kedalaman (depth bar), serta modul pergeseran rahang yang halus dengan baut pengunci manual. Menggunakan sistem dual skala (Metrik/Inci) gravir permanen yang anti-pudar, alat ini menawarkan pengukuran dimensi luar, dalam, dan kedalaman objek dengan tingkat ketelitian tinggi (0,02 mm / 0,05 mm) tanpa ketergantungan pada daya baterai. Kokoh, andal, dan siap pakai untuk kebutuhan bengkel, fabrikasi, maupun edukasi teknik.', 'jangka sorong.png', 'aktif', '2026-08-29 15:11:24', '2026-08-29 15:11:24', NULL, NULL, NULL, NULL, NULL),
(115, 'PRD-045', 'Jangka Sorong Digital (Plastik/Carbon Fiber)', NULL, 47000.00, 17, 5, 'box', 'Alat ukur modern super ringan berbahan komposit serat karbon (carbon fiber) berkualitas tinggi yang aman dan anti-gores terhadap permukaan benda kerja. Produk ini dilengkapi dengan layar LCD besar untuk menampilkan hasil ukur secara instan, akurat, dan mudah dibaca tanpa perlu menghitung garis skala. Memiliki tombol konversi satu-klik antara satuan Milimeter dan Inci, tombol Zero untuk kalibrasi ulang di posisi mana pun, serta fitur mati otomatis (auto-off) untuk menghemat baterai. Sangat ideal, aman, dan praktis digunakan oleh pelajar, penghobi kerajinan tangan, 3D printing, hingga keperluan rumah tangga.', 'Jangka Sorong Digital (PlastikCarbon Fiber).png', 'aktif', '2026-08-29 15:14:20', '2026-08-29 15:14:20', NULL, NULL, NULL, NULL, NULL),
(116, 'PRD-046', 'Jangka Sorong Digital (Besi/Industri)', NULL, 150000.00, 20, 5, 'box', 'Alat ukur digital kelas profesional (heavy-duty) berbahan baja tahan karat (hardened stainless steel) yang dirancang khusus untuk akurasi tinggi di lingkungan pabrik dan permesinan. Produk ini dilengkapi dengan layar LCD beresolusi tinggi, modul pergeseran rahang yang sangat mulus dengan roda jempol (thumb roller), serta standar sertifikasi ketahanan air dan debu (seperti rating IP54) agar aman dari cipratan oli maupun cairan pendingin. Menawarkan konversi instan mm/inci, fitur kalibrasi instan (zero setting), dan tingkat ketelitian ekstrim hingga 0,01 mm, menjadikannya pilihan utama bagi teknisi industri, QC manufaktur, dan bengkel bubut presisi.', 'Jangka Sorong Digital (BesiIndustri).png', 'aktif', '2026-08-29 15:17:05', '2026-08-29 15:17:05', NULL, NULL, NULL, NULL, NULL),
(117, 'PRD-047', 'Jangka Sorong Presisi Tinggi', NULL, 500000.00, 64, 5, 'box', 'Alat ukur kasta tertinggi (ultra-precision) standar industri manufaktur global yang diproduksi dengan rekayasa teknologi dan kontrol kualitas ketat khas Jepang. Terbuat dari baja tahan karat kelas premium (high-grade hardened stainless steel) dengan perlakuan panas khusus untuk memastikan stabilitas dimensi jangka panjang dan ketahanan aus yang luar biasa.Produk ini mengadopsi sensor induksi elektromagnetik canggih (seperti teknologi Absolute) untuk pembacaan posisi yang instan tanpa eror kecepatan, serta dilengkapi layar LCD kontras tinggi yang sangat jernih. Memiliki proteksi tangguh tingkat tinggi (IP67) yang sepenuhnya kedap debu dan tahan rendaman cairan pendingin/oli, alat ini menawarkan tingkat ketelitian mikron (hingga 0,01 mm atau lebih tinggi) dengan akurasi repetisi yang absolut untuk kebutuhan QC laboratorium, industri kedirgantaraan, otomotif, dan pembuatan cetakan (mold making) presisi tinggi.', 'Jangka Sorong Presisi Tinggi (Merk ProJepang).png', 'aktif', '2026-08-29 15:19:48', '2026-08-29 15:19:48', NULL, NULL, NULL, NULL, NULL),
(118, 'PRD-048', 'Kotak Pensil', NULL, 170000.00, 100, 5, 'unit', 'Tempat pensil modern nan interaktif yang dirancang khusus untuk meningkatkan semangat belajar anak-anak sekolah. Terbuat dari material plastik tebal berkualitas tinggi yang awet dan mudah dibersihkan, produk ini hadir dengan berbagai pilihan motif karakter kartun yang lucu dan menggemaskan (seperti tema astronot dan boneka beruang).Keunggulan utama kotak pensil ini terletak pada fiturnya yang multifungsi; dilengkapi dengan kalkulator elektronik mini di bagian atas untuk membantu menghitung cepat, rautan pensil terintegrasi, serta tombol-tombol kompartemen rahasia yang otomatis terbuka saat ditekan. Pembelian produk ini juga sudah termasuk lembaran stiker dekoratif gratis (free sticker), sehingga anak-anak bisa berkreasi menghias kotak pensil mereka sendiri agar tampil lebih unik dan personal.', 'kotak pensil.jpg', 'aktif', '2026-08-29 15:25:44', '2026-08-29 15:25:44', NULL, NULL, NULL, NULL, NULL),
(119, 'PRD-049', 'Kaus kaki sd', NULL, 5000.00, 40, 5, 'pcs', 'Kaus kaki sekolah model klasik yang dirancang khusus untuk kenyamanan dan kerapian aktivitas belajar siswa sekolah dasar sepanjang hari. Terbuat dari kombinasi material katun berkualitas tinggi dan spandeks yang lembut, tebal, elastis, serta efektif menyerap keringat guna mencegah bau kaki akibat pemakaian sepatu yang lama.Produk ini hadir dengan pilihan warna standar instansi pendidikan—seperti kombinasi putih-hitam atau putih polos—serta dilengkapi dengan tulisan bordir identitas \"SD\" yang rahasia dan kuat pada bagian betis. Desain karet pelindung di bagian atas (cuff) dibuat pas dan tidak terlalu ketat, memastikan kaus kaki tetap tegak dan tidak mudah melorot saat anak-anak aktif bergerak di kelas maupun di lapangan upacara.', 'kaus kaki sd.png', 'aktif', '2026-08-29 15:32:22', '2026-08-29 15:32:22', NULL, NULL, NULL, NULL, NULL),
(120, 'PRD-050', 'Kaus kaki SMP', NULL, 8000.00, 49, 5, 'pcs', 'Kaus kaki sekolah standar instansi pendidikan yang dirancang khusus untuk mendukung kenyamanan aktivitas harian siswa remaja sepanjang hari di sekolah. Terbuat dari perpaduan benang katun pilihan dan serat elastis (spandeks) yang tebal, lembut, serta memiliki sirkulasi udara yang baik untuk menyerap keringat dan mencegah bau kaki akibat pemakaian sepatu yang lama.Produk ini hadir dengan varian warna formal wajib (putih-hitam atau putih polos) dan dilengkapi dengan bordir tulisan \"SMP\" yang rapi, tegas, serta tahan lama pada bagian atas. Didesain dengan rajutan karet rib berkualitas pada pergelangan kaki, kaus kaki ini mencengkeram dengan pas tanpa rasa sesak, memastikan posisi kaus kaki tetap rapi dan tidak melorot saat siswa aktif bergerak di lingkungan sekolah.', 'kaus kaki smp.png', 'aktif', '2026-08-29 15:33:46', '2026-08-29 15:33:46', NULL, NULL, NULL, NULL, NULL),
(121, 'PRD-051', 'kaus kaki SMA ', NULL, 10000.00, 74, 5, 'pcs', 'Kaus kaki sekolah model formal standar nasional yang dirancang khusus untuk melengkapi seragam harian siswa tingkat atas secara rapi dan profesional. Terbuat dari material katun premium yang dikombinasikan dengan spandeks elastis, menghasilkan tekstur yang tebal, lembut di kulit, serta memiliki kemampuan menyerap keringat optimal demi menjaga kesegaran kaki selama jam belajar yang panjang hingga waktu ekstrakurikuler.Produk ini hadir dengan pilihan warna wajib sekolah (putih polos atau kombinasi putih-hitam) dan dilengkapi dengan detail bordir tulisan \"SMA\" yang presisi, kuat, serta tidak mudah pudar pada bagian samping atas. Didukung oleh rajutan karet kompresi yang pas pada bagian cuff, kaus kaki ini mampu mencengkeram kaki dengan mantap tanpa meninggalkan bekas merah, memastikan penampilan tetap rapi dan tidak melorot dari pagi hingga pulang sekolah.', 'kaus kaki SMA.png', 'aktif', '2026-08-29 15:37:07', '2026-08-29 15:37:07', NULL, NULL, NULL, NULL, NULL),
(122, 'PRD-052', 'PEN HITECH KENKO/ Pena HI TECH', NULL, 10000.00, 32, 5, 'pcs', 'Pulpen gel kualitas premium dari brand Kenko yang dirancang khusus untuk kebutuhan menulis dengan tingkat kerapian dan akurasi tinggi. Menggunakan mata pena tipe jarum (needle pen / bullet tip) berukuran ekstra kecil 0.28 mm, pulpen ini menghasilkan goresan garis yang sangat tipis, tajam, dan konsisten.\r\nFormulasi tinta gel berbasis air (water-resistance) di dalamnya memberikan sensasi menulis yang sangat lancar dan lembut tanpa macet, serta memiliki keunggulan cepat kering sehingga tidak luntur atau mengotori kertas. Dilengkapi bodi transparan ramping yang memudahkan pemantauan sisa tinta serta klip saku praktis, pulpen ikonik ini menjadi pilihan favorit para pelajar, mahasiswa, hingga profesional untuk menulis catatan harian, kebutuhan teknis, tanda tangan dokumen, hingga menulis huruf Arab.', 'pena hitech.png', 'aktif', '2026-08-29 15:54:55', '2026-08-29 15:55:39', NULL, NULL, NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Struktur dari tabel `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `nama` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` enum('admin','staff') DEFAULT 'staff',
  `avatar` varchar(10) DEFAULT 'A',
  `provider` varchar(20) DEFAULT 'email',
  `status` enum('aktif','nonaktif') DEFAULT 'aktif',
  `last_login` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `users`
--

INSERT INTO `users` (`id`, `nama`, `email`, `password`, `role`, `avatar`, `provider`, `status`, `last_login`, `created_at`) VALUES
(2, 'Vina Garutt', 'vinagarutt315@gmail.com', 'scrypt:32768:8:1$5TJq7xC3qDrteHfO$b4caea97215579ea85ef97d3462b55ca764ec525c154bf42266e09c39d64c91c53bd58f65bea86c21b3bb9f83aae7bb3ec8b8ba2042a1bfeae933426c483cca2', 'admin', 'A', 'google', 'aktif', NULL, '2026-08-20 20:35:52');

--
-- Indexes for dumped tables
--

--
-- Indeks untuk tabel `detail_pesanan`
--
ALTER TABLE `detail_pesanan`
  ADD PRIMARY KEY (`id`),
  ADD KEY `pesanan_id` (`pesanan_id`),
  ADD KEY `produk_id` (`produk_id`);

--
-- Indeks untuk tabel `kategori`
--
ALTER TABLE `kategori`
  ADD PRIMARY KEY (`id`);

--
-- Indeks untuk tabel `notifikasi`
--
ALTER TABLE `notifikasi`
  ADD PRIMARY KEY (`id`),
  ADD KEY `pelanggan_id` (`pelanggan_id`),
  ADD KEY `pesanan_id` (`pesanan_id`);

--
-- Indeks untuk tabel `pelanggan`
--
ALTER TABLE `pelanggan`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `kode_pelanggan` (`kode_pelanggan`),
  ADD UNIQUE KEY `google_id` (`google_id`);

--
-- Indeks untuk tabel `pesanan`
--
ALTER TABLE `pesanan`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `no_pesanan` (`no_pesanan`),
  ADD KEY `pelanggan_id` (`pelanggan_id`);

--
-- Indeks untuk tabel `produk`
--
ALTER TABLE `produk`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `kode_produk` (`kode_produk`),
  ADD KEY `kategori_id` (`kategori_id`);

--
-- Indeks untuk tabel `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT untuk tabel yang dibuang
--

--
-- AUTO_INCREMENT untuk tabel `detail_pesanan`
--
ALTER TABLE `detail_pesanan`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT untuk tabel `kategori`
--
ALTER TABLE `kategori`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `notifikasi`
--
ALTER TABLE `notifikasi`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT untuk tabel `pelanggan`
--
ALTER TABLE `pelanggan`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT untuk tabel `pesanan`
--
ALTER TABLE `pesanan`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT untuk tabel `produk`
--
ALTER TABLE `produk`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=123;

--
-- AUTO_INCREMENT untuk tabel `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- Ketidakleluasaan untuk tabel pelimpahan (Dumped Tables)
--

--
-- Ketidakleluasaan untuk tabel `detail_pesanan`
--
ALTER TABLE `detail_pesanan`
  ADD CONSTRAINT `detail_pesanan_ibfk_1` FOREIGN KEY (`pesanan_id`) REFERENCES `pesanan` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `detail_pesanan_ibfk_2` FOREIGN KEY (`produk_id`) REFERENCES `produk` (`id`);

--
-- Ketidakleluasaan untuk tabel `notifikasi`
--
ALTER TABLE `notifikasi`
  ADD CONSTRAINT `notifikasi_ibfk_1` FOREIGN KEY (`pelanggan_id`) REFERENCES `pelanggan` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `notifikasi_ibfk_2` FOREIGN KEY (`pesanan_id`) REFERENCES `pesanan` (`id`) ON DELETE CASCADE;

--
-- Ketidakleluasaan untuk tabel `pesanan`
--
ALTER TABLE `pesanan`
  ADD CONSTRAINT `pesanan_ibfk_1` FOREIGN KEY (`pelanggan_id`) REFERENCES `pelanggan` (`id`);

--
-- Ketidakleluasaan untuk tabel `produk`
--
ALTER TABLE `produk`
  ADD CONSTRAINT `produk_ibfk_1` FOREIGN KEY (`kategori_id`) REFERENCES `kategori` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
