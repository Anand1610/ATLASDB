CREATE VIEW [dbo].[SJR-PAYMENT_COMPLETED]
AS
SELECT dbo.tblcase.Case_Id, dbo.tblProvider.Provider_Name, 
    dbo.tblInsuranceCompany.InsuranceCompany_Name, 
    ISNULL(SUM(dbo.tblTransactions.Transactions_Amount), 0) 
    AS PAYMT_TOTAL, dbo.tblSettlements.Settlement_Total, 
    dbo.tblSettlements.Settlement_Total - ISNULL(SUM(dbo.tblTransactions.Transactions_Amount),
     0) AS BALANCE
FROM dbo.tblTransactions INNER JOIN
    dbo.tblcase ON 
    dbo.tblTransactions.Case_Id = dbo.tblcase.Case_Id INNER JOIN
    dbo.tblInsuranceCompany ON 
    dbo.tblcase.InsuranceCompany_Id = dbo.tblInsuranceCompany.InsuranceCompany_Id
     INNER JOIN
    dbo.tblProvider ON 
    dbo.tblcase.Provider_Id = dbo.tblProvider.Provider_Id INNER JOIN
    dbo.tblSettlements ON 
    dbo.tblcase.Case_Id = dbo.tblSettlements.Case_Id
GROUP BY dbo.tblcase.Case_Id, dbo.tblProvider.Provider_Name, 
    dbo.tblInsuranceCompany.InsuranceCompany_Name, 
    dbo.tblSettlements.Settlement_Total
HAVING (SUM(dbo.tblTransactions.Transactions_Amount) 
    >= dbo.tblSettlements.Settlement_Total - 1)

GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane1', @value = N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
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
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
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
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = -96
      End
      Begin Tables = 
         Begin Table = "tblTransactions"
            Begin Extent = 
               Top = 22
               Left = 61
               Bottom = 196
               Right = 261
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "tblcase"
            Begin Extent = 
               Top = 7
               Left = 293
               Bottom = 167
               Right = 566
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "tblInsuranceCompany"
            Begin Extent = 
               Top = 185
               Left = 487
               Bottom = 293
               Right = 735
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "tblProvider"
            Begin Extent = 
               Top = 198
               Left = 38
               Bottom = 306
               Right = 233
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "tblSettlements"
            Begin Extent = 
               Top = 35
               Left = 659
               Bottom = 143
               Right = 864
            End
            DisplayFlags = 280
            TopColumn = 5
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 2400
         Width = 2235
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 12
         Column = 144', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'SJR-PAYMENT_COMPLETED';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane2', @value = N'0
         Alias = 900
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
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'SJR-PAYMENT_COMPLETED';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 2, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'SJR-PAYMENT_COMPLETED';

