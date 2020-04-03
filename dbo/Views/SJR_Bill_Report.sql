
CREATE VIEW [dbo].[SJR_Bill_Report]
AS
SELECT     dbo.tblcase.Case_AutoId, dbo.tblcase.Case_Id, dbo.tblcase.Case_Code, 
                      dbo.tblcase.InjuredParty_LastName + ',' + dbo.tblcase.InjuredParty_FirstName AS patient, dbo.tblProvider.Provider_Name, 
                      dbo.tblProvider.Provider_GroupName, dbo.tblInsuranceCompany.InsuranceCompany_Name, 
                      dbo.tblTreatment.Claim_Amount - dbo.tblTreatment.Paid_Amount AS balance, dbo.tblcase.IndexOrAAA_Number AS [index], dbo.tblcase.Status, 
                      dbo.tblcase.Initial_Status, NULL AS Global_Status, CONVERT(varchar(20), dbo.tblTreatment.DateOfService_Start, 101) + ' - ' + CONVERT(varchar(20), 
                      dbo.tblTreatment.DateOfService_End, 101) AS DOS, dbo.tblcase.Ins_Claim_Number AS claim_number, dbo.tblTreatment.SERVICE_TYPE, 
                      --dbo.tblTreatment.DENIALREASONS_TYPE,
                       dbo.tblcase.Provider_Id, dbo.tblcase.InsuranceCompany_Id, dbo.tblcase.Accident_Date, 
                      dbo.tblcase.Date_Opened, dbo.tblTreatment.Treatment_Id, dbo.tblTreatment.CPT_Id, dbo.tblTreatment.BX_BILL_ID, dbo.tblTreatment.Date_Created, 
                     -- dbo.tblTreatment.Doctor_Id, 
                     dbo.tblTreatment.Litigation_Status, dbo.tblTreatment.account_number, dbo.tblTreatment.BILL_NUMBER, 
                      dbo.tblTreatment.Action_Type,
                      -- dbo.tblTreatment.Operating_Doctor, 
                      dbo.tblTreatment.Claim_Amount, dbo.tblTreatment.Paid_Amount, 
                      dbo.tblTreatment.DateOfService_Start AS DOS_START, tblcase.DomainId
FROM         dbo.tblcase INNER JOIN
                      dbo.tblProvider ON dbo.tblcase.Provider_Id = dbo.tblProvider.Provider_Id INNER JOIN
                      dbo.tblInsuranceCompany ON dbo.tblcase.InsuranceCompany_Id = dbo.tblInsuranceCompany.InsuranceCompany_Id LEFT OUTER JOIN
                      dbo.tblTreatment ON dbo.tblcase.Case_Id = dbo.tblTreatment.Case_Id

GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane1', @value = N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[41] 4[28] 2[13] 3) )"
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
         Left = 0
      End
      Begin Tables = 
         Begin Table = "tblcase"
            Begin Extent = 
               Top = 28
               Left = 17
               Bottom = 145
               Right = 299
            End
            DisplayFlags = 280
            TopColumn = 113
         End
         Begin Table = "tblProvider"
            Begin Extent = 
               Top = 246
               Left = 38
               Bottom = 363
               Right = 254
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "tblInsuranceCompany"
            Begin Extent = 
               Top = 366
               Left = 38
               Bottom = 483
               Right = 295
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "tblTreatment"
            Begin Extent = 
               Top = 9
               Left = 431
               Bottom = 224
               Right = 633
            End
            DisplayFlags = 280
            TopColumn = 13
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 5910
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
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'SJR_Bill_Report';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'SJR_Bill_Report';

