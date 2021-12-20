<template>
  <v-row justify="center" style="margin-top: 2em; margin-bottom:2em; overflow-y:auto">
      <v-card outlined elevation="2">
        <v-card-title style="display:flex; flex-direction:column; gap:12px;">
        <v-icon 
        large
        color="pink lighten-2"
        >mdi-account-plus</v-icon>
          <h2>Addr Actor</h2>
        </v-card-title>
        <v-card-text>
          <v-container>
            <v-row>
              <v-col cols="6">
                <v-text-field color="grey darken-2" label="Name*" v-model="newActorData.ActorName" required></v-text-field>
              </v-col>
              <v-col cols="6">
                <v-text-field color="grey darken-2" label="Image link*" v-model="newActorData.ActorImage" required></v-text-field>
              </v-col>
              <v-col cols="6">
                <v-text-field color="grey darken-2" label="Birth date*" type="text" v-model="newActorData.ActorDOB" required></v-text-field>
              </v-col>
              <v-col cols="6">
                <v-text-field color="grey darken-2" label="Gender*" type="text" v-model="newActorData.ActorGender" required></v-text-field>        
              </v-col>
            </v-row>
          </v-container>
          <!-- <small>*indicates required field</small> -->
        </v-card-text>
        <v-card-actions>
          <v-spacer></v-spacer>
          <!-- <a href="/movies"> -->
          <v-btn color="red lighten-5 ma-6"  @click="createActor()">
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
  name: "AddActor",
  data: () => ({
    newActorData:{
        ActorName:'',
        ActorDOB:'',
        ActorImage:'',
        ActorGender:''
    },
    dialog: false,
  }),
    methods: {
    ...mapActions({
      postActorAPI: "postActorAPI",
    }),
    ...mapMutations({
      addActor: "setActor",
    }),
    async createActor(){
        this.postActorAPI(this.newActorData)
        console.log('actor saved');
        location.href = "/actor";
    }
  },
  mutations: {
  }
};
</script>