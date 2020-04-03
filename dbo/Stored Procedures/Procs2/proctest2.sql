-- =============================================
-- Author:		<Author,,Name>
-- ALTER date: <ALTER Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[proctest2]
	
AS
BEGIN	
	SET NOCOUNT ON;
 DECLARE @Treatment_id varchar(100)
 DECLARE @paid varchar(100)
 DECLARE @case varchar(100)
 declare @newcase as varchar(100)
 DECLARE cursorName CURSOR 

 FOR
    select treatment_id,Case_Id from tbltreatment where treatment_id in (232488,232492,232489,232490,232491)order by treatment_id
 
OPEN cursorName -- open the cursor

FETCH NEXT FROM cursorName
 
   INTO @Treatment_id
 
    
WHILE @@FETCH_STATUS = 0
 
BEGIN
 
   FETCH NEXT FROM cursorName   
   INTO @Treatment_id
   
  -- set @newcase=(select top 1 'FH' + RIGHT(CAST(DATEPART(year, GETDATE()) AS NVARCHAR),2) + '-' + CAST((select MAX(Case_AUTOID)+1 from tblcase) AS NVARCHAR) from tblcase)
  -- insert into test_caseid(case_id) values(@newcase)
  -- insert into tblcase SELECT 
  --     @newcase
  --    ,[Case_Code]
  --    ,[Provider_Code]
  --    ,[InsuranceCompany_Code]
  --    ,[Provider_Id]
  --    ,[InsuranceCompany_Id]
  --    ,[InjuredParty_LastName]
  --    ,[InjuredParty_FirstName]
  --    ,[InjuredParty_Address]
  --    ,[InjuredParty_City]
  --    ,[InjuredParty_State]
  --    ,[InjuredParty_Zip]
  --    ,[InjuredParty_Phone]
  --    ,[InjuredParty_Misc]
  --    ,[InsuredParty_LastName]
  --    ,[InsuredParty_FirstName]
  --    ,[InsuredParty_Address]
  --    ,[InsuredParty_City]
  --    ,[InsuredParty_State]
  --    ,[InsuredParty_Zip]
  --    ,[InsuredParty_Misc]
  --    ,[Accident_Date]
  --    ,[Accident_Address]
  --    ,[Accident_City]
  --    ,[Accident_State]
  --    ,[Accident_Zip]
  --    ,[Policy_Number]
  --    ,[Ins_Claim_Number]
  --    ,[IndexOrAAA_Number]
  --    ,[Status]
  --    ,[Old_Status]
  --    ,[Defendant_Id]
  --    ,[Date_Opened]
  --    ,[Date_Opened_Full]
  --    ,[Last_Status]
  --    ,[Initial_Status]
  --    ,[Memo]
  --    ,[InjuredParty_Type]
  --    ,[InsuredParty_Type]
  --    ,[Adjuster_Id]
  --    ,[DenialReasons_Type]
  --    ,[Court_Id]
  --    ,[Attorney_FileNumber]
  --    ,[Group_Data]
  --    ,[Group_Id]
  --    ,[Date_Status_Changed]
  --    ,[Date_Answer_Received]
  --    ,[Motion_Date]
  --    ,[Trial_Date]
  --    ,[Attorney_Id]
  --    ,[Date_Answer_Expected]
  --    ,[Reply_Date]
  --    ,[Calendar_Part]
  --    ,[Motion_Type]
  --    ,[Whose_Motion]
  --    ,[Defense_Opp_Due]
  --    ,[Date_Ext_Of_Time_2]
  --    ,[XMotion_Type]
  --    ,[Case_Billing]
  --    ,[DateOfService_Start]
  --    ,[DateOfService_End]
  --    ,@claim
  --    ,@paid
  --    ,[Date_BillSent]
  --    ,[Caption]
  --    ,[Group_ClaimAmt]
  --    ,[Group_PaidAmt]
  --    ,[Group_Balance]
  --    ,[Group_InsClaimNo]
  --    ,[Group_All]
  --    ,[Date_Packeted]
  --    ,[Group_Accident]
  --    ,[Group_PolicyNum]
  --    ,[GROUP_CASE_SEQUENCE]
  --    ,[Our_SJ_Motion_Activity]
  --    ,[Their_SJ_Motion_Activity]
  --    ,[Our_Discovery_Demands]
  --    ,[Our_Discovery_Responses]
  --    ,[Date_Summons_Printed]
  --    ,[Plaintiff_Discovery_Due_Date]
  --    ,[Defendant_Discovery_Due_Date]
  --    ,[Date_Bill_Submitted]
  --    ,[Date_Index_Number_Purchased]
  --    ,[Date_Afidavit_Filed]
  --    ,[Date_Ext_Of_Time]
  --    ,[Date_Summons_Sent_Court]
  --    ,[Date_Ext_Of_Time_3]
  --    ,[Served_To]
  --    ,[Served_On_Date]
  --    ,[Served_On_Time]
  --    ,[Date_Closed]
  --    ,[Notary_id]
  --    ,[stips_signed_and_returned]
  --    ,[stips_signed_and_returned_2]
  --    ,[stips_signed_and_returned_3]
  --    ,[Date_Demands_Printed]
  --    ,[Date_Disc_Conf_Letter_Printed]
  --    ,[Date_Reply_To_Disc_Conf_Letter_Recd]
  --    ,[psid]
  --    ,[Motion_Status]
  --    ,[BX_Originated]
  --    ,[BX _ID]
  --    ,[Date_AAA_Arb_Filed]
  --    ,[Date_AAA_Concilation_Over]
  --    ,[Arbitrator_ID]
  --    ,[AAA_Confirmed_Date]
  --    ,[userId]
  --    ,[Doctor_id]
  --    ,[batchcode]
  --    ,[location_id]
  --    ,[GBDocument_RelativePath]
  --    ,[GBDocument_AbsolutePath]
  --    ,[INJURED_LAST_BKP]
  --    ,[Bit_FromGB]
  --    ,[Injured_Caption]
  --    ,[Provider_Caption]
  --    ,[AAA_Decisions]
  --    ,[GB_Dms_Link]
  --    ,[GB_CASE_ID]
  --    ,[GB_COMPANY_ID]
  --    ,[GB_CASE_NO]
  --    ,[DateNotice_TrialFiled]
  --    ,[DateFile_Trial_DeNovo]
  --    ,[DateAAA_packagePrinting]
  --    ,[DateAAA_ResponceRecieved]
  --    ,[Fee_Schedule]
  --    ,[Representetive]
  --    ,[Representative_Contact_Number]
  --    ,[Denial_Date]
  --    ,[INSURANCECOMPANY_INITIAL_ADDRESS]
  --    ,[DOSHI_CASE_ID]
  --FROM [tblcase] where Case_Id=@case   

update tbltreatment set Paid_Amount  ='0.00'  where treatment_id=@Treatment_id 
END
 
CLOSE cursorName -- close the cursor

DEALLOCATE cursorName -- Deallocate the cursor
END

