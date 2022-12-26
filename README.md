# Domain Check / Domain Sorgulama

Bu shell script "whois" ile çalışıyor o yüzden sisteminizde whois yüklü olmalı
```bash
sudo apt update
sudo apt install whois
```
Domain yazarken uzantı girmenze gerek yok içirisinde domainler ekli oradan ilave edebilir veya silebilir siniz
Uzantı bölümünden istediğiniz domain uzantılarını ekleyeblirsiniz şuan "('.com' '.com.tr' '.net' '.org' '.info' '.name' '.me' '.pro' '.tv' '.cc' )"  bunlar var.

Dosyayı indirdiğinizde; 
```bash
sudo chmod 775 domain-check.sh
```
yaparak çalıştırma izini vermeyi unutmayın..

./domain.check.sh yaparak çalıştıraiblirsiniz 
