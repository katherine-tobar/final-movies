using ProyectoFinal.Data;
using ProyectoFinal.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace ProyectoFinal.Controllers
{
    public class ValuesController : ApiController
    {
        // GET api/values
        public List<Movie> Get()
        {
            return MovieData.ListMovies();
        }

        // GET api/values/5
        public Movie Get(int id)
        {
            return MovieData.Get(id);
        }


        // POST api/values
        public bool Post([FromBody] Movie oMovie)
        {
            return MovieData.Create(oMovie);
        }

        // PUT api/values/5     
        public bool Put([FromBody] Movie oMovie)
        {
            return MovieData.Modify(oMovie);
        }

        // DELETE api/values/5
        public bool Delete(int id)
        {
            return MovieData.Delete(id);
        }
    }
}
