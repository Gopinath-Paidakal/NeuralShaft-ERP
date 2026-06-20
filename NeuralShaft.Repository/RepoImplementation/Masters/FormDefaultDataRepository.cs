using Microsoft.EntityFrameworkCore;
//using MyApiProject.Data;
using NeuralShaft.Model;
using NeuralShaft.Repository.RepoInterfaces;
using Microsoft.Data.SqlClient;
using System.Data;
using Microsoft.Extensions.Configuration;
using System.Data.SqlClient;
using NeuralShart.Data;


namespace NeuralShaft.Repository.RepoImplementation
{
    public class FormDefaultDataRepository : IFormDefaultDataRepository
    {
        private readonly IConfiguration _config;
        //private readonly DbConnection _connection;
        //private readonly string _connectionString;
        private readonly DbConnection _connectionFactory;

        public FormDefaultDataRepository(DbConnection connectionFactory)
        {
            _connectionFactory = connectionFactory;
            
        }

        public async Task<string> GetFormDefaultData()
        {
            using var con = _connectionFactory.CreateConnection();
            //using var con = GetConnection();
            using var cmd = new SqlCommand("Sp_FormDefaultData", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@Action", "Get");

            await con.OpenAsync();
            var result = await cmd.ExecuteScalarAsync();
            return result.ToString();
        }

        public async Task<short> InsertFormDefaultData(FormDefaultData formdefaultdata)
        {
            using var con = _connectionFactory.CreateConnection();
            //using var con = GetConnection();
            using var cmd = new SqlCommand("Sp_FormDefaultData", con);

            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@Action", "Insert");
            cmd.Parameters.AddWithValue("@FormDefaultDataType", formdefaultdata.FormDefaultDataType);
            cmd.Parameters.AddWithValue("@FormDefaultDataName", formdefaultdata.FormDefaultDataName);
            cmd.Parameters.AddWithValue("@FormDefaultDataDesc", formdefaultdata.FormDefaultDataDesc);
            cmd.Parameters.AddWithValue("@FormDefaultDataStatus", formdefaultdata.FormDefaultDataStatus);
            cmd.Parameters.AddWithValue("@@FormDefaultDataOrderBy", formdefaultdata.FormDefaultDataOrderBy);

            await con.OpenAsync();
            await cmd.ExecuteNonQueryAsync();

            return 1;
        }

        public async Task<short> UpdateFormDefaultData(FormDefaultData formdefaultdata)
        {
            using var con = _connectionFactory.CreateConnection();
            //using var con = GetConnection();
            using var cmd = new SqlCommand("Sp_FormDefaultData", con);

            cmd.Parameters.AddWithValue("@Action", "Insert");
            cmd.Parameters.AddWithValue("@FormDefaultDataType", formdefaultdata.FormDefaultDataType);
            cmd.Parameters.AddWithValue("@FormDefaultDataName", formdefaultdata.FormDefaultDataName);
            cmd.Parameters.AddWithValue("@FormDefaultDataDesc", formdefaultdata.FormDefaultDataDesc);
            cmd.Parameters.AddWithValue("@FormDefaultDataStatus", formdefaultdata.FormDefaultDataStatus);
            cmd.Parameters.AddWithValue("@@FormDefaultDataOrderBy", formdefaultdata.FormDefaultDataOrderBy);

            await con.OpenAsync();
            await cmd.ExecuteNonQueryAsync();

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