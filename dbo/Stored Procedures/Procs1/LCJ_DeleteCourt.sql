CREATE PROCEDURE [dbo].[LCJ_DeleteCourt]
(
	@DomainId nvarchar(50),
	@Court_Id int,
	@OperationResult INT OUTPUT
)


AS
	IF EXISTS(select top 1 court_id from tblcase  where court_id=@Court_Id AND DomainId = @DomainId) BEGIN
		SET @OperationResult=1
		SELECT @OperationResult
	END
	ELSE
		BEGIN
			BEGIN TRAN
			DELETE from tblCourt  where Court_Id = @Court_Id AND @DomainId = DomainId
			SET @OperationResult=0
			COMMIT TRAN
			SELECT @OperationResult
		END

