<%-- 
    Document   : appoints
    Created on : 12-Oct-2020, 4:19:47 pm
    Author     : tharu
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.app.*"%>
<%@page import="java.sql.*"%>
<%@page import="javax.servlet.*"%>
<%@page import="java.util.*"%>
<%@page import="javax.servlet.http.*"%>
<%
    TimeFormat obj = new TimeFormat();
    Connection con = DBcon.getCon();
    String uname=(String)session.getAttribute("uname");
    String uid=(String)session.getAttribute("uid");
    Set<Integer> hash_Set = new HashSet<Integer>(); 
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link href="css/appoints.css" rel="stylesheet" type="text/css">
        <title>Home</title>
        <script>
            function commonTime(aid, url, params, time){
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
                            if(num!=time){
                                opt = document.getElementById("opt-"+aid+"-"+num);
                                if(opt!=null){
                                    opt.style.color = "red";
                                    opt.disabled = true;                                    
                                }
                            }
                        }
                    }
                }
                http.send(params); 
            }        
            function clean(aid, first_time, last_time){
                for(var i=first_time; i<=last_time; i++){
                    opt = document.getElementById("opt-"+aid+"-"+i);
                    opt.style.color = "blue";
                    opt.disabled = false;
                    opt.selected = false;
                }
            }
            function getTime(aid, sid, first_time, last_time){
                var time = document.getElementById("time-"+aid).value;
                var date = document.getElementById("date-"+aid).value;
                clean(aid, first_time, last_time);
                commonTime(aid,"storeTime", 'date='+date+"&sid="+sid+"&aid="+aid, time);
                commonTime(aid,"userTime", 'date='+date+"&aid="+aid, time);
            }              
            function modify(x, y, prevDate, prevTime, first_time, last_time){
                var btn = document.getElementById("btn-"+x);
                var date = document.getElementById("date-"+x);
                var time = document.getElementById("time-"+x);
                if(btn.innerHTML == "Modify"){
                   getTime(x, y, first_time, last_time);
                   date.disabled = false;
                   time.disabled = false;
                   btn.innerHTML = "Confirm";
                   btn.style.backgroundColor = "rgb(34,139,34)";
                }
                else{
                    if(time.value == "none"){
                        location.reload();
                    }
                    if(date.value === prevDate && time.value === prevTime){
                        location.reload();
                    }
                    var http = new XMLHttpRequest();
                    var url = 'modifyApt';
                    var params = 'date='+date.value+"&"+'time='+time.value*60+"&aid="+x;
                    http.open('POST', url, true);
                    http.setRequestHeader('Content-type', 'application/x-www-form-urlencoded');
                    http.onreadystatechange = function() {
                        if(http.readyState == 4 && http.status == 200) {
                            var msg = http.responseText;
                            if(msg === "Success"){
                                date.disabled = "true";
                                time.disabled = "true";
                                location.reload();
                            }
                            else{
                                document.getElementById("responseMsg").innerHTML = "<h1>Error<h1>";
                            }
                        }
                    }
                    http.send(params);
                }
            }
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
          <li><a href="Home">Home</a></li>
          <li><a class="active" href="Appointments">My Schedule</a></li>
          <li><a href="UserProfile">My Profile</a></li>
          <li style="float: right; background-color: #DC143C;" ><a href="Logout">Logout</a></li>
        </ul>    
        <div id="responseMsg"></div>
        <%
        try{
        Statement st = con.createStatement();
        String qry = "SELECT * from (SELECT * FROM appoint where uid="+uid+") a LEFT join store s on a.sid=s.sid"+ " order by date, ntime";
        ResultSet resultSet = st.executeQuery(qry);
        String prevDate="";
        int cnt=0;
        while(resultSet.next()){
            String sid = resultSet.getString("sid");
            String sname = resultSet.getString("sname");
            String stype = resultSet.getString("stype");
            String aid = resultSet.getString("aid");
            String date = resultSet.getString("date");
            int first_time = resultSet.getInt("first_time")/60;
            int last_time = resultSet.getInt("last_time")/60;
            int ntime = resultSet.getInt("ntime");
            if((!prevDate.equals(resultSet.getString("date")))){
                prevDate = resultSet.getString("date");
                String dat[] = prevDate.split("-");
                String mon = DateToDay.getMonth(dat[1]);%>
                </table>
                <h2 style="margin-left: 40%;"><%= dat[2]+", "+mon +" "+dat[0]%></h2>
                <%if(cnt == 0 ){%>
                  <table border="1" id="store-tab">
                  <tr><th>Store</th><th>Type</th><th>Date</th><th>Time</th><th>Options</th><tr>
                <%}
                else{%>
                  <table border="1" id="store-tab"> 
                <%}
                cnt++;
            }
        %>
        <tr>
            <td><%=sname %></td>
        <td><%=stype %></td>
        <td><input id="date-<%=aid%>" type="date" value="<%=date%>" onchange="getTime(<%=aid+","+sid+","+first_time+","+last_time%>)" disabled></td>
        <td>
            <select id="time-<%=aid%>" disabled>
            <option value="none">--select time--</option>
                <%  
                    for(int i=first_time; i<=last_time; i++){
                        %> 
                        <option id="opt-<%=aid+"-"+i%>" value="<%=i%>" <%if(i*60 == ntime){%><%="selected"%><%} %> ><%=obj.timeConvert.get(i)%></option>
                        <%                    
                    }
                    %>
            </select>
        </td>
        <td>
            <button class="btn-add" onclick="modify('<%=aid%>','<%=sid%>','<%=date %>','<%=ntime/60%>','<%=first_time%>','<%=last_time%>' )" id="btn-<%=aid%>">Modify</button>
            <button style="background-color: rgb(178,34,34)" class="btn-add" onclick="delApt(<%=aid%>)" id="btn-<%=aid%>">Delete</button>
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
