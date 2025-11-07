use bank_db;
RENAME TABLE `debit and credit banking_data` TO debit_credit;

-- Debit And Credit DashBoard --
--  1.Total Credit KPI--
select concat(Format(sum(Amount)/1000000,2),"M") as Total_Credit_Amount from debit_credit where `Transaction Type` = "Credit";

-- 2.Total Debit Amount KPI --
select concat(Format(sum(Amount)/1000000,2),"M") as Total_Debit_Amount from debit_credit where `Transaction Type` = "Debit";

-- 3.Net Transaction Amount KPI --
select round(sum(case when `Transaction Type` = "Credit" then Amount else 0 end),0) -
round(sum(case when `Transaction Type` = "Debit" then Amount else 0 end),0) as Net_transaction_Amount from debit_credit;

-- 4.Credit and Debit Ratio KPI -- 
select round(sum(case when `Transaction Type` = "Credit" then Amount else 0 end),5) /
round(sum(case when `Transaction Type` = "Debit" then Amount else 0 end),5) as Credit_And_Debit_Ratio from debit_credit;

-- 5.Account Activity Ratio --
select round(count(*),5) / sum(balance) as Account_Activity_Ratio  from debit_credit;

-- 6.Transaction Per Day/Week/Month KPI --
-- Day --
select Date(`Transaction date`)as Day, count(*) as Transaction_Per_day
 from debit_credit Group by Day order by Day; 

-- week --
select monthname(`Transaction date`)as Month,
week(`Transaction date`)as Week,
count(*) as Transaction_Per_day from debit_credit
Group by Week,Month order by week,Month; 

-- 7.Total Transaction Amount By Branch KPI --

select branch,Format(round(sum(Amount),0),"M") as Transaction_Amount from debit_credit group by branch;

-- 8.Transaction By Bank KPI --
select `Bank Name` , Concat(format(Sum(Amount)/1000000,2),"M") as Transaction_Amount  from debit_credit group by `Bank Name` Order by Transaction_Amount Desc;

-- 9.Transaction Method Distribution KPI --

select `Transaction Type`,
CONCAT(ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM debit_credit), 2), '%')as Transaction_Amount 
from debit_credit group by `Transaction Type` Order by Transaction_Amount Desc;

-- 10-Branch Transaction Growth --

select `Transaction Type`,
CONCAT(ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM debit_credit), 2), '%')as Transaction_Amount 
from debit_credit group by `Transaction Type` Order by Transaction_Amount Desc;

-- 11-High-Risk Transaction Flag: --

select * from debit_credit;
select `Customer ID`,`Transaction Date`,`Transaction Type`,Amount,
case when Amount > 4600 then "High Risk" else "Norml" end as Risk_Status  from debit_credit order by Amount Desc;





