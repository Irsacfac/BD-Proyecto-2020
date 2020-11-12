USE [Proyecto];
GO
DROP PROCEDURE  IF EXISTS dbo.CargarPersonas;
GO
CREATE PROCEDURE dbo.CargarPersonas
AS
BEGIN
SET NOCOUNT ON
	BEGIN TRY
		DECLARE
			@tipo_Documento XML = NULL
			, @doc INT = 0
		SELECT @tipo_Documento = od	FROM OPENROWSET (BULK 'D:\S3\Proyecto2020\Datos_Tarea1 v2.xml', SINGLE_BLOB) AS TiposDoc(od) --pone la direccion donde se encuentra
		EXEC sp_xml_preparedocument @doc OUTPUT, @tipo_Documento
		INSERT INTO [dbo].[Personas](TipoDocumentoIdentidadId
									, Nombre
									, ValDocIdentidad
									, FechaNacimiento
									, Email
									, Telefono1
									, Telefono2
									)				--selecciona la tabla a llenar y las columnas 
		SELECT * FROM OPENXML (@doc, 'Datos/Personas/Persona')						--encabezado a buscar
		WITH(TipoDocumentoIdentidadId [INT]'@TipoDocuIdentidad'
			, Nombre [VARCHAR](100)'@Nombre'
			, ValDocIdentidad [VARCHAR](100)'@ValorDocumentoIdentidad'
			, FechaNacimiento [DATE]'@FechaNacimiento'
			, Email [VARCHAR](50)'@Email'
			, Telefono1 [INT]'@Telefono1'
			, Telefono2 [INT]'@Telefono2'
			);
	END TRY

	BEGIN CATCH

	END CATCH
SET NOCOUNT OFF
END
GO
EXEC dbo.CargarPersonas
SELECT * FROM [dbo].[Personas]