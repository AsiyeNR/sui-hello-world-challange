# Day 17: Entry Functions ve Shared Objects
Bugün kontratımızı dış dünyaya açan `entry` fonksiyonlarını ve herkesin erişebildiği paylaşılan objeleri öğrendik.

### Öğrenilenler:
- **entry fun**: Transaction'lar üzerinden doğrudan çağrılabilen fonksiyonlar.
- **transfer::share_object**: Objeyi global ve herkes tarafından erişilebilir kılma.
- **tx_context::sender()**: İşlemi başlatan adresi tanıma.
