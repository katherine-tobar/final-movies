import Vue from "vue";
import Vuex from "vuex";
import router from '@/router'

Vue.use(Vuex);

export default new Vuex.Store({
  namespaced: true,
  state: {
    movies: [],
    specificMovieData: [],
    dataSearch: [],
    actor:[],
    specificActorData:[],
    director:[],
    specificDirectorData:[],
    cast:[],
    directorToMovie: []
  },
  getters: {
    getMovies(state) {
      return state.movies;
    },
    getDirectorMovie(state){
      return state.directorToMovie
    },
    getSpecifics(state) {
      return state.specificMovieData;
    },
    getDataSearch(state){
      return state.dataSearch;
    },
    getActor(state) {
      return state.actor;
    },
    getSpecificsActor(state){
      return state.specificActorData;
    },
    getDirector(state) {
      return state.director;
    },
    getSpecificsDirector(state) {
      return state.specificDirectorData;
    },
    getCast(state){
      return state.cast;
    }
  },

  mutations: {
    // setShow(state, movie){
    //   state.movies = movie

    // },
    setMovie(state, newMovieData) {
      console.log('movie,', newMovieData);
      state.movies = newMovieData;
    },
    setSpecifics(state, data) {
      console.log('movie,', data);
      state.specificMovieData = data;
    },
    setDataSearch(state, data) {
      console.log('movie,', data);
      state.dataSearch = data;
    },
    setActor(state, newActorData) {
      console.log('actor,', newActorData);
      state.actor = newActorData;
    },
    setSpecificsActor(state, data){
      state.specificActorData = data;
    },
    setDirector(state, newDirectorData) {
      console.log('director,', newDirectorData);
      state.director = newDirectorData;
    },
    setSpecificsDirector(state, data) {
      console.log('director,', data);
      state.specificDirectorData = data;
    },
    setCast(state, data){
      state.cast = data;
    },
    setDirectorName(state, data){
      state.directorToMovie = data;
    }
  },
  actions: {
    // async search(searchID){
    //   for(var items in this.getDataSearch){
    //     if(items.FilmName == this.searchName){
    //       searchID = items.FilmID;
    //     }
    //   }
    // },
    
    async getMoviesAPI({ commit }) {
      const data = await fetch(`https://localhost:44382/api/values/`, {
        method: "GET",
      })
      if (!data) {
        console.error(data);
      } else {
        const response = await data.json()
        console.log(response);
        // commit('setMovie', [...response])
        // const { _embedded: { movies } } = await data.json();
        commit('setMovie', [...response]);
        commit('setDataSearch',[...response]);
      }
      console.log(data);
    },
    async postMoviesAPI({ commit }, newMovieData) {

      const data = await fetch(`https://localhost:44382/api/values/`, {
        method: "POST",
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          FilmName: newMovieData.FilmName,
          FilmSynopsis: newMovieData.FilmSynopsis,
          FilmReleaseDate: newMovieData.FilmReleaseDate,
          FilmImage: newMovieData.FilmImage,
          FilmRating: newMovieData.FilmRating
        })
      })
      if (!data) {
        console.error(data);
      } else {
        const response = await data.json()
        console.log(response);
        commit('setMovie', newMovieData)
        commit('setDataSearch', newMovieData)

      }
      console.log(data);
    },
    async movieData({commit}) {
      let id = router.currentRoute.params.id

      const data = await fetch(`https://localhost:44382/api/values/${id}`, {
        method: "GET",
      })
      if (!data) {
        console.error(data);
      } else {
        const response = await data.json()
        console.log(response);
        commit('setSpecifics', response)
      }
    },
    async updateMovie({ commit }, newData){
      let id = router.currentRoute.params.id

      // console.log(document.querySelector("#name").value)
      
      console.log(newData)

      const data = await fetch(`https://localhost:44382/api/values/${id}`, {
        method: 'PUT',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          FilmID: id,
          FilmName: newData.FilmName,
          FilmSynopsis: newData.FilmSynopsis,
          FilmReleaseDate: newData.FilmReleaseDate,
          FilmImage: newData.FilmImage,
          FilmRating: newData.FilmRating
        })
    })
    const response = await data.json()
    // .then(newData.id = '',newData.name= '',newData.year= '',newData.image='',newData.description= '')
      console.log(response);
      commit('setSpecifics', newData)
      // .catch(err => console.log(err)) 

    },
    async deleteMovieData() {
      let id = router.currentRoute.params.id
  
      const data = await fetch(`https://localhost:44382/api/values/${id}`, {
        method: "DELETE",
      })
      if (!data) {
        console.error(data);
      } else {
        const response = await data.json()
        console.log(response);
        // commit('setSpecifics', response)
      }
      window.location.href = "/movies";
    },
    async searchData({commit},state,movieName){
      state.movies.map(item =>{
        if(item.name == movieName){
          commit('setSpecifics', item)
        }
      })
    },

    // ACTORES
    async getActorAPI({ commit }) {
      const data = await fetch(`https://localhost:44382/api/Actor/`, {
        method: "GET",
      })
      if (!data) {
        console.error(data);
      } else {
        const response = await data.json()
        console.log(response);
        // commit('setMovie', [...response])
        // const { _embedded: { movies } } = await data.json();
        commit('setActor', [...response]);
        // commit('setDataSearch',[...response]);
      }
      console.log(data);
    },
    async postActorAPI({ commit }, newActorData) {

      const data = await fetch(`https://localhost:44382/api/Actor/`, {
        method: "POST",
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          ActorImage: newActorData.ActorImage,
          ActorName: newActorData.ActorName,
          ActorDOB: newActorData.ActorDOB,
          ActorGender: newActorData.ActorGender,
          // ActorID: newMovieData.FilmReleaseDate,
        })
      })
      if (!data) {
        console.error(data);
      } else {
        const response = await data.json()
        console.log(response);
        commit('setActor', newActorData)
        // commit('setDataSearch', newMovieData)

      }
      console.log(data);
    },
    async actorData({commit}) {
      let id = router.currentRoute.params.id

      const data = await fetch(`https://localhost:44382/api/Actor/${id}`, {
        method: "GET",
      })
      if (!data) {
        console.error(data);
      } else {
        const response = await data.json()
        console.log(response);
        commit('setSpecificsActor', response)
      }
    },
    async updateActor({ commit }, newDataActor){
      let id = router.currentRoute.params.id

      // console.log(document.querySelector("#name").value)
      
      console.log(newDataActor)

      const data = await fetch(`https://localhost:44382/api/Actor/${id}`, {
        method: 'PUT',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          ActorID: id,
          ActorDOB: newDataActor.ActorDOB,
          ActorGender: newDataActor.ActorGender,
          ActorImage: newDataActor.ActorImage,
          ActorName: newDataActor.ActorName,
        })
    })
    const response = await data.json()
    // .then(newData.id = '',newData.name= '',newData.year= '',newData.image='',newData.description= '')
      console.log(response);
      commit('setSpecificsActor', newDataActor)
      // .catch(err => console.log(err)) 

    },
    async deleteActorData() {
      let id = router.currentRoute.params.id
  
      const data = await fetch(`https://localhost:44382/api/Actor/${id}`, {
        method: "DELETE",
      })
      if (!data) {
        console.error(data);
      } else {
        const response = await data.json()
        console.log(response);
        // commit('setSpecifics', response)
      }
      window.location.href = "/actor";
    },

     // DIRECTORES
     async getDirectorAPI({ commit }) {
      const data = await fetch(`https://localhost:44382/api/Director/`, {
        method: "GET",
      })
      if (!data) {
        console.error(data);
      } else {
        const response = await data.json()
        console.log(response);
        // commit('setMovie', [...response])
        // const { _embedded: { movies } } = await data.json();
        commit('setDirector', [...response]);
        // commit('setDataSearch',[...response]);
      }
      console.log(data);
    },
    async postDirectorAPI({ commit }, newDirectorData) {

      const data = await fetch(`https://localhost:44382/api/Director/`, {
        method: "POST",
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          DirectorName: newDirectorData.DirectorName,
          DirectorImage: newDirectorData.DirectorImage,
          DirectorGender: newDirectorData.DirectorGender,
          DirectorDOB: newDirectorData.DirectorDOB,
          // ActorID: newMovieData.FilmReleaseDate,
        })
      })
      if (!data) {
        console.error(data);
      } else {
        const response = await data.json()
        console.log(response);
        commit('setDirector', newDirectorData)
        // commit('setDataSearch', newMovieData)

      }
      console.log(data);
    },
    async directorData({commit}) {
      let id = router.currentRoute.params.id

      const data = await fetch(`https://localhost:44382/api/Director/${id}`, {
        method: "GET",
      })
      if (!data) {
        console.error(data);
      } else {
        const response = await data.json()
        console.log(response);
        commit('setSpecificsDirector', response)
      }
    },
    async updateDirector({ commit }, newDataDirector){
      let id = router.currentRoute.params.id

      // console.log(document.querySelector("#name").value)
      
      console.log(newDataDirector)

      const data = await fetch(`https://localhost:44382/api/Director/${id}`, {
        method: 'PUT',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          DirectorID: id,
          DirectorDOB: newDataDirector.DirectorDOB,
          DirectorGender: newDataDirector.DirectorGender,
          DirectorImage: newDataDirector.DirectorImage,
          DirectorName: newDataDirector.DirectorName,
        })
    })
    const response = await data.json()
    // .then(newData.id = '',newData.name= '',newData.year= '',newData.image='',newData.description= '')
      console.log(response);
      commit('setSpecificsDirector', newDataDirector)
      // .catch(err => console.log(err)) 

    },
    async deleteDirectorData() {
      let id = router.currentRoute.params.id
  
      const data = await fetch(`https://localhost:44382/api/Director/${id}`, {
        method: "DELETE",
      })
      if (!data) {
        console.error(data);
      } else {
        const response = await data.json()
        console.log(response);
        // commit('setSpecifics', response)
      }
      window.location.href = "/director";
    },

    // CAST
    async castData({commit}) {
      let id = router.currentRoute.params.id

      const data = await fetch(`https://localhost:44382/api/Cast/${id}`, {
        method: "GET",
      })
      if (!data) {
        console.error(data);
      } else {
        const response = await data.json()
        console.log('cast',response);
        commit('setCast', response)
        // state.directorToMovie = response.DirectorName
        commit('setDirectorName', response[0])
      }
    },
    
  },
  
  modules: {},
});
