USE [Proyecto];
GO
DROP PROCEDURE  IF EXISTS dbo.CargarTipoCuentaAhorro;
GO
CREATE PROCEDURE dbo.CargarTipoCuentaAhorro
AS
BEGIN
SET NOCOUNT ON
	BEGIN TRY
		DECLARE
			@tipo_Documento XML = NULL,
			@doc INT =0
		SELECT @tipo_Documento = od	FROM OPENROWSET (BULK 'D:\S3\Proyecto2020\Datos_Tarea1 v2.xml', SINGLE_BLOB) AS TiposDoc(od) --pone la direccion donde se encuentra
		EXEC sp_xml_preparedocument @doc OUTPUT, @tipo_Documento
		INSERT INTO [dbo].[TipoCuentaAhorro](Id
											, TipoMonedaId
											, Nombre
											, SaldoMinimo
											, MultaIncumplirSaldoMinimo
											, CargosPorServicio
											, NumRetirosHumano
											, NumRetirosAutomatico
											, ComisionSuperarRetirosHumano
											, ComisionSuperarRetirosAutomatico
											, TasaInteresAnualisado)				--selecciona la tabla a llenar y las columnas
		SELECT * FROM OPENXML (@doc, 'Datos/Tipo_Cuenta_Ahorros/TipoCuentaAhorro')						--encabezado a buscar
		WITH(Id [INT]'@Id'																				--nombre de los datos de la tabla
			, TipoMonedaId [INT]'@IdTipoMoneda'
			, Nombre [VARCHAR](100)'@Nombre'
			, SaldoMinimo [FLOAT]'@SaldoMinimo'
			, MultaIncumplirSaldoMinimo [FLOAT]'@MultaSaldoMin'
			, CargosPorServicio [INT]'@CargoAnual'
			, NumRetirosHumano [INT]'@NumRetirosHumano'
			, NumRetirosAutomatico [INT]'@NumRetirosAutomatico'
			, ComisionSuperarRetirosHumano [INT]'@ComisionHumano'
			, ComisionSuperarRetirosAutomatico [INT]'@ComisionAutomatico'
			, TasaInteresAnualisado [INT]'@Interes');
	END TRY

	BEGIN CATCH

	END CATCH
SET NOCOUNT OFF
END
GO
EXEC dbo.CargarTipoCuentaAhorro
SELECT * FROM [dbo].[TipoCuentaAhorro]