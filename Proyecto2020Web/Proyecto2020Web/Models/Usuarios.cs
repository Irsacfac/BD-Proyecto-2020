namespace Proyecto2020Web.Models
{
    public class Usuarios
    {
        public int Id { get; set; }
        public int PersonaId { get; set; }
        public string Usuario { get; set; }
        public string Contrasena { get; set; }
        public bool isAdministrador{ get; set; }

    }
}
