/*
Alias: STANDARD1
LiveAnswer: FALSE

*/

SELECT
 Tarifz.TARIFZ_KOD,
 Tarifz.TARIFZ_ET,
 Tarifz.TARIFZ_PL,
 Tarifz.TARIFZ_COST,
 Tarifz.TARIFZ_TAG, 
 Tarifet.TARIFET_NAM, 
 Tarifpl.TARIFPL_NAM
 FROM "TARIFZ.DB" Tarifz
	INNER JOIN "TARIFET.DB" Tarifet
	ON  (Tarifet.TARIFET_KOD = Tarifz.TARIFZ_ET)
	INNER JOIN "TARIFPL.DB" Tarifpl
	ON  (Tarifpl.TARIFPL_KOD = Tarifz.TARIFZ_PL)
 ORDER BY Tarifz.TARIFZ_ET, Tarifz.TARIFZ_PL


