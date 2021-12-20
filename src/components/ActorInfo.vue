<template>
  <v-container fluid class="pt-10" style="display: flex">
    <v-card elevation="3" outlined class="mx-auto mb-5" color="transparent">
      <v-row dense>
        <v-col cols="6">
          <v-img class="fill-height" :src="this.getSpecificsActor.ActorImage"></v-img>
        </v-col>
        <v-col cols="6">
          <div style="display: flex; justify-content: end">
            <!-- <v-rating
              :value="parseFloat(this.getSpecifics.FilmRating)"
              dense
              half-increments
              readonly
              size="24"
              class="pl-4 pt-4"
              color="pink lighten-2"
              background-color="pink lighten-2"
              style="margin-top: 1em"
            ></v-rating> -->
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
                    <UpdateActor />
              </v-dialog>

              <v-btn class="mx-2" fab dark small color="white">
                <v-icon medium color="pink lighten-2" @click="deleteActorData()"
                  >mdi-movie-open-remove-outline</v-icon
                >
              </v-btn>
            </div>
          </div>
          <v-card-title class="text-h5 font-weight-bold">
            <a style="text-decoration: none; color: black">
              {{ this.getSpecificsActor.ActorName }}</a
            >
          </v-card-title>
          <v-card-text class="text-h6">
            {{ this.getSpecificsActor.ActorDOB }}
          </v-card-text>
          <v-card-text style="font-size: 14px">
            {{ this.getSpecificsActor.ActorGender }}
          </v-card-text>
        </v-col>
      </v-row>
    </v-card>
  </v-container>
</template>

<script>
import { mapActions, mapGetters } from "vuex";
import UpdateActor from "../components/UpdateActor.vue";
export default {
  name: "Data",
  mounted() {
    this.actorData();
  },
  methods: {
    ...mapActions({
      actorData: "actorData",
      deleteActorData: "deleteActorData" 
    }),
    //     async deleteM(){
    //       this.deleteMovieData()
    // },
    
  },
  computed: {
    ...mapGetters({
      getSpecificsActor: "getSpecificsActor",
    }),
  },

  components: {
    UpdateActor,
  },
};
</script>

<style>
</style>