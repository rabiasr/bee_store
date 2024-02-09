import 'package:bee_store/sayfalar/kayit_sayfasi.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class GirisSayfasi extends StatefulWidget {
  const GirisSayfasi({super.key});

  @override
  State<GirisSayfasi> createState() => _GirisSayfasiState();
}

class _GirisSayfasiState extends State<GirisSayfasi> {
  var _yukleniyor = false;
  var _hataMesaji = "";
  var _email = "";
  var _sifre = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Giriş Sayfası")),
      body: Padding(
        padding: const EdgeInsets.all(48.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_hataMesaji.isNotEmpty)
              Text(
                "Bir hata oluştu: $_hataMesaji",
                style: const TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
            TextField(
              decoration: const InputDecoration(hintText: "Email adresini gir"),
              keyboardType: TextInputType.emailAddress,
              onChanged: (deger) {
                _email = deger;
                debugPrint(deger);

                if (_hataMesaji.isNotEmpty) {
                  _hataMesaji = "";
                  setState(() {});
                }
              },
            ),
            const SizedBox(height: 24),
            TextField(
              decoration: const InputDecoration(hintText: "Şifreni gir"),
              keyboardType: TextInputType.visiblePassword,
              obscureText: true,
              onChanged: (deger) {
                _sifre = deger;
                debugPrint(deger);

                if (_hataMesaji.isNotEmpty) {
                  _hataMesaji = "";
                  setState(() {});
                }
              },
            ),
            const SizedBox(height: 32),
            if (_yukleniyor)
              const CircularProgressIndicator()
            else
              TextButton(
                onPressed: () {
                  if (_email.isNotEmpty && _sifre.isNotEmpty) {
                    _yukleniyor = true;
                    setState(() {});
                    FirebaseAuth.instance
                        .signInWithEmailAndPassword(
                      email: _email,
                      password: _sifre,
                    )
                        .catchError(
                      (hataMesaji) {
                        _hataMesaji = hataMesaji.toString();
                        _yukleniyor = false;
                        setState(() {});
                      },
                    );
                  } else {
                    _hataMesaji = "Email adresi ve şifre boş geçilemez!";
                    setState(() {});
                  }
                },
                child: const Text("Giriş Yap"),
              ),
            const Divider(height: 64),
            TextButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) {
                    return const KayitSayfasi();
                  }),
                );
              },
              child: const Text("Kayıt Ol"),
            ),
          ],
        ),
      ),
    );
  }
}
