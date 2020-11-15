USE [Proyecto];
GO
DROP PROCEDURE  IF EXISTS dbo.GetAllCuentaAhorro;
GO
CREATE PROCEDURE dbo.GetAllCuentaAhorro
AS
BEGIN 
	SELECT * FROM [dbo].[CuentaAhorro]
END
GO
