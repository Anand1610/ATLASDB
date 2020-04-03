CREATE PROCEDURE [dbo].[Additional_Case_Details_Add]  
(  
   @s_a_user         NVARCHAR(100),
   @s_a_case_id     NVARCHAR(100),  
   @s_a_DomainID	NVARCHAR(100),    
   @s_a_Patient_no_Medic           nvarchar(100),  
  -- @s_a_Bill_Adjustment         NVARCHAR(200),  
   @s_a_Purchase_Balance        NVARCHAR(200),  
   @s_a_Purchase_Price   NVARCHAR(200),  
   @s_a_First_Party_Case_Status       NVARCHAR(200),  
   @s_a_First_Party_Attorney  NVARCHAR(200),     
   @s_a_First_Party_LawFirm      NVARCHAR(100),  
   @s_a_Attorney_frmBiller_Note   NVARCHAR(200),
   @s_a_Our_Attorney     NVARCHAR(200),    
   @s_a_Our_Attorney_Law_Firm   NVARCHAR(100), 
   @s_a_Law_Suit_Type     NVARCHAR(200),    
   @s_a_Settledby_First_Party_Litigation	NVARCHAR(500)
   
)  
AS  
BEGIN  
 SET NOCOUNT ON;  
 DECLARE @i_l_result    INT  
 DECLARE @s_l_message   NVARCHAR(500)  
 DECLARE @s_l_LawFirmName  VARCHAR(200)  
 DECLARE @s_l_notes_desc   NVARCHAR(MAX)  
   
  
     IF NOT EXISTS(SELECT case_id FROM tblCase_additional_info (NOLOCK) WHERE  DomainID = @s_a_DomainID and case_id = @s_a_case_id)  
     BEGIN  
          BEGIN TRAN  
			INSERT INTO tblCase_additional_info  
			(  
				case_id,
				domainid,
				Patient_no_Medic,
				--Bill_Adjustment,
				Purchase_Balance,
				Purchase_Price,
				First_Party_Case_Status,
				First_Party_Attorney,
				First_Party_LawFirm,
				Attorney_frmBiller_Note,
				Our_Attorney,
				Our_Attorney_Law_Firm,
				Law_Suit_Type,
				Settledby_First_Party_Litigation
             
			)  
			VALUES  
			(  
				  @s_a_case_id,
				  @s_a_DomainID,
				  @s_a_Patient_no_Medic,
				 -- @s_a_Bill_Adjustment,
				  @s_a_Purchase_Balance,
				  @s_a_Purchase_Price,
				  @s_a_First_Party_Case_Status,
				  @s_a_First_Party_Attorney,
				  @s_a_First_Party_LawFirm,
				  @s_a_Attorney_frmBiller_Note,
				  @s_a_Our_Attorney,
				  @s_a_Our_Attorney_Law_Firm,
				  @s_a_Law_Suit_Type,
				  @s_a_Settledby_First_Party_Litigation
       
			)  
  
		COMMIT TRAN   
     END   
  ELSE  
  BEGIN  
		BEGIN TRAN
		   UPDATE tblCase_additional_info  
		   SET    
			 Patient_no_Medic = @s_a_Patient_no_Medic,  
		--	 Bill_Adjustment  = @s_a_Bill_Adjustment,  
			 Purchase_Balance = @s_a_Purchase_Balance,  
			 Purchase_Price  = @s_a_Purchase_Price,  
			 First_Party_Case_Status   = @s_a_First_Party_Case_Status,  
			 First_Party_Attorney = @s_a_First_Party_Attorney,
			 First_Party_LawFirm = @s_a_First_Party_LawFirm,
			 Attorney_frmBiller_Note = @s_a_Attorney_frmBiller_Note,
			 Our_Attorney = @s_a_Our_Attorney,
			 Our_Attorney_Law_Firm = @s_a_Our_Attorney_Law_Firm,
			 Law_Suit_Type = @s_a_Law_Suit_Type,
			Settledby_First_Party_Litigation = @s_a_Settledby_First_Party_Litigation
			WHERE case_id = @s_a_case_id 
			and domainid = @s_a_DomainID

		COMMIT TRAN 
  END   
  
  SET @s_l_message  =  'Case Details saved successfully'  
  SET @i_l_result  =  0  
  SET @s_l_notes_desc = 'Additional Case details Saved for Case -'+  @s_a_case_id   
  EXEC F_AdminNotes_Add @s_a_notes_desc=@s_l_notes_desc,@s_a_User_Id = @s_a_user,@s_a_notes_type='Activity',@DomainID =@s_a_DomainID   
   
  SELECT @s_l_message AS [MESSAGE], @i_l_result AS [RESULT]   
  
END  
  
  
  
