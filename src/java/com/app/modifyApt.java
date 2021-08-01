/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.app;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.sql.*;
import javax.servlet.http.HttpSession;

@WebServlet(name = "modifyApt", urlPatterns = {"/modifyApt"})
public class modifyApt extends HttpServlet {
    Connection con = DBcon.getCon();
    Statement st = null; 
    ResultSet rs = null;
    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response, int val)
            throws ServletException, IOException {
        try (PrintWriter out = response.getWriter()) {
            if(val == 1){
                out.print("Success");    
            }
            else{
                out.print("Failure"); 
            }  
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String aid = request.getParameter("aid");
        String date = request.getParameter("date");
        String time = request.getParameter("time");
        int ntime = Integer.parseInt(time);
        PrintWriter out = response.getWriter();
                
        String qry = "UPDATE appoint set date=\""+date+"\", ntime="+ntime+" WHERE aid="+aid;
        try {
            st = con.createStatement();
            st.execute(qry);
            out.print("Success");
        } catch (SQLException ex) {
            out.print("Failure");
            ex.printStackTrace();
        }
    }
 }
