using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ProyectoFinal.Models
{
    public class Actor
    {
        public int ActorID { get; set; }
        public string ActorName { get; set; }
        public string ActorDOB { get; set; }
        public string ActorGender { get; set; }
        public string ActorImage { get; set; }
    }
}