--TABLEAU QUERIES FOR VISUALIZATION

--1

Select sum(new_cases) Total_cazes, sum(cast(new_deaths as int)) as Total_deathz, sum(cast(new_deaths as int))/sum(new_cases)*100 as percentage_D
--, total_cases, total_deaths, (total_deaths/total_cases)*100 as Death_percentage
From [Portfolio Projects]..CovidDeaths$
--where location like '%states%'
where continent is not null
--group by date_c
order by 1,2

--Ctrl+ Shift+ C helps copy the output with its headers
--2

Select location, sum(convert(int,total_deaths)) as Total_DCount
From [Portfolio Projects]..CovidDeaths$
--where location like '%states%'
where continent is null
and location not in ('world', 'European Union', 'International')
group by location 
order by Total_Dcount desc


--3

Select location, max(total_cases) as Hihgest_infection_count, population, max((total_cases/population))*100 as Highestinfectedpop_percentage
From [Portfolio Projects]..CovidDeaths$
--where location like '%states%'
--and continent is not null
group by location, population
order by Highestinfectedpop_percentage desc

--4

Select location, max(total_cases) as Hihgest_infection_count, population, max((total_cases/population))*100 as Highestinfectedpop_percentage
From [Portfolio Projects]..CovidDeaths$
--where location like '%states%'
--and continent is not null
group by location, population, date_c
order by Highestinfectedpop_percentage desc