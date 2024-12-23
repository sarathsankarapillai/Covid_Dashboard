SELECT * FROM Portfolio.CovidDeaths ORDER BY 3,4;

SELECT location,`date`,total_cases,new_cases,total_deaths,population 
FROM Portfolio.CovidDeaths 
order by 1,2;

/*Total cases vs Total Death*/
/*Shows the chance of dying in each country*/

SELECT location,`date`,total_cases,total_deaths,(total_deaths/total_cases)*100 AS Death_Percentage
FROM Portfolio.CovidDeaths 
order by 1,2;


SELECT location,`date`,total_cases,total_deaths,(total_deaths/total_cases)*100 AS Death_Percentage
FROM Portfolio.CovidDeaths  WHERE location LIKE '%INDIA%'
order by 1,2;


/*Total Cases vs Population*/

SELECT location,`date`,total_cases,population ,(total_cases /population)*100 AS Covid_Percentage /*Shows the percentage of covid cases*/
FROM Portfolio.CovidDeaths  WHERE location LIKE '%INDIA%'
order by 1,2;


/*Countries with highest confirmed covid cases respective to the total population*/

SELECT location,population, MAX(total_cases) as HighestInfection,MAX((total_cases /population))*100 AS Covid_Percentage /*Shows the percentage of covid cases*/
FROM Portfolio.CovidDeaths /*WHERE location LIKE '%INDIA%'*/ GROUP BY location ,population 
order by Covid_Percentage desc;



/*Countries with highest death rate*/

SELECT location,MAX(total_deaths) AS TotalDeathCount FROM Portfolio.CovidDeaths  WHERE continent!='0' GROUP BY location 
ORDER by TotalDeathCount DESC;

/*Categorizing on basis of continent*/

SELECT continent ,MAX(total_deaths) AS TotalDeathCount FROM Portfolio.CovidDeaths  WHERE continent !='0' GROUP BY continent 
ORDER by TotalDeathCount DESC;

	

/*Categorizing globally*/

SELECT date,SUM(new_cases)as Total_cases ,SUM(new_deaths) as Total_Deaths, SUM(new_deaths) / SUM(new_cases) *100 as Death_percent
FROM Portfolio.CovidDeaths WHERE continent !='0' GROUP BY `date` 
ORDER by 1,2;

/*TOTAL CASES AND DEATHS GLOBALLY*/

SELECT SUM(new_cases)as Total_cases ,SUM(new_deaths) as Total_Deaths, SUM(new_deaths) / SUM(new_cases) *100 as Death_percent
FROM Portfolio.CovidDeaths WHERE continent !='0'
ORDER by 1,2;

/*VACCINATIONS*/

SELECT * FROM Portfolio.CovidVaccinations;



/*Total Population vs Vaccination*/


SELECT cd.continent,cd.location,cd.`date`,cd.population,cv.new_vaccinations  FROM Portfolio.CovidDeaths cd JOIN
Portfolio.CovidVaccinations cv ON cd.location =cv.location AND cd.date=cv.date
WHERE cd.continent !='0' ORDER BY 2,3



SELECT cd.continent,cd.location,cd.`date`,cd.population,cv.new_vaccinations,SUM(cv.new_vaccinations) 
OVER (PARTITION BY cd.location ORDER BY cd.location,cd.`date`) as Cumulative_Vaccinations
FROM Portfolio.CovidDeaths cd JOIN
Portfolio.CovidVaccinations cv ON cd.location =cv.location AND cd.date=cv.date
WHERE cd.continent !='0' ORDER BY 2,3

/*--------------------------------------------*/


WITH TempRes(continent,Location,Date,Population,New_vaccinations,Cumulative_Vaccinations)

as

( 


SELECT cd.continent,cd.location,cd.`date`,cd.population,cv.new_vaccinations,SUM(cv.new_vaccinations) 
OVER (PARTITION BY cd.location ORDER BY cd.location,cd.`date`) as Cumulative_Vaccinations
FROM Portfolio.CovidDeaths cd JOIN
Portfolio.CovidVaccinations cv ON cd.location =cv.location AND cd.date=cv.date
WHERE cd.continent !='0' ORDER BY 2,3

)

SELECT  *,(Cumulative_Vaccinations/Population)*100 as Vaccination_Percent FROM  TempRes






/*--------------------------------------------*/
/*Creating View*/


CREATE View Portfolio.VaccinatedPercent as SELECT cd.continent,cd.location,cd.`date`,cd.population,cv.new_vaccinations,SUM(cv.new_vaccinations) 
OVER (PARTITION BY cd.location ORDER BY cd.location,cd.`date`) as Cumulative_Vaccinations
FROM Portfolio.CovidDeaths cd JOIN
Portfolio.CovidVaccinations cv ON cd.location =cv.location AND cd.date=cv.date
WHERE cd.continent !='0' 
/*--------------------------------------------*/

SELECT * FROM  Portfolio.VaccinatedPercent
















