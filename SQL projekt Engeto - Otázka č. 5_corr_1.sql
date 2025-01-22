/*
SQL projekt Engeto - Otázka č. 5: Má výška HDP vliv na změny ve mzdách a cenách potravin?
                                  Nebo-li, pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách potravin či mzdách ve stejném nebo následujícím roce výraznějším růstem?
*/

/*
Použiji několik VIEW se kterými budu pracovat:

a) total_salary_in_year_new:			rok, průměrná mzda ze všech oborů
   										VIEW bylo vytvořeno již v rámci otázky č. 1
   									
b) total_price_in_year_new:				rok, celková cena potravin (spotřební koš)
   										VIEW bylo vytvořeno již v rámci otázky č. 4
   																			
c) cz_gdp_year_new:    					rok, HDP, pro ČR
  										VIEW bude vytvořeno, viz script níže

d) each_year_price_salary_GDP_CZ		rok, celková cena potravin (spotřební koš), průměrná mzda ze všech oborů, HDP 
  										vznikne spojením výše jmenovaných VIEW, viz script níže
  										provedu SELF-JOIN s tímto VIEW a z výsledného výpisu zodpovím otázku č. 5 								
*/

CREATE VIEW cz_gdp_year_new AS
SELECT DISTINCT payroll_year, year_GDP_CZ FROM t_pavel_mokrejs_project_sql_primary_final_new;

CREATE VIEW each_year_price_salary_GDP_CZ AS
SELECT
	total_price_in_year_new.payroll_year,
	total_price_in_year_new.total_year_grocery_price,
	total_salary_in_year_new.total_avg_year_salary,
	cz_gdp_year_new.year_GDP_CZ	
FROM
	total_price_in_year_new JOIN total_salary_in_year_new 
		ON total_price_in_year_new.payroll_year = total_salary_in_year_new.payroll_year 
	JOIN cz_gdp_year_new
		ON total_salary_in_year_new.payroll_year = cz_gdp_year_new.payroll_year;

SELECT
	each_year_price_salary_GDP_CZ_a.payroll_year,
	each_year_price_salary_GDP_CZ_a.total_year_grocery_price,
	each_year_price_salary_GDP_CZ_a.total_avg_year_salary,
	each_year_price_salary_GDP_CZ_a.year_GDP_CZ,
	each_year_price_salary_GDP_CZ_b.payroll_year AS payroll_year_next,
	each_year_price_salary_GDP_CZ_b.total_year_grocery_price AS total_year_grocery_price_next, 
	each_year_price_salary_GDP_CZ_b.total_avg_year_salary AS total_avg_year_salary_next,
	each_year_price_salary_GDP_CZ_b.year_GDP_CZ AS year_GDP_CZ_next,
	CASE
		WHEN	
			each_year_price_salary_GDP_CZ_b.total_year_grocery_price > each_year_price_salary_GDP_CZ_a.total_year_grocery_price
			THEN 'zdražily (potraviny, meziročně)'
		WHEN
			each_year_price_salary_GDP_CZ_b.total_year_grocery_price = each_year_price_salary_GDP_CZ_a.total_year_grocery_price
			THEN 'stejná cena (potraviny, meziročně)'
		WHEN
			each_year_price_salary_GDP_CZ_b.total_year_grocery_price < each_year_price_salary_GDP_CZ_a.total_year_grocery_price
			THEN 'zlevnily (potraviny, meziročně)'
		ELSE 'nemáme data'
	END AS grocery_price_change_between_years,
	CASE
		WHEN
			each_year_price_salary_GDP_CZ_b.total_avg_year_salary > each_year_price_salary_GDP_CZ_a.total_avg_year_salary
			THEN 'vzrostla (průměrná mzda meziročně)'
		WHEN
			each_year_price_salary_GDP_CZ_b.total_avg_year_salary = each_year_price_salary_GDP_CZ_a.total_avg_year_salary
			THEN 'stejná (průměrná mzda meziročně)'
		WHEN
			each_year_price_salary_GDP_CZ_b.total_avg_year_salary < each_year_price_salary_GDP_CZ_a.total_avg_year_salary
			THEN 'klesla (průměrná mzda meziročně)'
		ELSE 'nemáme data'
	END AS salary_change_between_years,
	CASE
		WHEN
			each_year_price_salary_GDP_CZ_b.year_GDP_CZ > each_year_price_salary_GDP_CZ_a.year_GDP_CZ
			THEN 'růst HDP (meziročně)'
		WHEN
			each_year_price_salary_GDP_CZ_b.year_GDP_CZ = each_year_price_salary_GDP_CZ_a.year_GDP_CZ
			THEN 'stejný HDP (meziročně)'
		WHEN
			each_year_price_salary_GDP_CZ_b.year_GDP_CZ < each_year_price_salary_GDP_CZ_a.year_GDP_CZ
			THEN 'pokles HDP (meziročně)'
		ELSE 'nemáme data'
	END AS GDP_change_between_years_CZ
FROM
	each_year_price_salary_GDP_CZ AS each_year_price_salary_GDP_CZ_a
	LEFT JOIN	each_year_price_salary_GDP_CZ AS each_year_price_salary_GDP_CZ_b
	ON			each_year_price_salary_GDP_CZ_a.payroll_year = each_year_price_salary_GDP_CZ_b.payroll_year-1
;

/*
Z výpisu vidíme, že nelze jednoznačně spojit růst HDP s růstem průměrné mzdy a růstem cen.
V některých letech najdeme kombinaci meziročního růstu HDP - růstu průměrné mzdy a růstu cen (např. roky 2007, 2008 a další),
ale stejně tak vidíme i kombinace odlišné, jako např. pokles HDP - pokles průměrné mzdy a zdražení potravin (rok 2013),
nebo ještě odlišnou kombinaci růst HDP - růst průměrné mzdy a zlevnění potravin (rok 2016).
*/