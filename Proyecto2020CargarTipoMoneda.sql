USE [Proyecto];
GO
DROP PROCEDURE  IF EXISTS dbo.CargarTipoMoneda;
GO
CREATE PROCEDURE dbo.CargarTipoMoneda
AS
BEGIN
SET NOCOUNT ON
	BEGIN TRY
		DECLARE
			@tipo_Documento XML = NULL,
			@doc INT =0
		SELECT @tipo_Documento = od	FROM OPENROWSET (BULK 'D:\S3\Proyecto2020\Datos_Tarea1 v2.xml', SINGLE_BLOB) AS TiposDoc(od) --pone la direccion donde se encuentra
		EXEC sp_xml_preparedocument @doc OUTPUT, @tipo_Documento
		INSERT INTO [dbo].[TipoMoneda](Id, Nombre, Simbolo)														--selecciona la tabla a llenar y las columnas
		SELECT * FROM OPENXML (@doc, 'Datos/Tipo_Moneda/TipoMoneda')									--encabezado a buscar
		WITH(Id [INT]'@Id',Nombre [VARCHAR](100)'@Nombre',Simbolo [VARCHAR](10)'@Simbolo');				--nombre de los datos de la tabla
	END TRY

	BEGIN CATCH

	END CATCH
SET NOCOUNT OFF
END
GO
EXEC dbo.CargarTipoMoneda
SELECT * FROM [dbo].[TipoMoneda]