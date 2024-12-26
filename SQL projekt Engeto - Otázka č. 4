/*
SQL projekt Engeto - Otázka č. 4: Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?
*/

/*
Použiji několik VIEW se kterými budu pracovat:

a) total_salary_in_year_new:			rok, průměrná mzda ze všech oborů
   										VIEW bylo vytvořeno již v rámci otázky č.1
   									
b) total_price_in_year_new:				rok, celková cena potravin (spotřební koš)
   										VIEW bude vytvořeno, viz script níže
   									
c) each_year_total_price_total_salary:	rok, celková cena potravin (spotřební koš), průměrná mzda ze všech oborů 
 										VIEW vznikne spojením obou VIEW výše jmenovaných
 										
d) sumarized_each_year_salary_price:    rok, celková cena potravin (spotřební koš), průměrná mzda ze všech oborů
  										informace pro MEZIROČNÍ srovnání
  										VIEW znikne jako SELF-JOIN výše uvedeného VIEW each_year_total_price_total_salary
  										z tohoto VIEW potom vypíšu meziroční procentuální změnu mezd a cen potravin a odpovím na otázku č. 4 								
*/

SELECT * FROM total_salary_in_year_new;			-- rok, průměrná mzda ze všech oborů, máme již z otázky č. 1 

SELECT * FROM total_price_in_year_new;				-- rok, celková cena potravin (spotřební koš), vytvoření VIEW viz níže

SELECT * FROM each_year_total_price_total_salary;	-- rok, celková cena potravin (spotřební koš), průměrná mzda ze všech oborů, vytvoření VIEW viz níže

SELECT * FROM sumarized_each_year_salary_price; 	-- rok, celková cena potravin (spotřební koš), průměrná mzda ze všech oborů, MEZIROČNĚ, vytvoření VIEW viz níže


CREATE VIEW total_price_in_year_new AS
	WITH distinct_year_price AS
		(
			SELECT DISTINCT payroll_year, name, grocery_price_year FROM t_pavel_mokrejs_project_sql_primary_final_new
		)
	SELECT
		payroll_year,
		SUM(grocery_price_year) AS total_year_grocery_price 
	FROM distinct_year_price
	GROUP BY payroll_year;

	
CREATE VIEW each_year_total_price_total_salary AS
	SELECT
		total_price_in_year_new.payroll_year,
		total_price_in_year_new.total_year_grocery_price,
		total_salary_in_year_new.total_avg_year_salary
	FROM
		total_price_in_year_new JOIN total_salary_in_year_new
		ON total_price_in_year_new.payroll_year = total_salary_in_year_new.payroll_year;
		
CREATE VIEW	sumarized_each_year_salary_price AS
SELECT
	each_year_total_price_total_salary_a.payroll_year,
	each_year_total_price_total_salary_a.total_year_grocery_price,
	each_year_total_price_total_salary_a.total_avg_year_salary,
	each_year_total_price_total_salary_b.payroll_year AS payroll_year_next,
	each_year_total_price_total_salary_b.total_year_grocery_price AS total_year_grocery_price_next, 
	each_year_total_price_total_salary_b.total_avg_year_salary AS total_avg_year_salary_next 
FROM	
	each_year_total_price_total_salary AS each_year_total_price_total_salary_a
	LEFT JOIN	each_year_total_price_total_salary AS each_year_total_price_total_salary_b
	ON 			each_year_total_price_total_salary_a.payroll_year = each_year_total_price_total_salary_b.payroll_year-1
;

SELECT
	*,
	ROUND((total_year_grocery_price_next - total_year_grocery_price )/total_year_grocery_price*100,1) AS percentual_grocery_price_change_between_years,
	ROUND((total_avg_year_salary_next - total_avg_year_salary )/total_avg_year_salary*100,1) AS percentual_salary_change_between_years,
	CASE
		WHEN
			((total_year_grocery_price_next - total_year_grocery_price )/total_year_grocery_price*100) > ((total_avg_year_salary_next - total_avg_year_salary )/total_avg_year_salary*100)
			THEN 'potraviny více než mzdy'
		WHEN
			((total_year_grocery_price_next - total_year_grocery_price )/total_year_grocery_price*100) = ((total_avg_year_salary_next - total_avg_year_salary )/total_avg_year_salary*100)
			THEN 'potraviny stejně jako mzdy'
		WHEN
			((total_year_grocery_price_next - total_year_grocery_price )/total_year_grocery_price*100) < ((total_avg_year_salary_next - total_avg_year_salary )/total_avg_year_salary*100)
			THEN 'mzdy více než potraviny'
		ELSE 'nemáme data'
		END AS grocery_salary_change_between_years
FROM sumarized_each_year_salary_price;
/*
Na výpisu vidíme, že ani meziroční nárůst cen, ani meziroční nárůst mezd nepřesáhly hranici 10%.
V některých letech meziročně vzrostly ceny potravin více než mzdy, v jiných letech tomu bylo naopak, jak ukazuje tabulka.
Relativně vyšší nárůst cen potravin vůči průměrné mzdě se odehrál v letech 2012, 2013 a 2017.
Z pohledu "cena potravin vs. mzdy" byl nejméně příznivý rok 2013, kdy ceny potravin vzrostly oproti předešlému roku, zatímco průměrná mzda poklesla.
*/ 
