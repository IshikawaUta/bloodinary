# Contoh kode dengan kerentanan keamanan untuk pengujian Bloodinary

# 1. SQL Injection
def get_user(params)
  user_id = params[:id]
  # Interpolasi string langsung dalam query adalah bahaya besar
  User.where("id = #{user_id}") 
  
  # find_by juga rentan jika menggunakan string dinamis
  User.find_by("name = '#{params[:name]}'")
  
  # Method query kustom
  DB.query("SELECT * FROM users WHERE email = '#{params[:email]}'")
end

# 2. Cross-Site Scripting (XSS)
def show_content(params)
  # Menggunakan raw() tanpa pembersihan
  @content = raw(params[:content])
  
  # Menggunakan html_safe pada variabel dinamis
  @safe_name = "User: #{params[:name]}".html_safe
end

# 3. Command Injection
def run_command(params)
  dir = params[:dir]
  # Eksekusi sistem dengan variabel dinamis
  system("ls #{dir}")
  
  # Penggunaan exec
  exec "rm -rf #{params[:path]}"
  
  # Penggunaan backticks
  `cat #{params[:file]}`
end

# 5. File Access (Path Traversal)
def file_access(params)
  # Berbahaya: Nama file dari user
  File.read("uploads/#{params[:filename]}")
  
  # Berbahaya: Dir.glob
  Dir.glob("data/#{params[:pattern]}")
end

# 6. Insecure Redirect
def redirect_user(params)
  # Berbahaya: URL dari user
  redirect_to params[:url]
end

# 7. Weak Cryptography
require 'digest'
def weak_hashing(password)
  # Berbahaya: MD5 dan SHA1 sudah tidak aman
  Digest::MD5.hexdigest(password)
  Digest::SHA1.hexdigest(password)
end

# 8. Fitur Ignore
def ignore_me(params)
  # Baris ini berisiko tapi diabaikan oleh user
  system("ls #{params[:dir]}") # bloodinary:ignore
end
