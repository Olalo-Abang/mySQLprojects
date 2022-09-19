
Select *
From [Portfolio Projects]..CovidDeaths$
order by 3,4

Select *
From [Portfolio Projects]..CovidDeaths$
where continent is not null
order by 3,4

--Select *
--From [Portfolio Projects]..['Covid Vaccinations$']
--where continent is not null
--order by 3,4

   --select data that would be important out.

Select location, date_c, total_cases, new_cases, total_deaths, population
From [Portfolio Projects]..CovidDeaths$
--where continent is not null
order by 1,2

--Looking at total Cases vs Total Deaths,
--to get the percentage of the division above, you multiply by 100.
--always add your alias.

Select location, date_c, total_cases, total_deaths, (total_deaths/total_cases)*100 as Death_percentage
From [Portfolio Projects]..CovidDeaths$
--where continent is not null
order by 1,2

--the 'Death percentage shows the likelihood of dying in a country from covid

Select location, date_c, total_cases, total_deaths, (total_deaths/total_cases)*100 as Death_percentage
From [Portfolio Projects]..CovidDeaths$
where location like '%states%'
--and continent is not null
order by 1,2


--USE OF "AND" or "OR" helps to accommodate two or more conditions

--looking at total cases vs population
--shows what percentage of population got covid

Select location, date_c, total_cases, population, total_deaths, (total_cases/population)*100 as pop_percentage
From [Portfolio Projects]..CovidDeaths$
where location like '%states%'
--and continent is not null
order by 1,2


Select location, date_c, total_cases, population, total_deaths, (total_cases/population)*100 as pop_percentage
From [Portfolio Projects]..CovidDeaths$
where location like '%states%'
--and continent is not null
order by pop_percentage

--Looking at countries with highest infection rate compared to population
Select location, max(total_cases) as Hihgest_infection_count, population, max((total_cases/population))*100 as Highestinfectedpop_percentage
From [Portfolio Projects]..CovidDeaths$
--where location like '%states%'
--and continent is not null
group by location, population
order by Highestinfectedpop_percentage desc


--Countries with highest death count per population 

Select location, max(total_deaths) as Total_DCount
From [Portfolio Projects]..CovidDeaths$
--where location like '%states%'
group by location 
order by Total_Dcount desc

Select location, max(cast(total_deaths as int)) as Total_DCount
From [Portfolio Projects]..CovidDeaths$
--where location like '%states%'
where continent is not null
group by location 
order by Total_Dcount desc

--LET'S DO BY CONTINENT
--Continent with the highest death count per population

Select continent, max(cast(total_deaths as int)) as Total_DCount
From [Portfolio Projects]..CovidDeaths$
--where location like '%states%'
where continent is not null
group by continent 
order by Total_Dcount desc
--since "NOT NULL" is used some outputs might not be accurate, because 'NULL' columns still have
--certain values that can be computed and used.

--NOW, LET'S DO LOCATION AGAIN, BUT THIS TIME "NULL" INCLUDED.


Select location, max(cast(total_deaths as int)) as Total_DCount
From [Portfolio Projects]..CovidDeaths$
--where location like '%states%'
where continent is null
group by location 
order by Total_Dcount desc



--GLOBAL NUMBERS

Select date_c, sum(new_cases) -- total_cases, total_deaths, (total_deaths/total_cases)*100 as Death_percentage
From [Portfolio Projects]..CovidDeaths$
--where location like '%states%'
where continent is not null
group by date_c
order by 1,2


--CAST help change between data types temporarily
--CONVERT does the same thing as CAST
--Cast(expression as 'Data types'), Convert('data types', expression)

Select date_c, sum(new_cases), sum(cast(new_deaths as int)) --, total_cases, total_deaths, (total_deaths/total_cases)*100 as Death_percentage
From [Portfolio Projects]..CovidDeaths$
--where location like '%states%'
where continent is not null
group by date_c
order by 1,2

Select sum(new_cases) as Total_cazes, sum(cast(new_deaths as int)) as Total_deathz 
--, total_cases, total_deaths, (total_deaths/total_cases)*100 as Death_percentage
From [Portfolio Projects]..CovidDeaths$
--where location like '%states%'
where continent is not null
--group by date_c
order by 1,2

Select sum(new_cases) Total_cazes, sum(cast(new_deaths as int)) as Total_deathz, sum(cast(new_deaths as int))/sum(new_cases)*100 as percentage_D
--, total_cases, total_deaths, (total_deaths/total_cases)*100 as Death_percentage
From [Portfolio Projects]..CovidDeaths$
--where location like '%states%'
where continent is not null
--group by date_c
order by 1,2



Select *
From [Portfolio Projects]..['Covid Vaccinations$'] as VAC
Join [Portfolio Projects]..CovidDeaths$ as DAC 
    On VAC.location= DAC.location
	and VAC.date_c= DAC.date_c
--where continent is not null
--order by 3,4


--Using Joins to find Total population vs Vaccinations

Select DAC.continent, DAC.location, DAC.date_c, DAC.population, VAC.new_vaccinations
From [Portfolio Projects]..['Covid Vaccinations$'] as VAC
Join [Portfolio Projects]..CovidDeaths$ as DAC 
    On VAC.location= DAC.location
	and VAC.date_c= DAC.date_c
order by 1,2,3

--Use 'where continent is not null' so as to get a better output result

Select DAC.continent, DAC.location, DAC.date_c, DAC.population, VAC.new_vaccinations
From [Portfolio Projects]..['Covid Vaccinations$'] as VAC
Join [Portfolio Projects]..CovidDeaths$ as DAC 
    On VAC.location= DAC.location
	and VAC.date_c= DAC.date_c
	where VAC.continent is not null
order by 1,2,3

Select DAC.continent, DAC.location, DAC.date_c, DAC.population, VAC.new_vaccinations,
  sum(Convert(int,VAC.new_vaccinations)) OVER (Partition by DAC.location Order by DAC.location,
  DAC.date_c) as rollovervaccinated
  --(rollovervaccinated/population)*100
From [Portfolio Projects]..['Covid Vaccinations$'] as VAC
Join [Portfolio Projects]..CovidDeaths$ as DAC 
    On VAC.location= DAC.location
	and VAC.date_c= DAC.date_c
where VAC.continent is not null
order by 2,3

--newly created columns cannot be used to run immediate queries,
-- to run it, a CTE or Temp table needs to be created.

--USING CTE

With PopvsVAC(continent, location, date_c, population, new_vaccinations, rollovervaccinated)
as
(
Select DAC.continent, DAC.location, DAC.date_c, DAC.population, VAC.new_vaccinations,
  sum(Convert(int,VAC.new_vaccinations)) OVER (Partition by DAC.location Order by DAC.location,
  DAC.date_c) as rollovervaccinated
  --(rollovervaccinated/population)*100
From [Portfolio Projects]..['Covid Vaccinations$'] as VAC
Join [Portfolio Projects]..CovidDeaths$ as DAC 
    On VAC.location= DAC.location
	and VAC.date_c= DAC.date_c
where VAC.continent is not null
--order by 2,3
)
Select *, (rollovervaccinated/population)*100
From PopvsVAC


--TEMP TABLE
Drop table if exists #PercentPopulationVaccinated

Create table #PercentPopulationVaccinated
(
continent varchar,
location varchar,
date_c datetime,
population numeric,
new_vaccinations numeric,
rollovervaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select DAC.continent, DAC.location, DAC.date_c, DAC.population, VAC.new_vaccinations,
  sum(Convert(int,VAC.new_vaccinations)) OVER (Partition by DAC.location Order by DAC.location,
  DAC.date_c) as rollovervaccinated
  --(rollovervaccinated/population)*100
From [Portfolio Projects]..['Covid Vaccinations$'] as VAC
Join [Portfolio Projects]..CovidDeaths$ as DAC 
    On VAC.location= DAC.location
	and VAC.date_c= DAC.date_c
where VAC.continent is not null
--order by 2,3

Select *, (rollovervaccinated/population)*100
From #PercentPopulationVaccinated


--VIEWS CREATION FOR STORING DATA
Create View PercentPopulationVaccinated as 
Select DAC.continent, DAC.location, DAC.date_c, DAC.population, VAC.new_vaccinations,
  sum(Convert(int,VAC.new_vaccinations)) OVER (Partition by DAC.location Order by DAC.location,
  DAC.date_c) as rollovervaccinated
  --(rollovervaccinated/population)*100
From [Portfolio Projects]..['Covid Vaccinations$'] as VAC
Join [Portfolio Projects]..CovidDeaths$ as DAC 
    On VAC.location= DAC.location
	and VAC.date_c= DAC.date_c
where VAC.continent is not null
--order by 2,3

drop view PercentPopulationVaccinated

select *
from PercentPopulationVaccinated