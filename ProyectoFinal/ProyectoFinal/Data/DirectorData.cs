using ProyectoFinal.Models;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

namespace ProyectoFinal.Data
{
    public class DirectorData
    {
        public static bool Create(Director oDirector)
        {
            using (SqlConnection oConnection = new SqlConnection(Connection.routeConnection))
            {
                DataTable dt = new DataTable();
                SqlCommand command = new SqlCommand("INSERT INTO tblDirector (DirectorName, DirectorDOB, DirectorGender, DirectorImage) VALUES (@DirectorName,@DirectorDOB,@DirectorGender,@DirectorImage)", oConnection);

                //command.Parameters.AddWithValue("@id", oMovie.id);
                command.Parameters.AddWithValue("@DirectorName", oDirector.DirectorName);
                command.Parameters.AddWithValue("@DirectorDOB", oDirector.DirectorDOB);
                command.Parameters.AddWithValue("@DirectorGender", oDirector.DirectorGender);
                command.Parameters.AddWithValue("@DirectorImage", oDirector.DirectorImage);


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

        public static bool Modify(Director oDirector)
        {
            using (SqlConnection oConnection = new SqlConnection(Connection.routeConnection))
            {
                DataTable dt = new DataTable();
                SqlCommand command = new SqlCommand("UPDATE tblDirector set DirectorName = @DirectorName, DirectorDOB = @DirectorDOB, DirectorGender = @DirectorGender, DirectorImage = @DirectorImage WHERE DirectorID = @DirectorID", oConnection);

                command.Parameters.AddWithValue("@DirectorID", oDirector.DirectorID);
                command.Parameters.AddWithValue("@DirectorName", oDirector.DirectorName);
                command.Parameters.AddWithValue("@DirectorDOB", oDirector.DirectorDOB);
                command.Parameters.AddWithValue("@DirectorGender", oDirector.DirectorGender);
                command.Parameters.AddWithValue("@DirectorImage", oDirector.DirectorImage);

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

        public static List<Director> ListDirectors()
        {
            List<Director> oListDirectors = new List<Director>();

            using (SqlConnection oConnection = new SqlConnection(Connection.routeConnection))
            {
                DataTable dt = new DataTable();
                SqlCommand command = new SqlCommand("Select DirectorID, DirectorName, DirectorDOB, DirectorGender, DirectorImage From tblDirector ORDER BY DirectorDOB ASC", oConnection);
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
                            oListDirectors.Add(new Director()
                            {
                                DirectorID = Convert.ToInt32(dr["DirectorID"]),
                                DirectorName = dr["DirectorName"].ToString(),
                                DirectorDOB = dr["DirectorDOB"].ToString(),
                                DirectorGender = dr["DirectorGender"].ToString(),
                                DirectorImage = dr["DirectorImage"].ToString(),
                            });
                        }
                    }
                    return oListDirectors;
                }
                catch (Exception ex)
                {
                    return oListDirectors;
                }

            }
        }

        public static Director Get(int id)
        {
            Director oDirector = new Director();

            using (SqlConnection oConnection = new SqlConnection(Connection.routeConnection))
            {
                DataTable dt = new DataTable();
                SqlCommand command = new SqlCommand("Select * From tblDirector where DirectorID = @DirectorID", oConnection);


                command.Parameters.AddWithValue("@DirectorID", id);
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
                            oDirector = new Director()
                            {
                                DirectorID = Convert.ToInt32(dr["DirectorID"]),
                                DirectorName = dr["DirectorName"].ToString(),
                                DirectorDOB = dr["DirectorDOB"].ToString(),
                                DirectorGender = dr["DirectorGender"].ToString(),
                                DirectorImage = dr["DirectorImage"].ToString(),
                            };
                        }
                    }
                    return oDirector;
                }
                catch (Exception ex)
                {
                    return oDirector;
                }
            }

        }

        public static bool Delete(int id)
        {
            using (SqlConnection oConnection = new SqlConnection(Connection.routeConnection))
            {
                DataTable dt = new DataTable();
                SqlCommand command = new SqlCommand("DELETE From tblDirector WHERE DirectorID = @DirectorID", oConnection);

                command.Parameters.AddWithValue("@DirectorID", id);
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