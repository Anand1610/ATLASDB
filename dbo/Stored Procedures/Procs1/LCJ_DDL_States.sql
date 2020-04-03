CREATE PROCEDURE [dbo].[LCJ_DDL_States]
@DomainId NVARCHAR(50)=null	
AS

BEGIN
create table #temp(State_Abr varchar(50), State_Name varchar(100))
insert into #temp VALUES ('NY','NY')
insert into #temp 
SELECT   State_Abr, State_Name FROM tblStates ORDER BY 1 asc
SELECT * FROM #temp 
END

