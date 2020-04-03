-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Get_CaseIds]
	@s_a_DomainId varchar(50),
	@s_a_Case_Id varchar(50),
	@i_a_PageSize int = 5,
	@i_a_PageNumber int =1
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	Declare @RowNo Bigint;

  Select @RowNo=RowNo from 
  (SELECT 
	 ROW_NUMBER() OVER(ORDER BY Case_Id) AS RowNo,  Case_Id
   FROM tblcase (NOLOCK)
   Where DomainId=@s_a_DomainId and Case_Id like SUBSTRING(@s_a_Case_Id, 0, 3)+'%'
   ) 
   As Cases where Case_Id = @s_a_Case_Id

    If @i_a_PageNumber = 1 and @RowNo is not null and @RowNo != 0
     BEGIN
       set @i_a_PageNumber = CEILING(CAST(@RowNo As float)/CAST(@i_a_PageSize As float))
     END

	SELECT 
	   Case_Id
   FROM tblcase (NOLOCK)
   Where DomainId=@s_a_DomainId and Case_Id like SUBSTRING(@s_a_Case_Id, 0, 3)+'%'
   ORDER BY Case_Id
   OFFSET @i_a_PageSize * (@i_a_PageNumber - 1) ROWS
   FETCH NEXT @i_a_PageSize ROWS ONLY;

   Select 
   CEILING(CAST(count(Case_Id) As float)/CAST(@i_a_PageSize As float))
    as TotalPages
	,@i_a_PageNumber as PageNo
   FROM tblcase (NOLOCK)
   Where DomainId=@s_a_DomainId and Case_Id like SUBSTRING(@s_a_Case_Id, 0, 3)+'%'
   SET NOCOUNT OFF;
END
