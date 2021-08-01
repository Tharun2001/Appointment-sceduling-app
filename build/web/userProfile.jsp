<%-- 
    Document   : userProfile
    Created on : 29-Oct-2020, 9:17:34 am
    Author     : tharu
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.app.*"%>
<%@page import="java.sql.*"%>
<%@page import="javax.servlet.*"%>
<%@page import="javax.servlet.http.*"%>
<%
    Connection con = DBcon.getCon();
    String uid=(String)session.getAttribute("uid");
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link href="css/home.css" rel="stylesheet" type="text/css">
        <title>Store Page</title>
        <script>
            function modify(uid){
                var uname = document.getElementById("uname");
                var name = document.getElementById("name");
                var phone = document.getElementById("phone");
                var pass = document.getElementById("pass");
                var conf_pass = document.getElementById("conf-pass");
                var msg = document.getElementById("msg");
                var btn = document.getElementById("btn");
                if(btn.innerHTML == "Modify"){
                   prevUname = uname.value; 
                   uname.disabled = false;
                   name.disabled = false;
                   phone.disabled = false;
                   pass.disabled = false;
                   conf_pass.disabled = false;
                   btn.innerHTML = "Confirm";
                   btn.style.backgroundColor = "rgb(34,139,34)";
                }
                else{
                    if(conf_pass.value != pass.value){
                        msg.innerHTML = "Status: Password should Match";
                        return;
                    }    
                    var http = new XMLHttpRequest();
                    var url = 'UserProfile';
                    var params = "uname="+uname.value+"&name="+name.value+"&phone="+phone.value+"&pass="+pass.value+"&uid="+uid;
                    http.open('POST', url, true);
                    http.setRequestHeader('Content-type', 'application/x-www-form-urlencoded');
                    http.onreadystatechange = function() {
                        if(http.readyState == 4 && http.status == 200) {
                            var resp = http.responseText;
                            console.log(resp);
                            if(resp === "success"){
                                uname.disabled = true;
                                name.disabled = true;
                                phone.disabled = true;
                                pass.disabled = true;
                                conf_pass.disabled = true;                                
                                location.reload();
                            }
                            else{
                                msg.innerHTML = "Status: "+resp;
                            }
                        }
                    }
                    http.send(params);
                }
            }
        </script>
    </head>
    <body >
        <ul style="margin-bottom: 50px;">
          <li><a href="Home">Home</a></li>
          <li><a href="Appointments">My Schedule</a></li>
          <li><a class="active" href="Profile">My Profile</a></li>
          <li style="float: right; background-color: #DC143C;" ><a href="Logout">Logout</a></li>
        </ul>
        <span id="msg" style="diplsay: inline; margin-left: 650px; font-weight: bold; font-size: 25px;" ></span>
        <table id="store-tab" style="width: 550px; margin:10px 450px;">
        <%
        try{  
            Statement st = con.createStatement();
            String sql ="select * from users where uid="+uid;
            ResultSet resultSet = st.executeQuery(sql);
            if(resultSet.next()){
                String uname = resultSet.getString("uname");
                String name = resultSet.getString("name");
                String phone = resultSet.getString("phone");
                String pass = resultSet.getString("password");
            %>            
        <tr>
        <th>Username</th>
        <td><input id="uname" class="store-txt" type="text" value="<%=uname%>" disabled></td>
        </tr>
        <th>Name</th>
        <td><input id="name" class="store-txt" type="text" value="<%if(name != null){%><%=name%><%}else{%><%=""%><%}%>" disabled></td>
        </tr>
        <tr>
        <th>Phone no</th>
        <td><input id="phone" class="store-txt" type="text" value="<%if(phone != null){%><%=phone%><%}else{%><%=""%><%}%>" disabled></td>
        </tr>
        <tr>
        <th>Password</th>
        <td><input id="pass" class="store-txt" type="text" value="<%=pass%>" disabled></td>
        </tr>        
        <tr>
        <th>Confirm password</th>
        <td><input id="conf-pass" class="store-txt" type="text" value="<%=pass%>" disabled></td>
        </tr>
        <tr>
        <td colspan="2"><button style="float: right;" class="btn-add" onclick="modify(<%=uid%>)" id="btn">Modify</button>
        </td>
        </tr>
        </table>
            <%
            }
        } catch (Exception e) {
        e.printStackTrace();
        }
        %>        
    </body>
</html>
