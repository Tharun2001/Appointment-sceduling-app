/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.app;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author tharu
 */
@WebServlet(name = "Register", urlPatterns = {"/Register"})
public class Register extends HttpServlet {
    Connection con = DBcon.getCon();
    Statement st = null; 
    ResultSet rs = null;    
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("register.html").include(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {        
        String type = request.getParameter("login-type");
        String uname = request.getParameter("username");
        String pass = request.getParameter("password");
        PrintWriter out = response.getWriter();
        
        if(type.equals("customer")){
            if(!custExists(uname))
                customer(uname, pass, request, response);
            else
                processRequest(request, response);    
        }
        else if(type.equals("store") && !storeExists(uname)){
            if(!storeExists(uname))
                store(uname, pass, request, response);                
            else
                processRequest(request, response);             
        }
        
        
    }
    void customer(String uname, String pass, HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException{
        try {
            String qry = "insert into users (uname, password)" + " values (?, ?)";
            PreparedStatement ps = con.prepareStatement(qry);
            ps.setString(1,uname);
            ps.setString(2,pass);
            ps.execute();
            Login login = new Login();
            login.customer(uname, pass, request, response);
        } catch (SQLException ex) {
        }
        
    }
    
    void store(String aname, String apass, HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException{
        try {
            String qry = "insert into store (aname, apassword)" + " values (?, ?)";
            PreparedStatement ps = con.prepareStatement(qry);
            ps.setString(1,aname);
            ps.setString(2,apass);
            ps.execute();
            Login login = new Login();
            login.store(aname, apass, request, response);        
        } catch (SQLException ex) {
        }    
    }
    
    boolean custExists(String uname){
        String qry = "select * from users where uname='"+uname+"'";
        Connection con = DBcon.getCon();
        try {
            Statement st = con.createStatement();
            ResultSet rs = st.executeQuery(qry);
            if(rs.next()){
                return true;
            }
        } catch (SQLException ex) {
            
        }
        return false;
    }

    boolean storeExists(String aname){
        String qry = "select * from store where aname='"+aname+"'";
        Connection con = DBcon.getCon();
        try {
            Statement st = con.createStatement();
            ResultSet rs = st.executeQuery(qry);
            if(rs.next()){
                return true;
            }
        } catch (SQLException ex) {
            
        }
        return false;
    }
    

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet DevRender</title>");            
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Username already exists.</h1>");
            out.println("<a href=\"Register\">Go back to register</a>");
            out.println("</body>");
            out.println("</html>");
        }
    }    
}
