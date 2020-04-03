CREATE VIEW [dbo].[SJR_COLLECTION_TRACKER_DETAILS]
AS
SELECT     TOP (100) PERCENT dbo.tblcase.Case_Id, dbo.tblTransactions.Transactions_Type, dbo.tblTransactions.Transactions_Amount, 
                      dbo.tblTransactions.Transactions_Date, dbo.tblNotes.User_Id, dbo.tblTransactions.Transactions_Id, DATEDIFF(d, 
                      dbo.[SJR-SETTLEMENTS_FULL].Settl_date, dbo.tblTransactions.Transactions_Date) AS AGE
FROM         dbo.tblInsuranceCompany INNER JOIN
                      dbo.tblcase ON dbo.tblInsuranceCompany.InsuranceCompany_Id = dbo.tblcase.InsuranceCompany_Id INNER JOIN
                      dbo.tblProvider ON dbo.tblcase.Provider_Id = dbo.tblProvider.Provider_Id INNER JOIN
                      dbo.tblTransactions ON dbo.tblcase.Case_Id = dbo.tblTransactions.Case_Id INNER JOIN
                      dbo.tblNotes ON dbo.tblcase.Case_Id = dbo.tblNotes.Case_Id AND dbo.tblTransactions.Transactions_Date > dbo.tblNotes.Notes_Date INNER JOIN
                      dbo.[SJR-SETTLEMENTS_FULL] ON dbo.tblcase.Case_Id = dbo.[SJR-SETTLEMENTS_FULL].Case_Id
WHERE     (dbo.tblNotes.Notes_Desc LIKE '%COLLECTION CALL%')
GROUP BY dbo.tblcase.Case_Id, dbo.tblTransactions.Transactions_Type, dbo.tblTransactions.Transactions_Amount, dbo.tblTransactions.Transactions_Date, 
                      dbo.tblNotes.User_Id, dbo.tblTransactions.Transactions_Id, DATEDIFF(d, dbo.[SJR-SETTLEMENTS_FULL].Settl_date, 
                      dbo.tblTransactions.Transactions_Date)
HAVING      (dbo.tblNotes.User_Id = N'evrosenthal') AND (DATEDIFF(d, dbo.[SJR-SETTLEMENTS_FULL].Settl_date, dbo.tblTransactions.Transactions_Date) > 37)
ORDER BY dbo.tblTransactions.Transactions_Id

GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane1', @value = N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[41] 4[28] 2[12] 3) )"
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
         Top = -27
         Left = 0
      End
      Begin Tables = 
         Begin Table = "tblInsuranceCompany"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 121
               Right = 303
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "tblcase"
            Begin Extent = 
               Top = 6
               Left = 341
               Bottom = 121
               Right = 631
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "tblProvider"
            Begin Extent = 
               Top = 6
               Left = 669
               Bottom = 121
               Right = 893
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "tblTransactions"
            Begin Extent = 
               Top = 126
               Left = 38
               Bottom = 241
               Right = 255
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "tblNotes"
            Begin Extent = 
               Top = 139
               Left = 371
               Bottom = 254
               Right = 539
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "SJR-SETTLEMENTS_FULL"
            Begin Extent = 
               Top = 243
               Left = 38
               Bottom = 358
               Right = 230
            End
            DisplayFlags = 280
            TopColumn = 0
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
         Width', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'SJR_COLLECTION_TRACKER_DETAILS';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane2', @value = N' = 1500
         Width = 1500
         Width = 1500
         Width = 2370
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 12
         Column = 2115
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
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'SJR_COLLECTION_TRACKER_DETAILS';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 2, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'SJR_COLLECTION_TRACKER_DETAILS';

