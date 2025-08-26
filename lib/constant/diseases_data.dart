final Map<String, Map<String, dynamic>> diseaseData = {
  "acne": {
    "description":
        "Jerawat adalah kondisi kulit yang umum terjadi ketika folikel rambut tersumbat oleh minyak dan sel kulit mati. Hal ini menyebabkan pembentukan komedo, bintik merah, dan kadang nanah yang bisa menimbulkan rasa sakit dan bekas jika tidak diobati dengan tepat.",
    "cause": [
      "Produksi minyak berlebih oleh kelenjar sebaceous",
      "Penyumbatan pori-pori oleh sel kulit mati",
      "Pertumbuhan bakteri Propionibacterium acnes",
      "Peradangan lokal pada kulit",
    ],
    "prevention": [
      "Menjaga kebersihan kulit dengan mencuci muka dua kali sehari",
      "Menggunakan produk perawatan non-komedogenik",
      "Menghindari memencet jerawat",
      "Menjaga pola makan sehat dan mengurangi stres",
    ],
    "treatment": [
      "Obat topikal (benzoyl peroxide, retinoid)",
      "Antibiotik topikal atau oral",
      "Terapi hormonal (jika perlu)",
      "Isotretinoin untuk kasus berat",
    ],
    "urgency": "low",
  },

  "actinic keratoses": {
    "description":
        "Actinic keratoses adalah bercak kulit kasar dan bersisik yang berkembang akibat paparan sinar ultraviolet dalam jangka panjang. Kondisi ini dapat berpotensi berkembang menjadi kanker kulit jika tidak ditangani.",
    "cause": [
      "Paparan berulang dan berkepanjangan terhadap sinar UV dari matahari",
      "Kerusakan DNA sel kulit akibat sinar ultraviolet",
    ],
    "prevention": [
      "Menggunakan tabir surya dengan SPF tinggi",
      "Mengenakan pakaian pelindung",
      "Menghindari paparan sinar matahari langsung terutama di jam puncak",
    ],
    "treatment": [
      "Krioterapi (pembekuan)",
      "Krim topikal (5-FU, imiquimod)",
      "Terapi fotodinamik",
      "Eksisi bedah bila diperlukan",
    ],
    "urgency": "high",
  },

  "alopecia": {
    "description":
        "Alopecia adalah kondisi yang menyebabkan hilangnya rambut pada kulit kepala atau area tubuh lainnya, bisa bersifat sementara atau permanen, dan dapat mempengaruhi kepercayaan diri penderitanya.",
    "cause": [
      "Faktor autoimun",
      "Stres berat",
      "Genetik",
      "Infeksi",
      "Perubahan hormonal",
    ],
    "prevention": [
      "Menjaga kesehatan kulit kepala dengan kebersihan yang baik",
      "Menghindari stres berlebihan",
      "Pola makan seimbang",
      "Menghindari perlakuan rambut yang kasar",
    ],
    "treatment": [
      "Minoxidil",
      "Kortikosteroid (topikal atau injeksi)",
      "Imunoterapi topikal",
      "JAK inhibitor (sesuai anjuran dokter)",
      "Transplantasi rambut (kasus terpilih)",
    ],
    "urgency": "medium",
  },

  "atopic dermatitis": {
    "description":
        "Atopic dermatitis adalah jenis eksim kronis yang menyebabkan kulit menjadi sangat kering, gatal, dan meradang. Kondisi ini sering kali kambuh dan dapat mempengaruhi kualitas hidup penderitanya.",
    "cause": [
      "Faktor genetik",
      "Sistem imun yang terlalu responsif",
      "Alergi",
      "Paparan iritan dan alergen lingkungan",
    ],
    "prevention": [
      "Menggunakan pelembap secara rutin",
      "Menghindari sabun atau deterjen keras",
      "Meminimalkan kontak dengan alergen serta iritan",
    ],
    "treatment": [
      "Emolien/pelembap intensif",
      "Kortikosteroid topikal",
      "Inhibitor calcineurin (tacrolimus/pimecrolimus)",
      "Antihistamin untuk gatal",
      "Terapi cahaya UV pada kasus sedang-berat",
    ],
    "urgency": "medium",
  },

  "basal cell carcinoma": {
    "description":
        "Basal cell carcinoma adalah jenis kanker kulit yang paling umum dan biasanya tumbuh lambat. Kanker ini biasanya muncul pada area kulit yang sering terkena sinar matahari.",
    "cause": [
      "Paparan berlebihan terhadap sinar ultraviolet dari matahari",
      "Paparan sumber UV buatan seperti tanning bed",
    ],
    "prevention": [
      "Menghindari paparan sinar matahari berlebihan",
      "Menggunakan pelindung kulit dan tabir surya",
      "Rutin memeriksakan kulit ke dokter",
    ],
    "treatment": [
      "Eksisi bedah",
      "Mohs micrographic surgery",
      "Krioterapi",
      "Terapi topikal (imiquimod, 5-FU)",
      "Radioterapi pada kasus tertentu",
    ],
    "urgency": "high",
  },

  "benign keratosis-like lesions": {
    "description":
        "Lesi jinak ini biasanya muncul sebagai bercak kasar dan berwarna coklat atau hitam pada kulit yang menua. Walau tidak berbahaya, lesi ini dapat mengganggu penampilan.",
    "cause": ["Faktor usia", "Paparan sinar matahari yang lama"],
    "prevention": [
      "Melindungi kulit dari paparan sinar UV",
      "Menjaga kelembapan kulit secara rutin",
    ],
    "treatment": [
      "Tidak memerlukan terapi khusus bila asimtomatik",
      "Krioterapi",
      "Kuretase",
      "Laser atau eksisi jika mengganggu",
    ],
    "urgency": "low",
  },

  "bullous": {
    "description":
        "Kelainan kulit bullous ditandai dengan munculnya lepuhan atau blister berisi cairan di kulit yang dapat pecah dan menyebabkan luka terbuka serta risiko infeksi.",
    "cause": [
      "Penyakit autoimun (mis. pemphigus/pemphigoid)",
      "Reaksi alergi terhadap obat tertentu",
    ],
    "prevention": [
      "Menghindari pemicu alergi/obat",
      "Mengelola penyakit autoimun dengan baik",
      "Konsultasi dini saat muncul lepuhan",
    ],
    "treatment": [
      "Kortikosteroid sistemik",
      "Imunosupresan (azathioprine, mycophenolate, dll.)",
      "Antibiotik topikal pada luka untuk cegah infeksi",
      "Perawatan luka yang baik",
    ],
    "urgency": "high",
  },

  "cellulitis impetigo": {
    "description":
        "Cellulitis adalah infeksi bakteri pada lapisan kulit yang lebih dalam dan jaringan di bawahnya, sementara impetigo adalah infeksi kulit superfisial yang sangat menular, sering terjadi pada anak-anak.",
    "cause": [
      "Infeksi bakteri Staphylococcus aureus",
      "Infeksi Streptococcus pyogenes",
      "Masuk melalui luka/lecet pada kulit",
    ],
    "prevention": [
      "Menjaga kebersihan kulit",
      "Merawat luka dengan benar",
      "Menghindari kontak langsung dengan penderita impetigo",
    ],
    "treatment": [
      "Antibiotik oral/topikal sesuai indikasi",
      "Salep mupirocin untuk impetigo",
      "Perawatan luka dan kebersihan kulit",
    ],
    "urgency": "high",
  },

  "dermatofibroma": {
    "description":
        "Dermatofibroma adalah benjolan kecil, keras, dan jinak pada kulit yang biasanya muncul akibat reaksi terhadap luka kecil seperti gigitan serangga atau trauma ringan.",
    "cause": [
      "Respons berlebihan jaringan kulit terhadap cedera atau iritasi kecil",
    ],
    "prevention": ["Menghindari cedera kulit dan iritasi"],
    "treatment": [
      "Umumnya tidak memerlukan terapi",
      "Eksisi bedah jika mengganggu estetika atau gejala",
    ],
    "urgency": "low",
  },

  "eczema": {
    "description":
        "Eczema adalah kondisi kulit yang menyebabkan peradangan, kemerahan, gatal, dan terkadang lecet atau kulit pecah-pecah. Bentuk yang paling umum adalah dermatitis atopik.",
    "cause": [
      "Faktor genetik",
      "Iritasi kulit",
      "Alergi",
      "Stres yang memicu peradangan",
    ],
    "prevention": [
      "Menggunakan pelembap rutin",
      "Menghindari bahan kimia keras dan alergen",
      "Menjaga kelembapan kulit",
    ],
    "treatment": [
      "Emolien/pelembap",
      "Kortikosteroid topikal",
      "Antihistamin untuk gatal",
      "Terapi cahaya",
      "Obat sistemik pada kasus berat",
    ],
    "urgency": "medium",
  },

  "exanthems": {
    "description":
        "Exanthems adalah ruam kulit yang menyebar luas, biasanya akibat infeksi virus atau reaksi alergi. Contohnya termasuk campak, rubella, dan roseola.",
    "cause": [
      "Infeksi virus (campak, rubella, roseola)",
      "Reaksi alergi terhadap obat/zat tertentu",
    ],
    "prevention": [
      "Imunisasi lengkap",
      "Menghindari kontak dengan penderita infeksi",
      "Waspada terhadap reaksi obat",
    ],
    "treatment": [
      "Terapi simptomatik (antipiretik, antihistamin)",
      "Antivirus bila diindikasikan",
      "Hidrasi dan istirahat cukup",
    ],
    "urgency": "low",
  },

  "herpes hpv": {
    "description":
        "Infeksi herpes simplex virus (HSV) dan human papillomavirus (HPV) menyebabkan luka atau kutil pada kulit dan area genital yang dapat menular melalui kontak langsung.",
    "cause": [
      "Kontak kulit ke kulit dengan penderita yang aktif",
      "Aktivitas seksual tanpa pelindung (HPV)",
    ],
    "prevention": [
      "Menggunakan alat pelindung seperti kondom",
      "Vaksinasi HPV",
      "Menghindari kontak langsung dengan lesi aktif",
    ],
    "treatment": [
      "Acyclovir/valacyclovir untuk herpes",
      "Krioterapi atau asam salisilat untuk kutil akibat HPV",
      "Terapi ablasi/eksisi untuk kutil resisten",
    ],
    "urgency": "medium",
  },

  "pigmentation disorders": {
    "description":
        "Pigmentation disorders adalah gangguan warna kulit akibat produksi melanin yang tidak normal, membuat sebagian area lebih gelap atau lebih terang dari sekitarnya.",
    "cause": [
      "Faktor genetik atau autoimun (misalnya vitiligo, albinisme)",
      "Paparan sinar matahari berlebih yang merangsang produksi melanin",
      "Perubahan hormonal (misalnya pada kehamilan)",
      "Peradangan/cedera kulit yang meninggalkan noda",
      "Penyakit tertentu, infeksi, dan efek obat",
    ],
    "prevention": [
      "Melindungi kulit dari sinar matahari (tabir surya, pakaian pelindung)",
      "Merawat kulit agar terhindar dari luka atau jerawat",
      "Menjaga pola hidup sehat",
      "Memantau perubahan kulit dan konsultasi dokter bila muncul bercak tidak wajar",
    ],
    "treatment": [
      "Krim pencerah (hidrokuinon) dan retinoid",
      "Chemical peel atau laser (kasus terpilih)",
      "Terapi fototerapi/imun untuk vitiligo",
      "Koreksi kosmetik/kamuflase",
    ],
    "urgency": "medium",
  },

  "light disease": {
    "description":
        "Light disease mengacu pada kondisi kulit yang sensitif terhadap cahaya, yang dapat menyebabkan ruam, peradangan, atau luka akibat paparan sinar UV.",
    "cause": [
      "Kondisi genetik",
      "Reaksi autoimun",
      "Pemakaian obat tertentu yang meningkatkan fotosensitivitas",
    ],
    "prevention": [
      "Menghindari paparan sinar matahari langsung",
      "Menggunakan pelindung UV dan tabir surya",
      "Konsultasi dokter untuk pengelolaan obat pemicu",
    ],
    "treatment": [
      "Kortikosteroid topikal",
      "Perlindungan UV yang ketat",
      "Imunosupresif bila kasus berat",
    ],
    "urgency": "medium",
  },

  "lupus": {
    "description":
        "Lupus adalah penyakit autoimun kronis yang dapat menyerang berbagai organ, termasuk kulit, yang menyebabkan ruam khas, sensitivitas terhadap sinar matahari, dan peradangan.",
    "cause": [
      "Faktor genetik",
      "Faktor hormonal",
      "Pemicu lingkungan yang memicu autoimun",
    ],
    "prevention": [
      "Mengelola stres",
      "Menghindari sinar matahari berlebih",
      "Rutin kontrol kesehatan dan minum obat sesuai anjuran",
    ],
    "treatment": [
      "Kortikosteroid topikal/sistemik",
      "Antimalaria (hydroxychloroquine)",
      "Obat imunosupresif/biologik sesuai indikasi",
    ],
    "urgency": "high",
  },

  "melanocytic nevi": {
    "description":
        "Melanocytic nevi atau tahi lalat adalah pertumbuhan jinak dari sel pigmen kulit yang biasanya muncul sejak masa kanak-kanak atau remaja.",
    "cause": ["Faktor genetik", "Paparan sinar ultraviolet berlebihan"],
    "prevention": [
      "Melindungi kulit dari paparan UV",
      "Memantau perubahan pada tahi lalat (aturan ABCDE)",
      "Konsultasi jika ada perubahan mencurigakan",
    ],
    "treatment": [
      "Tidak memerlukan terapi bila jinak",
      "Eksisi bedah bila iritasi/kosmetik atau mencurigakan",
    ],
    "urgency": "medium",
  },

  "melanoma": {
    "description":
        "Melanoma adalah jenis kanker kulit yang agresif dan berbahaya, berkembang dari sel penghasil pigmen (melanosit), dan dapat menyebar ke organ lain jika tidak cepat ditangani.",
    "cause": [
      "Paparan sinar ultraviolet berlebihan",
      "Riwayat keluarga dengan melanoma",
      "Mutasi genetik pada sel kulit",
    ],
    "prevention": [
      "Menggunakan tabir surya secara rutin",
      "Menghindari paparan sinar matahari langsung",
      "Pemeriksaan kulit berkala",
      "Menghindari tanning bed",
    ],
    "treatment": [
      "Eksisi bedah dengan margin adekuat",
      "Imunoterapi (checkpoint inhibitors)",
      "Targeted therapy (mutasi BRAF/MEK, dll.)",
      "Radioterapi/kemoterapi pada kasus terpilih",
    ],
    "urgency": "high",
  },

  "nail fungus": {
    "description":
        "Infeksi jamur pada kuku yang menyebabkan kuku menjadi tebal, rapuh, berubah warna, dan kadang menimbulkan bau tidak sedap. Jika tidak diobati, infeksi dapat menyebar dan menyebabkan nyeri.",
    "cause": [
      "Jamur dermatofit",
      "Candida pada kondisi lembap dan hangat di sekitar kuku",
    ],
    "prevention": [
      "Menjaga kuku tetap bersih dan kering",
      "Menghindari sepatu ketat",
      "Tidak berbagi alat pedikur",
      "Mengganti kaus kaki secara rutin",
    ],
    "treatment": [
      "Antijamur topikal (mis. ciclopirox)",
      "Antijamur oral (terbinafine, itraconazole) jika perlu",
      "Perawatan kuku (debridement) pendamping",
    ],
    "urgency": "medium",
  },

  "poison ivy": {
    "description":
        "Reaksi alergi kulit yang disebabkan oleh kontak dengan tanaman poison ivy yang mengandung minyak urushiol, menyebabkan ruam merah, gatal, dan lepuhan.",
    "cause": [
      "Kontak langsung dengan minyak urushiol pada daun/batang/akar poison ivy",
    ],
    "prevention": [
      "Menghindari kontak dengan tanaman liar",
      "Memakai pakaian pelindung saat beraktivitas di alam",
      "Segera mencuci kulit/alat bila terpajan",
    ],
    "treatment": [
      "Kortikosteroid topikal atau oral (sesuai derajat)",
      "Antihistamin untuk gatal",
      "Kompres dingin/soothing",
    ],
    "urgency": "low",
  },

  "psoriasis": {
    "description":
        "Psoriasis adalah penyakit kulit kronis autoimun yang ditandai dengan pertumbuhan sel kulit yang cepat sehingga menyebabkan bercak merah bersisik, gatal, dan kadang nyeri.",
    "cause": [
      "Faktor genetik",
      "Sistem imun yang terlalu aktif",
      "Stres",
      "Infeksi",
      "Cuaca dingin",
    ],
    "prevention": [
      "Mengelola stres",
      "Menghindari merokok dan alkohol",
      "Menjaga kelembapan kulit",
      "Menghindari faktor pencetus",
    ],
    "treatment": [
      "Krim kortikosteroid",
      "Vitamin D analog",
      "Fototerapi (NB-UVB/PUVA)",
      "Obat sistemik (methotrexate, cyclosporine)",
      "Biologics (anti-TNF, IL-17/23) pada kasus sedang-berat",
    ],
    "urgency": "medium",
  },

  "sjs-ten": {
    "description":
        "Sindrom Stevens-Johnson dan Toxic Epidermal Necrolysis (SJS-TEN) adalah reaksi alergi parah terhadap obat atau infeksi yang menyebabkan kulit dan membran mukosa terkelupas dan luka serius yang mengancam jiwa.",
    "cause": [
      "Reaksi terhadap antibiotik tertentu",
      "Obat antikejang",
      "Infeksi virus tertentu",
    ],
    "prevention": [
      "Menghindari obat pemicu",
      "Konsultasi dengan dokter sebelum menggunakan obat baru",
      "Pencatatan alergi obat yang jelas",
    ],
    "treatment": [
      "Rawat inap (seringnya di ICU/ruang luka bakar)",
      "Hentikan obat pemicu",
      "Terapi cairan dan elektrolit",
      "Perawatan luka intensif",
      "IV immunoglobulin dan/atau imunomodulator (kasus terpilih)",
    ],
    "urgency": "high",
  },

  "scabies lyme": {
    "description":
        "Scabies adalah infeksi kulit akibat tungau kecil yang menyebabkan gatal hebat, sedangkan Lyme adalah penyakit menular akibat gigitan kutu yang dapat menyebabkan gejala sistemik serius.",
    "cause": [
      "Scabies: tungau Sarcoptes scabiei",
      "Lyme: bakteri Borrelia yang dibawa oleh kutu",
    ],
    "prevention": [
      "Menjaga kebersihan tubuh dan lingkungan",
      "Menghindari kontak dengan penderita scabies",
      "Menggunakan pengusir serangga dan pakaian pelindung untuk mencegah gigitan kutu",
    ],
    "treatment": [
      "Scabies: permethrin 5% atau ivermectin",
      "Lyme: antibiotik (doxycycline, amoxicillin) sesuai fase",
      "Terapi kontak serumah (scabies) dan dekontaminasi linen",
    ],
    "urgency": "high",
  },

  "systemic disease": {
    "description":
        "Penyakit sistemik adalah kondisi medis yang mempengaruhi banyak organ atau sistem dalam tubuh, termasuk kulit, dan sering kali berkaitan dengan gangguan autoimun atau inflamasi kronis.",
    "cause": [
      "Faktor genetik",
      "Gaya hidup tidak sehat",
      "Gangguan sistem imun",
    ],
    "prevention": [
      "Menjaga pola hidup sehat",
      "Rutin memeriksakan kesehatan",
      "Mengikuti pengobatan dan saran medis secara konsisten",
    ],
    "treatment": [
      "Disesuaikan dengan penyakit dasar",
      "Kortikosteroid, imunosupresif, atau biologik bila diperlukan",
      "Pendekatan multidisiplin",
    ],
    "urgency": "high",
  },

  "tinea candidiasis": {
    "description":
        "Infeksi jamur pada kulit, kuku, atau area mulut yang disebabkan oleh jamur tinea atau kandida, menyebabkan gatal, ruam, dan perubahan warna kulit atau kuku.",
    "cause": [
      "Pertumbuhan jamur berlebihan di area lembap dan kurang ventilasi",
    ],
    "prevention": [
      "Menjaga kebersihan dan kekeringan kulit",
      "Memakai pakaian yang menyerap keringat",
      "Tidak berbagi alat mandi atau pakaian",
    ],
    "treatment": [
      "Antijamur topikal (clotrimazole, miconazole, nystatin)",
      "Antijamur oral jika berat atau melibatkan kuku",
      "Perubahan kebiasaan agar area tetap kering",
    ],
    "urgency": "medium",
  },

  "urticaria hives": {
    "description":
        "Urtikaria atau biduran adalah kondisi kulit yang ditandai dengan munculnya bentol-bentol merah yang gatal akibat reaksi alergi atau faktor lain seperti stres dan suhu ekstrem.",
    "cause": [
      "Alergi terhadap makanan atau obat",
      "Gigitan/tersengat serangga",
      "Faktor fisik (panas/dingin/tekanan)",
      "Stres",
    ],
    "prevention": [
      "Menghindari pemicu alergi yang diketahui",
      "Mengelola stres dengan baik",
      "Waspada terhadap faktor fisik pemicu",
    ],
    "treatment": [
      "Antihistamin non-sedatif lini pertama",
      "Kortikosteroid oral jangka pendek pada kasus berat",
      "Biologik (omalizumab) untuk urtikaria kronis refrakter",
    ],
    "urgency": "low",
  },

  "vascular lesions": {
    "description":
        "Lesi vaskular adalah gangguan pada pembuluh darah kulit yang dapat menyebabkan bercak merah, ungu, atau benjolan kecil, baik yang bersifat bawaan maupun akibat trauma.",
    "cause": [
      "Faktor genetik",
      "Cedera/trauma pada kulit",
      "Penyakit pembuluh darah",
    ],
    "prevention": [
      "Menghindari trauma pada kulit",
      "Menjaga kesehatan pembuluh darah",
      "Pemantauan berkala bila ada riwayat keluarga",
    ],
    "treatment": [
      "Laser vaskular (PDL/ND:YAG) sesuai tipe",
      "Skleroterapi",
      "Operasi bila diperlukan",
    ],
    "urgency": "medium",
  },

  "vasculitis": {
    "description":
        "Vasculitis adalah peradangan pada pembuluh darah yang dapat menyebabkan kerusakan jaringan kulit dan organ lain, dengan gejala berupa ruam, nyeri, dan luka kulit.",
    "cause": ["Reaksi autoimun", "Infeksi", "Reaksi alergi obat"],
    "prevention": [
      "Mengelola kondisi medis yang mendasari",
      "Menghindari pemicu alergi/obat",
      "Kontrol rutin sesuai anjuran dokter",
    ],
    "treatment": [
      "Kortikosteroid sistemik",
      "Imunosupresif (azathioprine, cyclophosphamide, dll.)",
      "Biologik sesuai tipe vasculitis",
    ],
    "urgency": "high",
  },

  "warts molluscum": {
    "description":
        "Kutil (warts) dan molluscum contagiosum adalah infeksi virus yang menyebabkan benjolan kecil pada kulit, sering kali menular melalui kontak langsung dan dapat menyebar di area tubuh.",
    "cause": [
      "Infeksi virus Human Papillomavirus (HPV) untuk kutil",
      "Infeksi Molluscum contagiosum virus untuk molluscum",
    ],
    "prevention": [
      "Hindari kontak langsung dengan lesi",
      "Jaga kebersihan kulit",
      "Tidak berbagi barang pribadi (handuk, alat cukur)",
    ],
    "treatment": [
      "Krioterapi",
      "Asam salisilat/keratolitik",
      "Kuretase atau kauterisasi",
      "Imiquimod/topikal imunomodulator",
    ],
    "urgency": "medium",
  },
};
