help-arg-remote = Remote Git lokal yang mengarah ke repositori yang akan dikerjakan
help-arg-repo = Repo yang ingin dikerjakan
msg-repo_not_found = Repo yang dituju tidak ditemukan
-dash =
    { IS_MINIMAL() ->
        [yes] -
       *[no] —
    }
msg-whoami = Login sebagai { $name }@{ $host }
help-cmd-auth-login = Masuk ke instalasi Forgejo
help-cmd-auth-login-long =
    Masuk ke instalasi Forgejo

    Membuka halaman autentikasi di browser
msg-auth-login-oauth_unsupported =
    Instalasi Forgejo anda tidak mendukung perintah `login` untuk { $host_domain }

    Silahkan mengunjungi { $applications_url }
    untuk membuat token dan gunakan untuk login dengan perintah `forge auth add-key`
msg-auth-login-canceled = Login dibatalkan
msg-auth-login-browser_success = Autentikasi berhasil! Tutup tab ini dan kembali ke terminal Anda.
msg-auth-login-browser_failure = Autentikasi gagal.
