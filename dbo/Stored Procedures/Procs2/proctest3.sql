-- =============================================
-- Author:		<Author,,Name>
-- ALTER date: <ALTER Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[proctest3]
	
AS
BEGIN	
	SET NOCOUNT ON;
 --DECLARE @claim varchar(100)
 --DECLARE @paid varchar(100)
 DECLARE @case varchar(100)
 --declare @newcase as varchar(100)
 --declare @DOS_start as varchar(100)
 --declare @DOS_End as varchar(100)
 
 DECLARE cursorName CURSOR 
 FOR
    select distinct Case_Id from tblcase where case_id in ('FH12-102599','FH12-102607','FH12-95257')
 
OPEN cursorName -- open the cursor

FETCH NEXT FROM cursorName
 
   INTO @case
 
    
WHILE @@FETCH_STATUS = 0
 
BEGIN
 
   FETCH NEXT FROM cursorName   
   INTO @case
   --set @newcase=(select top 1 'FH' + RIGHT(CAST(DATEPART(year, GETDATE()) AS NVARCHAR),2) + '-' + CAST((select MAX(Case_AUTOID)+1 from tblcase) AS NVARCHAR) from tblcase)
   
       
	--SElect @DOS_start=DateOfService_Start,@DOS_End=DateOfService_End from tblcase where case_id=@case
	
	--update tbltreatment set Case_Id =@newcase  where Case_Id=@case and paid_amount<>0

		
	insert into tblnotes (Notes_Desc ,Notes_Type ,Notes_Priority ,Case_Id, Notes_Date ,User_Id )
	values('Case on hold by FHKP since its less than $25 ','General',1, @case ,getdate(),'System')
	
	
	
	--FHKP cannot pursue this case because it’s  paid
	--FHKP cannot pursue this case because it’s less than $25
	--FHKP cannot pursue this case because it’s workers compensation
	
	
END
 
CLOSE cursorName -- close the cursor

DEALLOCATE cursorName -- Deallocate the cursor
END

