﻿CREATE PROCEDURE [dbo].[SpInsertMergedCasesFilesDetails]
(
	@DOMAINID VARCHAR(20),
	@CASEID VARCHAR(MAX),
	@NODENAME VARCHAR(200),
	@JOBID INT,
	@CREATEDBY VARCHAR(100)
)
AS
BEGIN
	INSERT INTO MergedCasesFiles (DomainId,CaseId,NodeName,JobId,CreatedBy,Status,DateCreated)
	VALUES (@DOMAINID,@CASEID,@NODENAME,@JOBID,@CREATEDBY,'In-Progress',GETDATE())
END