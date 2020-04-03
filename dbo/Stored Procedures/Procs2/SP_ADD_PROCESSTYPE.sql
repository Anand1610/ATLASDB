CREATE PROCEDURE [dbo].[SP_ADD_PROCESSTYPE]--'test'
(
@DomainId NVARCHAR(50),
@SZ_PROCESS_NAME nvarchar(300)
)
AS
BEGIN
	
	BEGIN

    
	BEGIN TRAN
	
		
		INSERT INTO MST_PROCESS
		(
		SZ_PROCESS_CODE,
		SZ_PROCESS_NAME,
		DomainId
				
		)

		VALUES(
		'PROC-',
		@SZ_PROCESS_NAME,
		@DomainId
		
		)					

		DEclare @MaxID as int
		DECLARE @SZ_MAX_CODE AS NVARCHAR(20)
		SET @SZ_MAX_CODE = (SELECT MAX(substring(SZ_PROCESS_CODE,0,10)) FROM MST_PROCESS WHERE DomainId=@DomainId)
		DEclare @SZ_PROCESS_CODE as nvarchar(20)

		set	@MaxID=	(select MAX(substring(SZ_PROCESS_CODE,6,4)) + 1 from MST_PROCESS WHERE DomainId=@DomainId)

		set @SZ_PROCESS_CODE= 'PROC-' + convert(varchar,(RIGHT ('0'+ CAST (@MaxID as nvarchar), 3)))			
print(@SZ_PROCESS_CODE)

		update MST_PROCESS set SZ_PROCESS_CODE=@SZ_PROCESS_CODE where SZ_PROCESS_CODE='PROC-' and DomainId=@DomainId

		COMMIT TRAN

	END

END

