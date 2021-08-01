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


@WebServlet(name = "addApt", urlPatterns = {"/addApt"})
public class addApt extends HttpServlet {
    Connection con = DBcon.getCon();
    Statement st = null; 
    ResultSet rs = null;
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String sid = request.getParameter("sid");
        String date = request.getParameter("date");
        String time = request.getParameter("time");
        int ntime = Integer.parseInt(time);
        HttpSession session = request.getSession(false);  
        String uname = (String)session.getAttribute("uname");
        String uid = (String)session.getAttribute("uid");   
        if(request.getParameter("uid") != null){
            uid = request.getParameter("uid");
        }           
        PrintWriter out = response.getWriter();
        if(uid == null || sid == null || date == null || time == null){
            out.print("error");
        }
        else{
            try {
                String qry = "insert into appoint(uid, sid, date, ntime) values(?, ?, ?, ?)";
                PreparedStatement ps = con.prepareStatement(qry);
                ps.setString(1,uid);
                ps.setString(2,sid);
                ps.setString(3,date);
                ps.setInt(4, ntime);
                ps.execute();
                out.print("success");
            } catch (SQLException ex) {
                out.print("failure "+ntime+" "+sid+" "+date+" "+uid);
            }
        }
    }
 }


