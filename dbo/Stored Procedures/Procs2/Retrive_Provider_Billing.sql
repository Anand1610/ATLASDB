-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Retrive_Provider_Billing] -- Retrive_Provider_Billing 
	@s_a_Case_Id VARCHAR(2000),
	@s_a_Domain_Id VARCHAR(2000),
	@s_a_Tran_Type VARCHAR(2000)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	IF @s_a_Tran_Type = 'I'
    BEGIN
		Select  Provider_Initial_IntBilling AS Billing_PER 
		from tblcase c
		INNER JOIN tblProvider p ON  c.provider_id = p.provider_id
		WHERE case_id = @s_a_Case_Id and c.DomainId = @s_a_Domain_Id and Case_Id LIKE 'ACT%'
		UNION
		Select  Provider_IntBilling  AS Billing_PER from tblcase c
		INNER JOIN tblProvider p ON  c.provider_id = p.provider_id
		WHERE case_id = @s_a_Case_Id and c.DomainId = @s_a_Domain_Id and Case_Id NOT LIKE 'ACT%'
	END
	ELSE
	BEGIN
		Select  Provider_Initial_Billing  AS Billing_PER
		from tblcase c
		INNER JOIN tblProvider p ON  c.provider_id = p.provider_id
		WHERE case_id = @s_a_Case_Id and c.DomainId = @s_a_Domain_Id and Case_Id LIKE 'ACT%'
		UNION
		Select  Provider_Billing AS Billing_PER
		from tblcase c
		INNER JOIN tblProvider p ON  c.provider_id = p.provider_id
		WHERE case_id = @s_a_Case_Id and c.DomainId = @s_a_Domain_Id and Case_Id NOT LIKE 'ACT%'
	END
END
