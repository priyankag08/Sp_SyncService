/*Name:
	[UI].[SpDMLFormDesignVersion]

Purpose:
	To maintain records for DML operation performed on table UI.FormDesignVersion using CDC

Assumption:
	There must be single DML operation on table at a time

History:
	Created on  22/09/2022 by priyanka gaikwad
	Modified on ---------
*/

CREATE OR ALTER PROCEDURE [UI].[SpDMLFormDesignVersion]
AS

BEGIN
 SET NOCOUNT ON;
    --Local variables declaration
	DECLARE @Operation	int,@dFormName varchar(100),@dDisplayText varchar(100),@iFormName varchar(100),@iDisplayText varchar(100),
	@dformDesignId int, @iformDesignId int,@dStatusID int,@iStatusID int

	SET @dformDesignId = (SELECT Distinct FormDesignId from [cdc].[UI_FormDesignVersion_CT])
	SET @iformDesignId = (SELECT Distinct  FormDesignId from [cdc].[UI_FormDesignVersion_CT])

	SET @dFormName=(SELECT FormName FROM UI.FormDesign WHERE FormID=@dformDesignId);
	SET @iFormName=(SELECT FormName FROM UI.FormDesign WHERE FormID=@iformDesignId);

	SET @dDisplayText=(SELECT DisplayText FROM UI.FormDesign WHERE FormID=@dformDesignId);
	SET @iDisplayText=(SELECT DisplayText FROM UI.FormDesign WHERE FormID=@iformDesignId);

	--Check if records inserted, updated or deleted
	Set @Operation = (Select Top 1  __$operation From [cdc].[UI_FormDesignVersion_CT])

	IF @Operation = 1 -- Deletion Of Record
	BEGIN
			Insert Into [Trgr].[FormDesignVersion]
				(			FormDesignVersionID,			FormDesignID,			TenantID,			VersionNumber,			EffectiveDate,			FormDesignVersionData,			StatusID,			AddedBy,			AddedDate,			UpdatedBy,			UpdatedDate,			Comments,			FormDesignTypeID,			LastUpdatedDate,			RuleExecutionTreeJSON,			RuleEventMapJSON,			PBPViewImpacts,			MigrationID,			IsMigrated,				IsMigrationOverriden,			MigrationDate,					DMLOperation,				OperationDate	)
			Select	[cdc].[UI_FormDesignVersion_CT].FormDesignVersionID, [cdc].[UI_FormDesignVersion_CT].FormDesignID,
			[cdc].[UI_FormDesignVersion_CT].TenantID, 
			[cdc].[UI_FormDesignVersion_CT].VersionNumber, [cdc].[UI_FormDesignVersion_CT].	EffectiveDate,
			[cdc].[UI_FormDesignVersion_CT].FormDesignVersionData, [cdc].[UI_FormDesignVersion_CT].	StatusID, 
			[cdc].[UI_FormDesignVersion_CT].AddedBy, [cdc].[UI_FormDesignVersion_CT].	AddedDate, 
			[cdc].[UI_FormDesignVersion_CT].UpdatedBy, [cdc].[UI_FormDesignVersion_CT].	UpdatedDate, 
			[cdc].[UI_FormDesignVersion_CT].Comments, [cdc].[UI_FormDesignVersion_CT].	FormDesignTypeID, 
			[cdc].[UI_FormDesignVersion_CT].LastUpdatedDate, [cdc].[UI_FormDesignVersion_CT].	RuleExecutionTreeJSON,
			[cdc].[UI_FormDesignVersion_CT].RuleEventMapJSON, [cdc].[UI_FormDesignVersion_CT].	PBPViewImpacts,
			[cdc].[UI_FormDesignVersion_CT].MigrationID, [cdc].[UI_FormDesignVersion_CT].	IsMigrated,
			[cdc].[UI_FormDesignVersion_CT].IsMigrationOverriden, [cdc].[UI_FormDesignVersion_CT].	MigrationDate,
			4 as	DMLOperation, getdate() as	OperationDate
			From [cdc].[UI_FormDesignVersion_CT] Where __$operation = @Operation
			
			Insert Into [UI].[FormDesignVersionActivityLog] ([FormDesignID], [UIElementID], [Description], 
			[AddedBy],[AddedDate],[UpdatedBy],[UpdatedLast], [UIElementName], [Label], [FormDesignVersionId])
			Select ISNULL([cdc].[UI_FormDesignVersion_CT].FormDesignID,0),ISNULL([cdc].[UI_FormDesignVersion_CT].FormDesignID,0), ' Design version '+ [cdc].[UI_FormDesignVersion_CT].VersionNumber +' for design ' + @dDisplayText + ' is deleted ',
			 [cdc].[UI_FormDesignVersion_CT].AddedBy , [cdc].[UI_FormDesignVersion_CT].AddedDate , ISNULL([cdc].[UI_FormDesignVersion_CT].UpdatedBy, [cdc].[UI_FormDesignVersion_CT].AddedBy) , GETDATE(), @dDisplayText, @dFormName, [cdc].[UI_FormDesignVersion_CT].FormDesignVersionID 
			From [cdc].[UI_FormDesignVersion_CT] Where __$operation = @Operation	
END
else
BEGIN

    If @operation = 2 -- Insert Record
	BEGIN   
			Insert Into [Trgr].[FormDesignVersion]
				(			FormDesignVersionID,			FormDesignID,			TenantID,			VersionNumber,			EffectiveDate,			FormDesignVersionData,			StatusID,			AddedBy,			AddedDate,			UpdatedBy,			UpdatedDate,			Comments,			FormDesignTypeID,			LastUpdatedDate,			RuleExecutionTreeJSON,			RuleEventMapJSON,			PBPViewImpacts,			MigrationID,			IsMigrated,				IsMigrationOverriden,			MigrationDate,					DMLOperation,				OperationDate	)
			Select	[cdc].[UI_FormDesignVersion_CT].FormDesignVersionID, [cdc].[UI_FormDesignVersion_CT].FormDesignID,
			[cdc].[UI_FormDesignVersion_CT].TenantID, 
			[cdc].[UI_FormDesignVersion_CT].VersionNumber, [cdc].[UI_FormDesignVersion_CT].	EffectiveDate,
			[cdc].[UI_FormDesignVersion_CT].FormDesignVersionData, [cdc].[UI_FormDesignVersion_CT].	StatusID, 
			[cdc].[UI_FormDesignVersion_CT].AddedBy, [cdc].[UI_FormDesignVersion_CT].	AddedDate, 
			[cdc].[UI_FormDesignVersion_CT].UpdatedBy, [cdc].[UI_FormDesignVersion_CT].	UpdatedDate, 
			[cdc].[UI_FormDesignVersion_CT].Comments, [cdc].[UI_FormDesignVersion_CT].	FormDesignTypeID, 
			[cdc].[UI_FormDesignVersion_CT].LastUpdatedDate, [cdc].[UI_FormDesignVersion_CT].	RuleExecutionTreeJSON,
			[cdc].[UI_FormDesignVersion_CT].RuleEventMapJSON, [cdc].[UI_FormDesignVersion_CT].	PBPViewImpacts,
			[cdc].[UI_FormDesignVersion_CT].MigrationID, [cdc].[UI_FormDesignVersion_CT].	IsMigrated,
			[cdc].[UI_FormDesignVersion_CT].IsMigrationOverriden, [cdc].[UI_FormDesignVersion_CT].	MigrationDate,
			1 as	DMLOperation, getdate() as	OperationDate
			From [cdc].[UI_FormDesignVersion_CT] Where __$operation = @Operation

			Insert Into [UI].[FormDesignVersionActivityLog] ([FormDesignID], [UIElementID], [Description], 
			[AddedBy],[AddedDate],[UpdatedBy],[UpdatedLast], [UIElementName], [Label], [FormDesignVersionId])
			Select ISNULL([cdc].[UI_FormDesignVersion_CT].FormDesignID,0),ISNULL([cdc].[UI_FormDesignVersion_CT].FormDesignID,0),'Design version '+ [cdc].[UI_FormDesignVersion_CT].VersionNumber +' for design ' + @iDisplayText + ' is added ',
			[cdc].[UI_FormDesignVersion_CT].AddedBy , [cdc].[UI_FormDesignVersion_CT].AddedDate , ISNULL([cdc].[UI_FormDesignVersion_CT].UpdatedBy, [cdc].[UI_FormDesignVersion_CT].AddedBy) , GETDATE(), @iDisplayText, @iFormName, [cdc].[UI_FormDesignVersion_CT].FormDesignVersionID 
			From [cdc].[UI_FormDesignVersion_CT]
	   END;

		 IF @operation = 3 -- Update Record(Need before update and after update details)
			BEGIN
					Insert Into [Trgr].[FormDesignVersion]
				(			FormDesignVersionID,			FormDesignID,			TenantID,			VersionNumber,			EffectiveDate,			FormDesignVersionData,			StatusID,			AddedBy,			AddedDate,			UpdatedBy,			UpdatedDate,			Comments,			FormDesignTypeID,			LastUpdatedDate,			RuleExecutionTreeJSON,			RuleEventMapJSON,			PBPViewImpacts,			MigrationID,			IsMigrated,				IsMigrationOverriden,			MigrationDate,					DMLOperation,				OperationDate	)
			Select	[cdc].[UI_FormDesignVersion_CT].FormDesignVersionID, [cdc].[UI_FormDesignVersion_CT].FormDesignID,
			[cdc].[UI_FormDesignVersion_CT].TenantID, 
			[cdc].[UI_FormDesignVersion_CT].VersionNumber, [cdc].[UI_FormDesignVersion_CT].	EffectiveDate,
			[cdc].[UI_FormDesignVersion_CT].FormDesignVersionData, [cdc].[UI_FormDesignVersion_CT].	StatusID, 
			[cdc].[UI_FormDesignVersion_CT].AddedBy, [cdc].[UI_FormDesignVersion_CT].	AddedDate, 
			[cdc].[UI_FormDesignVersion_CT].UpdatedBy, [cdc].[UI_FormDesignVersion_CT].	UpdatedDate, 
			[cdc].[UI_FormDesignVersion_CT].Comments, [cdc].[UI_FormDesignVersion_CT].	FormDesignTypeID, 
			[cdc].[UI_FormDesignVersion_CT].LastUpdatedDate, [cdc].[UI_FormDesignVersion_CT].	RuleExecutionTreeJSON,
			[cdc].[UI_FormDesignVersion_CT].RuleEventMapJSON, [cdc].[UI_FormDesignVersion_CT].	PBPViewImpacts,
			[cdc].[UI_FormDesignVersion_CT].MigrationID, [cdc].[UI_FormDesignVersion_CT].	IsMigrated,
			[cdc].[UI_FormDesignVersion_CT].IsMigrationOverriden, [cdc].[UI_FormDesignVersion_CT].	MigrationDate,
			2 as	DMLOperation, getdate() as	OperationDate
			From [cdc].[UI_FormDesignVersion_CT] Where __$operation = @Operation

			Insert Into [Trgr].[FormDesignVersion]
				(			FormDesignVersionID,			FormDesignID,			TenantID,			VersionNumber,			EffectiveDate,			FormDesignVersionData,			StatusID,			AddedBy,			AddedDate,			UpdatedBy,			UpdatedDate,			Comments,			FormDesignTypeID,			LastUpdatedDate,			RuleExecutionTreeJSON,			RuleEventMapJSON,			PBPViewImpacts,			MigrationID,			IsMigrated,				IsMigrationOverriden,			MigrationDate,					DMLOperation,				OperationDate	)
			Select	[cdc].[UI_FormDesignVersion_CT].FormDesignVersionID, [cdc].[UI_FormDesignVersion_CT].FormDesignID,
			[cdc].[UI_FormDesignVersion_CT].TenantID, 
			[cdc].[UI_FormDesignVersion_CT].VersionNumber, [cdc].[UI_FormDesignVersion_CT].	EffectiveDate,
			[cdc].[UI_FormDesignVersion_CT].FormDesignVersionData, [cdc].[UI_FormDesignVersion_CT].	StatusID, 
			[cdc].[UI_FormDesignVersion_CT].AddedBy, [cdc].[UI_FormDesignVersion_CT].	AddedDate, 
			[cdc].[UI_FormDesignVersion_CT].UpdatedBy, [cdc].[UI_FormDesignVersion_CT].	UpdatedDate, 
			[cdc].[UI_FormDesignVersion_CT].Comments, [cdc].[UI_FormDesignVersion_CT].	FormDesignTypeID, 
			[cdc].[UI_FormDesignVersion_CT].LastUpdatedDate, [cdc].[UI_FormDesignVersion_CT].	RuleExecutionTreeJSON,
			[cdc].[UI_FormDesignVersion_CT].RuleEventMapJSON, [cdc].[UI_FormDesignVersion_CT].	PBPViewImpacts,
			[cdc].[UI_FormDesignVersion_CT].MigrationID, [cdc].[UI_FormDesignVersion_CT].	IsMigrated,
			[cdc].[UI_FormDesignVersion_CT].IsMigrationOverriden, [cdc].[UI_FormDesignVersion_CT].	MigrationDate,
			3 as	DMLOperation, getdate() as	OperationDate
			From [cdc].[UI_FormDesignVersion_CT] Where __$operation = (@Operation+1)

			Select @dStatusID =ISNULL([cdc].[UI_FormDesignVersion_CT].StatusID,0) from [cdc].[UI_FormDesignVersion_CT]
		    Select @iStatusID =ISNULL([cdc].[UI_FormDesignVersion_CT].StatusID,0) from [cdc].[UI_FormDesignVersion_CT]

			If (@dStatusID<>@iStatusID)
			BEGIN
					Insert Into [UI].[FormDesignVersionActivityLog] ([FormDesignID], [UIElementID], [Description] , 
					[AddedBy],[AddedDate],[UpdatedBy],[UpdatedLast], [UIElementName], [Label],[FormDesignVersionId])
					Select ISNULL([cdc].[UI_FormDesignVersion_CT].FormDesignID,0),ISNULL([cdc].[UI_FormDesignVersion_CT].FormDesignID,0),			
					CASE ISNULL(@iStatusID,0) WHEN 3 THEN 'Design version '+ [cdc].[UI_FormDesignVersion_CT].VersionNumber +' for design ' + @iDisplayText + ' is finalized' END ,			
					[cdc].[UI_FormDesignVersion_CT].AddedBy , [cdc].[UI_FormDesignVersion_CT].AddedDate , ISNULL([cdc].[UI_FormDesignVersion_CT].UpdatedBy, [cdc].[UI_FormDesignVersion_CT].AddedBy) , GETDATE(), @iDisplayText, @iFormName		, [cdc].[UI_FormDesignVersion_CT].FormDesignVersionID 	 
					From [cdc].[UI_FormDesignVersion_CT]  inner join [UI].[FormDesignVersion]  ON [UI].[FormDesignVersion].FormDesignVersionID=[cdc].[UI_FormDesignVersion_CT].FormDesignVersionID 		
				  END;

END;

END
END