using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace NeuralShaft.Model
{
    public class Department
    {
        [Key]
        public int DeptId { get; set; }

        //[Required]
        ////[Range(0, int.MaxValue, ErrorMessage = "Please enter valid integer Number")]
        ////[Range(0, int.MaxValue)]
        //[Range(0, 99999)]
        ////[MaxLength(5)]
        //[Column(TypeName = "int")]
        //public int? DeptSlno { get; set; }

        [Required]
        [MaxLength(150)]
        [Column(TypeName = "varchar(100)")]
        public string? DeptCode { get; set; }

        [Required]
        [MaxLength(100)]
        [Column(TypeName = "varchar(100)")]
        public string? DeptName { get; set; } = "";

        [Required]
        [MaxLength(100)]
        [Column(TypeName = "varchar(100)")]
        public string? DeptDescription { get; set; } = "";

    }
}
