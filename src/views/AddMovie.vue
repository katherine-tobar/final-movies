<template>
    <v-tabs color="pink lighten-2">
      <v-tab href="#AddMovie"> Add Movie </v-tab>
      <v-tab-item value="AddMovie">
        <Add />
      </v-tab-item>

      <v-tab href="#AddActor"> Add Actor </v-tab>
      <v-tab-item value="AddActor">
        <AddActor />
      </v-tab-item>

      <v-tab href="#AddDirector"> Add Director </v-tab>
      <v-tab-item value="AddDirector">
        <AddDirector />
      </v-tab-item>
    </v-tabs>
</template>

<script>
import Add from "../components/Add.vue";
import AddActor from "../components/AddActor.vue"
import AddDirector from "../components/AddDirector.vue"
export default {
  name: "AddMovie",

  components: {
    Add,
    AddActor,
    AddDirector
  },
};
</script>