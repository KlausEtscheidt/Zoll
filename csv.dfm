�
 TFORM1 09
  TPF0TForm1Form1Left Top CaptionForm1ClientHeight7ClientWidth�Color	clBtnFaceFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameTahoma
Font.Style OldCreateOrderPixelsPerInch`
TextHeight TDBGridDBGrid1Left(TopWidth@Heightx
DataSourceDataSource1TabOrder TitleFont.CharsetDEFAULT_CHARSETTitleFont.ColorclWindowTextTitleFont.Height�TitleFont.NameTahomaTitleFont.Style   TFDBatchMove	BatchMoveReader
TextReaderWriterFDBatchMoveSQLWriter1MappingsSourceFieldName	kunden_idDestinationFieldName	kunden_id  LogFileNamePC:\Users\Klaus Etscheidt\Documents\Embarcadero\Studio\Projekte\zoll\csv\Data.logLeft8Topx  TFDBatchMoveTextReader
TextReaderFileNameRC:\Users\Klaus Etscheidt\Documents\Embarcadero\Studio\Projekte\zoll\csv\Rabatt.csvDataDef.Fields	FieldName	kunden_idDataType	atLongInt	FieldSize 	FieldName
zu_ab_prozDataTypeatFloat	FieldSize 	FieldName	datum_vonDataTypeatFloat	FieldSize
 	FieldName	datum_bisDataTypeatFloat	FieldSize
  DataDef.Delimiter"DataDef.Separator;DataDef.RecordFormatrfCustomDataDef.WithFieldNames	EncodingecUTF8Left@Top(  TFDBatchMoveDataSetWriterDataSetWriterDirect	DataSetFDMemTable1Left�Top�   TDataSourceDataSource1DataSetFDMemTable1LeftTop�   TFDMemTableFDMemTable1Active		FieldDefsNameFDMemTable1Field9
Attributes	faUnNamed DataType
ftLargeint NameFDMemTable1Field10
Attributes	faUnNamed DataType
ftLargeint NameFDMemTable1Field11
Attributes	faUnNamed DataType
ftLargeint NameFDMemTable1Field12
Attributes	faUnNamed DataType
ftLargeint NameFDMemTable1Field13
Attributes	faUnNamed DataTypeftStringSize NameFDMemTable1Field14
Attributes	faUnNamed DataType
ftLargeint NameFDMemTable1Field15
Attributes	faUnNamed DataTypeftStringSize NameFDMemTable1Field16
Attributes	faUnNamed DataType
ftLargeint  	IndexDefs FetchOptions.AssignedValuesevMode FetchOptions.ModefmAllResourceOptions.AssignedValuesrvSilentMode ResourceOptions.SilentMode	UpdateOptions.AssignedValuesuvCheckRequireduvAutoCommitUpdates UpdateOptions.CheckRequiredUpdateOptions.AutoCommitUpdates		StoreDefs	Left� Top�   TFDBatchMoveSQLWriterFDBatchMoveSQLWriter1
ConnectionFDConnection1	TableName
kunde_zuabWriteSQL9insert into kunde_zuab(kunden_id,zu_ab_proz) values(?,?);Left8Top�   TFDPhysSQLiteDriverLinkFDPhysSQLiteDriverLink1Left� Top(  TFDConnectionFDConnection1Params.StringsConnectionDef=SQLite Zoll 	Connected	LoginPromptLeft� Topx   