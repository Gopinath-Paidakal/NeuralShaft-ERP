using Microsoft.EntityFrameworkCore;
//using MyApiProject.Data;
//using NeuralShaft.Model;
using NeuralShaft.Repository.RepoInterfaces;
using Microsoft.Data.SqlClient;
using System.Data;
using Microsoft.Extensions.Configuration;
using NeuralShaft.Data;
using Dapper;

namespace NeuralShaft.Repository.RepoImplementation
{
    public class JsonRepository : IJsonRepository
    {
        private readonly IConfiguration _config;
        //private readonly DbConnection _connectionFactory;

        public JsonRepository(IConfiguration config)
        {
            _config = config;
        }
             
        public async Task<string> ExecuteJsonSPWithParameter(string storedProcedure, object parameters)
        {
            using var connection = new SqlConnection(
            _config.GetConnectionString("conn"));

            var result = await connection.ExecuteScalarAsync<string>(
                storedProcedure,
                parameters,
                commandType: CommandType.StoredProcedure
            );

            return result;
            //return result?.ToString() ?? "{}";
        }

        public async Task<string> ExecuteJsonSPWithoutParameter(string storedProcedure)
        {
            using var connection = new SqlConnection(
            _config.GetConnectionString("conn"));

            var result1 = await connection.ExecuteScalarAsync<string>(
               storedProcedure,
               commandType: CommandType.StoredProcedure
           );

            return result1;
            //return result?.ToString() ?? "{}";
        }


    }
    
}


//public async Task<string> ExecuteJsonSPWithoutParameter(string storedProcedure)
//{
//    using var connection = new SqlConnection(_config.GetConnectionString("conn"));
//    await connection.OpenAsync();

//    using var command = new SqlCommand(storedProcedure, connection);
//    command.CommandType = CommandType.StoredProcedure;

//    // CommandBehavior.SequentialAccess allows efficient streaming of large columns
//    using var reader = await command.ExecuteReaderAsync(CommandBehavior.SequentialAccess);

//    if (await reader.ReadAsync())
//    {
//        // Read the first column, which contains your JSON string
//        return reader.GetString(0);
//    }

//    return "{}"; // Default empty JSON if no data
//}
