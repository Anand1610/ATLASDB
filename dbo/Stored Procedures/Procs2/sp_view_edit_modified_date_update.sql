CREATE PROCEDURE [dbo].[sp_view_edit_modified_date_update]
( 
	@DomainId			NVARCHAR(50),     
	@i_a_image_id		INT,
	@i_a_modified_by	INT
)
AS
BEGIN
	DECLARE @i_l_duplicate INT = 0	
	SELECT @i_l_duplicate = COUNT(*) FROM tblImageTag  WHERE ImageID = @i_a_image_id and DomainId=@DomainId
	 ---Start of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude  
    AND IsDeleted=0  
    ---End   of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude 
	IF(@i_l_duplicate <> 0)
	BEGIN
			UPDATE
					tblImageTag 
			SET
					DateModified	=	GETDATE()
			WHERE
					ImageID			=	@i_a_image_id
			AND		DomainId		=	@DomainId
		    ---Start of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude  
            AND IsDeleted=0  
            ---End   of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude  
  
			SET @i_l_duplicate		=	0
			SELECT @i_l_duplicate	=	COUNT(*) FROM  tbl_ImageTag_Modifiedby	WHERE ImageId	=	@i_a_image_id
			IF(@i_l_duplicate = 0)
			BEGIN
					INSERT INTO tbl_ImageTag_Modifiedby 
					VALUES(@DomainId,@i_a_image_id,@i_a_modified_by)
			END
			ELSE
			BEGIN
					UPDATE
							tbl_ImageTag_Modifiedby 
					SET
							modified_by		=	@i_a_modified_by
					WHERE
							ImageId			=	@i_a_image_id
						AND DomainId		=	@DomainId
			END
	END	
END

