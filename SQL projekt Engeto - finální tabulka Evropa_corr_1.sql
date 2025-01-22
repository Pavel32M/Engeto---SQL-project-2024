-- Engeto projekt, final, scripty a komentáře
/*
Vytvoření tabulky dat pro evropské země: země, rok, HDP, gini. 

Vytvořím tato VIEW:
country_year_GDP:			země, rok, HDP, script uvedený níže
european_countries_only:	z tabulky countries vybere pouze evropské země, script uvedený níže

Obě VIEW spojím do výsledné tabulky t_Pavel_Mokrejs_project_SQL_secondary_final, script uvedený níže 	
 */

CREATE VIEW country_year_GDP AS
	SELECT
		country, year, GDP, gini
	FROM economies
		WHERE GDP IS NOT NULL AND gini IS NOT NULL AND year >= 2006 AND year <=2018
;
	

CREATE VIEW european_countries_only AS						
	SELECT country, continent FROM countries
	WHERE continent = 'Europe'
;

CREATE TABLE t_Pavel_Mokrejs_project_SQL_secondary_final AS 
	SELECT
		european_countries_only.continent,
		european_countries_only.country,
		country_year_GDP.YEAR,
		ROUND ((country_year_GDP.GDP), 0) AS country_year_GDP_rounded,
		country_year_GDP.gini
	FROM
		european_countries_only JOIN country_year_GDP
		ON european_countries_only.country = country_year_GDP.country
	ORDER BY european_countries_only.country, country_year_GDP.YEAR
;
