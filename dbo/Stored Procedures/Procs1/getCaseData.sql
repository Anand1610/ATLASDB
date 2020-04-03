create proc [dbo].[getCaseData]
@DomainID varchar(10),
@case_id varchar (50)
as
begin
SELECT CASE_ID,  
     InjuredParty_Name=(InjuredParty_LastName + ', ' + InjuredParty_FirstName)   
   FROM TBLCASE (NOLOCK)   
   WHERE
     DomainID = @DomainID  
   AND  ISNULL(IsDeleted,0) = 0   
   AND  case_id  LIKE '%' + @case_id + '%' 
end