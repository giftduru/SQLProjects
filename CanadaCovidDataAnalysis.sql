/*
Queries used for Canada Covid Analysis Project
*/

-- 1. Death Rate per Case
Select date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathRatePerCase
From PortfolioProject..CovidDeaths
where location = 'Canada'
Group by date, total_cases, total_deaths


-- 2. Percentage of Population that are Vaccinated (Fully or First Dose Only)

Select vac.date, dea.population, vac.people_vaccinated,
(vac.people_vaccinated/dea.population)*100 as FirstDoseVaccinatedPercentage, vac.people_fully_vaccinated,
(vac.people_fully_vaccinated/dea.population)*100 as FullyVaccinatedPercentage, vac.total_vaccinations
From PortfolioProject..CovidVaccinations vac
Join PortfolioProject..CovidDeaths dea
	On vac.date = dea.date
	and vac.location = dea.location
where vac.location = 'Canada'
Group by vac.date, dea.population, vac.people_vaccinated, vac.people_fully_vaccinated, vac.total_vaccinations


-- 3. Percentage of Infected People Admitted to either the ICUs or Hospitals

Select date, total_cases, icu_patients, (icu_patients/total_cases)*100 as ICUPercentage, hosp_patients, 
(hosp_patients/total_cases)*100 as HospPercentage
From PortfolioProject..CovidDeaths
where location = 'Canada'
Group by date, total_cases, icu_patients, hosp_patients


-- 4. Comparing Infection Rate and Death Rate with Other North American Countries (TOP 10)

Select location, population, (MAX(total_cases)/population)*100 as PercentPopulationInfected,
(MAX(CONVERT(int, total_deaths))/MAX(total_cases))*100 as DeathRatePerCase
From PortfolioProject..CovidDeaths
where continent is not null and continent in ('North America')
Group by location, population
Order by 3 desc


-- 5. Comparing Cases, Vaccinations and Death Per Day

Select dea.date, dea.new_cases, vac.new_vaccinations, dea.new_deaths,
(MAX(CONVERT(int, new_deaths))/MAX(new_cases))*100 as DeathRatePerDay
From PortfolioProject..CovidVaccinations vac
Join PortfolioProject..CovidDeaths dea
	On vac.date = dea.date
	and vac.location = dea.location
where vac.location = 'Canada'
Group by dea.date, dea.new_cases, vac.new_vaccinations, dea.new_deaths
Order by dea.date


-- 6. Total Covid Numbers as of the 2nd of September, 2021

Select SUM(Cast(vac.new_tests as int)) as TotalTests, SUM(dea.new_cases) as TotalCases, 
SUM(dea.new_cases)/SUM(Convert(int, vac.new_tests))*100 as InfectionPercentage,
SUM(cast(vac.new_vaccinations as int)) as TotalVaccinations, SUM(Convert(int, dea.new_deaths)) as TotalDeaths,
SUM(cast(dea.new_deaths as int))/SUM(dea.new_cases)*100 as DeathPercentage
From PortfolioProject..CovidVaccinations vac
Join PortfolioProject..CovidDeaths dea
	On vac.date = dea.date
	and vac.location = dea.location
where dea.continent is not null and vac.location = 'Canada'

-- 7.
With PeopleVaxxed (Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(int, vac.new_vaccinations )) 
OVER (Partition by dea.location, vac.date Order by vac.date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null and vac.location = 'Canada'
)
Select *, (RollingPeopleVaccinated/Population)*100 as VaccinationRated
From PeopleVaxxed