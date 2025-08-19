USE MikroDB_V16_05

IF OBJECT_ID('tempdb..#OLMAZ0') IS NOT NULL
	    DROP TABLE #OLMAZ0;

WITH DATA_OLMAZ0 AS (
select * from 
(SELECT 
(select top 1 crg_isim from CARI_HESAP_GRUPLARI with (nolock) where crg_kod=cari_grup_kodu)  AS [GRUP ADI]
,cari_temsilci_kodu AS [TEMSILCI KODU]
,(select top 1 cari_per_adi from CARI_PERSONEL_TANIMLARI with (nolock) where cari_per_kod=cari_temsilci_kodu)  AS [TEMSILCI ADI]
,cari_kod AS [CARI KODU]
,cari_Ana_cari_kodu AS [CARI ANA KODU]
,cari_unvan1 AS [CARI ADI]
,cari_unvan2 AS [TAM ADI] 
,case when cari_Ana_cari_kodu in (select cari from KompaniyaB) then 'VIP' else 'STANDART' end [CARI TIPI]
,ROUND(ISNULL(H.[CARI BORC],0),2) [CARI BORC]
,ROUND(ISNULL(H.[ILK BORC],0),2) [ILK BORC]
,ROUND(ISNULL(H.[SON BORC],0),2) [SON BORC]
,cari_banka_hesapno2 AS [QALAN ENDIRIM]
,dbo.getaltlimit(cari_kod) AS [LIMIT]
,ISNULL(ct.ustlimit,0) [UST LIMIT]
,cari_banka_hesapno8 OLMAZ 
,case when cari_banka_hesapno8 like 'OLMAZ 0%' then case when REPLACE(REPLACE(cari_banka_hesapno8,LEFT(cari_banka_hesapno8,9),''),RIGHT(cari_banka_hesapno8,12),'')='100000' then  case when CAST(REPLACE(REPLACE(cari_banka_hesapno8,LEFT(cari_banka_hesapno8,9),''),RIGHT(cari_banka_hesapno8,12),'') as float)<1.00 then '0' else REPLACE(REPLACE(cari_banka_hesapno8,LEFT(cari_banka_hesapno8,9),''),RIGHT(cari_banka_hesapno8,12),'') end  else REPLACE(REPLACE(cari_banka_hesapno8,LEFT(cari_banka_hesapno8,9),''),RIGHT(cari_banka_hesapno8,12),'') end else '0' end [OLMAZ 0]

,ISNULL(H.BANK,0)+ISNULL(H.BANK2,0)+ISNULL(H.[KASSA MEDAXIL],0) MEDAXIL
,ISNULL(H.SATISH,0) SATISH
,ISNULL(H.[NET SATISH],0) [NET SATISH]
,ISNULL(H.[NISYE IADE],0) VOZVRAT
,ISNULL(H.BANK,0)+ISNULL(H.BANK2,0) BANK
,ISNULL(H.[KASSA MEDAXIL],0) KASSA

,'' [MUSHTERI PLAN]
,0 [SATISH FAIZI]
,0 [QALAN SATISH]

FROM CARI_HESAPLAR WITH(NOLOCK)

LEFT JOIN (

SELECT 

cha_kod
,SUM((case when cha_tip=0 and  cast(cha_tarihi as DATE)<=@tarix1 then 1 when  cha_tip<>0 and  cast(cha_tarihi as DATE)<=@tarix1 then -1 end)*cha_meblag) [ILK BORC]

,SUM((case when cha_tip=0 and  cast(cha_tarihi as DATE)<=@tarix2 then 1 when  cha_tip<>0 and  cast(cha_tarihi as DATE)<=@tarix2 then -1 end)*cha_meblag) [SON BORC]

,SUM((case when cha_tip=0 and  cast(cha_tarihi as DATE)<=CAST(getdate() as date) then 1 when  cha_tip<>0 and  cast(cha_tarihi as DATE)<=CAST(getdate() as date) then -1 end)*cha_meblag) [CARI BORC]

,SUM(ROUND(ISNULL((CASE when cha_tarihi >= @tarix1 AND cha_tarihi<= @tarix2 and cha_tip = 0 AND cha_cinsi = 6 AND cha_normal_Iade = 0 AND cha_evrak_tip = 63 AND cha_tpoz = 0 THEN 1 ELSE 0 END)*(cha_meblag + cha_ft_iskonto1 + cha_ft_iskonto2),0),2)) [SATISH]

,SUM(ROUND(ISNULL((CASE when cha_tarihi >= @tarix1 AND cha_tarihi<= @tarix2 and cha_tip = 0 AND cha_cinsi = 6 AND cha_normal_Iade = 0 AND cha_evrak_tip = 63 AND cha_tpoz = 0 THEN 1 ELSE 0 END)*cha_meblag,0),2)) [NET SATISH]

,SUM(ROUND(ISNULL((CASE when cha_tarihi >= @tarix1 AND cha_tarihi<= @tarix2 and cha_tip = 1 AND cha_cinsi IN (6, 7) AND cha_normal_Iade = 1 AND cha_evrak_tip = 0 AND cha_tpoz = 0 THEN 1 ELSE 0 END)*cha_meblag,0),2)) [NISYE IADE]

,SUM(ROUND(ISNULL((CASE when cha_tarihi >= @tarix1 AND cha_tarihi<= @tarix2 and cha_tip = 1 AND cha_cinsi = 0 AND cha_normal_Iade = 0 AND cha_evrak_tip = 2 THEN 1 ELSE 0 END)*cha_meblag,0),2)) [KASSA MEDAXIL]

,SUM(ROUND(ISNULL((CASE when cha_tarihi >= @tarix1 AND cha_tarihi<= @tarix2 and cha_tip = 1 AND cha_cinsi = 0 AND cha_normal_Iade = 0 AND cha_evrak_tip = 34 AND cha_tpoz = 0 THEN 1 ELSE 0 END)*cha_meblag,0),2)) BANK

,SUM(ROUND(ISNULL((CASE when cha_tarihi >= @tarix1 AND cha_tarihi<= @tarix2 and cha_tip=1 and cha_evrak_tip in (33,57) and cha_cinsi=5 and cha_projekodu='01' AND cha_cari_cins = 0 THEN 1 ELSE 0 END)*cha_meblag,0),2)) BANK2

FROM CARI_HESAP_HAREKETLERI WITH(NOLOCK)

--WHERE  cha_tarihi >= @tarix1 AND cha_tarihi<= @tarix2

GROUP BY cha_kod ) H ON H.cha_kod = cari_kod 
left JOIN (select ct_carikodu,MAX(ct_tutari) ustlimit from CARI_HESAP_TEMINATLARI group by ct_carikodu) ct on ct.ct_carikodu=cari_kod
 where cari_kod like '120%'
 
and (cari_grup_kodu IN (
        SELECT Code COLLATE SQL_Latin1_General_CP1_CI_AS 
        FROM BazarlamaHesabatDB.dbo.SaleGroup
    )
    OR cari_grup_kodu = '575')
 
 
 ) TT

)
select * into #OLMAZ0 from DATA_OLMAZ0

--BURDAN SONRA

SELECT
	--[GRUP ADI],[TEMSILCI KODU],[TEMSILCI ADI],[CARI KODU],[CARI ANA KODU],[CARI ADI],[LIMIT],[UST LIMIT]
	[GRUP ADI] FILIAL, ROUND(SUM([SON BORC]),0) BORC
	--[GRUP ADI], SUM(CAST([NET SATISH] AS FLOAT)) AS NET_SATISH, SUM(CAST([ILK BORC] AS FLOAT)) AS ilk_borc_SUM, SUM(CAST([SON BORC] AS FLOAT)) AS SON_BORC_SUM, SUM(CAST([MEDAXIL] AS FLOAT)) AS MEDAXIL, SUM(CAST([LIMIT] AS FLOAT)) AS ALT_LIMIT
FROM
	#OLMAZ0
WHERE
	[TEMSILCI ADI] IS NOT NULL
	AND [TEMSILCI KODU] NOT IN ('150','160','2000')
	AND [TEMSILCI ADI] NOT IN ('BAKI 1', 'BAKI 2', 'BAKI 3', 'BAKI 4', 'BAKI 5', 'GENCE 1', 'GENCE 2', 'LENKERAN', 'SABIRABAD', 'SHEKI', 'GOYCHAY', 'QUBA', 'BNAXCHIVAN')
	AND [TEMSILCI KODU] NOT IN ('521')
	AND [GRUP ADI]  != 'KORPORATIV'
GROUP BY [GRUP ADI]
ORDER BY
	[GRUP ADI]