CREATE PROCEDURE [dbo].[SP_GET_Color_cases] --SP_GET_Color_cases 'FH07-42372'
@DomainId NVARCHAR(50),
@SZ_CASE_ID NVARCHAR(100)
AS
BEGIN
		select case_id  as Case_Id
            from tblcase (NOLOCK) inner join tblProvider  
			(NOLOCK) on tblcase.Provider_Id =tblProvider.Provider_Id
            and tblcase.Case_Id =@SZ_CASE_ID
			--and tblcase.Case_Id=@DomainId
END

