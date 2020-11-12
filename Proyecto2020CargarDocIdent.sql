USE [Proyecto];
GO
DROP Procedure  IF EXISTS Cargar_Tipo_Doc;
GO
CREATE PROCEDURE Cargar_Tipo_Doc
AS
BEGIN
SET NOCOUNT ON
	BEGIN TRY
		DECLARE
			@tipo_Documento XML = NULL,
			@doc INT =0
		SELECT @tipo_Documento = od	FROM OPENROWSET (BULK 'D:\S3\Proyecto2020\Datos_Tarea1 v2.xml', SINGLE_BLOB) AS TiposDoc(od) --pone la direccion donde se encuentra
		EXEC sp_xml_preparedocument @doc OUTPUT, @tipo_Documento
		INSERT INTO [dbo].[TipoDocumentoIdentidad](Id, Nombre) --selecciona la tabla a llenar y las columnas
		SELECT * FROM OPENXML (@doc, 'Datos/Tipo_Doc/TipoDocuIdentidad' ,2)   --encabezado a buscar y cantidad de elementos a agregar 2
		WITH(Id [INT]'@Id',Nombre [VARCHAR](100)'@Nombre');
	END TRY

	BEGIN CATCH

	END CATCH
SET NOCOUNT OFF
END
GO
EXEC Cargar_Tipo_Doc
select * from [dbo].[TipoDocumentoIdentidad]