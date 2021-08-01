<%-- 
    Document   : storeappoints
    Created on : 28-Oct-2020, 12:38:43 am
    Author     : tharu
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.app.*"%>
<%@page import="java.sql.*"%>
<%@page import="javax.servlet.*"%>
<%@page import="javax.servlet.http.*"%>
<%
    Connection con = DBcon.getCon();
    String sid=(String)session.getAttribute("sid");
    TimeFormat obj = new TimeFormat();    
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link href="css/appoints.css" rel="stylesheet" type="text/css">
        <title>Home</title>
        <script>
            function delApt(x){
                var http = new XMLHttpRequest();
                var url = 'deleteApt';
                var params = 'aid='+x;
                http.open('POST', url, true);
                http.setRequestHeader('Content-type', 'application/x-www-form-urlencoded');
                http.onreadystatechange = function() {
                    if(http.readyState == 4 && http.status == 200) {
                        location.reload();
                    }
                }
                http.send(params);
            }
        </script>
        </head>
        <body style="padding-bottom: 100px;">
        <ul>
          <li><a href="StoreHome">Home</a></li>
          <li><a class="active" href="Appointments">My Schedule</a></li>
          <li><a href="StoreBookAppoint">Book Appointment</a></li>
          <li style="float: right; background-color: #DC143C;" ><a href="Logout">Logout</a></li>
        </ul>
        <h1 style="margin-left:500px;">Scheduled Appointments</h1>
        <div id="responseMsg"></div>
        <%
        try{
        Statement st = con.createStatement();
        String qry = "SELECT aid, u.uname as uname, u.uid as uid, date, ntime from (SELECT aid, uid, date, ntime from appoint WHERE sid ="+sid+") a LEFT JOIN users u on a.uid = u.uid order by date, ntime";
        ResultSet resultSet = st.executeQuery(qry);
        String prevDate="";
        int i=0;
        while(resultSet.next()){
            int ntime = Integer.parseInt(resultSet.getString("ntime"));
            if((!prevDate.equals(resultSet.getString("date")))){
                prevDate = resultSet.getString("date");
                String dat[] = prevDate.split("-");
                String mon = DateToDay.getMonth(dat[1]);
        %>
                </table><h2 style="margin-left: 40%;"><%= dat[2]+", "+mon +" "+dat[0]%></h2>
                <table border="1" id="store-tab" style="margin: auto auto; width: 950px"> 
                <%if(i == 0 ){%>
                  <tr><th>Username</th><th>Date</th><th>Time</th><th>Options</th><tr>
                <%}
                i++;
            }
        %>
        <tr>
        <td><%=resultSet.getString("uname") %></td>
        <td><input  type="date" value="<%=resultSet.getString("date") %>" disabled></td>
        <td><input  type="text" style="font-size: 17px;  padding: 3px 3px; background: white; color: red; width: 75px;" value="<%=obj.timeConvert.get(ntime/60) %>" disabled></td>
        <td>
            <button style="background-color: rgb(178,34,34)" class="btn-add" onclick="delApt(<%=resultSet.getString("aid")%>)" id="btn-<%=resultSet.getString("aid")%>">Cancel</button>
        </td>
        </tr>
        <%
        }
        } catch (Exception e) {
        e.printStackTrace();
        }
        %>
    </body>
</html>
