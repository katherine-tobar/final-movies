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
    public class DirectorController : ApiController
    {
        // GET api/<controller>
        public List<Director> Get()
        {
            return DirectorData.ListDirectors();
        }

        // GET api/<controller>/5
        public Director Get(int id)
        {
            return DirectorData.Get(id);
        }

        // POST api/<controller>
        public bool Post([FromBody] Director oDirector)
        {
            return DirectorData.Create(oDirector);
        }

        // PUT api/<controller>/5
        public bool Put([FromBody] Director oDirector)
        {
            return DirectorData.Modify(oDirector);
        }

        // DELETE api/<controller>/5
        public bool Delete(int id)
        {
            return DirectorData.Delete(id);
        }
    }
}