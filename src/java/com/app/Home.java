package com.app;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class Home extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        response.setContentType("text/html");  
        PrintWriter out=response.getWriter();  
        if(session!=null && session.getAttribute("uid") != null){
                request.getRequestDispatcher("home.jsp").include(request, response);
                String name=(String)session.getAttribute("uname");
        }
        else{
            response.sendRedirect("Login");
        }
        out.close(); 
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

    }

}
