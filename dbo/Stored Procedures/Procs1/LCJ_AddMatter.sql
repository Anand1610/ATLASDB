CREATE PROCEDURE [dbo].[LCJ_AddMatter]

(

@Client_Id  		NVARCHAR(255),
@Patient_LastName 	VARCHAR(20) ,
@Patient_FirstName 	VARCHAR(20),
@Patient_Address	VARCHAR(250), 
@Patient_City      	VARCHAR(20), 
@Patient_State     	VARCHAR(20), 
@Patient_Zip       	VARCHAR(20), 
@Patient_Phone     	VARCHAR(20),
@Patient_Misc		VARCHAR(50),
@Insured_LastName	VARCHAR(20),
@Insured_FirstName	VARCHAR(20),
@Insured_Address	NVARCHAR(255),
@Insured_City      	VARCHAR(20), 
@Insured_State     	VARCHAR(20), 
@Insured_Zip       	VARCHAR(20), 
@Insured_Misc		VARCHAR(50),
@Claim_Amount 	MONEY ,
@Policy_Number 	NVARCHAR(20) ,
@Ins_Claim_Number	NVARCHAR(20),
--@Index_Number	NVARCHAR(40),
@DateOfService_Start 	DATETIME,
@DateOfService_End	DATETIME,
@Accident_Address	VARCHAR(250), 
@Accident_City 		VARCHAR(20), 
@Accident_State 	VARCHAR(20), 
@Accident_Zip 		VARCHAR(20), 
@Defense_FirmId	NVARCHAR(255),
@Accident_Date 	DATETIME, 
@Insurer_Id 		NVARCHAR(255), 
@Date_Assigned 	DATETIME, 
@Date_Status_Changed	DATETIME, 
@Status 		VARCHAR(10), 
@Original_Status 	VARCHAR(10), 
@Last_Status 		VARCHAR(10), 
@Bill_FF		BIT,
@Payments		MONEY,
@Memo		NVARCHAR(255),
--@Comment VARCHAR(250) ,
--@NotesDesc VARCHAR(250),
--@ValueMemo Varchar(250) ,
--@ValueClaimID Varchar(10),
--@UserID AS VARCHAR(10) ,
/*
Add @OperationResult Paramater to Check if Matter inserted already exists!
Add @NewMatterOutputResult to get the Last New Matter ID Just Added in the DBase
*/
@OperationResult INTEGER OUTPUT,
@NewMatterOutputResult VARCHAR(100) OUTPUT
				 
)
AS
BEGIN
	DECLARE 	--@IntOfFirstName AS VARCHAR(1) ,
			--@ClaimKey 	AS VARCHAR(21) ,
			--@ClaimNo	AS Integer ,
			@Matter_Id	AS NVARCHAR(20) ,
			--@ClaimFeeType  AS VARCHAR(20),
			--@CID 	AS VARCHAR(20),
			
			@CurrentDate AS SmallDATETIME
			--@ClaimFF	AS Integer
			
	-- Remove Leading and ending spaces from the input parameters
	SET @Patient_LastName = RTRIM(LTRIM(@Patient_LastName))
	SET @Patient_FirstName = RTRIM(LTRIM(@Patient_FirstName))
	SET @CurrentDate = Convert(Varchar(15), GetDate(),102)
	
	-- Check if similiar Claim already exisits 
	-- if it exists the don't proceed further , return output code as 2
	IF EXISTS(Select Matter_Id  
			FROM  tblMatter 
			WHERE 
			Client_Id = @Client_Id and 
			Patient_LastName = @Patient_LastName and 
			Patient_FirstName = @Patient_FirstName and
			Accident_Date = @Accident_Date and 
			Claim_Amount = @Claim_Amount and 
			Policy_Number = @Policy_Number  and  
			DateOfService_Start = @DateOfService_Start and 
			DateOfService_End = @DateOfService_End  )

		BEGIN
			SET @OperationResult = 2
			RETURN @OperationResult
		END
	
	ELSE
	
		BEGIN
			-- Get the Intial of the FirstName
			--SET  @IntOfFirstName = SUBSTRING(@Patient_FirstName , 1 ,1)
		
			-- Form the CLAIM key (ClaimKey = LastNAme + IntOfFirstName)
			-- for eg is injured person is Jean Wallace the the claim key is "wallacej"
		
			/*SET @ClaimKey = @Patient_LastName + @IntOfFirstName 
		
			-- This Temp table is used to store all the claims having the same claim key
			-- and then we can determine the new claim key depending on the max of the related claim no's
		
			DECLARE @TempClaimRecords  TABLE(num Integer)
	
			Insert into @TempClaimRecords
			Select Convert(Integer , SUBSTRING(CLAIM_KEY,len(@ClaimKey)+1, 3)) from tblMatter 
				WHERE CLAIM_KEY LIKE( @ClaimKey +  '%')
		
			
			Select @ClaimNo = max(num) from @TempClaimRecords 
			IF (@ClaimNo = NULL)
			BEGIN   -- No claims with this Claim key exists
				SET @ClaimNo = 1
			END
			ELSE
			BEGIN
				SET @ClaimNo = @ClaimNo + 1
			END
			*/
		
			-- Generate the ClaimID CID
			-- Get the max Claim ID and the form the CID using tha MAX  Claim No
			-- CID = M + Current Year + MAX Claim No + 1
		
			DECLARE @MaxMatter_Id INTEGER
			--DECLARE @MM_ID INTEGER
			DECLARE @Matter_Id_IDENTITY INTEGER
			
			
			-- Get Fee Type
			/*
			Select 

				@ClaimFeeType =
				CASE	

					WHEN (@Orignal_Status = 'ACT') THEN
					Client_FeeType
					ELSE
					Client_FeeType_Denials
				END ,
				@ClaimFF =
				CASE	
					WHEN( @Orignal_Status = 'ACT')	THEN
					FFPaidACT
					ELSE
					FFPaidDenials
				END
			FROM tblClient WHERE Client_Id= @Client_Id
			*/
	
			-- Insert the records
			BEGIN TRAN
				-- Insert Claim Details
			
				Insert INTO tblMatter 
				(
				
				Matter_Id,
				Client_Id  		,
				Patient_LastName 	,
				Patient_FirstName 	,
				Patient_Address	, 
				Patient_City      	, 
				Patient_State     	, 
				Patient_Zip       	, 
				Patient_Phone     	,
				Patient_Misc		,
				Insured_LastName	,
				Insured_FirstName	,
				Insured_Address,
				Insured_City      	, 
				Insured_State     	, 
				Insured_Zip       	, 
				Insured_Misc		,
				Claim_Amount 	,
				Policy_Number 	 ,
				Ins_Claim_Number	,
				--Index_Number	NVARCHAR(40),
				DateOfService_Start 	,
				DateOfService_End	,
				Accident_Address	, 
				Accident_City 		, 
				Accident_State 	, 
				Accident_Zip 		, 
				Defense_FirmId	,
				Accident_Date 	, 
				Insurer_Id 		, 
				Date_Assigned 	, 
				Date_Status_Changed	, 
				Status 		, 
				Original_Status 	, 
				Last_Status 		, 
				Bill_FF			,
				Payments		,
				Memo		

				)
				 
				VALUES

				(
				
				'',
				@Client_Id  		,
				@Patient_LastName 	,
				@Patient_FirstName 	,
				@Patient_Address	, 
				@Patient_City      	, 
				@Patient_State     	, 
				@Patient_Zip       	, 
				@Patient_Phone     	,
				@Patient_Misc		,
				@Insured_LastName	,
				@Insured_FirstName	,
				@Insured_Address	,
				@Insured_City      	, 
				@Insured_State     	, 
				@Insured_Zip       	, 
				@Insured_Misc		,
				@Claim_Amount 	,
				@Policy_Number 	,
				@Ins_Claim_Number	,
				--@Index_Number	,
				convert(datetime, @DateOfService_Start,101) ,
				convert(datetime, @DateOfService_End,101) ,
				@Accident_Address	, 
				@Accident_City 		, 
				@Accident_State 	, 
				@Accident_Zip 		, 
				@Defense_FirmId	,
				convert(datetime, @Accident_Date,101) 	, 
				@Insurer_Id 		, 
				convert(datetime, @Date_Assigned,101) 	, 
				convert(datetime, @Date_Status_Changed,101)	, 
				@Status 		, 
				@Original_Status 	, 
				@Last_Status 		, 
				@Bill_FF		,
				@Payments		,
				@Memo		
								
				)
					
				--Select @NewMatterOutputResult = Max(Matter_Id) from tblMatter
				--return @NewMatterOutputResult
				--return @OperationResult
				--Set  @NewMatterOutputResult = @@IDENTITY
				-- Insert Notes Data Entry
				/*INSERT INTO Notes 
				(Notes_Desc , Notes_Type , Claim_ID , Notes_Date , User_ID , Notes_Priority) VALUES 
			    	 (@NotesDesc , 'A' , @ValueClaimID , @CurrentDate , @UserID , '0')
				
				IF @Comment <> ''
				BEGIN
					-- Insert into Notes again??
					INSERT INTO Notes
					(Notes_Desc , Notes_Type , Claim_ID , Notes_Date , User_ID , Notes_Priority) VALUES 
					(@ValueMemo , 'A' , @ValueClaimID , @CurrentDate , @UserID , '0')
				END
	
				IF ((@Status = 'SUIT' OR @Status = 'UNTIMELY') AND @claimff = 1 AND @OrignalStatus ='SUIT') 
					Insert into Transactions VALUES(@CID ,'OTH',@CurrentDate,55,'' ,@ClientId,'System',55)
				*/
			COMMIT TRAN
			
			SET  @Matter_Id_IDENTITY = @@IDENTITY

			--Select @MaxMatter_Id =Convert(Integer, SUBSTRING(MAX(Matter_Id),PATINDEX('%-%' , MAX(Matter_Id) )+1, 8)) from tblMatter 
			--Select @MaxMatter_Id = Max(Matter_AutoId) from tblMatter
			
			--Set @MM_ID = @MaxMatter_Id + 1
			
			--IF (@MaxMatter_Id = NULL)
				
			SET @Matter_Id  = 'FHA' + RIGHT(CAST(DATEPART(year, GETDATE()) AS NVARCHAR),2) + '-' + CAST(@Matter_Id_IDENTITY AS NVARCHAR)
			UPDATE tblMatter SET Matter_Id = @Matter_Id where Matter_AutoId = @Matter_Id_IDENTITY
			SET @NewMatterOutputResult = @Matter_Id
			--ELSE
				--SET @Matter_Id  = 'LCJ' + RIGHT(CAST(DATEPART(year, GETDATE()) AS NVARCHAR),2) + '-' + CAST(@MaxMatter_Id AS NVARCHAR)
				--SET @Matter_Id  = 'LCJ' +  DATEPART(year, GETDATE()) + '-' + CONVERT( VARCHAR(8) , (@MaxMatter_Id + 1))
				--SET @Matter_Id  = 'LCJ' + RIGHT( CAST(DATEPART(year, GETDATE()) AS NVARCHAR),2) + '-' + CONVERT( VARCHAR(8) , (@MM_ID))
				--SET @Matter_Id  = 'LCJ' + RIGHT( CAST(DATEPART(year, GETDATE()) AS NVARCHAR),2) + '-' + CONVERT( VARCHAR(8) ,  CAST(@MaxMatter_Id AS NVARCHAR))

				--SET @Matter_Id  = 'LCJ' +  CAST(DATEPART(year, GETDATE()) AS NVARCHAR) + '-' + CONVERT( VARCHAR(8) , (@MaxMatter_Id + 1))
				--SET @Matter_Id = CAST( 'LCJ' + RIGHT(CAST(DATEPART(year, GETDATE()) AS NVARCHAR),2) + '-' + CAST((@MM_ID) AS INTEGER) AS NVARCHAR)



			--RETURN @OperationResult
			--RETURN  @Matter_Id
		END -- END of ELSE	
	
END

