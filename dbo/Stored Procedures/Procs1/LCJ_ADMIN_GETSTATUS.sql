﻿CREATE PROCEDURE [dbo].[LCJ_ADMIN_GETSTATUS]
@DomainId NVARCHAR(50)

AS

Select STATUS_ABR, LTRIM(RTRIM(UPPER(STATUS_TYPE))) AS STATUS_TYPE  from tblStatus where 1=1 and DomainId=@DomainId

