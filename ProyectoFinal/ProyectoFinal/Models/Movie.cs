using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ProyectoFinal.Models
{
    public class Movie
    {
        public int FilmID { get; set; }
        public string FilmName { get; set; }
        public string FilmReleaseDate { get; set; }
        public string FilmSynopsis { get; set; }
        public string FilmImage { get; set; }
        public string FilmRating { get; set; }
    }
}