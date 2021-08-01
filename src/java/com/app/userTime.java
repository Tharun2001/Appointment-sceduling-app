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

@WebServlet(name = "userTime", urlPatterns = {"/userTime"})
public class userTime extends HttpServlet {  
    Connection con = DBcon.getCon();
    Statement st = null; 
    ResultSet rs = null;   
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);  
        String uid = (String)session.getAttribute("uid");
        String date = request.getParameter("date");
        if(request.getParameter("uid") != null){
            uid = request.getParameter("uid");
        }
        String qry;
        if(request.getParameter("aid") != null){
            String aid = request.getParameter("aid");
            qry = "select * from appoint where uid='"+uid +"' and aid!='"+aid +"' and date='"+date+"'";
        }
        else{
            qry = "select * from appoint where uid='"+uid +"' and date='"+date +"'";
        }
        
        String txt = "";
        PrintWriter out = response.getWriter();
        txt += "{\"uid\":"+uid+", \"date\":\""+date+"\", \"booked\":[";
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
            out.print("failure "+uid+","+date);
        }
    }

}
