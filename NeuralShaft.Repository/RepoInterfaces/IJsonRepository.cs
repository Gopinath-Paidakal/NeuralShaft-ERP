using System;
using System.Collections.Generic;
using System.Text;

namespace NeuralShaft.Repository.RepoInterfaces
{
    public interface IJsonRepository
    {
        Task<string> ExecuteJsonSPWithParameter(string storedProcedure, object parameters);
        Task<string> ExecuteJsonSPWithoutParameter(string storedProcedure);
    }
}
