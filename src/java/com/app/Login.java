/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.app;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.sql.*;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author tharu
 */
public class Login extends HttpServlet {
    
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
            out.println("<h1>Invalid credentials.</h1>");
            out.println("<a href=\"Login\">Go back to Login.</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("login.html").include(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if(session != null){
            session.invalidate();
        }
        String type = request.getParameter("login-type");
        String uname = request.getParameter("username");
        String pass = request.getParameter("password");
        if(type == null || uname == null || pass == null){
            processRequest(request,response);
        }
        else{
                if(type.equals("customer")){
                    customer(uname, pass, request, response);
                }
                else{
                    store(uname, pass, request, response);
                }
        }

    }
    
    void customer(String uname, String pass, HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException{
        String qry = "select * from users where uname='"+uname+"' and password='"+pass+"'";
        Connection con = DBcon.getCon();
        try {
            Statement st = con.createStatement();
            ResultSet rs = st.executeQuery(qry);
            if(rs.next()){
                HttpSession session = request.getSession(true);
                session.setAttribute("uname",uname);
                session.setAttribute("uid",rs.getString("uid"));
                response.sendRedirect("Home");
            }
            else{
                response.sendRedirect("Login");
            }
        } catch (SQLException ex) {
            
        }
    }
    
    void store(String aname, String apass, HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException{
        String qry = "select sid,aname,apassword from store where aname='"+aname+"' and apassword='"+apass+"'";
        Connection con = DBcon.getCon();
        try {
            Statement st = con.createStatement();
            ResultSet rs = st.executeQuery(qry);
            if(rs.next()){
                HttpSession session = request.getSession(true);
                session.setAttribute("aname",aname);
                session.setAttribute("sid",rs.getString("sid"));
                response.sendRedirect("StoreHome");
            }
            else{
                response.sendRedirect("Login");
            }
        } catch (SQLException ex) {
            
        }
    }
}
