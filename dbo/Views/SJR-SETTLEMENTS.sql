
CREATE VIEW [dbo].[SJR-SETTLEMENTS]
AS
	SELECT dbo.tblSettlements.Case_Id, SUM(dbo.tblSettlements.Settlement_Amount + dbo.tblSettlements.Settlement_Int) AS Sett_tot, 
		dbo.tblProvider.Provider_Name, dbo.tblInsuranceCompany.InsuranceCompany_Name, 
		dbo.tblcase.InjuredParty_LastName + N',' + dbo.tblcase.InjuredParty_FirstName AS InjuredParty_Name, CONVERT(money, Isnull(dbo.tblcase.Claim_Amount,0)) 
		AS Claim_Amount, CONVERT(money, isnull(dbo.tblcase.Fee_Schedule,0)) AS Fee_Schedule, dbo.tblSettlements.User_Id, SUM(dbo.tblSettlements.Settlement_Amount) AS Settlement_Amount, 
		SUM(dbo.tblSettlements.Settlement_Int) AS Settlement_Int, SUM(dbo.tblSettlements.Settlement_Af) AS Settlement_Af, 
		SUM(dbo.tblSettlements.Settlement_Ff) AS Settlement_Ff, dbo.tblSettlements.Settlement_Date, MAX(dbo.tblSettlements.Settlement_Notes) 
		AS Settlement_Notes, dbo.tblProvider.Provider_Id, SUM(dbo.tblSettlements.Settlement_Amount + dbo.tblSettlements.Settlement_Int) 
		AS Settlement_Total, CONVERT(money,isnull(dbo.tblcase.Paid_Amount,0)) AS Paid_amount, dbo.tblcase.Date_Opened, 
		dbo.tblInsuranceCompany.InsuranceCompany_Id, ISNULL(REPLACE(dbo.tblcase.DateOfService_Start, '12:00AM', '') 
		+ ' - ' + REPLACE(dbo.tblcase.DateOfService_End, '12:00AM', ''), N'N/A') AS DOS,dbo.tblcase.IndexOrAAA_Number,
		dbo.tblSettlement_Type.Settlement_Type,
		
		   CASE WHEN (isnull(sum(convert(money,Fee_Schedule)-convert(money,paid_amount)),0.00))=0.00 THEN 0
	     ELSE (( isnull(sum(settlement_amount),0.00)) + (isnull(sum(settlement_int),0.00)) ) * 100 / (isnull(sum(convert(money,Fee_Schedule)-convert(money,paid_amount)),1.00)) 
	     END
		 AS SET_FS_PER,
		 tblInsuranceCompany.DomainId
		 
	FROM    dbo.tblInsuranceCompany 
		INNER JOIN dbo.tblcase ON dbo.tblInsuranceCompany.InsuranceCompany_Id = dbo.tblcase.InsuranceCompany_Id 
		INNER JOIN dbo.tblProvider ON dbo.tblcase.Provider_Id = dbo.tblProvider.Provider_Id 
		INNER JOIN dbo.tblSettlements ON dbo.tblcase.Case_Id = dbo.tblSettlements.Case_Id
		LEFT OUTER JOIN	dbo.tblSettlement_Type on dbo.tblSettlement_Type.SettlementType_Id = dbo.tblSettlements.Settled_Type
	GROUP BY dbo.tblSettlements.Case_Id, dbo.tblProvider.Provider_Name, dbo.tblInsuranceCompany.InsuranceCompany_Name, tblcase.IndexOrAAA_Number,
		dbo.tblcase.InjuredParty_LastName + N',' + dbo.tblcase.InjuredParty_FirstName, CONVERT(money, isnull(dbo.tblcase.Claim_Amount,0)),CONVERT(money, isnull(dbo.tblcase.Fee_Schedule,0)), 
		dbo.tblSettlements.User_Id, dbo.tblSettlements.Settlement_Date, dbo.tblProvider.Provider_Id, CONVERT(money, isnull(dbo.tblcase.Paid_Amount,0)), 
		dbo.tblcase.Date_Opened, dbo.tblInsuranceCompany.InsuranceCompany_Id, ISNULL(REPLACE(dbo.tblcase.DateOfService_Start, '12:00AM', '') 
		+ ' - ' + REPLACE(dbo.tblcase.DateOfService_End, '12:00AM', ''), N'N/A'), dbo.tblSettlement_Type.Settlement_Type,Settled_Percent,Settlement_Amount,
		dbo.tblSettlements.Settled_by,dbo.tblcase.Claim_Amount,ISNULL(dbo.tblcase.Paid_Amount,'0.00'),ISNULL(dbo.tblcase.Fee_Schedule,'0.00'), dbo.tblInsuranceCompany.DomainId

GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane1', @value = N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[7] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1[54] 4[33] 3) )"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1[50] 2[25] 3) )"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1 [56] 4 [18] 2))"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1[75] 4) )"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 2
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "tblInsuranceCompany"
            Begin Extent = 
               Top = 250
               Left = 44
               Bottom = 490
               Right = 309
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "tblcase"
            Begin Extent = 
               Top = 11
               Left = 310
               Bottom = 201
               Right = 600
            End
            DisplayFlags = 280
            TopColumn = 57
         End
         Begin Table = "tblProvider"
            Begin Extent = 
               Top = 218
               Left = 460
               Bottom = 479
               Right = 672
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "tblSettlements"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 230
               Right = 260
            End
            DisplayFlags = 280
            TopColumn = 4
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 20
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 900
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      PaneHidden = 
      Begin ColumnWidths = 12
         Column = 39', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'SJR-SETTLEMENTS';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane2', @value = N'30
         Alias = 1770
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'SJR-SETTLEMENTS';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 2, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'SJR-SETTLEMENTS';

