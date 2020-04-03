CREATE PROCEDURE [dbo].[SP_GET_EXHIBITS_FOR_DISCOVERY_MOTION] --  'FH09-55947','PROC-001','H:'
	@SZ_CASE_ID NVARCHAR(50),
	@SZ_PROCESS_ID NVARCHAR(10),
	@SZ_BASE_PATH NVARCHAR(1000)
AS
BEGIN
	DECLARE @COunt int

	If @SZ_PROCESS_ID='PROC-001'
		Begin
			Set @Count=(Select count(SZ_PROCESS_CODE) From TXN_EXHIBIT_SEQUENCE Where SZ_PROCESS_CODE=@SZ_PROCESS_ID)

			SELECT 
				I_DOCUMENT_TYPE [EXHIBIT_ID],
				isnull(@SZ_BASE_PATH + '\' + IMAGEPATH + '\' + [FILENAME],N'') [InputFilePath],
				TSEQ.SZ_ABSENT_EXHIBIT_STATEMENT [STATEMENT],
				@Count [COUNT]
			FROM TXN_EXHIBIT_SEQUENCE TSEQ
				  JOIN TBLIMAGES TIMAGES ON TSEQ.I_DOCUMENT_TYPE = TIMAGES.DOCUMENTID
				AND TIMAGES.CASE_ID =  @SZ_CASE_ID AND TSEQ.SZ_PROCESS_CODE = @SZ_PROCESS_ID
				--AND TIMAGES.USERID <> 'system' AND DELETEFLAG = 0
				AND DELETEFLAG = 0 
			ORDER BY TSEQ.I_SEQUENCE ASC
		End
	Else If @SZ_PROCESS_ID='PROC-002'
		Begin
			DECLARE @I_INSURANCE_COMPANY_ID int
			SET @I_INSURANCE_COMPANY_ID=(Select InsuranceCompany_Id From tblcase Where Case_Id=@SZ_CASE_ID)

			Set @Count=(Select count(SZ_PROCESS_CODE) From TXN_EXHIBIT_SEQUENCE Where SZ_PROCESS_CODE=@SZ_PROCESS_ID)

			SELECT 
				documentid [EXHIBIT_ID],
				isnull(@SZ_BASE_PATH + '\' + IMAGEPATH + '\' + [FILENAME],N'') [InputFilePath],
				'' [STATEMENT],
				@Count [COUNT],
				(select document_type from tbldocumenttype where document_id = TIMAGES.DOCUMENTID) Document_Type,
				doctypes.doc_sequence
			FROM TBLIMAGES TIMAGES 
				inner join  tbldocumenttype doctypes on TIMAGES.documentid = doctypes.document_id
				AND TIMAGES.CASE_ID =  @SZ_CASE_ID
				---AND TIMAGES.USERID <> 'system' AND DELETEFLAG = 0
				AND DELETEFLAG = 0 and doctypes.document_id is not null
				WHERE doctypes.doc_sequence Is not null
			ORDER BY doctypes.doc_sequence ASC
		End
END



-- select * from tblimages where ImageID = 1870887

