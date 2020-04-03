-- =============================================  
-- Author:  <Author,,Name>  
-- Create date: <Create Date,,>  
-- Description: <Description,,>  
-- =============================================  
CREATE PROCEDURE [dbo].[sp_GetProviderEmailDetail]   
 -- Add the parameters for the stored procedure here  
 @PVal nvarchar(max),  
 @DomainId nvarchar(100)  
AS  
BEGIN  
 -- SET NOCOUNT ON added to prevent extra result sets from  
 -- interfering with SELECT statements.  
 SET NOCOUNT ON;  
  
    -- Insert statements for procedure here  
  DECLARE @xml AS       XML,  
     @str AS       VARCHAR(100),  
     @delimiter AS VARCHAR(10);  
SET @str = @PVal;  
SET @delimiter = ',';  
SET @xml = CAST('<X>' + REPLACE(@str, @delimiter, '</X><X>') + '</X>' AS XML);   
  
select Provider_Id,Provider_Name
, 'priyanka.k@lawspades.com' as Email_For_Monthly_Report from tblProvider where Provider_Id IN(  
SELECT [N].value( '.', 'varchar(50)' ) AS value FROM @xml.nodes( 'X' ) AS [T]( [N] )  
) and DomainId=@DomainId  
  
END  
