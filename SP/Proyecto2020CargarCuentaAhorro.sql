USE [Proyecto];
GO
DROP PROCEDURE  IF EXISTS dbo.CargarCuentaAahorro;
GO
CREATE PROCEDURE dbo.CargarCuentaAahorro
AS
BEGIN
SET NOCOUNT ON
	BEGIN TRY
		DECLARE
			@tipo_Documento XML = NULL
			, @doc INT = 0
			--Tabla variable
		DECLARE 
			@VariableTabla TABLE (Sec INT IDENTITY(1,1), Campo2 VARCHAR(100), campo3 INT, campo4 INT, campo5 DATE, campo6 FLOAT)
		--Cargar datos a la tabla variable
		SELECT @tipo_Documento = od	FROM OPENROWSET (BULK 'D:\S3\Proyecto2020\Datos_Tarea1 v2.1.xml', SINGLE_BLOB) AS TiposDoc(od) --pone la direccion donde se encuentra
		EXEC sp_xml_preparedocument @doc OUTPUT, @tipo_Documento
		INSERT INTO @VariableTabla(Campo2
								, Campo3
								, Campo4
								, Campo5
								, Campo6
								)				--selecciona la tabla a llenar y las columnas 
		SELECT * FROM OPENXML (@doc, 'Datos/Cuentas/Cuenta')						--encabezado a buscar
		WITH( Campo2 [VARCHAR](100)'@ValorDocumentoIdentidadDelCliente'
			, Campo3 [INT]'@TipoCuentaId'
			, Campo4 [INT]'@NumeroCuenta'
			, Campo5 [DATE]'@FechaCreacion'
			, Campo6 [FLOAT]'@Saldo'
			);						--Se ingresan los datos a la tabla variable
		
		--Pasar datos de la tabla variable a la tablaCuentaAhorro
		DECLARE 
			@lo1 INT
			, @hi1 INT
			, @ValDocIdent VARCHAR(100)
			, @TipoCuentaAhorro INT
			, @NumeroCuenta INT
			, @FechaCreacion DATE
			, @Saldo FLOAT
			, @PersonaId INT;
		SELECT @lo1=MIN(Sec), @hi1=MAX(Sec)
		FROM @VariableTabla
		WHILE @lo1<=@hi1
		BEGIN
			SELECT
				@ValDocIdent = VT.campo2
				, @TipoCuentaAhorro = VT.campo3
				, @NumeroCuenta = VT.campo4
				, @FechaCreacion = VT.campo5
				, @Saldo = VT.campo6
			FROM @VariableTabla VT
			WHERE Sec = @lo1
			SELECT @PersonaId = P.Id
			FROM [dbo].[Personas] P
			WHERE P.ValDocIdentidad = @ValDocIdent
			INSERT [dbo].[CuentaAhorro](PersonaId
										, TipoCuentaAhorroId
										, NumeroDeCuenta
										, FechaDeCreacion
										, Saldo
										)
			VALUES(@PersonaId
			, @TipoCuentaAhorro
			, @NumeroCuenta
			, @FechaCreacion
			, @Saldo
			)
			SET @lo1=@lo1+1
		END
		--SELECT * FROM @VariableTabla
	END TRY

	BEGIN CATCH

	END CATCH
SET NOCOUNT OFF
END
GO
--EXEC dbo.CargarCuentaAahorro
--SELECT * FROM [dbo].[CuentaAhorro]