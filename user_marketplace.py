# =============================================================================
# PENDIDIKANSTORE — VERSI USER (Marketplace Front-end)
# =============================================================================
# CARA MENJALANKAN LOKAL:
#   1. pip install Flask pymysql authlib
#   2. Copy .env.example ke .env dan isi dengan credential lokal kamu
#   3. Jalankan: python user_marketplace.py
#   4. Buka browser: http://localhost:5001
#
# DEPLOY KE VERCEL:
#   - Set semua environment variables di Vercel Dashboard
#   - Lihat .env.example untuk daftar variables yang diperlukan
# =============================================================================

# Load .env untuk development lokal (di Render, env var sudah di-set via dashboard)
try:
    from dotenv import load_dotenv
    load_dotenv()
except ImportError:
    pass

from flask import (
    Flask, render_template, request, redirect,
    session, jsonify, flash, send_from_directory,
    get_flashed_messages
)
import pymysql
import pymysql.cursors
from authlib.integrations.flask_client import OAuth
from datetime import datetime, timedelta
import os
from werkzeug.utils import secure_filename

app = Flask(__name__, static_folder=os.path.join(os.path.dirname(os.path.abspath(__file__)), 'static'))

# =============================================================================
# KONFIGURASI
# Semua credential dibaca dari environment variables.
# Set di Vercel Dashboard → Project → Settings → Environment Variables.
# Untuk lokal, buat file .env dan load dengan python-dotenv atau set manual.
# =============================================================================
app.config['SECRET_KEY']              = os.environ.get('SECRET_KEY', 'user_pendidikanstore_very_long_2024_xK9pL3qRmN8vT5wY')
app.config['SESSION_COOKIE_SAMESITE']  = 'Lax'
app.config['SESSION_COOKIE_SECURE']    = os.environ.get('FLASK_ENV') == 'production'
app.config['SESSION_COOKIE_HTTPONLY']  = True
# PERMANENT_SESSION_LIFETIME mengatur berapa lama cookie session bertahan.
# Flask akan otomatis menyertakan 'Max-Age' dan 'Expires' pada header Set-Cookie
# selama session.permanent = True (di-set via make_session_permanent).
app.config['PERMANENT_SESSION_LIFETIME'] = timedelta(days=30)

# Konfigurasi MySQL — dibaca dari environment variables
DB_HOST     = os.environ.get('MYSQL_HOST',     '127.0.0.1')
DB_USER     = os.environ.get('MYSQL_USER',     'root')
DB_PASSWORD = os.environ.get('MYSQL_PASSWORD', '')
DB_NAME     = os.environ.get('MYSQL_DB',       'sistem_penjualan')
DB_PORT     = int(os.environ.get('MYSQL_PORT', 3306))

def get_db_connection():
    """Buat koneksi baru ke database. Wajib ditutup (cur.close(), conn.close()) setelah selesai."""
    # TiDB Cloud memerlukan koneksi SSL. Deteksi otomatis berdasarkan hostname.
    use_ssl = 'tidbcloud.com' in DB_HOST
    ssl_params = {'ssl': {'ssl_verify_cert': False}} if use_ssl else {}
    return pymysql.connect(
        host=DB_HOST,
        user=DB_USER,
        password=DB_PASSWORD,
        database=DB_NAME,
        port=DB_PORT,
        cursorclass=pymysql.cursors.DictCursor,
        charset='utf8mb4',
        autocommit=False,
        **ssl_params,
    )

# ============================================================
# GOOGLE OAUTH CONFIG
# ============================================================
GOOGLE_CLIENT_ID     = os.environ.get('GOOGLE_CLIENT_ID', '')
GOOGLE_CLIENT_SECRET = os.environ.get('GOOGLE_CLIENT_SECRET', '')

# BASE_URL digunakan untuk membangun callback URL OAuth secara dinamis.
# Di Render, set env var RENDER_EXTERNAL_URL atau APP_BASE_URL.
# Contoh: https://scholara-user.onrender.com
APP_BASE_URL = os.environ.get('RENDER_EXTERNAL_URL', 'http://127.0.0.1:5001').rstrip('/')

oauth = OAuth(app)
google = oauth.register(
    name='google',
    client_id=GOOGLE_CLIENT_ID,
    client_secret=GOOGLE_CLIENT_SECRET,
    server_metadata_url='https://accounts.google.com/.well-known/openid-configuration',
    client_kwargs={
        'scope': 'openid email profile',
    }
)

def login_required(f):
    from functools import wraps
    @wraps(f)
    def decorated(*args, **kwargs):
        if 'pelanggan_id' not in session:
            return redirect('/login?next=' + request.path)
        return f(*args, **kwargs)
    return decorated

@app.before_request
def make_session_permanent():
    # Tandai session sebagai permanent di setiap request.
    # Ini membuat Flask menyertakan header 'Max-Age'/'Expires' pada cookie
    # sehingga cookie disimpan ke disk (bukan memori) oleh browser.
    # Akibatnya user tidak perlu login ulang walaupun browser ditutup.
    session.permanent = True



# =============================================================================
# HELPER FUNCTIONS
# =============================================================================

def format_rupiah(angka):
    try:
        return f"Rp {int(angka):,}".replace(',', '.')
    except:
        return "Rp 0"

def get_keranjang():
    return session.get('keranjang', [])

def hitung_total_keranjang():
    keranjang = get_keranjang()
    total  = sum(item['harga'] * item['qty'] for item in keranjang)
    jumlah = sum(item['qty'] for item in keranjang)
    return total, jumlah

def get_kategori():
    try:
        conn = get_db_connection()
        cur = conn.cursor()
        cur.execute("SELECT * FROM kategori ORDER BY nama")
        data = cur.fetchall()
        cur.close()
        conn.close()
        return data
    except:
        return []


# =============================================================================
# CONTEXT PROCESSOR
# Variabel di sini otomatis tersedia di SEMUA template tanpa perlu dikirim manual
# =============================================================================
@app.context_processor
def inject_global():
    icon_map = {
        # Jenjang pendidikan
        'SD'              : '📚',
        'SMP'             : '📖',
        'SMA'             : '🎒',
        'SMK'             : '🔧',
        'Perguruan Tinggi': '🎓',
        # Kategori lama
        'Elektronik'      : '💻',
        'Pakaian'         : '👕',
        'Makanan'         : '🍱',
        'Alat Tulis'      : '✏️',
        'Buku'            : '📗',
    }
    total_harga, jumlah_item = hitung_total_keranjang()
    kategori_list = get_kategori()

    cat_links = []
    for k in kategori_list:
        cat_links.append({
            'url'   : f'/user/katalog?kat={k["id"]}',
            'icon'  : icon_map.get(k['nama'], '🛍'),
            'label' : k['nama'],
            'active': request.path == '/user/katalog' and request.args.get('kat') == str(k['id']),
        })

    return dict(
        jumlah_item  = jumlah_item,
        cat_links    = cat_links,
        format_rupiah= format_rupiah,
        icon_map     = icon_map,
    )


# =============================================================================
# ROUTE: REDIRECT ROOT
# =============================================================================
@app.route('/')
@login_required
def index():
    return redirect('/user')


# =============================================================================
# ROUTE: BERANDA
# =============================================================================

# ============================================================
# AUTH ROUTES
# ============================================================
@app.route('/login')
def login_page():
    if 'pelanggan_id' in session:
        return redirect('/user/')
    return render_template('user/login.html', title='Login')

@app.route('/auth/google')
def auth_google():
    import secrets
    from flask import url_for
    scheme = request.headers.get('X-Forwarded-Proto', request.scheme)
    redirect_uri = url_for('auth_google_callback', _external=True, _scheme=scheme)
    # Generate and store nonce + state manually to prevent CSRF
    nonce = secrets.token_urlsafe(16)
    session['google_oauth_nonce'] = nonce
    return google.authorize_redirect(redirect_uri)

@app.route('/auth/google/callback')
def auth_google_callback():
    try:
        token = google.authorize_access_token()
    except Exception as e:
        print("OAuth callback error:", e)
        flash('Login gagal, silakan coba lagi.', 'danger')
        return redirect('/login')
    user_info = token.get('userinfo')
    if not user_info:
        flash('Login gagal. Silakan coba lagi.', 'danger')
        return redirect('/login')

    google_id   = user_info['sub']
    email       = user_info.get('email', '')
    nama        = user_info.get('name', email)
    foto        = user_info.get('picture', '')

    conn = get_db_connection()
    cur = conn.cursor()

    # Cari pelanggan berdasarkan google_id atau email
    cur.execute("SELECT id, nama FROM pelanggan WHERE google_id=%s OR email=%s LIMIT 1", (google_id, email))
    pelanggan = cur.fetchone()

    if pelanggan:
        # Update info terbaru
        cur.execute("UPDATE pelanggan SET google_id=%s, foto_profil=%s, nama=%s WHERE id=%s",
                    (google_id, foto, nama, pelanggan['id']))
        pelanggan_id = pelanggan['id']
    else:
        # Buat pelanggan baru
        import uuid
        kode = 'PLG-' + uuid.uuid4().hex[:6].upper()
        cur.execute("""INSERT INTO pelanggan (kode_pelanggan, nama, email, google_id, foto_profil, status)
                       VALUES (%s, %s, %s, %s, %s, 'aktif')""",
                    (kode, nama, email, google_id, foto))
        pelanggan_id = cur.lastrowid

    conn.commit()
    cur.close()
    conn.close()

    # Set session.permanent = True SEBELUM mengisi data session.
    # Ini penting agar Flask mengirim cookie dengan Max-Age yang benar
    # sehingga browser menyimpan cookie ke disk (bertahan walaupun browser ditutup).
    session.permanent = True
    session['pelanggan_id']    = pelanggan_id
    session['nama']            = nama
    session['email']           = email
    session['foto']            = foto
    session['pelanggan_nama']  = nama
    session['pelanggan_foto']  = foto
    session['pelanggan_email'] = email
    session.modified = True
    # flash(f'Selamat datang, {nama}!', 'success') # Mute flash if we have a welcome screen
    return redirect('/welcome')

@app.route('/logout')
def logout():
    session.clear()
    flash('Anda telah keluar.', 'info')
    return redirect('/login')

@app.route('/welcome')
@login_required
def welcome():
    return render_template('user/welcome.html')

@app.route('/user/')
@app.route('/user')
@login_required
def beranda():
    conn = get_db_connection()
    cur = conn.cursor()

    cur.execute("""
        SELECT p.*, k.nama as kategori_nama
        FROM produk p LEFT JOIN kategori k ON p.kategori_id = k.id
        WHERE p.status = 'aktif' AND p.stok > 0
        ORDER BY p.stok DESC LIMIT 8
    """)
    produk_unggulan = cur.fetchall()

    cur.execute("""
        SELECT p.*, k.nama as kategori_nama
        FROM produk p LEFT JOIN kategori k ON p.kategori_id = k.id
        WHERE p.status = 'aktif' AND p.stok > 0
        ORDER BY p.created_at DESC LIMIT 4
    """)
    produk_baru = cur.fetchall()

    kategori = get_kategori()
    cur.close()
    conn.close()

    icon_map = {
        'SD'              : '📚',
        'SMP'             : '📖',
        'SMA'             : '🎒',
        'SMK'             : '🔧',
        'Perguruan Tinggi': '🎓',
        'Elektronik'      : '💻',
        'Pakaian'         : '👕',
        'Makanan'         : '🍱',
        'Alat Tulis'      : '✏️',
        'Buku'            : '📗',
    }

    return render_template(
        'user/beranda.html',
        title='Beranda',
        produk_unggulan=produk_unggulan,
        produk_baru=produk_baru,
        kategori=kategori,
        icon_map=icon_map,
    )


# =============================================================================
# ROUTE: KATALOG
# =============================================================================
@app.route('/user/katalog')
@app.route('/user/produk')
@login_required
def katalog():
    conn = get_db_connection()
    cur = conn.cursor()
    kat_id  = request.args.get('kat', '')
    sort_by = request.args.get('sort', '')
    q       = request.args.get('q', '')

    # Sertakan kolom atribut buku dalam query
    query  = """
        SELECT p.*, k.nama as kategori_nama,
               p.mapel, p.penerbit, p.kurikulum, p.kelas, p.semester
        FROM produk p LEFT JOIN kategori k ON p.kategori_id = k.id
        WHERE p.status = 'aktif'
    """
    params = []

    if q:
        query += " AND (p.nama LIKE %s OR p.mapel LIKE %s)"
        params.append(f"%{q}%")
        params.append(f"%{q}%")
    if kat_id:
        query += " AND p.kategori_id = %s"
        params.append(kat_id)

    if sort_by in ('terbaru', 'baru'):
        query += " ORDER BY p.created_at DESC"
    elif sort_by == 'termurah':
        query += " ORDER BY p.harga ASC"
    elif sort_by == 'stok_terbanyak':
        query += " ORDER BY p.stok DESC"
    elif sort_by == 'terjangkau':
        query += " AND p.harga <= 50000 ORDER BY p.harga ASC"
    elif sort_by == 'termahal':
        query += " ORDER BY p.harga DESC"
    else:
        query += " ORDER BY p.nama ASC"

    cur.execute(query, tuple(params))
    produk   = cur.fetchall()

    # Ambil info kategori aktif untuk heading
    kat_nama = ''
    if kat_id:
        cur.execute("SELECT nama FROM kategori WHERE id=%s", (kat_id,))
        kat_row = cur.fetchone()
        kat_nama = kat_row['nama'] if kat_row else ''

    kategori = get_kategori()
    cur.close()
    conn.close()

    # Icon map jenjang pendidikan
    JENJANG_ICON = {
        'SD': '📚', 'SMP': '📖', 'SMA': '🎒',
        'SMK': '🔧', 'Perguruan Tinggi': '🎓',
    }

    return render_template(
        'user/produk.html',
        title='Katalog Produk',
        produk=produk,
        kategori=kategori,
        kat_id=kat_id,
        kat_nama=kat_nama,
        sort_by=sort_by,
        q=q,
        JENJANG_ICON=JENJANG_ICON,
    )


# =============================================================================
# ROUTE: DETAIL PRODUK
# =============================================================================
@app.route('/user/produk/<int:produk_id>')
@login_required
def detail_produk(produk_id):
    conn = get_db_connection()
    cur = conn.cursor()
    cur.execute("""
        SELECT p.*, k.nama as kategori_nama
        FROM produk p LEFT JOIN kategori k ON p.kategori_id = k.id
        WHERE p.id = %s AND p.status = 'aktif'
    """, (produk_id,))
    p = cur.fetchone()

    if not p:
        flash('Produk tidak ditemukan.', 'danger')
        cur.close()
        conn.close()
        return redirect('/user/')

    cur.execute("""
        SELECT * FROM produk
        WHERE kategori_id = %s AND id != %s AND status='aktif' AND stok > 0
        LIMIT 4
    """, (p['kategori_id'], produk_id))
    terkait = cur.fetchall()
    cur.close()
    conn.close()

    return render_template(
        'user/detail.html',
        title=p['nama'],
        p=p,
        terkait=terkait,
        harga_fmt=format_rupiah(p['harga']),
    )


# =============================================================================
# ROUTE: KERANJANG
# =============================================================================
@app.route('/user/keranjang')
def keranjang():
    cart  = get_keranjang()
    total, jumlah = hitung_total_keranjang()

    return render_template(
        'user/keranjang.html',
        title='Keranjang Saya',
        keranjang=cart,
        total=total,
        jumlah=jumlah,
    )


# =============================================================================
# ROUTE: CHECKOUT
# =============================================================================
@app.route('/user/checkout', methods=['GET', 'POST'])
@login_required
def checkout():
    cart = get_keranjang()
    if not cart:
        flash('Keranjang kosong, silakan belanja dulu!', 'warning')
        return redirect('/user/katalog')

    total_harga, jumlah_item = hitung_total_keranjang()

    if request.method == 'POST':
        nama              = request.form.get('nama')
        telepon           = request.form.get('telepon')
        email             = request.form.get('email', '')
        alamat            = request.form.get('alamat')
        metode_pembayaran = request.form.get('metode_bayar') or request.form.get('metode_pembayaran', 'cod')

        if not all([nama, telepon, alamat, metode_pembayaran]):
            flash('Harap lengkapi semua data pengiriman!', 'danger')
            return redirect('/user/checkout')

        conn = get_db_connection()
        cur = conn.cursor()

        # Validasi stok sebelum proses
        for item in cart:
            cur.execute("SELECT stok, nama FROM produk WHERE id = %s", (item['produk_id'],))
            prod = cur.fetchone()
            if not prod or prod['stok'] < item['qty']:
                flash(f"Stok produk {item['nama']} tidak mencukupi (Sisa: {prod['stok'] if prod else 0}).", "danger")
                cur.close()
                conn.close()
                return redirect('/user/keranjang')

        try:
            no_pesanan   = 'ORD' + datetime.now().strftime('%Y%m%d%H%M%S')
            tanggal      = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
            pelanggan_id = session.get('pelanggan_id') or 0

            # Simpan info pengiriman ke catatan karena tidak ada kolom khusus
            catatan_kirim = f"Nama: {nama} | Telp: {telepon} | Alamat: {alamat}"

            cur.execute("""
                INSERT INTO pesanan (no_pesanan, pelanggan_id, tanggal_pesan,
                                     total_harga, total_bayar, status, metode_bayar, catatan)
                VALUES (%s, %s, %s, %s, %s, %s, %s, %s)
            """, (no_pesanan, pelanggan_id, datetime.now().strftime('%Y-%m-%d'),
                  total_harga, total_harga, 'pending', metode_pembayaran, catatan_kirim))
            pesanan_id = cur.lastrowid

            for item in cart:
                subtotal = item['harga'] * item['qty']
                cur.execute("""
                    INSERT INTO detail_pesanan (pesanan_id, produk_id, jumlah, harga_satuan, subtotal)
                    VALUES (%s, %s, %s, %s, %s)
                """, (pesanan_id, item['produk_id'], item['qty'], item['harga'], subtotal))
                cur.execute("UPDATE produk SET stok = stok - %s WHERE id = %s",
                            (item['qty'], item['produk_id']))

            conn.commit()
            cur.close()
            conn.close()

            session['keranjang'] = []
            session.modified = True
            return redirect(f'/user/sukses/{no_pesanan}')

        except Exception as e:
            flash(f'Terjadi kesalahan: {str(e)}', 'danger')
            cur.close()
            conn.close()

    return render_template(
        'user/checkout.html',
        title='Checkout',
        cart=cart,
        total=total_harga,
    )


# =============================================================================
# ROUTE: SUKSES
# =============================================================================
@app.route('/user/sukses/<no_pesanan>')
@login_required
def sukses(no_pesanan):
    return render_template(
        'user/sukses.html',
        title='Pesanan Berhasil',
        no_pesanan=no_pesanan,
    )


# =============================================================================
# ROUTE: RIWAYAT PESANAN
# =============================================================================

@app.route('/user/pengaturan', methods=['GET', 'POST'])
def user_pengaturan():
    if 'pelanggan_id' not in session:
        flash('Silakan login terlebih dahulu.', 'warning')
        return redirect('/login')

    pelanggan_id = session['pelanggan_id']
    conn = get_db_connection()
    cur = conn.cursor()

    if request.method == 'POST':
        nama = request.form.get('nama')
        telepon = request.form.get('telepon')
        alamat = request.form.get('alamat')
        kota = request.form.get('kota')
        foto_profil = None

        if 'foto_profil' in request.files:
            file = request.files['foto_profil']
            if file and file.filename != '':
                filename = secure_filename(file.filename)
                # Gunakan format id_filename untuk mencegah bentrok
                new_filename = f"pelanggan_{pelanggan_id}_{filename}"
                upload_path = os.path.join(app.root_path, 'static/uploads/pelanggan', new_filename)
                os.makedirs(os.path.dirname(upload_path), exist_ok=True)
                file.save(upload_path)
                foto_profil = new_filename

        if foto_profil:
            cur.execute("""
                UPDATE pelanggan
                SET nama=%s, telepon=%s, alamat=%s, kota=%s, foto_profil=%s
                WHERE id=%s
            """, (nama, telepon, alamat, kota, foto_profil, pelanggan_id))
        else:
            cur.execute("""
                UPDATE pelanggan
                SET nama=%s, telepon=%s, alamat=%s, kota=%s
                WHERE id=%s
            """, (nama, telepon, alamat, kota, pelanggan_id))

        conn.commit()
        
        # Update session
        session['pelanggan_nama'] = nama
        if foto_profil:
            session['pelanggan_foto'] = f"/static/uploads/pelanggan/{foto_profil}"

        cur.close()
        conn.close()
        flash('Pengaturan akun berhasil disimpan!', 'success')
        return redirect('/user/pengaturan')

    # GET request
    cur.execute("SELECT * FROM pelanggan WHERE id=%s", (pelanggan_id,))
    user = cur.fetchone()
    cur.close()
    conn.close()

    return render_template('user/pengaturan.html', user=user, title="Pengaturan Akun")

@app.route('/user/pesanan')
def user_pesanan():
    if 'pelanggan_id' not in session:
        flash('Login dulu ya!', 'warning')
        return redirect('/login')
    
    pelanggan_id = session['pelanggan_id']
    conn = get_db_connection()
    cur = conn.cursor()
    
    cur.execute("""
        SELECT p.*
        FROM pesanan p
        WHERE p.pelanggan_id = %s
        ORDER BY p.created_at DESC
    """, (pelanggan_id,))
    pesanan_raw = cur.fetchall()
    
    pesanan_list = []
    for p in pesanan_raw:
        cur.execute("""
            SELECT dp.*, pr.nama as nama_produk, pr.gambar, dp.harga_satuan
            FROM detail_pesanan dp
            JOIN produk pr ON dp.produk_id = pr.id
            WHERE dp.pesanan_id = %s
        """, (p['id'],))
        items = cur.fetchall()
        pesanan_list.append({**p, 'detail_items': items})
    
    cur.close()
    conn.close()
    return render_template('user/pesanan.html', title='Pesanan Saya', pesanan_list=pesanan_list)


@app.route('/user/tracking/<no_pesanan>')
def user_tracking(no_pesanan):
    if 'pelanggan_id' not in session:
        flash('Login dulu ya!', 'warning')
        return redirect('/login')
    
    conn = get_db_connection()
    cur = conn.cursor()
    cur.execute("""
        SELECT p.*, pl.nama as nama_pembeli
        FROM pesanan p
        LEFT JOIN pelanggan pl ON p.pelanggan_id = pl.id
        WHERE p.no_pesanan = %s AND p.pelanggan_id = %s
    """, (no_pesanan, session['pelanggan_id']))
    pesanan = cur.fetchone()
    
    if not pesanan:
        flash('Pesanan tidak ditemukan!', 'danger')
        cur.close()
        conn.close()
        return redirect('/user/pesanan')
    
    cur.execute("""
        SELECT dp.*, pr.nama as nama_produk, pr.gambar
        FROM detail_pesanan dp
        JOIN produk pr ON dp.produk_id = pr.id
        WHERE dp.pesanan_id = %s
    """, (pesanan['id'],))
    detail = cur.fetchall()
    
    # Mark notifikasi as read for this pesanan
    cur.execute("""
        UPDATE notifikasi SET is_read = 1
        WHERE pesanan_id = %s AND pelanggan_id = %s
    """, (pesanan['id'], session['pelanggan_id']))
    conn.commit()
    
    cur.close()
    conn.close()
    return render_template('user/tracking.html', title='Lacak Pesanan', pesanan=pesanan, detail=detail)

@app.route('/user/api/notifikasi')
def api_notifikasi():
    if 'pelanggan_id' not in session:
        return jsonify({'unread': 0, 'items': []})
    conn = get_db_connection()
    cur = conn.cursor()
    cur.execute("""
        SELECT n.*, p.no_pesanan
        FROM notifikasi n
        JOIN pesanan p ON n.pesanan_id = p.id
        WHERE n.pelanggan_id = %s
        ORDER BY n.created_at DESC LIMIT 10
    """, (session['pelanggan_id'],))
    items = cur.fetchall()
    unread = sum(1 for i in items if not i['is_read'])
    result = []
    for i in items:
        result.append({
            'id': i['id'],
            'pesan': i['pesan'],
            'no_pesanan': i['no_pesanan'],
            'is_read': i['is_read'],
            'created_at': i['created_at'].strftime('%d %b %Y, %H:%M') if i['created_at'] else ''
        })
    cur.close()
    conn.close()
    return jsonify({'unread': unread, 'items': result})

@app.route('/user/api/notifikasi/baca_semua', methods=['POST'])
def api_notifikasi_baca_semua():
    if 'pelanggan_id' not in session:
        return jsonify({'success': False})
    conn = get_db_connection()
    cur = conn.cursor()
    cur.execute("UPDATE notifikasi SET is_read=1 WHERE pelanggan_id=%s AND is_read=0", (session['pelanggan_id'],))
    conn.commit()
    cur.close()
    conn.close()
    return jsonify({'success': True})

@app.route('/user/api/keranjang/tambah', methods=['POST'])
def api_tambah_keranjang():
    data      = request.get_json()
    produk_id = int(data.get('produk_id', 0))
    qty       = int(data.get('qty', 1))

    try:
        conn = get_db_connection()
        cur = conn.cursor()
        cur.execute("SELECT * FROM produk WHERE id=%s AND status='aktif'", (produk_id,))
        p = cur.fetchone()
        cur.close()
        conn.close()
    except:
        return jsonify({'ok': False, 'msg': 'Database error'})

    if not p:
        return jsonify({'ok': False, 'msg': 'Produk tidak ditemukan'})
    if p['stok'] <= 0:
        return jsonify({'ok': False, 'msg': 'Stok habis!'})

    cart  = get_keranjang()
    found = False
    for item in cart:
        if item['id'] == produk_id:
            item['qty'] = min(item['qty'] + qty, p['stok'])
            found = True
            break

    if not found:
        cart.append({
            'id'       : produk_id,
            'produk_id': produk_id,
            'nama'     : p['nama'],
            'harga'    : float(p['harga']),
            'qty'      : min(qty, p['stok']),
            'satuan'   : p['satuan'],
            'gambar'   : p.get('gambar'),
            'stok_max' : p['stok'],
        })

    session['keranjang'] = cart
    session.modified = True

    total_qty = sum(i['qty'] for i in cart)
    return jsonify({'ok': True, 'msg': f'{p["nama"]} ditambahkan!', 'jumlah': total_qty})


# =============================================================================
# API: KERANJANG — UPDATE QTY
# =============================================================================
@app.route('/user/api/keranjang/update', methods=['POST'])
def api_update_keranjang():
    data      = request.get_json()
    produk_id = int(data.get('produk_id', 0))
    qty       = max(1, int(data.get('qty', 1)))

    cart          = get_keranjang()
    subtotal_item = 0
    total         = 0
    for item in cart:
        if item['id'] == produk_id:
            item['qty']   = qty
            subtotal_item = item['harga'] * qty
        total += item['harga'] * item['qty']

    session['keranjang'] = cart
    session.modified = True
    total_qty = sum(i['qty'] for i in cart)

    return jsonify({
        'ok'      : True,
        'subtotal': format_rupiah(subtotal_item),
        'total'   : format_rupiah(total),
        'jumlah'  : total_qty,
    })


# =============================================================================
# API: KERANJANG — HAPUS ITEM
# =============================================================================
@app.route('/user/api/keranjang/hapus', methods=['POST'])
def api_hapus_keranjang():
    data      = request.get_json()
    produk_id = int(data.get('produk_id', 0))

    cart = [i for i in get_keranjang() if i['id'] != produk_id]
    session['keranjang'] = cart
    session.modified = True

    total     = sum(i['harga'] * i['qty'] for i in cart)
    total_qty = sum(i['qty'] for i in cart)
    return jsonify({'ok': True, 'total': format_rupiah(total), 'jumlah': total_qty})


# =============================================================================
# STATIC: Serve gambar produk
# =============================================================================
@app.route('/static/uploads/<filename>')
def serve_upload(filename):
    base_dir      = os.path.dirname(os.path.abspath(__file__))
    upload_folder = os.path.join(base_dir, 'static', 'uploads', 'produk')
    return send_from_directory(upload_folder, filename)


# =============================================================================
# Google Verification
# =============================================================================
@app.route('/google063d7f23ed4aefda.html')
def google_verify():
    return app.send_static_file('google063d7f23ed4aefda.html')


# =============================================================================
# SSE: STREAM ORDER STATUS (diganti polling JSON untuk kompatibilitas Vercel)
# Vercel serverless function tidak mendukung streaming panjang.
# Frontend sekarang poll endpoint ini setiap beberapa detik.
# =============================================================================
from flask import Response
import json as _json

@app.route('/user/stream_order_status')
@login_required
def stream_order_status():
    """Endpoint polling JSON — return status pesanan saat ini (bukan SSE streaming)."""
    pelanggan_id = session.get('pelanggan_id')
    try:
        conn = get_db_connection()
        cur = conn.cursor()
        cur.execute("SELECT id, status FROM pesanan WHERE pelanggan_id = %s", (pelanggan_id,))
        orders = cur.fetchall()
        cur.close()
        conn.close()
        return jsonify({'orders': [{'id': o['id'], 'status': o['status']} for o in orders]})
    except Exception as e:
        return jsonify({'orders': [], 'error': str(e)})

# =============================================================================
# ENTRY POINT
# =============================================================================
if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5001, debug=True, use_reloader=False)
