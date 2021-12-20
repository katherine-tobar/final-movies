using ProyectoFinal.Models;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

namespace ProyectoFinal.Data
{
    public class CastData
    {
        public static List<Cast> ListCast(int id)
        {
            List<Cast> oListCast = new List<Cast>();

            using (SqlConnection oConnection = new SqlConnection(Connection.routeConnection))
            {
                DataTable dt = new DataTable();
                SqlCommand command = new SqlCommand(
                    "SELECT b.FilmName, b.FilmID, b.FilmDirectorID, a.CastCharacterName, a.CastFilmID, a.CastActorID, c.ActorName, c.ActorImage, c.ActorID," +
                    "d.DirectorName, d.DirectorImage FROM tblFilm AS b  " +
                    "INNER JOIN tblCast as A ON (b.FilmID=@FilmID) " +
                    "INNER JOIN tblActor as C ON (c.ActorID=CastActorID AND b.FilmID = a.CastFilmID)" +
                    "INNER JOIN tblDirector as D ON (b.FilmDirectorID = d.DirectorID)"
                    , oConnection);
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
                            oListCast.Add(new Cast()
                            {
                                CastFilmID = Convert.ToInt32(dr["CastFilmID"]),
                                CastActorID = Convert.ToInt32(dr["CastActorID"]),
                                CastCharacterName = dr["CastCharacterName"].ToString(),
                                FilmName = dr["FilmName"].ToString(),
                                FilmID = Convert.ToInt32(dr["FilmID"]),
                                FilmDirectorID = Convert.ToInt32(dr["FilmDirectorID"]),
                                ActorID = Convert.ToInt32(dr["ActorID"]),
                                ActorName = dr["ActorName"].ToString(),
                                DirectorName = dr["DirectorName"].ToString(),
                                ActorImage = dr["ActorImage"].ToString(),
                                DirectorImage = dr["DirectorImage"].ToString()
                            });
                        }
                    }
                    return oListCast;
                }
                catch (Exception ex)
                {
                    return oListCast;
                }

            }
        }
        //public static bool Create(Cast oCast)
        //{
        //    using (SqlConnection oConnection = new SqlConnection(Connection.routeConnection))
        //    {
        //        DataTable dt = new DataTable();
        //        SqlCommand command = new SqlCommand("INSERT INTO tblActor (ActorName, ActorDOB, ActorGender, ActorImage) VALUES (@ActorName,@ActorDOB,@ActorGender,@ActorImage)", oConnection);

        //        //command.Parameters.AddWithValue("@id", oMovie.id);
        //        command.Parameters.AddWithValue("@ActorName", oCast.ActorName);
        //        command.Parameters.AddWithValue("@ActorDOB", oCast.ActorDOB);
        //        command.Parameters.AddWithValue("@ActorGender", oCast.ActorGender);
        //        command.Parameters.AddWithValue("@ActorImage", oCast.ActorImage);


        //        SqlDataAdapter da = new SqlDataAdapter(command);

        //        try
        //        {
        //            oConnection.Open();
        //            command.ExecuteNonQuery();
        //            return true;
        //        }
        //        catch (Exception ex)
        //        {
        //            return false;
        //        }

        //    }
        //}

        //public static bool Modify(Actor oActor)
        //{
        //    using (SqlConnection oConnection = new SqlConnection(Connection.routeConnection))
        //    {
        //        DataTable dt = new DataTable();
        //        SqlCommand command = new SqlCommand("UPDATE tblActor set ActorName = @ActorName, ActorDOB = @ActorDOB, ActorGender = @ActorGender, ActorImage = @ActorImage WHERE ActorID = @ActorID", oConnection);

        //        command.Parameters.AddWithValue("@ActorID", oActor.ActorID);
        //        command.Parameters.AddWithValue("@ActorName", oActor.ActorName);
        //        command.Parameters.AddWithValue("@ActorDOB", oActor.ActorDOB);
        //        command.Parameters.AddWithValue("@ActorGender", oActor.ActorGender);
        //        command.Parameters.AddWithValue("@ActorImage", oActor.ActorImage);

        //        SqlDataAdapter da = new SqlDataAdapter(command);
        //        da.Fill(dt);

        //        try
        //        {
        //            oConnection.Open();
        //            command.ExecuteNonQuery();
        //            return true;
        //        }
        //        catch (Exception ex)
        //        {
        //            return false;
        //        }

        //    }
        //}


        //    public static Actor Get(int id)
        //    {
        //        Actor oActor = new Actor();

        //        using (SqlConnection oConnection = new SqlConnection(Connection.routeConnection))
        //        {
        //            DataTable dt = new DataTable();
        //            SqlCommand command = new SqlCommand("Select * From tblActor where ActorID = @ActorID", oConnection);


        //            command.Parameters.AddWithValue("@ActorID", id);
        //            SqlDataAdapter da = new SqlDataAdapter(command);
        //            da.Fill(dt);

        //            try
        //            {
        //                oConnection.Open();
        //                command.ExecuteNonQuery();

        //                using (SqlDataReader dr = command.ExecuteReader())
        //                {
        //                    while (dr.Read())
        //                    {
        //                        oActor = new Actor()
        //                        {
        //                            ActorID = Convert.ToInt32(dr["ActorID"]),
        //                            ActorName = dr["ActorName"].ToString(),
        //                            ActorDOB = dr["ActorDOB"].ToString(),
        //                            ActorGender = dr["ActorGender"].ToString(),
        //                            ActorImage = dr["ActorImage"].ToString(),
        //                        };
        //                    }
        //                }
        //                return oActor;
        //            }
        //            catch (Exception ex)
        //            {
        //                return oActor;
        //            }
        //        }

        //    }

        //    public static bool Delete(int id)
        //    {
        //        using (SqlConnection oConnection = new SqlConnection(Connection.routeConnection))
        //        {
        //            DataTable dt = new DataTable();
        //            SqlCommand command = new SqlCommand("DELETE From tblActor WHERE ActorID = @ActorID", oConnection);

        //            command.Parameters.AddWithValue("@ActorID", id);
        //            SqlDataAdapter da = new SqlDataAdapter(command);
        //            da.Fill(dt);

        //            try
        //            {
        //                oConnection.Open();
        //                command.ExecuteNonQuery();
        //                return true;
        //            }
        //            catch (Exception ex)
        //            {
        //                return false;
        //            }
        //        }
        //    }
    }
}