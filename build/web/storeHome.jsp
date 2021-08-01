<%-- 
    Document   : storeHome
    Created on : 27-Oct-2020, 12:49:41 am
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
        <link href="css/home.css" rel="stylesheet" type="text/css">
        <title>Store Page</title>
        <script>
            function modify(x){
                var aname = document.getElementById("aname");
                var sname = document.getElementById("sname");
                var stype = document.getElementById("stype");
                var addr = document.getElementById("addr");
                var capacity = document.getElementById("capacity");
                var first_time = document.getElementById("first-time");
                var last_time = document.getElementById("last-time");
                var pass = document.getElementById("pass");
                var conf_pass = document.getElementById("conf-pass");
                var btn = document.getElementById("btn-"+x);
                if(btn.innerHTML == "Modify"){
                   aname.disabled = false;
                   sname.disabled = false;
                   stype.disabled = false;
                   addr.disabled = false;
                   capacity.disabled = false;
                   first_time.disabled = false;
                   last_time.disabled = false;
                   pass.disabled = false;
                   conf_pass.disabled = false;
                   btn.innerHTML = "Confirm";
                   btn.style.backgroundColor = "rgb(34,139,34)";
                }
                else{                    
                    if(parseInt(first_time.value) >= parseInt(last_time.value)){
                        alert("Invalid Timings."+first_time.value+" "+last_time.value);
                        return;
                    }
                    if(pass.value != conf_pass.value){
                        alert("Passwords do not match.");
                        return;
                    }
                    var http = new XMLHttpRequest();
                    var url = 'StoreHome';
                    var params = "aname="+aname.value+"&sname="+sname.value+"&stype="+stype.value+"&addr="+addr.value+"&capacity="+capacity.value+"&first_time="+first_time.value*60+"&last_time="+last_time.value*60+"&pass="+pass.value+"&sid="+x;
                    http.open('POST', url, true);
                    http.setRequestHeader('Content-type', 'application/x-www-form-urlencoded');
                    http.onreadystatechange = function() {
                        if(http.readyState == 4 && http.status == 200) {
                            var msg = http.responseText;
                            console.log(msg);
                            if(msg === "success"){
                                aname.disabled = true;
                                sname.disabled = true;
                                stype.disabled = true;
                                addr.disabled = true;
                                capacity.disabled = true;
                                first_time.disabled = true;
                                last_time.disabled = true;
                                pass.disabled = true;  
                                conf_pass.disabled = true;  
                                location.reload();
                            }
                            else{
                                document.getElementById("message").innerHTML = "<h2>Status: "+msg+"</h2>";
                            }

                        }
                    }
                    http.send(params);
                }
            }
        </script>
    </head>
    <body>
        <ul>
          <li><a class="active" href="StoreHome">Home</a></li>
          <li><a href="StoreAppointments">My Schedule</a></li>
          <li><a href="StoreBookAppoint">Book Appointment</a></li>
          <li style="float: right; background-color: #DC143C;" ><a href="Logout">Logout</a></li>
        </ul>
        <h1 style="margin-left:600px;">Store Details</h1>
        
        <table id="store-tab" style="width: 550px; margin-left:450px;">
        <%
        try{  
            Statement st = con.createStatement();
            String sql ="select * from store where sid='"+sid+"'";
            ResultSet resultSet = st.executeQuery(sql);
            if(resultSet.next()){
                int first_time = resultSet.getInt("first_time");
                int last_time = resultSet.getInt("last_time");
                String aname = resultSet.getString("aname");
                String sname = resultSet.getString("sname");
                String stype = resultSet.getString("stype");
                String addr = resultSet.getString("addr");
                String capacity = resultSet.getString("capacity");
                String apass = resultSet.getString("apassword");
            %>
            <tr>
            <th>Admin username</th>
            <td><input id="aname" class="store-txt" type="text" value="<%if(aname != null){%><%=aname%><%}else{%><%=""%><%}%>" disabled></td>
            </tr>            
            <tr>
            <th>Store Name</th>
            <td><input id="sname" class="store-txt" type="text" value="<%if(sname != null){%><%=sname%><%}else{%><%=""%><%}%>" disabled></td>
            </tr>
            <th>Store Type</th>
            <td><input id="stype" class="store-txt" type="text" value="<%if(stype != null){%><%=stype%><%}else{%><%=""%><%}%>" disabled></td>
            </tr>
            <tr>
            <th>Address</th>
            <td><textarea id="addr" class="store-txt" type="text" disabled><%if(addr != null){%><%=addr%><%}else{%><%=""%><%}%> </textarea></td>
            </tr>
            <tr>
            <th>Capacity</th>
            <td><input id="capacity" class="store-txt" type="text" value="<%if(capacity != null){%><%=capacity%><%}else{%><%=""%><%}%>" disabled></td>
            </tr>
            <tr>
            <th>First slot time</th>
            <td>
            <select id="first-time" style="font-size: 15px; padding: 5px 5px; margin-left: 30px;" disabled>
            <option value="none">--select time--</option>
                <%  
                    for(int k=0; k<=23; k++){
                        %> 
                        <option id="opt-<%=sid+"-"+k%>" value="<%=k%>" <%if(k*60 == first_time){%><%="selected"%><%} %> ><%=obj.timeConvert.get(k)%></option>
                        <%                                               
                    }
                %>
            </select>                
            </td>
            </tr>
            <tr>
            <th>Last slot time</th>
            <td> 
            <select id="last-time" style="font-size: 15px; padding: 5px 5px; margin-left: 30px;" disabled>
            <option value="none">--select time--</option>
                <%  
                    for(int k=0; k<=23; k++){
                        %> 
                        <option id="opt-<%=sid+"-"+k%>" value="<%=k%>" <%if(k*60 == last_time){%><%="selected"%><%} %> ><%=obj.timeConvert.get(k)%></option>
                        <% 
                    }
                %>
            </select>
            </td>
            </tr>
            <tr>
            <th>Password</th>
            <td><input id="pass" class="store-txt" type="text" value="<%if(apass != null){%><%=apass%><%}else{%><%=""%><%}%>" disabled></td>
            </tr>
            <tr>
            <th>Confirm password</th>
            <td><input id="conf-pass" class="store-txt" type="text" value="<%if(apass != null){%><%=apass%><%}else{%><%=""%><%}%>" disabled></td>
            </tr>            
            <tr>
                <td  colspan="2"><button type="text" style="float: right; margin-right: 75px;" class="btn-add" onclick="modify(<%=resultSet.getString("sid")%>)" id="btn-<%=resultSet.getString("sid")%>">Modify</button></td>
            </tr>            
            </table>
            <span id="message" style="display: inline-block; margin-left: 600px;"></span>
            <%
            }
        } catch (Exception e) {
        e.printStackTrace();
        }
        %>
    </body>
</html>
