CREATE PROCEDURE Insurance_TPA_Group
(
	@Flag varchar(10),
	@DomainId varchar(10),
	@UserName varchar(20),
	@TPAGroupName varchar(200) = null,
	@Address varchar(250) = null,
	@City varchar(100) = null,
	@State varchar(20) = null,
	@ZipCode varchar(50) = null,
	@Email varchar(50) = null,
	@Id int = null,
	@Notes varchar(200) = null
)
AS
BEGIN
	IF(Lower(@Flag) = 'select')
		BEGIN
			SELECT		TPA_Group_Name AS [TPAGroupName],
						Address,
						City,
						State,
						ZipCode,
						Email,
						created_by_user AS [CreatedBy],
						CAST(created_date AS DATE) AS CreatedDate,
						modified_by_user AS [UpdatedBy],
						CAST(modified_date AS DATE) AS UpdatedDate,
						PK_TPA_Group_ID AS [ID],
						Notes
			FROM		tblInsurance_TPA_Group
			WHERE		IsActive = 0
			AND			DomainId = @DomainId
			ORDER BY	TPAGroupName,
						CreatedDate DESC
		END

	ELSE IF(Lower(@Flag) = 'add')
		BEGIN
			IF((SELECT 1 FROM tblInsurance_TPA_Group WHERE DomainId = @DomainId AND IsActive = 0 AND TPA_Group_Name = LTRIM(RTRIM(@TPAGroupName))) = 1)
				BEGIN
					SELECT 'Record Already Exists'
				END
			ELSE
				BEGIN
					INSERT INTO tblInsurance_TPA_Group
					(
						TPA_Group_Name,
						Address,
						City,
						State,
						ZipCode,
						Email,
						created_by_user,
						created_date,
						Notes,
						DomainId
					)
					VALUES
					(
						LTRIM(RTRIM(@TPAGroupName)),
						@Address,
						@City,
						@State,
						@ZipCode,
						@Email,
						@UserName,
						GETDATE(),
						@Notes,
						@DomainId
					)
					SELECT 'Record Added Successfully'
				END
		END

	ELSE IF(Lower(@Flag) = 'update')
		BEGIN
			UPDATE	tblInsurance_TPA_Group
			SET		TPA_Group_Name = LTRIM(RTRIM(@TPAGroupName)),
					Address = @Address,
					City = @City,
					State = @State,
					ZipCode = @ZipCode,
					Email = @Email,
					modified_by_user = @UserName,
					modified_date = GETDATE(),
					Notes = @Notes
			WHERE	DomainId = @DomainId
			AND		PK_TPA_Group_ID = @Id
			SELECT 'Record Updated Successfully'
		END

		ELSE IF(Lower(@Flag) = 'delete')
			IF NOT EXISTS(SELECT 1 FROM tblInsuranceCompany WHERE DomainId = @DomainId AND fk_TPA_Group_ID = (SELECT PK_TPA_Group_ID FROM tblInsurance_TPA_Group WHERE PK_TPA_Group_ID = @Id AND DomainId = @DomainId))
				BEGIN
					UPDATE	tblInsurance_TPA_Group
					SET		IsActive = 1,
							modified_by_user = @UserName,
							modified_date = GETDATE()
					WHERE	PK_TPA_Group_ID = @Id
					AND		DomainId = @DomainId
					SELECT 'Record Deleted Successfully'
				END
			ELSE
				BEGIN
					SELECT 'Cannot delete since some insurance companies are associated with it'
				END
END

