--sp_helptext LCJ_AddDataEntry1

CREATE PROCEDURE [dbo].[F_Case_DenialReasons_Retrieve] --[dbo].[F_Case_DenialReasons_Retrieve] 'FH13-160344' 
  
(  
	  @DomainId NVARCHAR(50),
	  @s_a_case_id NVARCHAR(200)
)  
AS 
	BEGIN 
		SELECT tbl_Case_Denial.PK_ID,tbl_Case_Denial.FK_Denial_ID,MST_DenialReasons.DenialReason,tbl_Case_Denial.Case_ID 
		FROM tbl_Case_Denial  AS tbl_Case_Denial inner join MST_DenialReasons  AS MST_DenialReasons on tbl_Case_Denial.fk_Denial_ID=MST_DenialReasons.PK_Denial_ID  
		WHERE Case_Id=@s_a_case_id AND @DomainId = tbl_Case_Denial.DomainId
    END

