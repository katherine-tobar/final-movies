<template v-slot:default="dialog">
          <v-card>
            <v-toolbar
              color="pink lighten-2"
              dark
            >Edit Actor</v-toolbar>
            <v-card-text>
              <v-container>
            <v-row>
              <v-col cols="12">
                <v-text-field id="name" color="grey darken-2" label="Name*" required  v-model="newDataActor.ActorName" v-bind:value='getSpecificsActor.ActorName'></v-text-field>
              </v-col>
              <v-col cols="6">
                <v-text-field id="image" color="grey darken-2" label="Link to Image*" required  v-model="newDataActor.ActorImage"></v-text-field>
              </v-col>
              <v-col cols="6">
                <v-text-field id="birth" color="grey darken-2" label="Date of birth*" type="text" required  v-model="newDataActor.ActorDOB"></v-text-field>
              </v-col>
              <v-col cols="12">
                <v-textarea id="gender" color="grey darken-2" label="Gender*" type="text" required  v-model="newDataActor.ActorGender"></v-textarea>        
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
  name: "UpdateActor",
  mounted() {
    this.actorData(),
    this.newDataActor.ActorName = this.getSpecificsActor.ActorName,
    this.newDataActor.ActorDOB = this.getSpecificsActor.ActorDOB,
    this.newDataActor.ActorGender = this.getSpecificsActor.ActorGender,
    this.newDataActor.ActorImage = this.getSpecificsActor.ActorImage    
  },
   data: () => ({
    newDataActor:{
        ActorName:'',
        ActorDOB:'',
        ActorGender:'',
        ActorImage:'',
    },
  }),
  methods: {
    ...mapActions({
      actorData: "actorData",
      updateActor: "updateActor"
    }),
    async actualizar(){
        this.updateActor(this.newDataActor)
        location.reload(true);
    },
  
  },
  computed: {
    ...mapGetters({
      getSpecificsActor: "getSpecificsActor",
    }),
  },

};
</script>

<style>

</style>