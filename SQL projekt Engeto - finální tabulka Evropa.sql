-- Engeto projekt, final, scripty a komentáře
/*
Vytvoření výchozí tabulky pro evropské země, která obsahuje především tyto údaje: země, rok, HDP, pro evropské země. 
*/


SELECT * FROM economies;

SELECT * FROM countries;

SELECT * FROM country_year_GDP; 							-- země, rok, HDP, script uvedený níže 

SELECT * FROM european_countries_only;	 					-- z tabulky countries vybere pouze evropské země, script uvedený níže

SELECT * FROM t_Pavel_Mokrejs_project_SQL_secondary_final; 	-- výsledná tabulka pro evropské země, script uvedený níže 

CREATE VIEW country_year_GDP AS
	SELECT
		country, year, GDP, gini
	FROM economies
		WHERE GDP IS NOT NULL AND gini IS NOT NULL AND year >= 2006 AND year <=2018
	ORDER BY country, year;

CREATE VIEW european_countries_only AS						
	SELECT country, continent FROM countries
	WHERE continent = 'Europe'
	ORDER BY country;

CREATE TABLE t_Pavel_Mokrejs_project_SQL_secondary_final AS	-- spojím evropské země s ekonomickými údaji a seřadím, finální tabulka pro Evropské země 
	SELECT
		european_countries_only.continent,
		european_countries_only.country,
		country_year_GDP.YEAR,
		ROUND ((country_year_GDP.GDP), 0) AS country_year_GDP_rounded,
		country_year_GDP.gini
	FROM
		european_countries_only JOIN country_year_GDP
		ON european_countries_only.country = country_year_GDP.country
	ORDER BY european_countries_only.country, country_year_GDP.YEAR;