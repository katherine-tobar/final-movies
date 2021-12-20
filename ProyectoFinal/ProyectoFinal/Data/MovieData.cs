using ProyectoFinal.Models;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

namespace ProyectoFinal.Data
{
    public class MovieData
    {
        public static bool Create(Movie oMovie )
        {
            using (SqlConnection oConnection = new SqlConnection(Connection.routeConnection) )
            {
                DataTable dt = new DataTable();
                SqlCommand command = new SqlCommand("INSERT INTO tblFilm (FilmName, FilmReleaseDate, FilmSynopsis, FilmImage, FilmRating) VALUES (@FilmName,@FilmReleaseDate,@FilmSynopsis,@FilmImage,@FilmRating)", oConnection);
                
                //command.Parameters.AddWithValue("@id", oMovie.id);
                command.Parameters.AddWithValue("@FilmName", oMovie.FilmName);
                command.Parameters.AddWithValue("@FilmReleaseDate", oMovie.FilmReleaseDate);
                command.Parameters.AddWithValue("@FilmSynopsis", oMovie.FilmSynopsis);
                command.Parameters.AddWithValue("@FilmImage", oMovie.FilmImage);
                command.Parameters.AddWithValue("@FilmRating", oMovie.FilmRating);


                SqlDataAdapter da = new SqlDataAdapter(command);

                try
                {
                    oConnection.Open();
                    command.ExecuteNonQuery();
                    return true;
                }
                catch(Exception ex)
                {
                    return false;
                }

            }
        }

        public static bool Modify(Movie oMovie)
        {
            using (SqlConnection oConnection = new SqlConnection(Connection.routeConnection))
            {
                DataTable dt = new DataTable();
                SqlCommand command = new SqlCommand("UPDATE tblFilm set FilmName = @FilmName, FilmReleaseDate = @FilmReleaseDate, FilmSynopsis = @FilmSynopsis, FilmImage = @FilmImage, FilmRating = @FilmRating WHERE FilmID = @FilmID", oConnection);

                command.Parameters.AddWithValue("@FilmID", oMovie.FilmID);
                command.Parameters.AddWithValue("@FilmName", oMovie.FilmName);
                command.Parameters.AddWithValue("@FilmReleaseDate", oMovie.FilmReleaseDate);
                command.Parameters.AddWithValue("@FilmSynopsis", oMovie.FilmSynopsis);
                command.Parameters.AddWithValue("@FilmImage", oMovie.FilmImage);
                command.Parameters.AddWithValue("@FilmRating", oMovie.FilmRating);

                SqlDataAdapter da = new SqlDataAdapter(command);
                da.Fill(dt);

                try
                {
                    oConnection.Open();
                    command.ExecuteNonQuery();
                    return true;
                }   
                catch (Exception ex)
                {
                    return false;
                }

            }
        }

        public static List<Movie> ListMovies()
        {
            List<Movie> oListMovie = new List<Movie>();

            using (SqlConnection oConnection = new SqlConnection(Connection.routeConnection))
            {
                DataTable dt = new DataTable();
                SqlCommand command = new SqlCommand("Select FilmID, FilmName, FilmReleaseDate, FilmSynopsis, FilmImage, FilmRating From tblFilm ORDER BY FilmReleaseDate DESC", oConnection);
                SqlDataAdapter da = new SqlDataAdapter(command);
                da.Fill(dt);

                try
                {
                    oConnection.Open();
                    command.ExecuteNonQuery();

                    using (SqlDataReader dr = command.ExecuteReader())
                    {
                        while (dr.Read())
                        {
                            oListMovie.Add(new Movie()
                            {
                                FilmID = Convert.ToInt32(dr["FilmID"]),
                                FilmName = dr["FilmName"].ToString(),
                                FilmReleaseDate = dr["FilmReleaseDate"].ToString(),
                                FilmSynopsis = dr["FilmSynopsis"].ToString(),
                                FilmImage = dr["FilmImage"].ToString(),
                                FilmRating = dr["FilmRating"].ToString()
                            });
                        }
                    }
                    return oListMovie;
                }
                catch (Exception ex)
                {
                    return oListMovie;
                }

            }
        }

        public static Movie Get(int id)
        {
            Movie oMovie = new Movie();

            using (SqlConnection oConnection = new SqlConnection(Connection.routeConnection))
            {
                DataTable dt = new DataTable();
                SqlCommand command = new SqlCommand("Select * From tblFilm where FilmID = @FilmID", oConnection);


                command.Parameters.AddWithValue("@FilmID", id);
                SqlDataAdapter da = new SqlDataAdapter(command);
                da.Fill(dt);

                try
                {
                    oConnection.Open();
                    command.ExecuteNonQuery();

                    using (SqlDataReader dr = command.ExecuteReader())
                    {
                        while (dr.Read())
                        {
                            oMovie = new Movie()
                            {
                                FilmID = Convert.ToInt32(dr["FilmID"]),
                                FilmName = dr["FilmName"].ToString(),
                                FilmReleaseDate = dr["FilmReleaseDate"].ToString(),
                                FilmSynopsis = dr["FilmSynopsis"].ToString(),
                                FilmImage = dr["FilmImage"].ToString(),
                                FilmRating = dr["FilmRating"].ToString()
                            };
                        }
                    }
                    return oMovie;
                }
                catch (Exception ex)
                {
                    return oMovie;
                }
            }

        }

        public static bool Delete(int id)
        {
            using (SqlConnection oConnection = new SqlConnection(Connection.routeConnection))
            {
                DataTable dt = new DataTable();
                SqlCommand command = new SqlCommand("DELETE From tblFilm WHERE FilmID = @FilmID", oConnection);
                
                command.Parameters.AddWithValue("@FilmID", id);
                SqlDataAdapter da = new SqlDataAdapter(command);
                da.Fill(dt);

                try
                {
                    oConnection.Open();
                    command.ExecuteNonQuery();
                    return true;
                }
                catch (Exception ex)
                {
                    return false;
                }
            }
        }

    }
}