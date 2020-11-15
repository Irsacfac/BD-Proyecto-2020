using Proyecto2020Web.Models;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;

namespace Proyecto2020Web.Context
{
    public class ConectarBaseDatos
    {
        string connectionString = "Data Source = proyectobd.clhkdgdsuovc.us-east-1.rds.amazonaws.com,1433; Initial Catalog = Proyecto; Integrated Security = SSPI, User ID = Irsacfac; Password = 1rsacfac;";
        
        public IEnumerable<CuentasAhorro> GetAllCuentaAhorro()
        {
            var CuentaAhorroList = new List<CuentasAhorro>();
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                SqlCommand cmd = new SqlCommand("GetAllCuentaAhorro", con);
                cmd.CommandType = CommandType.StoredProcedure;
                con.Open();
                SqlDataReader dr = cmd.ExecuteReader();
                while (dr.Read())
                {
                    var CuentaAhorro = new CuentasAhorro();
                    CuentaAhorro.Id = Convert.ToInt32(dr["Id"].ToString());
                    CuentaAhorro.PersonaId = Convert.ToInt32(dr["PersonaId"].ToString());
                    CuentaAhorro.TipoCuentaAhorroId = Convert.ToInt32(dr["TipoCuentaAhorroId"].ToString());
                    CuentaAhorro.NumeroDeCuenta = Convert.ToInt32(dr["NumeroDeCuenta"].ToString());
                    CuentaAhorro.FechaDeCreacion = Convert.ToDateTime(dr["FechaDeCreacion"].ToString());
                    CuentaAhorro.Saldo = (float)Convert.ToDouble(dr["Id"].ToString());

                    CuentaAhorroList.Add(CuentaAhorro);
                }
                con.Close();
            }
            return CuentaAhorroList;
        }

        public int validarUsuario(string pUsuario, string pContrasena)
        {
            int usuarioId = 0;
            //var Usuario = new Usuarios();
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                SqlCommand cmd = new SqlCommand("ValidarUsuario", con);

                cmd.Parameters.AddWithValue("@Usuario", pUsuario);
                cmd.Parameters.AddWithValue("@Contraseña", pContrasena);
                
                cmd.CommandType = CommandType.StoredProcedure;
                con.Open();
                SqlDataReader dr = cmd.ExecuteReader();
                while (dr.Read())
                {
                    usuarioId = Convert.ToInt32(dr["Id"].ToString());
                }
                con.Close();
            }
                return usuarioId;

        }
    }
}
