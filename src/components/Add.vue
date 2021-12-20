<template>
  <v-row justify="center" style="margin-top: 2em; margin-bottom:2em;overflow-y:auto">
      <v-card outlined elevation="2">
        <v-card-title style="display:flex; flex-direction:column; gap:12px;">
        <v-icon 
        large
        color="pink lighten-2"
        >mdi-movie-open-plus</v-icon>
          <h2>Add Movie</h2>
        </v-card-title>
        <v-card-text>
          <v-container>
            <v-row>
              <v-col cols="12">
                <v-text-field color="grey darken-2" label="Name*" v-model="newMovieData.FilmName" required></v-text-field>
              </v-col>
              <v-col cols="6">
                <v-text-field color="grey darken-2" label="Creation year*" type="text" v-model="newMovieData.FilmReleaseDate" required></v-text-field>
              </v-col>
              <v-col cols="6">
                <v-text-field color="grey darken-2" label="Rating*" type="text" v-model="newMovieData.FilmRating" required></v-text-field>
              </v-col>
              <v-col cols="12">
                <v-text-field color="grey darken-2" label="Image link*" v-model="newMovieData.FilmImage" required></v-text-field>
              </v-col>
              <v-col cols="12">
                <v-textarea color="grey darken-2" label="Description*" type="text" v-model="newMovieData.FilmSynopsis" required></v-textarea>        
              </v-col>
            </v-row>
          </v-container>
          <!-- <small>*indicates required field</small> -->
        </v-card-text>
        <v-card-actions>
          <v-spacer></v-spacer>
          <!-- <a href="/movies"> -->
          <v-btn color="red lighten-5 ma-6"  @click="createMovie()">
            Save
          </v-btn>
          <!-- </a> -->
        </v-card-actions>
      </v-card>
  </v-row>
</template>


<script>
import { mapActions, mapMutations } from "vuex"
export default {
  name: "Add",
  data: () => ({
    newMovieData:{
        FilmName:'',
        FilmReleaseDate:'',
        FilmSynopsis:'',
        FilmImage:'',
        FilmRating:''
    },
    dialog: false,
  }),
    methods: {
    ...mapActions({
      postMoviesAPI: "postMoviesAPI",
    }),
    ...mapMutations({
      addMovies: "setMovie",
    }),
    async createMovie(){
        this.postMoviesAPI(this.newMovieData)
        console.log('movie saved');
        location.href = "/movies";
    }
  },
  mutations: {
  }
};
</script>