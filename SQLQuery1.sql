
-- 1. Select all table and contents that will be used

SELECT
	*
FROM
	PortofolioProject..CovidDeaths
ORDER BY 
	3,4

SELECT
	*
FROM
	PortofolioProject..CovidVaccinations
ORDER BY 
3,4



-- 2. Select specific data (ORDER BY column 1,2 : location, date)
SELECT
	location,
	date,
	total_cases,
	new_cases,
	total_deaths,
	population
FROM
	PortofolioProject..CovidDeaths
ORDER BY 
	1,2

-- 3. Looking at Total Cases vs Total Deaths
SELECT
	location,
	date,
	total_cases,
	total_deaths,
	(total_deaths/total_cases)*100 AS DeathPercentage
FROM
	PortofolioProject..CovidDeaths
ORDER BY 
	1,2


-- 4. Looking at Total Cases vs Total Deaths at United States
SELECT
	location,
	date,
	total_cases,
	total_deaths,
	(total_deaths/total_cases)*100 AS DeathPercentage
FROM
	PortofolioProject..CovidDeaths
WHERE
	location LIKE '%states%'
ORDER BY 
	1,2



-- 5. Looking at Total Cases vs Total Deaths at United States
-- show the likelihood of dying if you contract COVID in your country 
SELECT
	location,
	date,
	total_cases,
	total_deaths,
	(total_deaths/total_cases)*100 AS DeathPercentage
FROM
	PortofolioProject..CovidDeaths
WHERE
	location LIKE '%states%'
ORDER BY 
	1,2


-- 6. Looking at Total Cases vs Populations
-- in Indonesia
-- show hiw much percentage of population got COVID
SELECT
	location,
	date,
	total_cases,
	population,
	(total_cases/population)*100 AS PopultationPercentage
FROM
	PortofolioProject..CovidDeaths
WHERE
	location LIKE '%indo%'
ORDER BY 
	1,2


-- 7. Looking at Countries with Highest Infection Rates compared to Population
SELECT
	location,
	population,
	MAX(total_cases) AS HighestInfectionCount,
	MAX(total_cases/population) * 100 AS PopultationInfectionPercentage
FROM
	PortofolioProject..CovidDeaths
GROUP BY
	location,
	population
ORDER BY 
	PopultationInfectionPercentage	DESC


-- 8. Looking at Countries on Highest Death Count per Poplulation
SELECT
	location,
	MAX(CAST(total_deaths AS INT)) AS TotalDeathCount
FROM
	PortofolioProject..CovidDeaths
WHERE
	continent IS NULL
GROUP BY
	location
ORDER BY 
	TotalDeathCount	DESC

-- 9. Break things down in continents
SELECT
	continent,
	MAX(CAST(total_deaths AS INT)) AS TotalDeathCount
FROM
	PortofolioProject..CovidDeaths
WHERE
	continent IS NOT NULL
GROUP BY
	continent
ORDER BY 
	TotalDeathCount	DESC

-- 10. Select all table and contents that will be used (NOT NULL continent)
SELECT
	*
FROM
	PortofolioProject..CovidDeaths
WHERE
	continent IS NOT NULL
ORDER BY 
	3,4


-- 11. Showing continents with the highest death count per population
SELECT
	continent,
	MAX(CAST(total_deaths AS INT)) AS TotalDeathCount
FROM
	PortofolioProject..CovidDeaths
WHERE
	continent IS NOT NULL
GROUP BY
	continent
ORDER BY
	TotalDeathCount DESC

-- 12. Global Numbers
SELECT
	continent,
	MAX(CAST(total_cases AS INT)) AS TotalDeathCount
FROM
	PortofolioProject..CovidDeaths
WHERE
	continent IS NOT NULL
GROUP BY
	continent
ORDER BY
	TotalDeathCount DESC

-- 13. Breaking Global Numbers
SELECT
	date,
	SUM(new_cases) AS TotalCases,
	SUM(CAST(new_deaths AS INT)) AS TotalDeaths,
	SUM(CAST(new_deaths AS INT)) / SUM(new_cases) * 100 AS DeathPercentage
	-- total_deaths,
	-- (total_deaths / total_cases)*100 AS DeathPercentage
FROM
	PortofolioProject..CovidDeaths
WHERE
	continent IS NOT NULL
GROUP BY
	date
ORDER BY
	1,2


-- 13. Breaking Global Numbers without date
SELECT
	SUM(new_cases) AS TotalCases,
	SUM(CAST(new_deaths AS INT)) AS TotalDeaths,
	SUM(CAST(new_deaths AS INT)) / SUM(new_cases) * 100 AS DeathPercentage
	-- total_deaths,
	-- (total_deaths / total_cases)*100 AS DeathPercentage
FROM
	PortofolioProject..CovidDeaths
WHERE
	continent IS NOT NULL
ORDER BY
	1,2


-- 14. View Covid Vaccination
SELECT
	*
FROM
	PortofolioProject..CovidVaccinations


-- 15. View Covid Deaths
SELECT
	*
FROM
	PortofolioProject..CovidDeaths


-- 16. View Join Covid Vaccination and Covid Deaths
SELECT
	*
FROM
	PortofolioProject..CovidVaccinations vac
JOIN
	PortofolioProject..CovidDeaths dea
ON
	dea.location = vac.location
	AND
	dea.date = vac.date
	

-- 17. Looking at Total Population vs Vaccinations order by dea.continent, dea.location, and dea.date,
SELECT
	dea.continent,
	dea.location,
	dea.date,
	dea.population,
	vac.new_vaccinations
FROM
	PortofolioProject..CovidDeaths dea
JOIN
	PortofolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE
	dea.continent IS NOT NULL
ORDER BY
	dea.continent,
	dea.location,
	dea.date

-- 18. Looking at Total Population vs Vaccinations order by dea.continent, dea.location, and dea.date, where dea.continent is NOT NULL and with sum of 
-- location partition using Rolling Count, using CONVERT
SELECT
	dea.continent,
	dea.location,
	dea.date,
	dea.population,
	vac.new_vaccinations,
	SUM(CONVERT(INT,vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date)	AS RollingPeopleVaccinated
FROM
	PortofolioProject..CovidDeaths dea
JOIN
	PortofolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE
	dea.continent IS NOT NULL
ORDER BY
	dea.location,
	dea.date


-- 19. Looking at Total Population vs Vaccinations order by dea.continent, dea.location, and dea.date, where dea.continent is NOT NULL and with sum of 
-- location partition using Rolling Count, using CAST
SELECT
	dea.continent,
	dea.location,
	dea.date,
	dea.population,
	vac.new_vaccinations,
	SUM(CAST(vac.new_vaccinations AS INT)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date)	AS RollingPeopleVaccinated
FROM
	PortofolioProject..CovidDeaths dea
JOIN
	PortofolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE
	dea.continent IS NOT NULL
ORDER BY
	dea.location,
	dea.date

-- 20. Looking at Total Population vs Vaccinations order by dea.continent, dea.location, and dea.date, where dea.continent is NOT NULL and with sum of 
-- location partition using Rolling Count divided by Population
SELECT
	dea.continent,
	dea.location,
	dea.date,
	dea.population,
	vac.new_vaccinations,
	SUM(CAST(vac.new_vaccinations AS INT)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date)	AS RollingPeopleVaccinated,
	(RollingPeopleVaccinated / population) * 100
FROM
	PortofolioProject..CovidDeaths dea
JOIN
	PortofolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE
	dea.continent IS NOT NULL
ORDER BY
	dea.location,
	dea.date

-- 21. USE CTE 
-- make sure the number of column same as the parameter
With PopvsVac (Continent, Location, Date, Population, NewVaccinations, RollingPeopleVaccinated)
AS
(
	SELECT
		dea.continent,
		dea.location,
		dea.date,
		dea.population,
		vac.new_vaccinations,
		SUM(CONVERT(INT,vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date)	AS RollingPeopleVaccinated
		-- (RollingPeopleVaccinated / dea.population)*100
	FROM
		PortofolioProject..CovidDeaths dea
	JOIN
		PortofolioProject..CovidVaccinations vac
		ON dea.location = vac.location
		AND dea.date = vac.date
	WHERE
		dea.continent IS NOT NULL
	-- ORDER BY
	--	dea.location,
	--	dea.date
)

SELECT
	*,
	(RollingPeopleVaccinated / Population)*100
FROM
	PopvsVac


-- 22. Temp Table for Counting Each Location Maximum Cases
DROP TABLE IF EXISTS #PercentPopulationVaccinated

CREATE TABLE #PercentPopulationVaccinated
(
	Continent NVARCHAR(255),
	Location NVARCHAR(255),
	Date DATETIME,
	Population NUMERIC,
	New_vaccination NUMERIC,
	RollingPeopleVaccinated NUMERIC
)
INSERT INTO	#PercentPopulationVaccinated
	SELECT
		dea.continent,
		dea.location,
		dea.date,
		dea.population,
		vac.new_vaccinations,
		SUM(CONVERT(INT,vac.new_vaccinations)) OVER (PARTITION BY dea.location) AS RollingPeopleVaccinated
	FROM
		PortofolioProject..CovidDeaths dea
	JOIN
		PortofolioProject..CovidVaccinations vac
		ON
		dea.location = vac.location
		AND
		dea.date = vac.date
--	WHERE
--		dea.continent IS NOT NULL
SELECT
	*,
	(RollingPeopleVaccinated / Population)*100
FROM
	#PercentPopulationVaccinated
		

-- 23. Temp Table for Counting Each Location Maximum Cases
SELECT
	continent,
	MAX(CAST(total_deaths AS INT)) AS TotalDeathCount
FROM
	PortofolioProject..CovidDeaths
WHERE
	continent IS NOT NULL
GROUP BY
	continent
ORDER BY
	TotalDeathCount DESC

SELECT
	dea.continent,
	dea.location,
	dea.date,
	dea.population,
	vac.new_vaccinations,
	SUM(CONVERT(INT,vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date)	AS RollingPeopleVaccinated
	-- (RollingPeopleVaccinated / dea.population)*100
FROM
	PortofolioProject..CovidDeaths dea
JOIN
	PortofolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE
	dea.continent IS NOT NULL

-- ORDER BY
--	dea.location,
--	dea.date


SELECT
	continent,
	MAX(CAST(total_deaths AS INT)) AS TotalDeathCount
FROM
	PortofolioProject..CovidDeaths
WHERE
	continent IS NOT NULL
GROUP BY
	continent
ORDER BY
	TotalDeathCount DESC

-- 24. Creating View to Store Data for Later Visualization
DROP VIEW PercentPopulationVaccinated
CREATE VIEW	PercentPopulationVaccinated AS
	SELECT 
		dea.continent,
		dea.location,
		dea.date,
		dea.population,
		vac.new_vaccinations,
		SUM(CONVERT(INT, vac.new_vaccinations)) OVER(
			PARTITION BY 
				dea.location 
			ORDER BY 
				dea.location,
				dea.date) AS RollingPeopleVaccinated
--		MAX(CAST(total_deaths AS INT)) AS TotalDeathCount
	FROM
		PortofolioProject..CovidDeaths dea
	JOIN 
		PortofolioProject..CovidVaccinations vac
	ON
		dea.location = vac.location
		AND
		dea.date = vac.date
	WHERE
		dea.continent IS NOT NULL
	--GROUP BY
	--	dea.continent
	--ORDER BY
	--	TotalDeathCount DESC


-- 25. Display View to Store Data for Later Visualization
SELECT
	*
FROM
	PercentPopulationVaccinated