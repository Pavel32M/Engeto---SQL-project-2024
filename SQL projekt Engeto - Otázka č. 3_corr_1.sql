/*
SQL projekt Engeto - Otázka č. 3: Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?
*/


/*
Zde srovnávám cenu na počátku srovnatelného období (rok 2006) a na jeho konci (rok 2018).
*/

CREATE VIEW grocery_price_2006_new AS
	SELECT DISTINCT name, payroll_year, grocery_price_year AS grocery_price_year_2006
	FROM t_pavel_mokrejs_project_sql_primary_final_new
	WHERE payroll_year = 2006;
	

CREATE VIEW grocery_price_2018_new AS
	SELECT DISTINCT name, payroll_year, grocery_price_year AS grocery_price_year_2018
	FROM t_pavel_mokrejs_project_sql_primary_final_new
	WHERE payroll_year = 2018;
	

SELECT
	grocery_price_2006_new.name AS grocery_name,
	grocery_price_year_2006,
	grocery_price_year_2018,
	ROUND((grocery_price_year_2018 - grocery_price_year_2006)/grocery_price_year_2006 * 100,1) AS grocery_price_percentual_change_2006_2018
FROM
	grocery_price_2006_new JOIN grocery_price_2018_new
	ON grocery_price_2006_new.name = grocery_price_2018_new.name
ORDER BY ROUND((grocery_price_year_2018 - grocery_price_year_2006)/grocery_price_year_2006 * 100,1);
/*
Z výpisu vidíme, že mezi roky 2006 a 2018 nejpomaleji zdražovaly "Banány žluté" a "Vepřová pečeně s kostí".
Potraviny "Cukr krystalový" a "Rajská jablka červená kulatá" dokonce zlevnily.
*/

