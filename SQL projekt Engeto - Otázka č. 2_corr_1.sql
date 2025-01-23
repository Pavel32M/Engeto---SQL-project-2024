/*
 SQL projekt Engeto - Otázka č. 2: Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?
 */

SELECT
	payroll_year,
	ROUND(AVG(branch_salary_year),0) AS year_2006_2018_salary,
	name,
	grocery_price_year,
	ROUND(AVG(branch_salary_year)/grocery_price_year,0) AS customer_can_buy
FROM t_pavel_mokrejs_project_sql_primary_final_new
WHERE name = 'Chléb konzumní kmínový' AND payroll_year IN(2006, 2018) OR name = 'Mléko polotučné pasterované'AND payroll_year IN(2006, 2018)
GROUP BY payroll_year, name;
/*
Výpis uvádí průměrnu mzdu (ze všech oborů) v letech 2006 a 2018 a jednotkovou cenu chleba a mléka v těchto letech. 
V roce 2006 jsme si za průměrnou mzdu (přes všechna odvětví) mohli koupit 1271 kg chleba nebo 1453 l mléka
V roce 2018 jsme si za průměrnou mzdu (přes všechna odvětví) mohli koupit 1333 kg chleba nebo 1599 l mléka.
*/