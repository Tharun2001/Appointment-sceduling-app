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
import javax.servlet.http.*;

public class UserProfile extends HttpServlet {
    Connection con = DBcon.getCon();
    Statement st = null; 
    ResultSet rs = null;
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        response.setContentType("text/html");    
        if(session!=null && session.getAttribute("uid") != null){
            request.getRequestDispatcher("userProfile.jsp").forward(request, response);        
        }
        else{
            response.sendRedirect("Login");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);  
        String uid = (String)session.getAttribute("uid");        
        
        String uname = request.getParameter("uname");
        String name = request.getParameter("name");
        String phone = request.getParameter("phone");
        String pass = request.getParameter("pass");
        PrintWriter out = response.getWriter();
        if(!custExists(uname, uid)){
            String qry="UPDATE users set uname=\""+uname+"\",name=\""+name+"\",phone=\""+phone+"\",password=\""+pass+"\" where uid="+uid;
            try {
                st = con.createStatement();
                st.execute(qry);
                out.print("success");
            } catch (SQLException ex) {
                out.print("Error");
                ex.printStackTrace();
            }
        }
        else{
            out.print("username already exists.");
        }
        
    }
    
    boolean custExists(String uname, String uid){
        String qry = "select * from users where uname='"+uname+"' and uid!="+uid;
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
    

}
