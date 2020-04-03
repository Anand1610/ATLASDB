CREATE PROCEDURE [dbo].[INSERT_ECMC_CASES]
AS
BEGIN
DECLARE @ECMC_Case_Id INT
DECLARE @Case_Id VARCHAR(100)
DECLARE @Patient_Last_Name VARCHAR(500)
DECLARE @Policy_No VARCHAR(100)
DECLARE @FHKPCASEID VARCHAR(100)
DECLARE @Date_Opened AS DATETIME,
		@LASTCASEID VARCHAR(50),
		@NEWCASEID VARCHAR(50),
		@PART1CASEID INT,
		@PART2CASEID INT
DECLARE @MaxCase_Id INTEGER
			DECLARE @Case_Id_IDENTITY INTEGER
DECLARE ECMC_CURSOR CURSOR
FOR SELECT ID, [Patient Name],Policy
	from ECMC where FHKP_Case_Id is NULL
OPEN ECMC_CURSOR
fetch next from ECMC_CURSOR
INTO @ECMC_Case_Id,@Patient_Last_Name,@Policy_No
WHILE @@FETCH_STATUS=0
BEGIN
	Insert INTO tblCase 
				(
					Case_Id,
					Provider_Id,
					InsuranceCompany_Id,
					InjuredParty_LastName,
					InjuredParty_FirstName,
					Accident_Date,
					Policy_Number,
					Ins_Claim_Number,					
					Status,
					Claim_Amount,
					Paid_Amount,
					Date_Opened,					
					Initial_Status,
					Memo,					
					Court_Id
				)				 
				VALUES
				(			
					'',
					NULL,
					NULL,
					@Patient_Last_Name,
					'ECMC',
					Convert(nvarchar(15), GETDATE(), 101),
					@Policy_No,
					'',					
					'ECMC-OPEN',
					0.00,
					0.00,
					'',					
					'ECMC',
					'',					
					NULL
				)

			SET  @Case_Id_IDENTITY = @@IDENTITY 
			PRINT(@Case_Id_IDENTITY)  
  
   SET @Case_Id  = 'RFA' + RIGHT(CAST(DATEPART(year, GETDATE()) AS NVARCHAR),2) + '-' + CAST(@Case_Id_IDENTITY AS NVARCHAR)  
  
   UPDATE tblCase SET Case_Id = @Case_Id where Case_AutoId = @Case_Id_IDENTITY  
			
			SET @FHKPCASEID = @Case_Id
			UPDATE ECMC SET FHKP_Case_Id = @Case_Id where ID=@ECMC_Case_Id
		fetch next from ECMC_CURSOR
		INTO @ECMC_Case_Id,@Patient_Last_Name,@Policy_No
END
CLOSE ECMC_CURSOR
DEALLOCATE ECMC_CURSOR
END

