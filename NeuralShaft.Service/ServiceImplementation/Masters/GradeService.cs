using NeuralShaft.Repository.RepoInterfaces;
using NeuralShaft.Service.ServiceInterfaces.Masters;
using System;
using System.Collections.Generic;
using System.Text;

namespace NeuralShaft.Service.ServiceImplementation.Masters
{
    public class GradeService : IGrade
    {
        private readonly IJsonRepository _repoJSon;

        public GradeService(IJsonRepository repoJson)
        {
            _repoJSon = repoJson;
        }

        public async Task<string> GetGrade()
        {
            try
            {
                string GetGrade = await _repoJSon.ExecuteJsonSPWithoutParameter("SP_getGrade");
                return GetGrade;
            }
            catch (Exception ex)
            {
                // log error

                Console.WriteLine(ex.Message);
                throw;
            }
        }

        public async Task<string> GetGradeById(int gradeId)
        {
            try
            {
                string GetGradeById = await _repoJSon.ExecuteJsonSPWithParameter("SP_GetGradeById", new { @GradeId = gradeId });
                return GetGradeById;
            }
            catch (Exception ex)
            {
                // log error

                Console.WriteLine(ex.Message);
                throw; // rethrow to controller
            }
        }

        public async Task<string> InsertGrade(object grade)
        {
            try
            {
                string insertGrade = await _repoJSon.ExecuteJsonSPWithParameter("SP_InsertGrade", new { @Grade = grade.ToString() });
                return (insertGrade);

            }
            catch (Exception ex)
            {
                // log error
                Console.WriteLine(ex.Message);
                throw;
            }
        }

        public async Task<string> UpdateGrade(int gradeId, object grade)
        {
            try
            {
                string updateGrade = await _repoJSon.ExecuteJsonSPWithParameter("SP_UpdateGrade", new { @GradeId = gradeId, @Grade = grade.ToString() });
                return (updateGrade);

            }
            catch (Exception ex)
            {
                // log error
                Console.WriteLine(ex.Message);
                throw; // rethrow to controller
            }

        }

        public async Task<string> DeleteGrade(int gradeId)
        {
            throw new NotImplementedException();
        }
    }
}
