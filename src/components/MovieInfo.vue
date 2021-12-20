<template>
  <v-container class="pt-10" style="display: flex; flex-direction:column">
    <v-container>
        <v-card elevation="3" outlined class="mx-auto mb-5" color="transparent">
          <v-row dense>
            <v-col cols="6">
              <v-img
                class="fill-height"
                :src="this.getSpecifics.FilmImage"
              ></v-img>
            </v-col>
            <v-col cols="6">
              <div style="display: flex; justify-content: space-between">
                <v-rating
                  :value="parseFloat(this.getSpecifics.FilmRating)"
                  dense
                  half-increments
                  readonly
                  size="24"
                  class="pl-4 pt-4"
                  color="pink lighten-2"
                  background-color="pink lighten-2"
                  style="margin-top: 1em"
                ></v-rating>
                <div style="margin-right: 1em; margin-top: 0.5em">
                  <v-dialog transition="dialog-top-transition" max-width="600">
                    <template v-slot:activator="{ on, attrs }">
                      <v-btn
                        class="mx-2"
                        fab
                        dark
                        small
                        color="pink lighten-2"
                        v-bind="attrs"
                        v-on="on"
                      >
                        <v-icon medium color="white"
                          >mdi-movie-open-edit-outline</v-icon
                        >
                      </v-btn>
                    </template>
                    <Update />
                  </v-dialog>

                  <v-btn class="mx-2" fab dark small color="white">
                    <v-icon
                      medium
                      color="pink lighten-2"
                      @click="deleteMovieData()"
                      >mdi-movie-open-remove-outline</v-icon
                    >
                  </v-btn>
                </div>
              </div>
              <v-card-title class="text-h5 font-weight-bold">
                <a style="text-decoration: none; color: black">
                  {{ this.getSpecifics.FilmName }}</a
                >
              </v-card-title>
              <v-card-text class="text-h6">
                {{ this.getSpecifics.FilmReleaseDate }}
              </v-card-text>
              <v-card-text style="font-size: 14px">
                {{ this.getSpecifics.FilmSynopsis }}
              </v-card-text>
              <v-card-text v-if="getDirectorMovie!=null">
                <h3 class="pb-2">Directed by:</h3>
                <v-avatar>
                  <img :src="getDirectorMovie.DirectorImage" alt="Director" />
                </v-avatar>
                {{ getDirectorMovie.DirectorName }}
              </v-card-text>
            </v-col>
          </v-row>
        </v-card>
  </v-container>
    <v-container>
      <v-row>
        <v-card width="100%" class="mx-auto">
          <v-toolbar color="pink lighten-2" dark>
            <v-toolbar-title>CAST</v-toolbar-title>

            <v-spacer></v-spacer>

            <v-btn icon>
              <v-icon large class="mr-3">mdi-account-group</v-icon>
            </v-btn>
          </v-toolbar>
          <v-list style="display: flex; flex-direction: row">
            <v-container>
              <v-row>
                <template v-for="item in getCast">
                  <v-col cols="3" :key="item.ActorID">
                    <v-list-item>
                      <v-list-item-avatar>
                        <v-img :src="item.ActorImage"></v-img>
                      </v-list-item-avatar>

                      <v-list-item-content>
                        <v-list-item-title
                          v-html="item.ActorName"
                        ></v-list-item-title>
                        <v-list-item-subtitle
                          v-html="item.CastCharacterName"
                        ></v-list-item-subtitle>
                      </v-list-item-content>
                    </v-list-item>
                  </v-col>
                </template>
              </v-row>
            </v-container>
          </v-list>
        </v-card>
      </v-row>
    </v-container>
  </v-container>
</template>

<script>
import { mapActions, mapGetters } from "vuex";
import Update from "../components/Update.vue";
export default {
  name: "Data",
  mounted() {
    this.movieData(), this.castData();
  },
  methods: {
    ...mapActions({
      movieData: "movieData",
      deleteMovieData: "deleteMovieData",
      castData: "castData",
    }),
    //     async deleteM(){
    //       this.deleteMovieData()
    // },
  },
  computed: {
    ...mapGetters({
      getSpecifics: "getSpecifics",
      getCast: "getCast",
      getDirectorMovie: "getDirectorMovie",
    }),
    // ...mapState({
    //   directorToMovie: "directorToMovie"
    // })
  },

  components: {
    Update,
  },
};
</script>

<style>
</style>