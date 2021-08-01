<%-- 
    Document   : bookAppoint
    Created on : 30-Oct-2020, 1:25:25 pm
    Author     : tharu
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.app.*"%>
<%@page import="java.sql.*"%>
<%@page import="javax.servlet.*"%>
<%@page import="javax.servlet.http.*"%>
<%
    Connection con = DBcon.getCon();
    String aname=(String)session.getAttribute("aname");
    String sid=(String)session.getAttribute("sid");
    TimeFormat obj = new TimeFormat();   
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link href="css/home.css" rel="stylesheet" type="text/css">
        <title>Store Page</title>
        <script>
            function commonTime(url, params){
                var http = new XMLHttpRequest();
                http.open('POST', url, true);
                http.setRequestHeader('Content-type', 'application/x-www-form-urlencoded');
                http.onreadystatechange = function() {
                    if(http.readyState == 4 && http.status == 200) {
                        var msg = http.responseText;
                        console.log(msg);
                        var data = JSON.parse(msg);
                        console.log(data.booked.length);
                        for(var i=0; i<data.booked.length-1; i++){
                            num = data.booked[i]/60;
                            opt = document.getElementById("opt-"+num);
                            if(opt != null){
                                opt.style.color = "red";
                                opt.disabled = true;
                            }

                        }
                    }
                }
                http.send(params); 
            }        
            function clean(first_time, last_time){
                for(var i=first_time; i<=last_time; i++){
                    opt = document.getElementById("opt-"+i);
                    opt.style.color = "blue";
                    opt.disabled = false;
                    opt.selected = false;
                }
            }
            function getTime(sid, first_time, last_time){
                var uid = document.getElementById("uid").value;
                var date = document.getElementById("date").value;
                clean(first_time, last_time);
                console.log(uid, sid);
                commonTime("storeTime", 'date='+date+"&sid="+sid);
                commonTime("userTime" , 'date='+date+"&uid="+uid);
            }              
            function appoint(x, first_time, last_time){
                time = document.getElementById("time").value;
                date = document.getElementById("date").value;
                uid = document.getElementById("uid").value;
                if(time == "none" || date == "" || uid == "none"){
                    return;
                }
                console.log(time, date);
                time = time*60;
                var http = new XMLHttpRequest();
                var url = 'addApt';
                var params = "uid="+uid+"&date="+date+"&time="+time+"&sid="+x;
                http.open('POST', url, true);
                http.setRequestHeader('Content-type', 'application/x-www-form-urlencoded');
                http.onreadystatechange = function() {
                    if(http.readyState == 4 && http.status == 200) {
                        var resp = http.responseText;
                        var msg = document.getElementById("msg");
                        console.log(resp);
                        if(resp == "success"){
                            var msg = document.getElementById("msg");
                            msg.innerHTML = "Status: Successfully added";
                            document.getElementById("time").value = "";
                            document.getElementById("date").value = "";
                            document.getElementById("uid").value = "";
                        }
                        else{
                            msg.innerHTML = "Status: Error";
                        }
                    }
                }
                http.send(params);
            }
            function clearDate(){
                document.getElementById("date").value = "";
            }
        </script>
    </head>
    <body>
        <ul>
          <li><a href="StoreHome">Home</a></li>
          <li><a href="StoreAppointments">My Schedule</a></li>
          <li><a class="active" href="BookAppointment">Book Appointment</a></li>
          <li style="float: right; background-color: #DC143C;" ><a href="Logout">Logout</a></li>
        </ul>
        <h1 style="margin-left:550px;">Add Appointment</h1>
        <span id="msg" style="diplsay: inline; margin-left: 550px; font-weight: bold; font-size: 25px;" ></span>
        <%
        try{
        Statement st1 = con.createStatement();
        String qry1 = "SELECT * from store where sid="+sid;
        ResultSet resultSet1 = st1.executeQuery(qry1);
        int first_time = 0;
        int last_time = 0;
        while(resultSet1.next()){
            first_time = resultSet1.getInt("first_time")/60;
            last_time = resultSet1.getInt("last_time")/60;
        }
        Statement st2 = con.createStatement();
        String qry2 = "SELECT uid,uname from users";
        ResultSet resultSet2 = st2.executeQuery(qry2);
        %>     
        <table id="store-tab" style="width: 450px; margin:10px 475px;">          
        <tr>
        <th>Username</th>
        <td>
         <select id="uid" style="font-size: 17px;" onchange="clearDate()">
         <option value="none">--select username--</option>
            <%
            String uid="";    
            while(resultSet2.next()){
                uid = resultSet2.getString("uid");
                String uname = resultSet2.getString("uname");
            %> 
                <option value="<%=uid%>" ><%=uname%></option>
            <%                    
            }
            %>
         </select>
        </td>
        </tr>
        <th>Date</th>
        <td><input id="date" style="font-size: 17px;" class="store-txt" type="date" onchange="getTime(<%=sid+","+first_time+","+last_time%>)"></td>
        </tr>
        <th>Time</th>
        <td>
            <select id="time" style="font-size: 17px;">
            <option value="none">--select time--</option>
                <%  
                    for(int i=first_time; i<=last_time; i++){
                        %> 
                        <option id="opt-<%=i%>" value="<%=i%>" ><%=obj.timeConvert.get(i)%></option>
                        <%                    
                    }
                %>
            </select>
        </td>
        <tr>
        <td colspan="2"><button style="float: right;" class="btn-add" onclick="appoint(<%=sid%>,<%=first_time%>, <%=last_time%>)" id="btn">Add</button>
        </td>
        </tr>
        </table>
        <%    
        } catch (Exception e) {
        e.printStackTrace();
        }
        %>            
    </body>
</html>
