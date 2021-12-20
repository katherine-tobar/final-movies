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
    public class ActorController : ApiController
    {
        // GET api/<controller>
        public List<Actor> Get()
        {
            return ActorData.ListActors();
        }

        // GET api/<controller>/5
        public Actor Get(int id)
        {
            return ActorData.Get(id);
        }

        // POST api/<controller>
        public bool Post([FromBody] Actor oActor)
        {
            return ActorData.Create(oActor);
        }

        // PUT api/<controller>/5
        public bool Put([FromBody] Actor oActor)
        {
            return ActorData.Modify(oActor);
        }

        // DELETE api/<controller>/5
        public bool Delete(int id)
        {
            return ActorData.Delete(id);
        }
    }
}