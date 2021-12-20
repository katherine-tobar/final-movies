using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ProyectoFinal.Models
{
    public class Cast
    {
        public string CastCharacterName { get; set; }
        public int CastFilmID { get; set; }
        public int CastActorID { get; set; }
        public string FilmName { get; set; }
        public int FilmID { get; set; }
        public int FilmDirectorID { get; set; }
        public string ActorName { get; set; }
        public int ActorID { get; set; }
        public string DirectorName { get; set; } 
        public string ActorImage { get; set; }
        public string DirectorImage { get; set; }
    }
}