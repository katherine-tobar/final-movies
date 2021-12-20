<template v-slot:default="dialog">
          <v-card>
            <v-toolbar
              color="pink lighten-2"
              dark
            >Edit Movie</v-toolbar>
            <v-card-text>
              <v-container>
            <v-row>
              <v-col cols="12">
                <v-text-field id="name" color="grey darken-2" label="Nombre*" required  v-model="newData.FilmName" v-bind:value='getSpecifics.FilmName'></v-text-field>
              </v-col>
              <v-col cols="6">
                <v-text-field id="image" color="grey darken-2" label="Link de Imagen*" required  v-model="newData.FilmImage"></v-text-field>
              </v-col>
              <v-col cols="6">
                <v-text-field id="year" color="grey darken-2" label="Año de Estreno*" type="text" required  v-model="newData.FilmReleaseDate"></v-text-field>
              </v-col>
              <v-col cols="12">
                <v-text-field id="rating" color="grey darken-2" label="Rating*" type="text" required  v-model="newData.FilmRating"></v-text-field>
              </v-col>
              <v-col cols="12">
                <v-textarea id="description" color="grey darken-2" label="Descripción*" type="text" required  v-model="newData.FilmSynopsis"></v-textarea>        
              </v-col>
            </v-row>
          </v-container>
            </v-card-text>
            <v-card-actions class="justify-end">
              <v-btn
                text
                @click="actualizar()"
              >Save</v-btn>
            </v-card-actions>
          </v-card>
</template>

<script>
import { mapActions, mapGetters } from "vuex";
export default {
  name: "Update",
  mounted() {
    this.movieData(),
    this.newData.FilmName = this.getSpecifics.FilmName,
    this.newData.FilmReleaseDate = this.getSpecifics.FilmReleaseDate,
    this.newData.FilmSynopsis = this.getSpecifics.FilmSynopsis,
    this.newData.FilmImage = this.getSpecifics.FilmImage,
    this.newData.FilmRating = this.getSpecifics.FilmRating
    
  },
   data: () => ({
    newData:{
        FilmName:'',
        FilmReleaseDate:'',
        FilmSynopsis:'',
        FilmImage:'',
        FilmRating:''
    },
  }),
  methods: {
    ...mapActions({
      movieData: "movieData",
      updateMovie: "updateMovie"
    }),
    async actualizar(){
        this.updateMovie(this.newData)
        location.reload(true);
    },
  
  },
  computed: {
    ...mapGetters({
      getSpecifics: "getSpecifics",
    }),
  },

};
</script>

<style>

</style>