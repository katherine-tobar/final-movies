<template v-slot:default="dialog">
          <v-card>
            <v-toolbar
              color="pink lighten-2"
              dark
            >Edit Director</v-toolbar>
            <v-card-text>
              <v-container>
            <v-row>
              <v-col cols="12">
                <v-text-field id="name" color="grey darken-2" label="Name*" required  v-model="newDataDirector.DirectorName" v-bind:value='getSpecificsDirector.DirectorName'></v-text-field>
              </v-col>
              <v-col cols="6">
                <v-text-field id="image" color="grey darken-2" label="Link to Image*" required  v-model="newDataDirector.DirectorImage"></v-text-field>
              </v-col>
              <v-col cols="6">
                <v-text-field id="birth" color="grey darken-2" label="Date of birth*" type="text" required  v-model="newDataDirector.DirectorDOB"></v-text-field>
              </v-col>
              <v-col cols="12">
                <v-textarea id="gender" color="grey darken-2" label="Gender*" type="text" required  v-model="newDataDirector.DirectorGender"></v-textarea>        
              </v-col>
            </v-row>
          </v-container>
            </v-card-text>
            <v-card-actions class="justify-end">
              <v-btn
                text
                @click="actualizarDirector()"
              >Save</v-btn>
            </v-card-actions>
          </v-card>
</template>

<script>
import { mapActions, mapGetters } from "vuex";
export default {
  name: "UpdateActor",
  mounted() {
    this.directorData(),
    this.newDataDirector.DirectorName = this.getSpecificsDirector.DirectorName,
    this.newDataDirector.DirectorDOB = this.getSpecificsDirector.DirectorDOB,
    this.newDataDirector.DirectorGender = this.getSpecificsDirector.DirectorGender,
    this.newDataDirector.DirectorImage = this.getSpecificsDirector.DirectorImage    
  },
   data: () => ({
    newDataDirector:{
        DirectorName:'',
        DirectorDOB:'',
        DirectorGender:'',
        DirectorImage:'',
    },
  }),
  methods: {
    ...mapActions({
      directorData: "directorData",
      updateDirector: "updateDirector"
    }),
    async actualizarDirector(){
        this.updateDirector(this.newDataDirector)
        location.reload(true);
    },
  
  },
  computed: {
    ...mapGetters({
      getSpecificsDirector: "getSpecificsDirector",
    }),
  },

};
</script>

<style>

</style>