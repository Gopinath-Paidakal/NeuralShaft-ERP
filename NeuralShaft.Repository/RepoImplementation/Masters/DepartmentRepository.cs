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
    public class DepartmentRepository : IDepartmentRepository
    {
        private readonly IConfiguration _config;
        //private readonly DbConnection _connection;
        //private readonly string _connectionString;
        private readonly DbConnection _connectionFactory;

        //public DepartmentRepository(IConfiguration config)
        //{
        //    _config = config;
        //    //config.GetConnectionString("DbConnection");

        //}

        public DepartmentRepository(DbConnection connectionFactory)
        {
            _connectionFactory = connectionFactory;
            
        }

        //private SqlConnection GetConnection()
        //{
        //    //return new SqlConnection(_config.GetConnectionString("DbConnection"));
        //    return new SqlConnection.CreateConnection();
        //    //return new config.GetConnectionString("DbConnection");
        //}

        public async Task<string> GetAllDepartments()
        {
            using var con = _connectionFactory.CreateConnection();
            //using var con = GetConnection();
            using var cmd = new SqlCommand("P_DEPARTMENT", con);
            cmd.CommandType = CommandType.StoredProcedure;

            await con.OpenAsync();
            var result = await cmd.ExecuteScalarAsync();
            return result.ToString();
        }

        //public Task<Department> GetById(int id)
        //{
        //    throw new NotImplementedException();
        //}

        public async Task<short> InsertDetpartment(Department department)
        {
            using var con = _connectionFactory.CreateConnection();
            //using var con = GetConnection();
            using var cmd = new SqlCommand("P_DEPARTMENT_INSERT", con);

            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@DeptCode", department.DeptCode);
            cmd.Parameters.AddWithValue("@DepartmentName", department.DeptName);
            cmd.Parameters.AddWithValue("@DepartmentDescription", department.DeptDescription);

            await con.OpenAsync();
            await cmd.ExecuteNonQueryAsync();

            return 1;
        }

        public async Task<short> UpdateDepartment(Department department)
        {
            using var con = _connectionFactory.CreateConnection();
            //using var con = GetConnection();
            using var cmd = new SqlCommand("P_DEPARTMENT_UPDATE", con);

            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@DeptId", department.DeptId);
            cmd.Parameters.AddWithValue("@DepartmentCode", department.DeptCode);
            cmd.Parameters.AddWithValue("@DepartmentName", department.DeptName);
            cmd.Parameters.AddWithValue("@DepartmentDescription", department.DeptDescription);

            await con.OpenAsync();
            await cmd.ExecuteNonQueryAsync();

            return 1;
        }

        public async Task<short> DeleteDepartment(int id)
        {
            using var con = _connectionFactory.CreateConnection();
            //using var con = GetConnection();
            using var cmd = new SqlCommand("P_DEPARTMENT_DELETE", con);

            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@DeptId", id);

            await con.OpenAsync();
            await cmd.ExecuteNonQueryAsync();

            return 1;
        }

        public async Task<short> GetDepartmentById(int id)
        {
            using var con = _connectionFactory.CreateConnection();
            //using var con = GetConnection();
            using var cmd = new SqlCommand("P_DEPARTMENT_BYID", con);

            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@DeptId", id);

            await con.OpenAsync();
            await cmd.ExecuteNonQueryAsync();

            return 1;
        }
    }
}
