import Vue from "vue";
import VueRouter from "vue-router";
import Home from "../views/Home.vue";
import MoviesList from "../views/MoviesList.vue"
import AddMovie from "../views/AddMovie.vue"
import MovieData from "../views/MovieData.vue"
import ActorList from "../views/ActorList.vue"
import ActorData from "../views/ActorData.vue"
import DirectorData from "../views/DirectorData.vue"
import DirectorList from "../views/DirectorList.vue"
// import Data from "../views/Data.vue"
Vue.use(VueRouter);

const routes = [
  {
    path: "/",
    name: "Home",
    component: Home,
  },
  {
    path: "/movies",
    name:"MoviesList",
    component: MoviesList,
  },
  {
    path: "/add",
    name:"AddMovie",
    component: AddMovie,
  },
  // {
  //   path: "/movieData",
  //   name:"MovieData",
  //   component: MovieData,
  // },
  {
    path:"/data/:id",
    name:'Data',
    component: MovieData,
  },
  {
    path: "/actor",
    name:"ActorList",
    component: ActorList,
  },
  {
    path:"/actor/:id",
    name:'DataActor',
    component: ActorData,
  },
  {
    path: "/director",
    name:"DirectorList",
    component: DirectorList,
  },
  {
    path:"/director/:id",
    name:'DirectorsData',
    component: DirectorData,
  },
  {
    path: "/about",
    name: "About",
    // route level code-splitting
    // this generates a separate chunk (about.[hash].js) for this route
    // which is lazy-loaded when the route is visited.
    component: function () {
      return import(/* webpackChunkName: "about" */ "../views/About.vue");
    },
  },
];

const router = new VueRouter({
  mode: 'history',
  routes,
});

export default router;
