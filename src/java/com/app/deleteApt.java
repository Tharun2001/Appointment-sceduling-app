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
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "deleteApt", urlPatterns = {"/deleteApt"})
public class deleteApt extends HttpServlet {
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try (PrintWriter out = response.getWriter()) {
            out.println("Successfully deleted" + request.getParameter("aid"));
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String aid = request.getParameter("aid");
        String qry = "delete from appoint where aid='"+aid+"'";
        Connection con = DBcon.getCon();
        try {
            Statement st = con.createStatement();
            st.execute(qry);
            processRequest(request, response);
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
    }
}
