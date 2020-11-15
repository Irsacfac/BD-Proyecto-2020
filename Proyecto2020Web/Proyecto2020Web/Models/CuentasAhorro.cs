using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Proyecto2020Web.Models
{
    public class CuentasAhorro
    {
        public int Id { get; set; }
        public int PersonaId { get; set; }
        public int TipoCuentaAhorroId { get; set; }
        public int NumeroDeCuenta { get; set; }
        public DateTime FechaDeCreacion { get; set; }
        public float Saldo { get; set; }
    }
}
