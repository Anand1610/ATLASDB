﻿CREATE VIEW [dbo].[SJR-PENDINGS]
AS
SELECT     dbo.tblcase.Case_Id, dbo.tblNotes.User_Id, dbo.tblcase.Status, dbo.tblProvider.Provider_Name, dbo.tblNotes.Notes_Desc, dbo.tblNotes.Notes_Date, 
                      CONVERT(numeric, dbo.tblcase.Claim_Amount) AS Claim_Amount, CONVERT(int, GETDATE() - dbo.tblNotes.Notes_Date) AS Latency, 
                      dbo.tblcase.DateOfService_Start + ' - ' + dbo.tblcase.DateOfService_End AS DOS, dbo.tblcase.Accident_Date
FROM         dbo.tblNotes INNER JOIN
                      dbo.tblcase INNER JOIN
                      dbo.tblProvider ON dbo.tblcase.Provider_Id = dbo.tblProvider.Provider_Id ON dbo.tblNotes.Case_Id = dbo.tblcase.Case_Id
GROUP BY dbo.tblcase.Case_Id, dbo.tblNotes.User_Id, dbo.tblcase.Status, dbo.tblProvider.Provider_Name, dbo.tblNotes.Notes_Desc, dbo.tblNotes.Notes_Date, 
                      CONVERT(numeric, dbo.tblcase.Claim_Amount), CONVERT(int, GETDATE() - dbo.tblNotes.Notes_Date), 
                      dbo.tblcase.DateOfService_Start + ' - ' + dbo.tblcase.DateOfService_End, dbo.tblcase.Accident_Date
HAVING      (dbo.tblcase.Status = N'PENDING') AND (dbo.tblNotes.Notes_Desc = N'Case Opened')

GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane1', @value = N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[26] 4[23] 2[23] 3) )"
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
         Left = -80
      End
      Begin Tables = 
         Begin Table = "tblNotes"
            Begin Extent = 
               Top = 0
               Left = 620
               Bottom = 195
               Right = 771
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "tblcase"
            Begin Extent = 
               Top = 0
               Left = 242
               Bottom = 273
               Right = 515
            End
            DisplayFlags = 280
            TopColumn = 50
         End
         Begin Table = "tblProvider"
            Begin Extent = 
               Top = 27
               Left = 0
               Bottom = 135
               Right = 195
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
      Begin ColumnWidths = 11
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 3885
         Width = 2430
         Width = 1650
         Width = 1500
         Width = 1185
         Width = 1470
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 12
         Column = 3105
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
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'SJR-PENDINGS';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'SJR-PENDINGS';

