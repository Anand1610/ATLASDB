CREATE PROCEDURE [dbo].[Get_Provider_Pending_Task_Count] 
	@s_a_DomainID varchar(50),
	@i_a_User_ID int,
	@i_a_Provider_ID int
AS
BEGIN

	SET NOCOUNT ON;
	     Select 
	   Count(*) As TaskCount 
	   from Task T (NOLOCK) 
	   LEFT JOIN 
	   Task_Status TS on T.Task_Status_ID = TS.Task_Status_ID inner join tblcase C (NOLOCK) on T.Case_ID=C.Case_Id
	   Where 
	   T.DomainID = @s_a_DomainID and ISNULL(TS.Description,'') !='completed' and Assign_User_ID = @i_a_User_ID and C.Provider_Id In(@i_a_Provider_ID)
   
END
