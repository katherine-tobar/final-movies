using ProyectoFinal.Models;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

namespace ProyectoFinal.Data
{
    public class ActorData
    {
        public static bool Create(Actor oActor)
        {
            using (SqlConnection oConnection = new SqlConnection(Connection.routeConnection))
            {
                DataTable dt = new DataTable();
                SqlCommand command = new SqlCommand("INSERT INTO tblActor (ActorName, ActorDOB, ActorGender, ActorImage) VALUES (@ActorName,@ActorDOB,@ActorGender,@ActorImage)", oConnection);

                //command.Parameters.AddWithValue("@id", oMovie.id);
                command.Parameters.AddWithValue("@ActorName", oActor.ActorName);
                command.Parameters.AddWithValue("@ActorDOB", oActor.ActorDOB);
                command.Parameters.AddWithValue("@ActorGender", oActor.ActorGender);
                command.Parameters.AddWithValue("@ActorImage", oActor.ActorImage);


                SqlDataAdapter da = new SqlDataAdapter(command);

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

        public static bool Modify(Actor oActor)
        {
            using (SqlConnection oConnection = new SqlConnection(Connection.routeConnection))
            {
                DataTable dt = new DataTable();
                SqlCommand command = new SqlCommand("UPDATE tblActor set ActorName = @ActorName, ActorDOB = @ActorDOB, ActorGender = @ActorGender, ActorImage = @ActorImage WHERE ActorID = @ActorID", oConnection);

                command.Parameters.AddWithValue("@ActorID", oActor.ActorID);
                command.Parameters.AddWithValue("@ActorName", oActor.ActorName);
                command.Parameters.AddWithValue("@ActorDOB", oActor.ActorDOB);
                command.Parameters.AddWithValue("@ActorGender", oActor.ActorGender);
                command.Parameters.AddWithValue("@ActorImage", oActor.ActorImage);

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

        public static List<Actor> ListActors()
        {
            List<Actor> oListActors = new List<Actor>();

            using (SqlConnection oConnection = new SqlConnection(Connection.routeConnection))
            {
                DataTable dt = new DataTable();
                SqlCommand command = new SqlCommand("Select ActorID, ActorName, ActorDOB, ActorGender, ActorImage From tblActor", oConnection);
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
                            oListActors.Add(new Actor()
                            {
                                ActorID = Convert.ToInt32(dr["ActorID"]),
                                ActorName = dr["ActorName"].ToString(),
                                ActorDOB = dr["ActorDOB"].ToString(),
                                ActorGender = dr["ActorGender"].ToString(),
                                ActorImage = dr["ActorImage"].ToString(),
                            });
                        }
                    }
                    return oListActors;
                }
                catch (Exception ex)
                {
                    return oListActors;
                }

            }
        }

        public static Actor Get(int id)
        {
            Actor oActor = new Actor();

            using (SqlConnection oConnection = new SqlConnection(Connection.routeConnection))
            {
                DataTable dt = new DataTable();
                SqlCommand command = new SqlCommand("Select * From tblActor where ActorID = @ActorID", oConnection);


                command.Parameters.AddWithValue("@ActorID", id);
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
                            oActor = new Actor()
                            {
                                ActorID = Convert.ToInt32(dr["ActorID"]),
                                ActorName = dr["ActorName"].ToString(),
                                ActorDOB = dr["ActorDOB"].ToString(),
                                ActorGender = dr["ActorGender"].ToString(),
                                ActorImage = dr["ActorImage"].ToString(),
                            };
                        }
                    }
                    return oActor;
                }
                catch (Exception ex)
                {
                    return oActor;
                }
            }

        }

        public static bool Delete(int id)
        {
            using (SqlConnection oConnection = new SqlConnection(Connection.routeConnection))
            {
                DataTable dt = new DataTable();
                SqlCommand command = new SqlCommand("DELETE From tblActor WHERE ActorID = @ActorID", oConnection);

                command.Parameters.AddWithValue("@ActorID", id);
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