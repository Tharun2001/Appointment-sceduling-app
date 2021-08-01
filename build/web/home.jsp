<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.app.*"%>
<%@page import="java.sql.*"%>
<%@page import="java.util.*"%>
<%@page import="javax.servlet.*"%>
<%@page import="javax.servlet.http.*"%>
<%
    Connection con = DBcon.getCon();
    Statement st = con.createStatement();
    ResultSet resultSet;
    TimeFormat obj = new TimeFormat();
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link href="css/home.css" rel="stylesheet" type="text/css">
        <title>Home</title>
        <script>
            function commonTime(sid, url, params){
                var http = new XMLHttpRequest();
                http.open('POST', url, true);
                http.setRequestHeader('Content-type', 'application/x-www-form-urlencoded');
                http.onreadystatechange = function() {
                    if(http.readyState == 4 && http.status == 200) {
                        var msg = http.responseText;
                        console.log(msg);
                        var data = JSON.parse(msg);
                        for(var i=0; i<data.booked.length-1; i++){
                            num = data.booked[i]/60;
                            opt = document.getElementById("opt-"+sid+"-"+num);
                            if(opt != null){
                                opt.style.color = "red";
                                opt.disabled = true;
                            }

                        }
                    }
                }
                http.send(params); 
            }        
            function clean(sid, first_time, last_time){
                for(var i=first_time; i<=last_time; i++){
                    opt = document.getElementById("opt-"+sid+"-"+i);
                    opt.style.color = "blue";
                    opt.disabled = false;
                    opt.selected = false;
                }
            }
            function getTime(sid, first_time, last_time){
                var time = document.getElementById("apt-time-"+sid).value;
                var date = document.getElementById("apt-date-"+sid).value;
                clean(sid, first_time, last_time);
                commonTime(sid, "storeTime", 'date='+date+"&sid="+sid);
                commonTime(sid, "userTime", 'date='+date);
            }              
            function appoint(x, first_time, last_time){
                time = document.getElementById("apt-time-"+x).value;
                date = document.getElementById("apt-date-"+x).value;
                if(time == "none" || date == ""){
                    return;
                }
                time = time*60;
                var http = new XMLHttpRequest();
                var url = 'addApt';
                var params = "sid="+x+"&date="+date+"&time="+time;
                http.open('POST', url, true);
                http.setRequestHeader('Content-type', 'application/x-www-form-urlencoded');
                http.onreadystatechange = function() {
                    if(http.readyState == 4 && http.status == 200) {
                        var resp = http.responseText;
                        if(resp == "success"){
                            var msg = document.getElementById("msg-"+x);
                            msg.innerHTML = "Successfully added";
                            document.getElementById("apt-date-"+x).value = "";
                            getTime(x, first_time, last_time);
                        }
                        else{
                            msg.innerHTML = "Error";
                        }
                    }
                }
                http.send(params);
            }    
        </script>
        </head>
        <body>
        <ul>
          <li><a class="active" href="#home">Home</a></li>
          <li><a href="Appointments">My Schedule</a></li>
          <li><a href="UserProfile">My Profile</a></li>
          <li style="float: right; background-color: #DC143C;" ><a href="Logout">Logout</a></li>
        </ul>
            <h1 style="margin-left: 35px;">Hi, ${uname}!</h1>
            <table border="1" id="store-tab" style="width: 950px;">   
        <tr>
        <th>Store</th>
        <th>Type</th>
        <th>Date</th>
        <th>Time</th>
        <th>Select</th>
        <th>Status</th>
        </tr>
        <%
        try{
        String sql ="select * from store";
        resultSet = st.executeQuery(sql);
        while(resultSet.next()){
            String sid = resultSet.getString("sid");
            String sname = resultSet.getString("sname");
            String stype = resultSet.getString("stype");
            int first_time = resultSet.getInt("first_time")/60;
            int last_time = resultSet.getInt("last_time")/60;            
        %>
        <tr>
        <td><%= sname %></td>
        <td><%= stype %></td>
        <td><input type="date" id="apt-date-<%=sid%>" name="appoint-date" onchange="getTime(<%=sid+","+first_time+","+last_time%>)"></td>
        <td><select id="apt-time-<%=sid%>" style="font-size: 15px; padding: 5px 5px;">
            <option value="none">--select time--</option>
                <%  
                    for(int i=first_time; i<=last_time; i++){
                        %> 
                        <option id="opt-<%=sid+"-"+i%>" value="<%=i%>" ><%=obj.timeConvert.get(i)%></option>
                        <%                         
                    }
                    %>
                 </select>       
        </td>
        <td><button class="btn-add" onclick="appoint(<%=sid+","+first_time+","+last_time%>)" id="btn"-<%=sid%>>ADD</button>
        </td>
        <td><span id="msg-<%=sid%>">N/A</span></td>
        </tr>
        <%
        }
        //con.close();
        } catch (Exception e) {
        e.printStackTrace();
        }
        %>
        </table>
    </body>
</html>
