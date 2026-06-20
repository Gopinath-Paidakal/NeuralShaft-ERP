using Microsoft.Data.SqlClient;
using Microsoft.Extensions.Configuration;
using System;
using System.Collections.Generic;
using System.Text;

namespace NeuralShart.Data
{
    public  class DbConnection
    {
        private readonly IConfiguration _configuration;

        public DbConnection(IConfiguration configuration)
        {
            _configuration = configuration;
        }

        public SqlConnection CreateConnection()
        {
            return new SqlConnection(_configuration.GetConnectionString("conn"));

            //return new SqlConnection(_configuration.GetConnectionString("Server=GOPINATH\\\\SQLSERVER2022;Database=NSHAFTERPDB;User Id=sa;Password=mount4523;TrustServerCertificate=true"));
        }
    }
}
