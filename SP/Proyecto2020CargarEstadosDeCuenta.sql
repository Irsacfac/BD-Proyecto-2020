USE [Proyecto];
GO
DROP PROCEDURE  IF EXISTS dbo.CargarEstadosDeCuenta;
GO
CREATE PROCEDURE dbo.CargarEstadosDeCuenta
AS
BEGIN
SET NOCOUNT ON
	BEGIN TRY
		DECLARE
			@tipo_Documento XML = NULL
			, @doc INT = 0
			--Tabla variable
		DECLARE 
			@VariableTabla TABLE (Sec INT IDENTITY(1,1), NumeroCuenta INT, FechaInicio DATE, FechaFin DATE, SaldoInicial FLOAT, SaldoFinal FLOAT)
		--Cargar datos a la tabla variable
		SELECT @tipo_Documento = od	FROM OPENROWSET (BULK 'D:\S3\Proyecto2020\Datos_Tarea1 v2.1.xml', SINGLE_BLOB) AS TiposDoc(od) --pone la direccion donde se encuentra
		EXEC sp_xml_preparedocument @doc OUTPUT, @tipo_Documento
		INSERT INTO @VariableTabla(NumeroCuenta
								, FechaInicio
								, FechaFin
								, SaldoInicial
								, SaldoFinal
								)				--selecciona la tabla a llenar y las columnas 
		SELECT * FROM OPENXML (@doc, 'Datos/Estados_de_Cuenta/Estado_de_Cuenta')						--encabezado a buscar
		WITH( NumeroCuenta [INT]'@NumeroCuenta'
			, FechaInicio [DATE]'@fechaInicio'
			, FechaFin [DATE]'@fechaFin'
			, SaldoInicial [FLOAT]'@saldoInicial'
			, SaldoFinal [FLOAT]'@saldoFinal'
			);						--Se ingresan los datos a la tabla variable
		
		--Pasar datos de la tabla variable a la tabla EstadoDeCuenta
		DECLARE 
			@lo1 INT
			, @hi1 INT
			, @NumeroCuenta INT
			, @FechaInicio DATE
			, @FechaFin DATE
			, @SaldoInicial FLOAT
			, @SaldoFinal FLOAT
			, @CuentaAhorroId INT;
		SELECT @lo1=MIN(Sec), @hi1=MAX(Sec)
		FROM @VariableTabla
		WHILE @lo1<=@hi1
		BEGIN
			SELECT
				@NumeroCuenta = VT.NumeroCuenta
				, @FechaInicio = VT.FechaInicio
				, @FechaFin= VT.FechaFin
				, @SaldoInicial = VT.SaldoInicial
				, @SaldoFinal = VT.SaldoFinal
			FROM @VariableTabla VT
			WHERE Sec = @lo1
			
			SELECT @CuentaAhorroId = CA.Id
			FROM[dbo].[CuentaAhorro] CA
			WHERE CA.NumeroDeCuenta = @NumeroCuenta

			INSERT [dbo].[EstadoDeCuenta](CuentaAhorroId
										, FechaInicio
										, FechaFin
										, SaldoInicial
										, SaldoFinal
										)
			VALUES(@CuentaAhorroId
			, @FechaInicio
			, @FechaFin
			, @SaldoInicial
			, @SaldoFinal
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
--EXEC dbo.CargarEstadosDeCuenta
--SELECT * FROM [dbo].[EstadoDeCuenta]