using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ProyectoFinal.Models
{
    public class Director
    {
        public int DirectorID { get; set; }
        public string DirectorName { get; set; }
        public string DirectorDOB { get; set; }
        public string DirectorGender { get; set; }
        public string DirectorImage { get; set; }
    }
}