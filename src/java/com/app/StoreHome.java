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
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author tharu
 */
public class StoreHome extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        response.setContentType("text/html");
        PrintWriter out=response.getWriter();  
        if(session != null && session.getAttribute("sid") != null){
                request.getRequestDispatcher("storeHome.jsp").include(request, response);
        }
        else{
            response.sendRedirect("Login");
        }
        out.close();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String aname = request.getParameter("aname");
        String sname = request.getParameter("sname");
        String stype = request.getParameter("stype");
        String addr = request.getParameter("addr");
        String capacity = request.getParameter("capacity");
        String pass = request.getParameter("pass");
        String sid = request.getParameter("sid");
        int first_time = Integer.parseInt(request.getParameter("first_time"));
        int last_time = Integer.parseInt(request.getParameter("last_time"));
        PrintWriter out = response.getWriter();
        Connection con = DBcon.getCon();
        if(!storeExists(aname, sid)){
            try {
                String qry = "UPDATE store set aname='"+aname+"', sname='"+sname+"', stype='"+stype+"', addr='"+addr+"', capacity='"+capacity+"', first_time="+first_time+", last_time="+last_time+", apassword='"+pass+"'"+                   
                             " WHERE sid="+sid;
                Statement st = con.createStatement();
                st.execute(qry);
                out.print("success");
                delOut(first_time, last_time, sid);
            } catch (SQLException ex) {
                out.print("error");
            }
        }
        else{
            out.print("username already exists.");
        }
    }
    
    boolean storeExists(String aname, String sid){
        String qry = "select * from store where aname='"+aname+"' and sid!="+sid;
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
    
    void delOut(int first_time, int last_time, String sid) {
        String qry = "delete from appoint where (ntime<"+first_time+" or ntime>"+last_time+") and sid="+sid;
        Connection con = DBcon.getCon();
        try {
            Statement st = con.createStatement();
            st.execute(qry);
        } catch (SQLException ex) {
        }
    }    
}
