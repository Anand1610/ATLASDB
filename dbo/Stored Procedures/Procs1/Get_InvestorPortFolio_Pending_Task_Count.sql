CREATE PROCEDURE [dbo].[Get_InvestorPortFolio_Pending_Task_Count]
	@s_a_DomainID varchar(50),
	@i_a_User_ID int,
	@i_a_Portfolio_ID int
AS
BEGIN
	SET NOCOUNT ON;    
	    Select 
	   Count(*) As TaskCount 
	   from Task T Left Join 
	   Task_Status TS on T.Task_Status_ID = TS.Task_Status_ID inner join tblcase C on T.Case_ID=C.Case_Id
	   Where 
	   T.DomainID = @s_a_DomainID and ISNULL(TS.Description,'') !='completed' and Assign_User_ID = @i_a_User_ID and C.PortfolioId =@i_a_Portfolio_ID
END
