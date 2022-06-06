/*
Covid 19 Data Exploration 
Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types
*/

SELECT *
FROM PortfolioProject..[covid-deaths]
WHERE continent is not null
order by 3,4

--select *
--from PortfolioProject..[covid-Vaccinations]
--ORDER BY 3,4
-- SELECT DATA that we are going to be using

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject..[covid-deaths]
WHERE continent is not null
ORDER BY 1,2

-- Looking at Total cases vs Total Deaths
-- Shows likelyhood og dying if you contract covid in your country


SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as Deathpercentage
FROM PortfolioProject..[covid-deaths]
Where location like '%states%' 
ORDER BY 1,2

-- Looking at Total Cases vs Population
-- Shows what percentage of population got covid

SELECT location, date, population, total_cases, (total_cases/population)*100 as InfectedPercentage
FROM PortfolioProject..[covid-deaths]
--Where location like '%states%'
ORDER BY 1,2

--Looking at countries with Highest Infection Rate compared to Population.

SELECT location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentPopulationInfected
FROM PortfolioProject..[covid-deaths]
--Where location like '%states%'
GROUP BY location, population
ORDER BY PercentPopulationInfected DESC


-- Showing countries with the highest Death Count per Population

SELECT location, MAX(cast(total_deaths as int)) as TotalDeathCount
FROM PortfolioProject..[covid-deaths]
--Where location like '%states%'
GROUP BY location
ORDER BY TotalDeathCount DESC

-- Breaking things up by continent

--Showing continents with highest Death Count.

SELECT location, MAX(cast(total_deaths as int)) as TotalDeathCount
FROM PortfolioProject..[covid-deaths]
--Where location like '%states%'
WHERE continent is null 
AND location NOT IN ('Lower middle income','Low income','Upper middle income', 'High income', 'International','World')
GROUP BY location
ORDER BY TotalDeathCount DESC


-- Global Numbers

SELECT date, SUM(new_cases) as total_cases,SUM(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
FROM PortfolioProject..[covid-deaths]
--Where location like '%states%' 
WHERE continent is not null
GROUP BY date
ORDER BY 1,2 

--Total cases

SELECT SUM(new_cases) as total_cases,SUM(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
FROM PortfolioProject..[covid-deaths]
--Where location like '%states%' 
WHERE continent is not null
--GROUP BY date
ORDER BY 1,2 

--Looking at Total Population VS Vaccinations

SELECT dea.continent, dea.location,dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.location ORDER BY dea.location, dea.date) as RollingPeopleVaccintated
FROM PortfolioProject..[covid-deaths] dea
JOIN PortfolioProject..[covid-Vaccinations] vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent is not null
ORDER BY 2,3

-- USE CTE

WITH POPvsVAC (Continent, Location, Date, Population, new_vaccinations, RollingPeopleVaccinated)
AS 
(
SELECT dea.continent, dea.location,dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.location ORDER BY dea.location, dea.date) as RollingPeopleVaccinated
--,(RollingPeopleVaccintated/population)*100
FROM PortfolioProject..[covid-deaths] dea
JOIN PortfolioProject..[covid-Vaccinations] vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent is not null
--ORDER BY 2,3
)
SELECT * , (RollingPeopleVaccinated/population)*100
FROM POPvsVAC


--TEMP TABLE
DROP TABLE IF EXISTS #PercentPopulationVaccinated

Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

INSERT into #PercentPopulationVaccinated
SELECT dea.continent, dea.location,dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.location ORDER BY dea.location, dea.date) as RollingPeopleVaccinated
--,(RollingPeopleVaccintated/population)*100
FROM PortfolioProject..[covid-deaths] dea
JOIN PortfolioProject..[covid-Vaccinations] vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent is not null
--ORDER BY 2,3

SELECT * , (RollingPeopleVaccinated/population)*100
FROM #PercentPopulationVaccinated

--Creating view to store for later visualizations

Create view PercentPopulationVaccinated as
SELECT dea.continent, dea.location,dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.location ORDER BY dea.location, dea.date) as RollingPeopleVaccinated
--,(RollingPeopleVaccintated/population)*100
FROM PortfolioProject..[covid-deaths] dea
JOIN PortfolioProject..[covid-Vaccinations] vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent is not null
--ORDER BY 2,3

Create view ContinentsByHighestDeathCount AS
SELECT location, MAX(cast(total_deaths as int)) as TotalDeathCount
FROM PortfolioProject..[covid-deaths]
--Where location like '%states%'
WHERE continent is null 
AND location NOT IN ('Lower middle income','Low income','Upper middle income', 'High income', 'International','World')
GROUP BY location
--ORDER BY TotalDeathCount DESC

Select * 
FROM PercentPopulationVaccinated
