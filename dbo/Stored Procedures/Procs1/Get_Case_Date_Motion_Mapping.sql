-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE Get_Case_Date_Motion_Mapping 
	@i_a_CaseDateDetailsID int,
	@s_a_DomainId varchar(50),
	@s_a_Case_Id varchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	   If @i_a_CaseDateDetailsID = 0 AND Exists(Select Auto_Id  from tblCase_Date_Details Where Case_Id = @s_a_Case_Id and DomainId = @s_a_DomainId)
		BEGIN
		  Select @i_a_CaseDateDetailsID = Auto_Id from tblCase_Date_Details Where Case_Id = @s_a_Case_Id and DomainId = @s_a_DomainId
		END

	Select Id
	       ,CaseDateDetailsID
		   ,map.MotionTypeId
		   ,m.Name as MotionType
		   ,Convert(varchar(50), MotionHearingDate, 101) MotionHearingDate
		   ,MotionHearingDate as MotionHearingDateWithTime
		   ,Motion_for_PL_or_DEF 
		   ,iif(Motion_for_PL_or_DEF=1, 'Defendant','Plaintiff') as PL_or_DEF
		   from tblCaseDateMotionMapping map (NOLOCK) left join tblMotionType m on m.MotionTypeId = map.MotionTypeId
		   Where CaseDateDetailsID = @i_a_CaseDateDetailsID and map.DomainId = @s_a_DomainId

END
