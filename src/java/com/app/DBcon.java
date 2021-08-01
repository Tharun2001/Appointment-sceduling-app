/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.app;

import java.sql.*;
public class DBcon {
    private static Connection con;    
    public DBcon(){}
    static{
        try{
            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/java_webapp?useUnicode=true&useJDBCCompliantTimezoneShift=true&useLegacyDatetimeCode=false&serverTimezone=UTC", "root", "");            
        }
        catch(Exception ex){ 
            System.out.print("Error:"+ ex);
        }
    }
    public static Connection getCon(){
        return con;
    }   
}
