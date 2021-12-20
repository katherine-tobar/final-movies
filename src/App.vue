<template>
  <v-app>
    <v-app-bar app color="pink lighten-2" dark>
      <v-row justify="space-between" class="ma-3">
        <a href="/" style="text-decoration: none; color: white" class="d-flex align-start"> 
          <span class="group pr-2">
            <v-icon large>mdi-movie-star</v-icon>
          </span>
          <h2>Home</h2>
        </a>
        <div style="display:flex; flex-direction:row;align-items:center">
          <searchBar/>
          <a href="/add"  style="text-decoration: none; color: white">
            <v-btn  color="red lighten-5" style="color:black;">
              <v-icon left> mdi-plus </v-icon>
              Add
            </v-btn>
          </a>
        </div>
      </v-row>
    </v-app-bar>
    <v-main>
      <router-view />
    </v-main>
  </v-app>
</template>

<script>
import searchBar from './components/SearchBar.vue'
import { mapActions } from "vuex";

export default {
  name: "App",
    mounted() {
      this.getMoviesAPI(),
      this.getActorAPI(),
      this.getDirectorAPI()
  },
  data: () => ({
    //
  }),
  components: {
    searchBar,
  },

  methods: {
    ...mapActions({
      getMoviesAPI: "getMoviesAPI",
      getActorAPI: "getActorAPI",
      getDirectorAPI: "getDirectorAPI"
    }),
    
  },
};
</script>
