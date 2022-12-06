select *
From [Portfolio Project]..CovidDeaths$
where continent is not NULL
order by 3,4

--select *
--From [Portfolio Project]..CovidVaccinations$
--order by 3,4

select location, date, total_cases, new_cases, total_deaths, population
From [Portfolio Project]..CovidDeaths$
order by 1,2


--Looking at Total Cases vs Total Deaths
Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From [Portfolio Project]..CovidDeaths$
where location like '%Kenya%'
order by 1,2

--Looking at Total Cases vs Population
--shows what percentage of population got covid
Select location, date, population, total_cases, (total_cases/population)*100 as DeathPercentage
From [Portfolio Project]..CovidDeaths$
--where location like '%Kenya%'
order by 1,2

--Looking at Countries with highest infection rate compared to population
Select location, population, MAX(total_cases) as HighestInfectionrate, MAX(total_cases/population)*100 as PercentPopulationInfected
From [Portfolio Project]..CovidDeaths$
where continent is not NULL
Group by location, population
order by PercentPopulationInfected desc

--Showing countries with Highest Death Count per population
Select location, MAX(cast(total_deaths as int)) as TotalDeathCount
From [Portfolio Project]..CovidDeaths$
where continent is not NULL
Group by location, population
order by TotalDeathCount desc

--Showing continents with Highest Death Count per population
Select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
From [Portfolio Project]..CovidDeaths$
where continent is not NULL
Group by continent
order by TotalDeathCount desc

--Global Cases
Select date, SUM(new_cases) as TotalCases, SUM(cast(new_deaths as int)) as TotalDeaths, SUM(cast(new_deaths as int))/SUM(New_Cases) *100 as DeathPercentage
From [Portfolio Project]..CovidDeaths$
where continent is not NULL
Group by date
order by 1,2


---Total Population vs Vaccinations
select death.continent, death.location, death.date, death.population, vac.new_vaccinations--SUM(vac.new_vaccinations)
From [Portfolio Project]..CovidDeaths$  death  --alias death
join [Portfolio Project]..CovidVaccinations$  vac  --alias vac
on death.location = vac.location
and death.date = vac.date
where death.continent is not null
order by 2,3


---Rolling count/Cummulative count of vaccinated population
select death.continent, death.location, death.date, death.population, vac.new_vaccinations, 
SUM(convert(int,vac.new_vaccinations)) over (partition by death.location order by death.location, death.date) as RollingCountVaccinations 
--(RollingCountVaccinations/population) *100 
From [Portfolio Project]..CovidDeaths$  death  --alias death
join [Portfolio Project]..CovidVaccinations$  vac  --alias vac
on death.location = vac.location
and death.date = vac.date
where death.continent is not null


--creating view to store data for later visualization

create view PercentPopulationVaccinated as
select death.continent, death.location, death.date, death.population, vac.new_vaccinations, 
SUM(convert(int,vac.new_vaccinations)) over (partition by death.location order by death.location, death.date) as RollingCountVaccinations 
--(RollingCountVaccinations/population) *100 
From [Portfolio Project]..CovidDeaths$  death  --alias death
join [Portfolio Project]..CovidVaccinations$  vac  --alias vac
on death.location = vac.location
and death.date = vac.date
where death.continent is not null