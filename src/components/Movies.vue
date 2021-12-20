<template>
    <div>
      <v-container fluid class="pt-10">
        <v-row dense>
          <v-col v-for="item in getMovies" :key="item.FilmID">
            <v-card elevation="3" outlined class="mx-auto mb-5" max-width="344px" color="transparent">
                <v-img height="250" :src="item.FilmImage">
                    
                </v-img>
                <v-rating :value="parseFloat(item.FilmRating)" dense half-increments readonly size="16" class="pl-4 pt-4" color="pink lighten-2" background-color="pink lighten-2"></v-rating>
                <router-link :to="{ name: 'Data', params: { id: item.FilmID } }"  style="text-decoration:none !important; color:black">
                  <v-card-title class="text-h5 font-weight-bold">
                    {{ item.FilmName }}
                  </v-card-title>
                </router-link>
                <v-card-text class="text-h6 ">
                    {{ item.FilmReleaseDate }}
                </v-card-text>
            </v-card>
            </v-col>
        </v-row>
      </v-container>
    </div>
</template>

<script>
import { mapActions, mapGetters } from "vuex";
export default {
  name: "movies-update",

  // mounted() {
  //     this.getMoviesAPI()
  // },
  methods: {
    ...mapActions({
      getMoviesAPI: "getMoviesAPI",
    }),
    
  },
  computed: {
    ...mapGetters({
      getMovies: "getMovies",
    }),
  },
};
</script>

<style>
</style>