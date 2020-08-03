using System;
using System.Collections.Generic;

namespace SIH_Dashboard
{
    public static class GlobalUser
    {
        public static string Name { get; set; }
        public static string UID { get; set; }
        public static bool IsVerified { get; set; }
        public static string Email { get; set; }
        public static Roles Role { get; set; }
    }
    public class UserData
    {
        public string Id { get; set; }
        public string Name { get; set; }
        public long Phone { get; set; }
        public Roles Role { get; set; }
        public string DOB { get; set; }
        public bool Male { get; set; }
        public string Email { get; set; }
        public bool RoleVerified { get; set; }
    }

    public enum Roles
    {
        Admin, VisitingOfficial, Teacher, Student, Parent
    }

    public class Schools
    {
        public string Id { get; set; }
        public string Name { get; set; }
        public string Address { get; set; }
        public double Latitude { get; set; }
        public double Longitude { get; set; }
        public string District { get; set; }
        public CategoryScores CategoryScores { get; set; }
        public CategoryScores CategoryScoresStudent { get; set; }
    }
    public class CategoryScores
    {
        public int Safety { get; set; }
        public int Academics { get; set; }
        public int Health { get; set; }
        public int Discipline { get; set; }
        public int Meals { get; set; }
        public int Activities { get; set; }
        public int All { get; set; }
    }

    public class Feedbacks
    {
        public string Id { get; set; }
        public string Date { get; set; }
        public int SchoolCode { get; set; }
        public string SubmitterId { get; set; }
        public string Notes { get; set; }
        public string Feedback { get; set; }
        public string SentimentScore { get; set; }
        public bool Verified { get; set; }
    }
    public class StudentRecord
    {
        public int Session { get; set; }
        public int Class { get; set; }
        public int SchoolCode { get; set; }
        public int RollNumber { get; set; }
    }
    public class TeacherRecord
    {
        public int Session { get; set; }
        public int Class { get; set; }
        public int SchoolCode { get; set; }
        public int TeacherId { get; set; }
        public DateTime UploadedTodays { get; set; }
        public string Subjects { get; set; }
    }
    public class StudentAttendance
    {
        public List<SubjectAttendance> SubjectAttendance { get; set; }
    }
    public class SubjectAttendance
    {
        public string SubjectName { get; set; }
        public int TotalClasses { get; set; }
        public int TotalPresent { get; set; }
        public int RollNumber { get; set; }
        public bool Todays { get; set; }
    }


    public class Appointment
    {
        public string SchoolCode { get; set; }
        public string Date { get; set; }
    }
    public class VistorDummy
    {
        public bool verified { get; set; }
    }

    public class Problem
    {
        public Roles UploaderRole { get; set; }
        public string Uid { get; set; }
        public string Title { get; set; }
        public string ProblemStatement { get; set; }
        public bool IsClosedStatus { get; set; }
        public DateTime CloseDateTime { get; set; }
        public string CloseStudent { get; set; }
        public bool IsAnonymous { get; set; }
    }

    public class SchoolProblem
    {
        public string Title { get; set; }
        public string Description { get; set; }
        public string Uid { get; set; }
        public int OpenStatus { get; set; } = 1;
        public DateTime CreatedDate { get; set; }
        public DateTime CloseDate { get; set; }
        public bool isAnonymous { get; set; }
    }
    public class QuizQuestion
    {
        public string id { get; set; }
        public string question { get; set; }
        public bool TrueFalse { get; set; } = false;
    }

}
