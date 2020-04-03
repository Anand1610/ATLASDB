CREATE PROCEDURE [dbo].[Get_Action_List]  --[Get_Action_List] '0'
 @DomainId	NVARCHAR(50),
 @DenialType NVARCHAR(50)        
AS        
BEGIN 

	select '0' as Action_id,' --- Select Action --- ' as Action_Type 
	UNION     
	select Action_id,Action_Type from tblAction  where DomainId=@DomainId and DenialReasons_Id=(select min(DenialReasons_Id) from tblDenialReasons  where DomainId=@DomainId and  DenialReasons_Type=@DenialType)

END

