select * from coviddeaths;
update covidvaccinations set date1 = str_to_date(date1, '%m/%d/%y');
select *from covidvaccinations;
SELECT 
    location,
    date1,
    total_cases,
    new_cases,
    total_deaths,
    population
FROM
    coviddeaths
Order by 
location,
date1;

-- shows the likelihood of dying if you get covid-19 in the countries. 
SELECT 
    location,
    date1,
    total_cases,
    total_deaths,
    (total_deaths/total_cases)*100 AS DeathPercentage
FROM
    coviddeaths
where continent != '' 
Order by 
location,
date1;



-- Looking at the total cases vs the population
-- Shows what percentage of population got COVID 
SELECT 
    location,
    date1,
    population,
    total_cases,
    total_deaths,
    (total_cases/population)*100 AS DeathPercentage
FROM
    coviddeaths
Where location = "El Salvador" 
Order by 
location,
date1;

-- Looking at countries with highest infection rate compared to population
SELECT 
    location,
    population,
    MAX(total_cases) AS Highest_Infection_Count ,
    MAX((total_cases/population))*100 AS PercentPopInfect
FROM
    coviddeaths 
group by
location,  
population
Order by 
PercentPopInfect desc;

-- Countries with highest death count or population 
Select location, MAX(cast(total_deaths as unsigned)) AS Max_TotalD 
from coviddeaths
where continent != ''
group by location
order by Max_TotalD desc;


-- Select by continent
Select continent, MAX(cast(total_deaths as unsigned)) AS Max_TotalD 
from coviddeaths
where continent != '' 
group by continent
order by Max_TotalD desc;

select CD.continent, CD.location, CD.date1, CD.population, CV.new_vaccinations, SUM(Cast(CV.new_vaccinations as unsigned)) 
Over (Partition by CD.location Order by CD.location, CD.date1)
from coviddeaths CD
JOIN covidvaccinations CV
	ON CD.location = CV.location and CD.date1 = CV.date1
ORDER BY 
1,2,3;

select location, date1, new_vaccinations 
from covidvaccinations
order by 1;
 
-- CHANGING THE FORMAT FROM text 09/23/2020 to the date format
ALTER TABLE coviddeaths ADD (date2 DATE);
UPDATE coviddeaths SET date2=str_to_date(date1,'%m/%d/%y');
ALTER TABLE coviddeaths drop column date1;
ALTER TABLE coviddeaths RENAME COLUMN date2 TO date1;




-- GLOBAL NUMBERS ALL TOGETHER
SELECT 
    date1,
    sum(new_cases) AS New_Cases,
    sum(cast(new_deaths as unsigned)) AS New_Deaths,
    sum(cast(new_deaths as unsigned))/ sum(new_cases) *100 AS DEATHPERCENTAGE
FROM
    coviddeaths
where continent is not null and continent != '' 
group by date1
Order by 
date1 asc;


-- TO LOOK AT COVIDVACCINATIONS TABLE
SELECT 
C_Deaths.continent,
C_Deaths.location, 
C_Deaths.date1,
C_Deaths.population,
C_VAC.new_vaccinations,
SUM(CAST(C_VAC.new_vaccinations as unsigned)) OVER (PARTITION by C_Deaths.location Order by C_Deaths.location, C_Deaths.date1) AS RollingPeopleVaccinated
FROM 
coviddeaths AS C_Deaths
JOIN  covidvaccinations AS C_VAC ON C_Deaths.location = C_VAC.location
Where C_Deaths.continent is  not null
Order by 2,3;

-- Creating A View
Create VIEW Deaths as 
Select location, MAX(cast(total_deaths as unsigned)) AS Max_TotalD 
from coviddeaths
where continent != ''
group by location
order by Max_TotalD desc;

select * from deaths


 