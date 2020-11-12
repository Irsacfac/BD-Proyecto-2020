USE [Proyecto];
GO
DROP PROCEDURE  IF EXISTS dbo.CargarParentezcos;
GO
CREATE PROCEDURE dbo.CargarParentezcos
AS
BEGIN
SET NOCOUNT ON
	BEGIN TRY
		DECLARE
			@tipo_Documento XML = NULL,
			@doc INT =0
		SELECT @tipo_Documento = od	FROM OPENROWSET (BULK 'D:\S3\Proyecto2020\Datos_Tarea1 v2.xml', SINGLE_BLOB) AS TiposDoc(od) --pone la direccion donde se encuentra
		EXEC sp_xml_preparedocument @doc OUTPUT, @tipo_Documento
		INSERT INTO [dbo].[Parentesco](Id, Nombre)														--selecciona la tabla a llenar y las columnas
		SELECT * FROM OPENXML (@doc, 'Datos/Parentezcos/Parentezco')									--encabezado a buscar
		WITH(Id [INT]'@Id',Nombre [VARCHAR](100)'@Nombre');												--nombre de los datos de la tabla
	END TRY

	BEGIN CATCH

	END CATCH
SET NOCOUNT OFF
END
GO
EXEC dbo.CargarParentezcos
SELECT * FROM [dbo].[Parentesco]