USE [Proyecto]
GO
CREATE PROCEDURE dbo.CargarXML
AS
BEGIN
SET NOCOUNT ON
	EXEC msdb.dbo.rds_download_from_s3
			@s3_arn_of_file='arn:aws:s3:::proyecto2020/Datos_Tarea1 v2.xml',
			@rds_file_path='D:\S3\Proyecto2020\Datos_Tarea1 v2.xml',
			@overwrite_file=1;
SET NOCOUNT OFF
END
GO