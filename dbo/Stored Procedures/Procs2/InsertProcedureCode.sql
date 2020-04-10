-- =============================================  
-- Changed By: Atul Jadhav 
-- Changed date: 4/9/2020
-- Description: Added CptCodeC Change  
-- =============================================  
CREATE PROCEDURE [dbo].[InsertProcedureCode] @Treatment_Details VARCHAR(MAX)
	,@Bill_Number VARCHAR(50) NULL
	,@Treatment_Id INT
	,@Case_Id VARCHAR(50)
	,@DomainID VARCHAR(50)
AS
BEGIN
	PRINT @Bill_Number
	PRINT @Case_Id

	BEGIN TRY
		BEGIN TRANSACTION

		CREATE TABLE #temp (
			TreatmentCodeID VARCHAR(255)
			,TreatmentCode VARCHAR(50)
			,TreatmentDescription VARCHAR(1000)
			,Specialty VARCHAR(255)
			,DOS DATETIME
			,Amount MONEY
			,Units DECIMAL
			,InsuranceFeeSchedule MONEY
			)

		INSERT INTO #temp (
			TreatmentCodeID
			,TreatmentCode
			,TreatmentDescription
			,Specialty
			,DOS
			,Amount
			,Units
			,InsuranceFeeSchedule
			)
		SELECT TreatmentCodeID
			,TreatmentCode
			,TreatmentDescription
			,Specialty
			,DOS
			,Amount
			,Units
			,InsuranceFeeSchedule
		FROM OPENJSON(@Treatment_Details) WITH (
				TreatmentCodeID VARCHAR(255)
				,TreatmentCode VARCHAR(50)
				,TreatmentDescription VARCHAR(1000)
				,Specialty VARCHAR(255)
				,DOS DATETIME
				,Amount MONEY
				,Units DECIMAL
				,InsuranceFeeSchedule MONEY
				)

		UPDATE #temp
		SET Specialty = 'Toxicology'
		WHERE Specialty = 'Toxicology-'

		UPDATE #temp
		SET Specialty = 'AC'
		WHERE Specialty = 'ACUPUNCTURE'

		UPDATE #temp
		SET Specialty = 'FCT'
		WHERE Specialty = 'FUNCTIONAL CAPACITY TEST'

		UPDATE #temp
		SET Specialty = 'MMT'
		WHERE Specialty = 'MANUAL MUSCLE TESTING'

		UPDATE #temp
		SET Specialty = 'MMT'
		WHERE Specialty = 'MUSCLE TESTING'

		UPDATE #temp
		SET Specialty = 'Outcome Test'
		WHERE Specialty = 'OutcomeTest'

		UPDATE #temp
		SET Specialty = 'Pain Management'
		WHERE Specialty = 'Pain-Management'

		UPDATE #temp
		SET Specialty = 'PT'
		WHERE Specialty = 'PHYSICAL THERAPY'

		DECLARE @Specialty VARCHAR(255)
		DECLARE @ServiceType_ID INT

		SET @Specialty = (
				SELECT TOP 1 Specialty
				FROM #temp
				)

		IF NOT EXISTS (
				SELECT ServiceType_ID
				FROM tblserviceType
				WHERE ServiceType = @Specialty
					AND DomainId = @DomainID
				)
		BEGIN
			INSERT INTO tblserviceType (
				ServiceType
				,ServiceDesc
				,DomainId
				,created_by_user
				,created_date
				)
			VALUES (
				@Specialty
				,@Specialty
				,'@DomainID'
				,'System'
				,getdate()
				)
		END

		SET @ServiceType_ID = (
				SELECT ServiceType_ID
				FROM tblserviceType
				WHERE ServiceType = @Specialty
					AND DomainId = @DomainID
				)

		SELECT #temp.TreatmentCode
			,#temp.TreatmentDescription
			,#temp.Amount
			,#temp.Specialty
			,#temp.InsuranceFeeSchedule
			,t2.Auto_Proc_id
		INTO #temp2
		FROM #temp
		LEFT JOIN MST_PROCEDURE_CODES t2 ON #temp.TreatmentCode = t2.Code
			AND #temp.TreatmentDescription = t2.Description
			AND #temp.Amount = t2.Amount
			AND #temp.Specialty = t2.Specialty
			AND t2.DomainId = @DomainID
		WHERE t2.Auto_Proc_id IS NULL

		INSERT INTO MST_PROCEDURE_CODES (
			Code
			,Description
			,Amount
			,Specialty
			,ins_fee_schedule
			,ServiceTypeID
			,DomainId
			,CreatedBY
			,CreatedDate
			)
		SELECT #temp2.TreatmentCode
			,#temp2.TreatmentDescription
			,#temp2.Amount
			,#temp2.Specialty
			,#temp2.InsuranceFeeSchedule
			,@ServiceType_ID
			,@DomainID
			,'system'
			,getdate()
		FROM #temp2

		SELECT #temp.*
			,t2.Auto_Proc_id
		INTO #temp3
		FROM #temp
		LEFT JOIN MST_PROCEDURE_CODES t2 ON #temp.TreatmentCode = t2.Code
			AND #temp.TreatmentDescription = t2.Description
			AND #temp.Amount = t2.Amount
			AND #temp.Specialty = t2.Specialty
			AND t2.DomainId = @DomainID

		INSERT INTO BILLS_WITH_PROCEDURE_CODES (
			BillNumber
			,Code
			,Description
			,Amount
			,DOS
			,Specialty
			,ins_fee_schedule
			,Case_ID
			,fk_Treatment_Id
			,UNITS
			,DomainID
			,created_by_user
			,created_date
			,GBBCodeID
			,Auto_Proc_id
			)
		SELECT @Bill_Number
			,t.TreatmentCode
			,t.TreatmentDescription
			,t.Amount
			,t.DOS
			,t.Specialty
			,t.InsuranceFeeSchedule
			,@Case_Id
			,@Treatment_Id
			,t.Units
			,@DomainID
			,'System'
			,getdate()
			,t.TreatmentCodeID
			,t.Auto_Proc_id
		FROM #temp3 t

		IF (@DomainID = 'AF')
		BEGIN
			DECLARE @RegionIvAmount MONEY

			SELECT @RegionIvAmount = sum(isnull(t2.RegionIVfeeScheduleAmount, 0))
			FROM BILLS_WITH_PROCEDURE_CODES t1
			JOIN MST_PROCEDURE_CODES t2 ON t1.Auto_Proc_id = t2.Auto_Proc_id
			WHERE t1.fk_Treatment_Id = @Treatment_Id
				AND t1.DomainID = @DomainID

			UPDATE tblTreatment
			SET Fee_Schedule = @RegionIvAmount
			WHERE tblTreatment.Treatment_Id = @Treatment_Id
		END

		COMMIT TRAN
	END TRY

	BEGIN CATCH
		PRINT 'Error'

		ROLLBACK TRAN --R
	END CATCH
END
