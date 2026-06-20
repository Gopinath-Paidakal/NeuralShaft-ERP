using Microsoft.EntityFrameworkCore;
//using MyApiProject.Data;
using NeuralShaft.Model;
using NeuralShaft.Repository.RepoInterfaces;
using Microsoft.Data.SqlClient;
using System.Data;
using Microsoft.Extensions.Configuration;
using System.Data.SqlClient;
using NeuralShart.Data;
using Newtonsoft.Json;


namespace NeuralShaft.Repository.RepoImplementation
{
    public class EnquiryRepository : IEnquiryRepository
    {
        private readonly IConfiguration _config;
        //private readonly DbConnection _connection;
        //private readonly string _connectionString;
        private readonly DbConnection _connectionFactory;

        public EnquiryRepository(DbConnection connectionFactory)
        {
            _connectionFactory = connectionFactory;
            
        }

        public async Task<string> GetEnquiry()
        {
            using var con = _connectionFactory.CreateConnection();
            //using var con = GetConnection();
            using var cmd = new SqlCommand("SP_GetEnquiry", con);
            cmd.CommandType = CommandType.StoredProcedure;
            //cmd.Parameters.AddWithValue("@EnquiryId", enquiryId);

            await con.OpenAsync();
            var result = await cmd.ExecuteScalarAsync();
            return result.ToString();
        }
       
        public async Task<string> GetEnquiryById(int enquiryId)
        {
            using var con = _connectionFactory.CreateConnection();
            //using var con = GetConnection();
            using var cmd = new SqlCommand("SP_GetEnquiry_ById", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@EnquiryId", enquiryId);

            await con.OpenAsync();
            var result = await cmd.ExecuteScalarAsync();
            return result.ToString();
        }

        public async Task<string> GetEnquiryFollowUp()
        {
            using var con = _connectionFactory.CreateConnection();
            //using var con = GetConnection();
            using var cmd = new SqlCommand("SP_EnqFollowUp", con);
            cmd.CommandType = CommandType.StoredProcedure;
            //cmd.Parameters.AddWithValue("@EnquiryId", enquiryId);

            await con.OpenAsync();
            var result = await cmd.ExecuteScalarAsync();
            return result.ToString();
        }

        public async Task<string> InsertEnquiry(object enqdata)
        {
            try
            {
                using var con = _connectionFactory.CreateConnection();
                using var cmd = new SqlCommand("Sp_InsertEnquiry", con);
                cmd.CommandType = CommandType.StoredProcedure;

                //var json = JsonConvert.SerializeObject(data);

                //cmd.Parameters.AddWithValue("@Enquiry", json);
                //string test = json;
                //var length = json.Length;
                cmd.Parameters.AddWithValue("@Enquiry", enqdata.ToString());   // working
                //cmd.Parameters.Add("@Enquiry", SqlDbType.NVarChar, -1).Value = data.ToString();  // this also works

                //string debugSql = GetSqlCommand(cmd);

                //System.Diagnostics.Debug.WriteLine(debugSql);

                await con.OpenAsync();

                //var result = await cmd.ExecuteNonQueryAsync();   // returns no of rows - works
                var result = await cmd.ExecuteScalarAsync();       // return the value from sql table - works

                //return Convert.ToInt16(result);
                return result.ToString();
            }
            catch (Exception ex)
            {
                throw ex;
                //MessageBox.Show("1 : " + this.Name.ToString() + "\n" + "2 : " + ex.TargetSite.ToString() + "\n" + "3 : " + ex.Message);
            }
            
        }

        public async Task<short> UpdateEnquiry(object enqdata)
        {
            using var con = _connectionFactory.CreateConnection();
            using var cmd = new SqlCommand("SP_UpdateEnquiry", con);
            cmd.CommandType = CommandType.StoredProcedure;
            
            cmd.Parameters.AddWithValue("@Enquiry", enqdata.ToString());   // working
             
            await con.OpenAsync();

            //var result = await cmd.ExecuteNonQueryAsync();   // returns no of rows - works
            var result = await cmd.ExecuteScalarAsync();       // return the value from sql table - works

            //return Convert.ToInt16(result);
            //return result.ToString();

            return 1;
        }
    }
}

//public async Task<short> DeleteDepartment(int id)
//{
//    using var con = _connectionFactory.CreateConnection();
//    //using var con = GetConnection();
//    using var cmd = new SqlCommand("P_DEPARTMENT_DELETE", con);

//    cmd.CommandType = CommandType.StoredProcedure;
//    cmd.Parameters.AddWithValue("@DeptId", id);

//    await con.OpenAsync();
//    await cmd.ExecuteNonQueryAsync();

//    return 1;
//}

//private SqlConnection GetConnection()
//{
//    //return new SqlConnection(_config.GetConnectionString("DbConnection"));
//    return new SqlConnection.CreateConnection();
//    //return new config.GetConnectionString("DbConnection");
//}

//public async Task<short> GetDepartmentById(int id)
//{
//    using var con = _connectionFactory.CreateConnection();
//    //using var con = GetConnection();
//    using var cmd = new SqlCommand("P_DEPARTMENT_BYID", con);

//    cmd.CommandType = CommandType.StoredProcedure;
//    cmd.Parameters.AddWithValue("@DeptId", id);

//    await con.OpenAsync();
//    await cmd.ExecuteNonQueryAsync();

//    return 1;
//}

//public Task<Department> GetById(int id)
//{
//    throw new NotImplementedException();
//}

//public DepartmentRepository(IConfiguration config)
//{
//    _config = config;
//    //config.GetConnectionString("DbConnection");

//}

//cmd.Parameters.Add("@Enquiry", SqlDbType.NVarChar, -1).Value = json;
////cmd.Parameters.Add("@Id", SqlDbType.Int).Direction = ParameterDirection.Output;
//await con.OpenAsync();

//var result = await cmd.ExecuteScalarAsync(); 

//return Convert.ToInt16(result);
//return id = Convert.ToInt32(cmd.Parameters["@Id"].Value);



//cmd.Parameters.AddWithValue("@Action", "Insert");
//cmd.Parameters.AddWi//thValue("@FormDefaultDataType", formdefaultdata.FormDefaultDataType);
//cmd.Parameters.AddWithValue("@FormDefaultDataName", formdefaultdata.FormDefaultDataName);
//cmd.Parameters.AddWithValue("@FormDefaultDataDesc", formdefaultdata.FormDefaultDataDesc);
//cmd.Parameters.AddWithValue("@FormDefaultDataStatus", formdefaultdata.FormDefaultDataStatus);
//cmd.Parameters.AddWithValue("@@FormDefaultDataOrderBy", formdefaultdata.FormDefaultDataOrderBy);

//public static string GetSqlCommand(SqlCommand cmd)
//{
//    var sql = cmd.CommandText;

//    foreach (SqlParameter param in cmd.Parameters)
//    {
//        sql += $"\n{param.ParameterName} = {param.Value}";
//    }

//    return sql;
//}
//public async Task<short> InsertEnquiry(object data)
//{
//    using var con = _connectionFactory.CreateConnection();
//    //using var con = GetConnection();
//    using var cmd = new SqlCommand("Sp_InsertEnquiry", con);
//    cmd.CommandType = CommandType.StoredProcedure;

//    var json = JsonConvert.SerializeObject(data);
//    cmd.Parameters.AddWithValue("@Enquiry", json);

//    await con.OpenAsync();
//    //await cmd.ExecuteNonQueryAsync();
//    //await cmd.ExecuteScalarAsync();

//    var  result = await cmd.ExecuteScalarAsync();

//    return Convert.ToInt32(result);

//    return 1;
//    //return Convert.ToInt32(result);
//}

//cmd.Parameters.AddWithValue("@Action", "Insert");
//cmd.Parameters.AddWithValue("@FormDefaultDataType", formdefaultdata.FormDefaultDataType);
//cmd.Parameters.AddWithValue("@FormDefaultDataName", formdefaultdata.FormDefaultDataName);
//cmd.Parameters.AddWithValue("@FormDefaultDataDesc", formdefaultdata.FormDefaultDataDesc);
//cmd.Parameters.AddWithValue("@FormDefaultDataStatus", formdefaultdata.FormDefaultDataStatus);
//cmd.Parameters.AddWithValue("@@FormDefaultDataOrderBy", formdefaultdata.FormDefaultDataOrderBy);