--[SP_ASSIGNED_CASES] 'tech'
CREATE PROCEDURE [dbo].[SP_ASSIGNED_CASES] 
(  
  @UserName		   nvarchar(10)
)  
  
AS  

BEGIN
IF(@UserName = 'tech' OR @UserName =  'slaxman')
BEGIN
      select  distinct 
      tblcase.Case_Id as cases,CASE  WHEN provider_groupname='GBB' and abs(datediff(dd,Accident_Date,DateOfService_Start))<30
    		      THEN '<font color=red>'+tblcase.Case_Id+'</font> ' 
			      WHEN provider_groupname='GBB' and abs(datediff(dd,Accident_Date,DateOfService_Start))>45
			      THEN '<font color=red>'+tblcase.Case_Id+'</font> '
			      WHEN provider_groupname='GBB' and abs(datediff(dd,Accident_Date,DateOfService_Start)) between 30 and 45
			      THEN '<font color=green>'+tblcase.Case_Id+'</font> '
                  else tblcase.case_id END
      as Case_Id,Case_Code,Last_Status,   
      InjuredParty_LastName + ', ' + InjuredParty_FirstName as [InjuredParty_Name],  
      Provider_Name + ISNULL(' [ ' + Provider_Groupname + ' ]','') as Provider_Name,  
      InsuranceCompany_Name,  
      Indexoraaa_number,  
      convert(decimal(38,2),(convert(money,convert(float,Claim_Amount) - convert(float,Paid_Amount)))) as Claim_Amount,
      Status,  
      Ins_Claim_Number, 
      (select convert(varchar, min(DateOfService_Start),101) from tbltreatment (NOLOCK) where case_id=tblcase.case_id) + ' - ' +
      (select convert(varchar, max(DateOfService_End),101) from tbltreatment (NOLOCK) where case_id=tblcase.case_id) as DateOfService, 
      INITIAL_STATUS,
      CASE WHEN (date_status_Changed is null) THEN datediff(dd,date_opened,getdate()) ELSE datediff(dd,date_status_Changed,getdate())  END as Status_Age,
      Provider_Groupname,
      --Assigned_Attorney,
	  Assigned_Attorney.Assigned_Attorney AS Assigned_Attorney ,
      	STUFF(
		(SELECT distinct ',' + notes_desc FROM tblnotes (NOLOCK)
		WHERE tblcase.Case_Id=tblnotes.Case_Id and tblnotes.Notes_Type='Pending' 
		FOR XML PATH('')),1,1,'') AS notes_desc
      From tblcase (NOLOCK) inner join tblprovider (NOLOCK) on tblcase.provider_id=tblprovider.provider_id 
      inner join tblinsurancecompany (NOLOCK) on tblcase.insurancecompany_id=tblinsurancecompany.insurancecompany_id
         inner join tblnotes (NOLOCK) on tblcase.Case_Id=tblnotes.Case_Id
		 LEFT OUTER JOIN Assigned_Attorney (NOLOCK) ON tblcase.Assigned_Attorney = Assigned_Attorney.PK_Assigned_Attorney_ID
      WHERE 1=1
      and tblcase.Assigned_Attorney is not null and 
      ((INITIAL_STATUS ='UNDETERMINED' and status like 'AAA%') OR (INITIAL_STATUS ='ARB' and status like '%AAA PACKAGE INCOMPLETE%' )) --in  ('AAA OPEN/SCANNED','AAA PACKAGE PRINTED AWAITING RE-PRINT','AAA PACKAGE READY','AAA PACKAGE READY TO SUBMIT','AAA PENDING','AAA PENDING - BILLS MISSING','AAA PENDING - DOCS MISSING')
       AND  tblcase.Case_Id not IN (SELECT Case_ID from tblcase (NOLOCK) WHERE Provider_Id = 41037 and Assigned_Attorney='ahmun' and Status in 
('AAA PACKAGE INCOMPLETE - BILLS MISSING',
'AAA PACKAGE INCOMPLETE - MEDICAL RECORDS MISSING',
'AAA PACKAGE INCOMPLETE - RECONSIDERATION LETTER MISSING',
'AAA PACKAGE INCOMPLETE - VERIFICATION REQUEST ISSUE'))
      ORDER BY Case_Id DESC
END
ELSE
BEGIN
     select distinct top 500
        tblcase.Case_Id as cases,CASE  WHEN provider_groupname='GBB' and abs(datediff(dd,Accident_Date,DateOfService_Start))<30
    		        THEN '<font color=red>'+tblcase.Case_Id+'</font> ' 
			        WHEN provider_groupname='GBB' and abs(datediff(dd,Accident_Date,DateOfService_Start))>45
			        THEN '<font color=red>'+tblcase.Case_Id+'</font> '
			        WHEN provider_groupname='GBB' and abs(datediff(dd,Accident_Date,DateOfService_Start)) between 30 and 45
			        THEN '<font color=green>'+tblcase.Case_Id+'</font> '
                    else tblcase.case_id END
        as Case_Id,Case_Code,Last_Status,   
        InjuredParty_LastName + ', ' + InjuredParty_FirstName as [InjuredParty_Name],  
        Provider_Name + ISNULL(' [ ' + Provider_Groupname + ' ]','') as Provider_Name,  
        InsuranceCompany_Name,  
        Indexoraaa_number,  
        convert(decimal(38,2),(convert(money,convert(float,Claim_Amount) - convert(float,Paid_Amount)))) as Claim_Amount,
        Status,  
        Ins_Claim_Number, 
        (select convert(varchar, min(DateOfService_Start),101) from tbltreatment (NOLOCK) where case_id=tblcase.case_id) + ' - ' +
        (select convert(varchar, max(DateOfService_End),101) from tbltreatment (NOLOCK) where case_id=tblcase.case_id) as DateOfService, 
        INITIAL_STATUS,
        CASE WHEN (date_status_Changed is null) THEN datediff(dd,date_opened,getdate()) ELSE datediff(dd,date_status_Changed,getdate())  END as Status_Age,
        Provider_Groupname,
        --Assigned_Attorney,
		 Assigned_Attorney.Assigned_Attorney AS Assigned_Attorney ,
        STUFF(
		(SELECT distinct ',' + notes_desc FROM tblnotes (NOLOCK)
		 WHERE tblcase.Case_Id=tblnotes.Case_Id and tblnotes.Notes_Type='Pending' 
		 FOR XML PATH('')),1,1,'') AS notes_desc
        From tblcase (NOLOCK) inner join tblprovider (NOLOCK) on tblcase.provider_id=tblprovider.provider_id 
        inner join tblinsurancecompany (NOLOCK) on tblcase.insurancecompany_id=tblinsurancecompany.insurancecompany_id
           inner join tblnotes (NOLOCK) on tblcase.Case_Id=tblnotes.Case_Id
		   LEFT OUTER JOIN Assigned_Attorney (NOLOCK) ON tblcase.Assigned_Attorney = Assigned_Attorney.PK_Assigned_Attorney_ID
        WHERE 1=1
        and Assigned_Attorney.Assigned_Attorney = @UserName and tblcase.Assigned_Attorney is not null and  
        ((INITIAL_STATUS ='UNDETERMINED' and status like 'AAA%') OR (INITIAL_STATUS ='ARB' and status like '%AAA PACKAGE INCOMPLETE%' ))
        AND  tblcase.Case_Id not IN (SELECT Case_ID from tblcase (NOLOCK) WHERE Provider_Id = 41037 and Assigned_Attorney='ahmun' and Status in 
('AAA PACKAGE INCOMPLETE - BILLS MISSING',
'AAA PACKAGE INCOMPLETE - MEDICAL RECORDS MISSING',
'AAA PACKAGE INCOMPLETE - RECONSIDERATION LETTER MISSING',
'AAA PACKAGE INCOMPLETE - VERIFICATION REQUEST ISSUE'))
        
        -- status in  ('AAA OPEN/SCANNED','AAA PACKAGE PRINTED AWAITING RE-PRINT','AAA PACKAGE READY','AAA PACKAGE READY TO SUBMIT','AAA PENDING','AAA PENDING - BILLS MISSING','AAA PENDING - DOCS MISSING')
        ORDER BY Case_Id DESC
END

  

end

