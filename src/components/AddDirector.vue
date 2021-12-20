<template>
  <v-row
    justify="center"
    style="margin-top: 2em; margin-bottom: 2em; overflow-y: auto"
  >
    <v-card outlined elevation="2">
      <v-card-title style="display: flex; flex-direction: column; gap: 12px">
        <v-icon large color="pink lighten-2">mdi-video-vintage</v-icon>
        <h2>Add Director</h2>
      </v-card-title>
      <v-card-text>
        <v-container>
          <v-row>
            <v-col cols="6">
              <v-text-field
                color="grey darken-2"
                label="Name*"
                v-model="newDirectorData.DirectorName"
                required
              ></v-text-field>
            </v-col>
            <v-col cols="6">
              <v-text-field
                color="grey darken-2"
                label="Image link*"
                v-model="newDirectorData.DirectorImage"
                required
              ></v-text-field>
            </v-col>
            <v-col cols="6">
              <v-text-field
                color="grey darken-2"
                label="Birth date*"
                type="text"
                v-model="newDirectorData.DirectorDOB"
                required
              ></v-text-field>
            </v-col>
            <v-col cols="6">
              <v-text-field
                color="grey darken-2"
                label="Gender*"
                type="text"
                v-model="newDirectorData.DirectorGender"
                required
              ></v-text-field>
            </v-col>
          </v-row>
        </v-container>
        <!-- <small>*indicates required field</small> -->
      </v-card-text>
      <v-card-actions>
        <v-spacer></v-spacer>
        <!-- <a href="/movies"> -->
        <v-dialog transition="dialog-top-transition" max-width="600">
          <template v-slot:activator="{ on, attrs }">
            <v-btn
              color="red lighten-5 ma-6"
              fab
              dark
              small
              v-bind="attrs"
              v-on="on"
              @click="createDirector()"
            >
              Save
            </v-btn>

          </template>
          <div>
          <h3>Added</h3>
           <router-link :to="{ name: 'Home' }">
          <v-btn >ok</v-btn>
           </router-link>
          </div>
        </v-dialog>

        <!-- </a> -->
      </v-card-actions>
    </v-card>
  </v-row>
</template>


<script>
import { mapActions, mapMutations } from "vuex";
export default {
  name: "AddDirector",
  data: () => ({
    newDirectorData: {
      DirectorName: "",
      DirectorDOB: "",
      DirectorImage: "",
      DirectorGender: "",
    },
    dialog: false,
  }),
  methods: {
    ...mapActions({
      postDirectorAPI: "postDirectorAPI",
    }),
    ...mapMutations({
      addDirector: "setDirector",
    }),
    async createDirector() {
      this.postDirectorAPI(this.newDirectorData);
      console.log("actor saved");
      location.href = "/director";
    },
  },
  mutations: {},
};
</script>