/*
SQL projekt Engeto - Otázka č. 1: Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?
*/

SELECT
	DISTINCT payroll_year, industry_branch_code, industry_name, branch_salary_year
FROM
	t_pavel_mokrejs_project_sql_primary_final_new
WHERE payroll_year = 2006 OR payroll_year = 2018
ORDER BY industry_branch_code, payroll_year;

/* 
Z tohoto výpisu vidíme, že v průběhu let 2006 - 2018 vzrostla mzda ve všech odvětvích.
Případně si totéž můžeme zobrazit názornějším způsobem, viz následující script níže.
 */

CREATE VIEW branch_salary_2006_new AS
	SELECT
		DISTINCT payroll_year, industry_branch_code, industry_name, branch_salary_year
	FROM t_pavel_mokrejs_project_sql_primary_final_new
	WHERE payroll_year = 2006;

CREATE VIEW branch_salary_2018_new AS
	SELECT
		DISTINCT payroll_year, industry_branch_code, industry_name, branch_salary_year
	FROM t_pavel_mokrejs_project_sql_primary_final_new
	WHERE payroll_year = 2018;

SELECT
	branch_salary_2006_new.industry_branch_code,
	branch_salary_2006_new.industry_name,
	branch_salary_2006_new.branch_salary_year AS industry_branch_salary_2006_new,
	branch_salary_2018_new.branch_salary_year AS industry_branch_salary_2018_new,
	CASE
		WHEN branch_salary_2018_new.branch_salary_year > branch_salary_2006_new.branch_salary_year THEN 'mzda v oboru vzrostla'
		WHEN branch_salary_2018_new.branch_salary_year = branch_salary_2006_new.branch_salary_year THEN 'mzda v oboru stejná'
		WHEN branch_salary_2018_new.branch_salary_year < branch_salary_2006_new.branch_salary_year THEN 'mzda v oboru klesla'
		ELSE 'překontrolovat'
	END AS industry_branch_salary_change_2006_2018
FROM
	branch_salary_2006_new JOIN branch_salary_2018_new ON branch_salary_2006_new.industry_branch_code = branch_salary_2018_new.industry_branch_code;
/* 
Výpis názorněji ukazuje vývoj platů v jednotlivých oborech mezi roky 2006 - 2018.
Mzda vzrostla ve všech oborech.
*/

/*
Zajímavý je pohled na vývoj průměrné mzdy (ze všech oborů) mezi lety 2006-2018 meziročně, viz následující scripty.
*/

CREATE VIEW total_salary_in_year_new AS
	SELECT
		payroll_year,
		ROUND(AVG(branch_salary_year),0) AS total_avg_year_salary
	FROM t_pavel_mokrejs_project_sql_primary_final_new
	GROUP BY payroll_year
	ORDER BY payroll_year;
-- zde jsem vytvořil pomocné VIEW, které použiju níže
 
SELECT
	total_salary_in_year_new_a.payroll_year,
	total_salary_in_year_new_a.total_avg_year_salary AS total_year_salary,
	total_salary_in_year_new_b.payroll_year,
	total_salary_in_year_new_b.total_avg_year_salary AS total_next_year_salary,
	CASE
		WHEN total_salary_in_year_new_b.total_avg_year_salary > total_salary_in_year_new_a.total_avg_year_salary THEN 'průměrná mzda meziročně vzrostla'
		WHEN total_salary_in_year_new_b.total_avg_year_salary = total_salary_in_year_new_a.total_avg_year_salary THEN 'průměrná mzda meziročně stejná'
		WHEN total_salary_in_year_new_b.total_avg_year_salary < total_salary_in_year_new_a.total_avg_year_salary THEN 'průměrná mzda meziročně klesla'
		ELSE 'nemáme data'
	END AS salary_change_between_years
FROM
	total_salary_in_year_new AS total_salary_in_year_new_a
	LEFT JOIN	total_salary_in_year_new AS total_salary_in_year_new_b
	ON 			total_salary_in_year_new_a.payroll_year = total_salary_in_year_new_b.payroll_year-1;
/* 
Z tabulky vidíme meziroční nárůst průměrné mzdy (ze všech oborů) mezi lety 2006-2018 meziročně.
V roce 2013 průměrná mzda poklesla oproti roku 2012.
V roce 2014 průměrná mzda vzrostla oproti roku 2013 a růst průměrné mzdy pokračoval až do konce sledovaného období (rok 2018).
*/
