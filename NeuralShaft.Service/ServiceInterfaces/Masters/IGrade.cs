using System;
using System.Collections.Generic;
using System.Text;

namespace NeuralShaft.Service.ServiceInterfaces.Masters
{
    public interface IGrade
    {
        Task<string> GetGrade();
        Task<string> GetGradeById(int gradeId);
        Task<string> InsertGrade(object grade);
        Task<string> UpdateGrade(int gradeId, object grade);
        Task<string> DeleteGrade(int gradeId);
    }
}
