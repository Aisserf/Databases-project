/* This is the driving engine of the program. It parses the command-line
 * arguments and calls the appropriate methods in the other classes.
 *
 * You should edit this file in two ways:
 * 1) Insert your database username and password in the proper places.
 * 2) Implement the three functions getInformation, registerStudent
 *    and unregisterStudent.
 */
import java.sql.*; // JDBC stuff.
import java.util.Properties;
import java.util.Scanner;
import java.io.*;  // Reading user input.

public class StudentPortal
{
    /* TODO Here you should put your database name, username and password */
    static final String USERNAME = "tda357_050";
    static final String PASSWORD = "CFpcVCwU";

    /* Print command usage.
     * /!\ you don't need to change this function! */
    public static void usage () {
        System.out.println("Usage:");
        System.out.println("    i[nformation]");
        System.out.println("    r[egister] <course>");
        System.out.println("    u[nregister] <course>");
        System.out.println("    q[uit]");
    }

    /* main: parses the input commands.
     * /!\ You don't need to change this function! */
    public static void main(String[] args) throws Exception
    {
        try {
            Class.forName("org.postgresql.Driver");
            String url = "jdbc:postgresql://ate.ita.chalmers.se/";
            Properties props = new Properties();
            props.setProperty("user",USERNAME);
            props.setProperty("password",PASSWORD);
            Connection conn = DriverManager.getConnection(url, props);

            String student = args[0]; // This is the identifier for the student.

            Console console = System.console();
	    // In Eclipse. System.console() returns null due to a bug (https://bugs.eclipse.org/bugs/show_bug.cgi?id=122429)
	    // In that case, use the following line instead:
	    // BufferedReader console = new BufferedReader(new InputStreamReader(System.in));
            usage();
            System.out.println("Welcome!");
            while(true) {
	        System.out.print("? > ");
                String mode = console.readLine();
                String[] cmd = mode.split(" +");
                cmd[0] = cmd[0].toLowerCase();
                if ("information".startsWith(cmd[0]) && cmd.length == 1) {
                    /* Information mode */
                    getInformation(conn, student);
                } else if ("register".startsWith(cmd[0]) && cmd.length == 2) {
                    /* Register student mode */
                    registerStudent(conn, student, cmd[1]);
                } else if ("unregister".startsWith(cmd[0]) && cmd.length == 2) {
                    /* Unregister student mode */
                    unregisterStudent(conn, student, cmd[1]);
                } else if ("quit".startsWith(cmd[0])) {
                    break;
                } else usage();
            }
            System.out.println("Goodbye!");
            conn.close();
        } catch (SQLException e) {
            System.err.println(e);
            System.exit(2);
        }
    }

    /* Given a student identification number, ths function should print
     * - the name of the student, the students national identification number
     *   and their issued login name (something similar to a CID)
     * - the programme and branch (if any) that the student is following.
     * - the courses that the student has read, along with the grade.
     * - the courses that the student is registered to. (queue position if the student is waiting for the course)
     * - the number of mandatory courses that the student has yet to read.
     * - whether or not the student fulfills the requirements for graduation
     */
    static void getInformation(Connection conn, String student) throws SQLException
    {
        // TODO: Your implementation here
      try {	
      //where to get the info
      String info1 = ("SELECT * FROM studentsfollowing WHERE studentsfollowing.stud_id = ?");
      String info21 = ("SELECT * FROM finishedcourses WHERE finishedcourses.stud_id = ?");
      String info22 = ("SELECT * FROM registrations LEFT JOIN waiting_list on registrations.course_code = waiting_list.course_code WHERE registrations.stud_id = ?");
      String info3 = ("SELECT * FROM pathtograduation WHERE student = ?");

      //create the statements
      PreparedStatement statementInfo1 = conn.prepareStatement(info1);
      PreparedStatement statementInfo21 = conn.prepareStatement(info21);
      PreparedStatement statementInfo22 = conn.prepareStatement(info22);
      PreparedStatement statementInfo3 = conn.prepareStatement(info3);

      //the first argument will be the student
      statementInfo1.setString(1, student);
      statementInfo21.setString(1, student);
      statementInfo22.setString(1, student);
      statementInfo3.setString(1, student);

      //retrieve the information
      ResultSet msi = statementInfo1.executeQuery();  //msi = myStudentInfo
      ResultSetMetaData rsmd = msi.getMetaData();
//      int howManyColumns = rsmd.getcolumnCount();

      msi.next();
      System.out.println("Name: " + msi.getString("stud_name"));
      System.out.println("Student ID :" + msi.getString("stud_id"));
      System.out.println("Program: " + msi.getString("prog_name"));
      System.out.println("Branch: " + msi.getString("branch_name"));

      msi = statementInfo21.executeQuery();
      rsmd = msi.getMetaData();
      System.out.println("Read Courses (course credits grade)");
        while (msi.next()) {
          System.out.println(
          msi.getString("stud_id") + msi.getString("course_name") + 
          msi.getString("credits") + ", " + msi.getString("grade"));
        }

      msi = statementInfo22.executeQuery();
      rsmd = msi.getMetaData();
        while(msi.next()) {
          System.out.println("Registered courses (name, code, status):" +
          msi.getString("course_code") + msi.getString("course_code") + 
          msi.getString("status"));

            if (msi.getString("status") == "Waiting") {
              System.out.println(" as nr " + msi.getString("position"));
            }
        }

      msi = statementInfo3.executeQuery();
      rsmd = msi.getMetaData();
        while(msi.next()) {
          System.out.println("Seminar courses taken:" + msi.getString("seminarcourses"));	
          System.out.println("Math credits taken: " + msi.getString("mathcredits"));
          System.out.println("Research credits taken: " + msi.getString("researchcredits"));
          System.out.println("Total credits taken: " + msi.getString("credits"));
          System.out.println("Fulfill the requrements for graduation: " + msi.getString("graduatable"));
        }
      }catch (SQLException error){
        System.out.println(error.getMessage());
      }
     }


    /* Register: Given a student id number and a course code, this function
     * should try to register the student for that course.
     */
    static void registerStudent(Connection conn, String student, String course)
    throws SQLException
    {
        // TODO: Your implementation here
      try{
       PreparedStatement toReg = conn.prepareStatement("INSERT INTO registrations(stud_id, course_code) VALUES (?, ?)");
       toReg.setString(1, student);
       toReg.setString(2, course);
       toReg.executeUpdate();
      }catch(SQLException error) {
        if (error.getMessage().contains("-")) {
          System.out.println("Success hohoohoho");
        } else 
        System.out.println(error.getMessage());
      }

    }

    /* Unregister: Given a student id number and a course code, this function
     * should unregister the student from that course.
     */
    static void unregisterStudent(Connection conn, String student, String course)
    throws SQLException
    {
        // TODO: Your implementation here
      try{
        PreparedStatement toUnreg = conn.prepareStatement("DELETE FROM registrations WHERE stud_id = ? AND course_code = ?;");
        toUnreg.setString(1, student);
        toUnreg.setString(2, course);
        toUnreg.executeQuery();
      }catch(SQLException error) {
        if (error.getMessage().contains(/*"No results were returned by the query."*/ "-")) {
          System.out.println("Success hohoohoho");
        } else 
        System.out.println(error.getMessage());
      }
    }
}
