<template>
  <section>
        <div class="movie_cont" style="height: 100vh;">  
            <v-img
            :src="require('../assets/images/cine2.jpg')"
            contain
            width="fit-auto"
            />    
            <div class="movie_rest" style=" position: absolute; left: 50%; top: 45%; -ms-transform: translate(-50%,-50%); -webkit-transform: translate(-50%,-50%); transform: translate(-50%,-50%); padding: 20px; width: 80%; text-align: center; background-color: rgba(253,	237,	236, 0.9); color: black; margin: auto;">
                <h1 style="font-size: 8vw; margin-bottom: 10px;">Movies</h1>
                <p style="  font-size: 4vw; margin-bottom: 10px;">See more information:</p>
                <hr/>
                <div class="movie_cont_link" style="padding-top: 2em" >
                    <a href="/movies" style="position: relative; display: inline-block; color: black; text-decoration: none; border: 1px solid black; padding: 5px; margin-bottom: 5px; width: 150px;">Movies</a>
                    <a href="/actor" style="position: relative; display: inline-block; color: black; text-decoration: none; border: 1px solid black; padding: 5px; margin-bottom: 5px; width: 150px;">Actors</a>
                    <a href="/director" style="position: relative; display: inline-block; color: black; text-decoration: none; border: 1px solid black; padding:5px; margin-bottom: 5px; width: 150px;">Directors</a>
                </div>
            </div>
        </div>
    </section>
</template>

<script>

export default {
  name: "Home",

  components: {},
};
</script>
