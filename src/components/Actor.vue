<template>
    <div>
      <v-container fluid class="pt-10">
        <v-row dense>
          <v-col v-for="item in getActor" :key="item.ActorID">
            <v-card elevation="3" outlined class="mx-auto mb-5" max-width="344px" color="transparent">
                <v-img height="250" :src="item.ActorImage">
                    
                </v-img>
                <!-- <v-rating :value="parseFloat(item.FilmRating)" dense half-increments readonly size="16" class="pl-4 pt-4" color="pink lighten-2" background-color="pink lighten-2"></v-rating> -->
                <router-link :to="{ name: 'DataActor', params: { id: item.ActorID } }"  style="text-decoration:none !important; color:black">
                  <v-card-title class="text-h5 font-weight-bold">
                    {{ item.ActorName }}
                  </v-card-title>
                </router-link>
                <v-card-text class="text-h6 ">
                    {{ item.ActorDOB }}
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
  name: "actor",

  // mounted() {
  //     this.getMoviesAPI()
  // },
  methods: {
    ...mapActions({
      getActorAPI: "getActorAPI",
    }),
    
  },
  computed: {
    ...mapGetters({
      getActor: "getActor",
    }),
  },
};
</script>

<style>
</style>