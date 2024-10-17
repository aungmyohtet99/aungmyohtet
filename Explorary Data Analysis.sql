-- Exploratory Data Analysis

select substring(`date`,1,7) as `MONTH`,SUM(total_laid_off)
from layoffs_staging2
where substring(`date`,1,7)  is not null
group by `MONTH`
order by 1 asc;

With Rolling_Total as (
select substring(`date`,1,7) as `MONTH`,SUM(total_laid_off) as Total_Off
from layoffs_staging2
where substring(`date`,1,7)  is not null
group by `MONTH`
order by 1 asc)
select `MONTH`, Total_Off,
sum(Total_Off) over (order by `MONTH`)
from Rolling_Total;

Select Company,Year(`Date`),sum(total_laid_off)
from layoffs_staging2
group by Company,Year(`Date`)
order by 3 desc;

With Company_Year (Company,Years,Total_Laid_Off) as (
Select Company,Year(`Date`),sum(total_laid_off)
from layoffs_staging2
group by Company,Year(`Date`)
), Company_Year_Rank as(
Select *,
dense_rank() over (partition by Years order by Total_Laid_Off desc) as Ranking
from Company_Year
where Years is not null)
select *
from Company_Year_Rank
where Ranking <=5;