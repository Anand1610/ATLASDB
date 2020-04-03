--sp_helptext LCJ_AddDataEntry1

CREATE PROCEDURE [dbo].[LCJ_DenialReasons_Add]  
  
(  
	  @Case_Id nvarchar(200),
	  @Denial_Date DATETIME,
	  @DenialReasons_Type nvarchar(200),
	  @UserID nvarchar(100)
)  
AS  
		DECLARE @NOTES VARCHAR(200),
		@DenialReason_Id INT,
		@DenialType varchar(200)
  BEGIN  
       BEGIN
			
			SET @DenialReason_Id=(SELECT PK_Denial_ID FROM MST_DenialReasons  WHERE DenialReason =@DenialReasons_Type)
			IF NOT EXISTS (SELECT * FROM tblDenial WHERE Case_Id=@Case_Id and FK_Denial_ID=@DenialReason_Id)
			INSERT INTO tblDenial
			(
				FK_Denial_ID,
				Case_Id,
				DenialDate
			)  
			VALUES
			(
				@DenialReason_Id,
				@Case_Id,
				Convert(nvarchar(15), @Denial_Date, 101)
			)    
         END
         SET @NOTES = 'Denial Reason Added' + @DenialReasons_Type +'on'+ Convert(nvarchar(15), @Denial_Date, 101)
		 exec LCJ_AddNotes @case_id=@case_id,@notes_type='Activity',@Ndesc=@NOTES,@User_id=@UserID,@Applytogroup=0
  END 
   
 

select * from dbo.MST_DenialReasons

