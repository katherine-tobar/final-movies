<template>
  <div style="display: flex; flex-direction: row">
 
    <v-autocomplete
      :items="getDataSearch"
      item-text="FilmName"
      cache-items
      class="mx-4"
      flat
      hide-no-data
      hide-details
      label="Search"
      solo-inverted
      v-model="searchName"
      @change="search"
      style="margin-right:0 !important; border-top-right-radius:0px;border-bottom-right-radius:0px"
    >
    </v-autocomplete>
        <v-btn  flat large class=" mr-4" style="background: rgba(255, 255, 255, 0.16); margin-left:0; height:auto;box-shadow:none;border-top-left-radius:0px;border-bottom-left-radius:0px">
          <router-link
            :to="{ name: 'Data', params: { id: this.searchID } }"
            style="text-decoration: none !important; color: green"
          >
            <v-icon medium color="white" 
              >mdi-movie-search</v-icon
            >
          </router-link>
        </v-btn>
  </div>
</template>

<script>
import { mapGetters } from "vuex";

export default {
  data: () => ({
    searchName: "",
    searchID: "",
  }),
  // mounted:{
  //   reset: "reset"
  // },
  name: "searchBar",
  computed: {
    ...mapGetters({
      getDataSearch: "getDataSearch",
    }),
  },
  methods: {
    search: function () {
      var film = "";
      console.log(this.searchName);
      for (var items in this.getDataSearch) {
        if (this.getDataSearch[items].FilmName == this.searchName) {
          film = this.getDataSearch[items].FilmID;
        }
      }
      this.searchID = film;
    },
    reset:function(){
      this.searchID = ""
    }
  },
};
</script>

<style>
</style>