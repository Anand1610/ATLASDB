CREATE PROCEDURE [dbo].[Additional_Case_Details_Retrive]  
(  
   @s_a_case_id NVARCHAR(100),
   @s_a_DomainID VARCHAR(50)  
)  
AS  
BEGIN  
 SET NOCOUNT ON;  
           
   SELECT   
    ci.case_id,
	ci.domainid,
	Patient_no_Medic,
	First_Party_Case_Status,
	First_Party_Attorney,
	First_Party_LawFirm,
	Attorney_frmBiller_Note,
	Our_Attorney,
	Our_Attorney_Law_Firm,
	Law_Suit_Type,
	Settledby_First_Party_Litigation  
  FROM tblCase_additional_info ci  (NOLOCK)
  --LEFT OUTER JOIN tblcase c on ci.case_id = c.case_id and ci.domainid = c.DomainId 
  WHERE  ci.DomainID = @s_a_DomainID  and ci.case_id = @s_a_case_id
END  
