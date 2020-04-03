



CREATE PROCEDURE [dbo].[dailyReport_LawSpades]  

     
(  
@strStatus nvarchar(250)='',  
 
@DomainId NVARCHAR(50)=''
)  
AS  
begin  
SET @strStatus=(LTRIM(RTRIM(@strStatus)))  
   
  
    
DECLARE @strsql as nvarchar(max)  
SET NOCOUNT ON;

--DECLARE @tblCaseTemp AS TABLE
--(
--	Status VARCHAR(250)
--)

--INSERT INTO @tblCaseTemp
--select items FROM dbo.STRING_SPLIT(@strStatus,',')


      
    BEGIN
	--	 SELECT DISTINCT v.Case_Id AS CASEID
 --           , InjuredParty_Name AS [PATIENT NAME]               
 --           , Provider_Name AS [PROVIDER NAME]         
	--		, Status AS [STATUS]
	--		, Initial_Status AS [CASE STATUS]          
	--	    ,(convert(decimal(38,2),Claim_Amount)-convert(decimal(38,2),Paid_Amount))[Balance]
	--		,(select top 1 [User_Id] from tblNotes WHERE Case_Id= v.Case_Id And Notes_Desc like '%Case Opened%'  order by Notes_ID desc) AS OPENED_BY
	--		,(select top 1 [User_Id] from tblNotes WHERE Case_Id= v.Case_Id And Notes_Desc like '%to AAA - FILED%'  order by Notes_ID desc) AS FILED_BY
	--		--,(select top 1 [User_Id] from tblNotes WHERE Case_Id= v.Case_Id And Notes_Desc like '%to AAA - PACKAGE READY%'  order by Notes_ID desc) AS [Whos_PACKAGE_READY]
	--		--,(select top 1 [User_Id] from tblNotes WHERE Case_Id= v.Case_Id And Notes_Desc like '%to AAA - PACKAGE READY%'  order by Notes_ID desc) AS [Whos_AR1_APPROVED]
	--		--,(select top 1 [User_Id] from tblNotes WHERE Case_Id= v.Case_Id And Notes_Desc like '%to AAA - REJECT - RETURN TO CLIENT%'  order by Notes_ID desc) AS [Whos_AAA_REJECT]
	--		--, Date_Opened	
	--		,convert(varchar,Date_Opened,101) AS Date_Opened
				
 --           FROM dbo.LCJ_VW_CaseSearchDetails v
 -- WHERE 1=1  
  
 --and v.DomainId= @DomainId  
 --And year(Date_Opened)= 2018 AND month(Date_Opened) > 3
 --And Initial_Status in ('ARB-GB','ARB-LS')
  
 --AND (@strStatus ='' OR v.Status in (SELECT Status FROM @tblCaseTemp))

 SELECT DISTINCT v.Case_Id AS CASEID
            , InjuredParty_Name AS [PATIENT NAME]               
            , Provider_Name AS [PROVIDER NAME]           
            , Status AS [STATUS]
		    , Initial_Status AS [CASE STATUS]          
        ,(convert(decimal(38,2),Claim_Amount)-convert(decimal(38,2),Paid_Amount))[Balance]
			  ,(select top 1 [User_Id] from tblNotes WHERE Case_Id= v.Case_Id And Notes_Desc like '%Case Opened%'  order by Notes_ID desc) AS OPENED_BY
			, convert(varchar,Date_Opened,101) AS Date_Opened
            FROM dbo.LCJ_VW_CaseSearchDetails v 
 WHERE  v.[DomainId] =@DomainId 
 And Status in ('AAA - FILED ','AAA - NEW CASE ENTERED','AR-1 APPROVED','AAA - PACKAGE READY') 
  And year(Date_Opened)= 2018 AND month(Date_Opened) > 3  
  And Initial_Status in ('ARB-GB','ARB-LS') 
  And Provider_Name not in ('MYRTLE AVE TRADING LLC','MiiSupply, LLC','BibiMed, Inc')
  UNION
  SELECT DISTINCT v.Case_Id AS CASEID
            , InjuredParty_Name AS [PATIENT NAME]               
            , Provider_Name AS [PROVIDER NAME] 
            , Status AS [STATUS]
			, Initial_Status AS [CASE STATUS]   
        ,(convert(decimal(38,2),Claim_Amount)-convert(decimal(38,2),Paid_Amount))[Balance]
			  ,(select top 1 [User_Id] from tblNotes WHERE Case_Id= v.Case_Id And Notes_Desc like '%Case Opened%'  order by Notes_ID desc) AS OPENED_BY
			, convert(varchar,Date_Opened,101) AS Date_Opened
            FROM dbo.LCJ_VW_CaseSearchDetails v
 WHERE  v.[DomainId] =@DomainId
ANd Status like '%AAA - REJECT - RETURN TO CLIENT%'
  And year(Date_Opened)= 2018 AND month(Date_Opened) > 3 
  And Initial_Status in ('ARB-GB','ARB-LS') 
   And Provider_Name not in ('MYRTLE AVE TRADING LLC','MiiSupply, LLC','BibiMed, Inc')






  
END 
END


