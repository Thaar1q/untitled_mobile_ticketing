import '../models/ticket_item.dart';

class MockTicketData {
  MockTicketData._();

  static List<TicketItem> initialTickets() {
    return const [
      TicketItem(
        id: 'TK-2401',
        title: 'Email kantor tidak bisa login',
        description:
            'Pengguna gagal login sejak pagi dengan pesan invalid token.',
        status: 'Open',
        requester: 'User',
        assignee: '-',
        createdAt: '22 Apr 2026 08:20',
        attachments: ['Kamera - screenshot_login.jpg'],
        comments: [
          TicketComment(
            id: 'C-2401-1',
            author: 'User',
            message: 'Sudah saya coba ganti password, masih gagal.',
            createdAt: '22 Apr 2026 08:25',
          ),
        ],
        tracking: [
          TicketTrackingEvent(
            label: 'Ticket dibuat',
            note: 'Laporan awal terkirim dari aplikasi mobile.',
            createdAt: '22 Apr 2026 08:20',
          ),
        ],
      ),
      TicketItem(
        id: 'TK-2402',
        title: 'Printer lantai 2 offline',
        description:
            'Printer jaringan tidak terdeteksi di 5 PC staf administrasi.',
        status: 'In Progress',
        requester: 'Deni Staff',
        assignee: 'Helpdesk',
        createdAt: '22 Apr 2026 09:05',
        attachments: ['Galeri - printer_error.png'],
        comments: [
          TicketComment(
            id: 'C-2402-1',
            author: 'Helpdesk',
            message: 'Sedang cek switch jaringan area lantai 2.',
            createdAt: '22 Apr 2026 09:20',
          ),
        ],
        tracking: [
          TicketTrackingEvent(
            label: 'Ticket dibuat',
            note: 'Keluhan printer diterima sistem.',
            createdAt: '22 Apr 2026 09:05',
          ),
          TicketTrackingEvent(
            label: 'Diproses',
            note: 'Helpdesk mulai investigasi perangkat.',
            createdAt: '22 Apr 2026 09:18',
          ),
        ],
      ),
      TicketItem(
        id: 'TK-2403',
        title: 'Reset akses VPN',
        description: 'Akun VPN terkunci setelah 3x salah password.',
        status: 'Resolved',
        requester: 'Lina Finance',
        assignee: 'Admin',
        createdAt: '21 Apr 2026 16:40',
        attachments: [],
        comments: [
          TicketComment(
            id: 'C-2403-1',
            author: 'Admin',
            message: 'Akses VPN sudah direset, silakan coba ulang.',
            createdAt: '21 Apr 2026 17:10',
          ),
        ],
        tracking: [
          TicketTrackingEvent(
            label: 'Ticket dibuat',
            note: 'Permintaan reset VPN diterima.',
            createdAt: '21 Apr 2026 16:40',
          ),
          TicketTrackingEvent(
            label: 'Selesai',
            note: 'Reset akses berhasil dan dikonfirmasi.',
            createdAt: '21 Apr 2026 17:12',
          ),
        ],
      ),
      TicketItem(
        id: 'TK-2404',
        title: 'Instal software akuntansi',
        description:
            'Perlu instalasi software akuntansi terbaru untuk tim keuangan.',
        status: 'Open',
        requester: 'Budi Finance',
        assignee: '-',
        createdAt: '21 Apr 2026 13:10',
        attachments: [],
        comments: [],
        tracking: [
          TicketTrackingEvent(
            label: 'Ticket dibuat',
            note: 'Permintaan instalasi aplikasi baru.',
            createdAt: '21 Apr 2026 13:10',
          ),
        ],
      ),
      TicketItem(
        id: 'TK-2405',
        title: 'Akses shared folder ditolak',
        description: 'Folder proyek tidak bisa dibuka oleh tim desain.',
        status: 'Open',
        requester: 'Salsa Design',
        assignee: '-',
        createdAt: '21 Apr 2026 11:05',
        attachments: ['Galeri - access_denied.png'],
        comments: [],
        tracking: [
          TicketTrackingEvent(
            label: 'Ticket dibuat',
            note: 'Gangguan hak akses folder bersama.',
            createdAt: '21 Apr 2026 11:05',
          ),
        ],
      ),
      TicketItem(
        id: 'TK-2406',
        title: 'Laptop sering blue screen',
        description: 'Blue screen terjadi 2-3 kali saat buka spreadsheet.',
        status: 'In Progress',
        requester: 'Rafi Operasional',
        assignee: 'Helpdesk',
        createdAt: '21 Apr 2026 10:00',
        attachments: ['Kamera - bsod_code.jpg'],
        comments: [],
        tracking: [
          TicketTrackingEvent(
            label: 'Ticket dibuat',
            note: 'Laporan perangkat crash berulang.',
            createdAt: '21 Apr 2026 10:00',
          ),
        ],
      ),
      TicketItem(
        id: 'TK-2407',
        title: 'Tidak bisa cetak PDF',
        description: 'Dokumen PDF dari browser gagal dikirim ke printer.',
        status: 'Open',
        requester: 'Mira Admin',
        assignee: '-',
        createdAt: '20 Apr 2026 16:15',
        attachments: [],
        comments: [],
        tracking: [
          TicketTrackingEvent(
            label: 'Ticket dibuat',
            note: 'Kendala output PDF printer kantor.',
            createdAt: '20 Apr 2026 16:15',
          ),
        ],
      ),
      TicketItem(
        id: 'TK-2408',
        title: 'Aplikasi kasir error saat login',
        description: 'App kasir menampilkan pesan timeout ke server internal.',
        status: 'In Progress',
        requester: 'Arman Retail',
        assignee: 'Admin',
        createdAt: '20 Apr 2026 15:20',
        attachments: [],
        comments: [],
        tracking: [
          TicketTrackingEvent(
            label: 'Ticket dibuat',
            note: 'Issue aplikasi kasir dilaporkan shift siang.',
            createdAt: '20 Apr 2026 15:20',
          ),
        ],
      ),
      TicketItem(
        id: 'TK-2409',
        title: 'Monitor kedua tidak terdeteksi',
        description: 'Dual monitor kantor tidak tampil setelah update driver.',
        status: 'Resolved',
        requester: 'Rendy Analyst',
        assignee: 'Helpdesk',
        createdAt: '20 Apr 2026 14:05',
        attachments: [],
        comments: [],
        tracking: [
          TicketTrackingEvent(
            label: 'Ticket dibuat',
            note: 'Permintaan dukungan display workstation.',
            createdAt: '20 Apr 2026 14:05',
          ),
          TicketTrackingEvent(
            label: 'Selesai',
            note: 'Konfigurasi ulang display berhasil.',
            createdAt: '20 Apr 2026 14:50',
          ),
        ],
      ),
      TicketItem(
        id: 'TK-2410',
        title: 'Mic meeting room tidak berfungsi',
        description:
            'Audio input ruangan meeting tidak masuk ke aplikasi call.',
        status: 'Open',
        requester: 'Tim HR',
        assignee: '-',
        createdAt: '20 Apr 2026 11:35',
        attachments: [],
        comments: [],
        tracking: [
          TicketTrackingEvent(
            label: 'Ticket dibuat',
            note: 'Keluhan perangkat meeting room.',
            createdAt: '20 Apr 2026 11:35',
          ),
        ],
      ),
      TicketItem(
        id: 'TK-2411',
        title: 'Permintaan akun email baru',
        description: 'Butuh akun email untuk staf baru divisi procurement.',
        status: 'Resolved',
        requester: 'Dita HR',
        assignee: 'Admin',
        createdAt: '20 Apr 2026 10:45',
        attachments: [],
        comments: [],
        tracking: [
          TicketTrackingEvent(
            label: 'Ticket dibuat',
            note: 'Permintaan provisioning akun email.',
            createdAt: '20 Apr 2026 10:45',
          ),
          TicketTrackingEvent(
            label: 'Selesai',
            note: 'Akun email baru aktif.',
            createdAt: '20 Apr 2026 11:10',
          ),
        ],
      ),
      TicketItem(
        id: 'TK-2412',
        title: 'Akses WiFi tamu gagal',
        description: 'Jaringan tamu tidak bisa terhubung di area lobby.',
        status: 'Open',
        requester: 'Resepsionis',
        assignee: '-',
        createdAt: '20 Apr 2026 09:30',
        attachments: [],
        comments: [],
        tracking: [
          TicketTrackingEvent(
            label: 'Ticket dibuat',
            note: 'Laporan kendala jaringan tamu kantor.',
            createdAt: '20 Apr 2026 09:30',
          ),
        ],
      ),
    ];
  }
}
