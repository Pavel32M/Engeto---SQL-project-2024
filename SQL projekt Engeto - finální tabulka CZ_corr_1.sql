-- Engeto projekt, final, scripty a komentáře
/*
Vytvoření výchozí tabulky pro ČR, která obsahuje především tyto údaje:
rok, obor činnosti, průměrnou mzdu v oboru, kategorie potravin, cenu, HDP 

Připravím VIEW:
a) all_branch_salary_year: rok, obor činnosti, průměrná mzda v oboru
b) all_grocery_price_year: rok, kategorie potravin, cena
c)all_year_GDP_CZ:         rok, HDP v ČR
d) všechna VIEW spojím a uložím jako výchozí tabulku pro ČR
   t_Pavel_Mokrejs_project_SQL_primary_final_new 
*/

CREATE VIEW all_branch_salary_year AS
WITH branch_salary_year AS
	(
		SELECT
			payroll_year,
			payroll_quarter,
			industry_branch_code,
			czechia_payroll_industry_branch.name AS industry_name,
			value
		FROM czechia_payroll
			JOIN czechia_payroll_calculation
				ON czechia_payroll.calculation_code = czechia_payroll_calculation.code
			JOIN czechia_payroll_industry_branch
				ON czechia_payroll.industry_branch_code = czechia_payroll_industry_branch.code
			JOIN czechia_payroll_unit
				ON czechia_payroll.unit_code = czechia_payroll_unit.code
			JOIN czechia_payroll_value_type
				ON czechia_payroll.value_type_code = czechia_payroll_value_type.code
		WHERE value_type_code = 5958 AND calculation_code = 100 AND payroll_year >=2006 AND payroll_year <= 2018
	)
SELECT
	payroll_year,
	industry_branch_code,
	industry_name,
	ROUND(AVG(value),0) AS branch_salary_year
FROM branch_salary_year
GROUP BY payroll_year, industry_branch_code;

CREATE VIEW all_grocery_price_year AS
WITH each_grocery_price_year AS
	(
		SELECT
			YEAR(date_from) AS year_from,
			region_code,
			value,
			category_code,
			name,
			price_value,
			price_unit
		FROM
			czechia_price INNER JOIN czechia_price_category ON czechia_price.category_code = czechia_price_category.code
		WHERE region_code IS NOT NULL
	)
SELECT
	year_from,
	category_code,
	name,
	price_value,
	price_unit,
	ROUND(AVG(value),0) AS grocery_price_year
FROM each_grocery_price_year
GROUP BY year_from, name;

CREATE VIEW all_year_GDP_CZ AS
	SELECT
		country, year, ROUND(GDP,0) AS year_GDP_CZ , gini FROM economies
	WHERE	GDP IS NOT NULL AND gini IS NOT NULL
			AND year >= 2006 AND year <=2018 AND country = 'Czech Republic'
	ORDER BY country, year;

CREATE TABLE t_Pavel_Mokrejs_project_SQL_primary_final_new AS
	SELECT
		country, payroll_year, industry_branch_code,
		industry_name, branch_salary_year, category_code,
		name, grocery_price_year, price_value,
		price_unit, year_GDP_CZ, gini 
	FROM
		all_year_GDP_CZ	JOIN all_branch_salary_year
							ON all_year_GDP_CZ.year = all_branch_salary_year.payroll_year
						JOIN all_grocery_price_year
							ON all_branch_salary_year.payroll_year = all_grocery_price_year.year_from
	ORDER BY payroll_year, industry_branch_code, name;
	

