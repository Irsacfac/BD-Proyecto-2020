USE [Proyecto]
GO
DROP Procedure  IF EXISTS dbo.CargarXML;
GO
CREATE PROCEDURE dbo.CargarXML													--startprocedure para descargar el xml
AS
BEGIN
SET NOCOUNT ON
	EXEC msdb.dbo.rds_download_from_s3											--Para descargr el documento del S#
			@s3_arn_of_file='arn:aws:s3:::proyecto2020/Datos_Tarea1 v2.xml',	--Documento a descargar
			@rds_file_path='D:\S3\Proyecto2020\Datos_Tarea1 v2.xml',			--Donde almacenar el documento
			@overwrite_file=1;													--Sobreescribir el archivo
SET NOCOUNT OFF
END
GO