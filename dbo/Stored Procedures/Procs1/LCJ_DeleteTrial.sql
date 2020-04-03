CREATE PROCEDURE [dbo].[LCJ_DeleteTrial]
(

@Trial_id nvarchar(3000)

)


AS

DELETE from tblTrials where Trial_ID = + @Trial_id

