﻿CREATE PROCEDURE [dbo].[DEMANDSUPDATE](
@DomainId NVARCHAR(50),
@CID VARCHAR(50),
@DATEDEMANDSSENTOUT VARCHAR(50)
)
AS
BEGIN
UPDATE TBLCASE SET Date_Demands_Printed=@DATEDEMANDSSENTOUT WHERE CASE_ID=@CID

INSERT INTO TBLNOTES (Notes_Desc,	Notes_Type,	Notes_Priority,	Case_Id,	Notes_Date,	User_Id,	DomainId)
SELECT 'DEMANDS PRINTED AND SENT OUT ON ' + CONVERT(VARCHAR,@DATEDEMANDSSENTOUT),'General',0,@cid,getdate(),'system',@DomainId

END

