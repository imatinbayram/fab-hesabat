USE MikroDB_V16_05

SELECT 
	crg_isim FILIAL,
	ROUND(SUM(sip_tutar - sip_iskonto_1  - sip_iskonto_2 - sip_iskonto_3), 2) [SIFARIS]
FROM MikroDB_V16_05.DBO.SIPARISLER WITH(NOLOCK)
LEFT JOIN MikroDB_V16_05.DBO.CARI_HESAPLAR WITH(NOLOCK) ON cari_kod = sip_musteri_kod
LEFT JOIN MikroDB_V16_05.DBO.CARI_HESAP_GRUPLARI WITH(NOLOCK) ON cari_grup_kodu = crg_kod
WHERE
	sip_tarih = @tarix2
	and sip_evrakno_seri like 'O%'
	and cari_grup_kodu in (
   '210','220','230','240','250',
   '520','521','523','540','542',
   '554','555','575'
	)

GROUP BY crg_isim