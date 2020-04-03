CREATE PROCEDURE [dbo].[LCJ_DeleteAdjuster]
(
@DomainId nvarchar(50),
@Adjuster_Id int,
@OperationResult INT OUTPUT

)


AS

		IF EXISTS(Select Adjuster_Id  
		
			FROM  tblcase 
			WHERE 
			Adjuster_Id = @Adjuster_Id
			and DomainId = @DomainId
		
			  
		)

			BEGIN
				SET @OperationResult = 1
				Return 1
				
			END
	
		ELSE
			BEGIN
				DELETE from tblAdjusters  where Adjuster_Id = @Adjuster_Id and DomainId = @DomainId
				SET @OperationResult = 0
				Return 0
			END
