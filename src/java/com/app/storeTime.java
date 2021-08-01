/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.app;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet(name = "storeTime", urlPatterns = {"/storeTime"})
public class storeTime extends HttpServlet {

    Connection con = DBcon.getCon();
    Statement st = null; 
    ResultSet rs = null;
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        response.setContentType("text/html");    
        if(session!=null && session.getAttribute("uid") != null){
            request.getRequestDispatcher("appoints.jsp").forward(request, response);
        }
        else{
            response.sendRedirect("Login");
        }
    }


    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
            String sid = request.getParameter("sid");
            String date = request.getParameter("date");
            String qry;
            if(request.getParameter("aid") != null){
                String aid = request.getParameter("aid");
                qry = "SELECT s.sid, ntime, date, cnt, capacity from (SELECT sid,ntime,date,count(*) as cnt from appoint where sid="+sid+" and aid!="+aid+" and date=\""+date+"\" GROUP by date,ntime) a LEFT JOIN store s on a.sid = s.sid where cnt>=capacity";
            }
            else{
                qry = "SELECT s.sid, ntime, date, cnt, capacity from (SELECT sid,ntime,date,count(*) as cnt from appoint where sid="+sid+" and date=\""+date+"\" GROUP by date,ntime) a LEFT JOIN store s on a.sid = s.sid where cnt>=capacity";
            }
            String txt = "";
            PrintWriter out = response.getWriter();
            txt += "{\"sid\":"+sid+", \"date\":\""+date+"\", \"booked\":[";
            try{
                st = con.createStatement();
                rs = st.executeQuery(qry);
                while(rs.next()){
                    txt += rs.getString("ntime")+",";
                }
                txt += "-1]}";
                out.print(txt);
            }
            catch(Exception ex){
                out.print("failure "+sid+","+date);
            }
    }

}
