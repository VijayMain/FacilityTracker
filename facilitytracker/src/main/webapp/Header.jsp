<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Header</title>
</head>
<body>
<header class="header dark-bg">
<% 
String uname = session.getAttribute("username").toString(), dept_name = session.getAttribute("deptName").toString();

%>
      <div class="toggle-nav">
        <div class="icon-reorder tooltips" data-original-title="Toggle Navigation" data-placement="bottom"><i class="icon_menu"></i></div>
      </div> 
      <!--logo start-->
      <a href="Home.jsp" class="logo"><span class="lite">Mutha Group </span> Facility Management</a>
      <!--logo end-->  
       <!-- notificatoin dropdown start-->
      <div class="top-nav notification-row">       
        <ul class="nav pull-right top-menu"> 
          <li class="dropdown">
            <a data-toggle="dropdown" class="dropdown-toggle" href="#">
            <i class="icon_profile"></i>
            <span class="username"><strong> <%= uname %> </strong>[ <%= dept_name %> ]</span>
            <b class="caret"></b>
            </a>
            <ul class="dropdown-menu extended logout">
              <div class="log-arrow-up"></div> 
              <li>
                <a href="Add_New.jsp"><i class="icon_pencil"></i>Add New Facility</a>
              </li>
              <li>
                <a href="Software_Usage.jsp"><i class="icon_ol"></i>Software Usage</a>
              </li>
              <li>
                <a href="Login.jsp"><i class="icon_key_alt"></i> Log Out</a>
              </li> 
            </ul>
          </li>
          <!-- user login dropdown end -->
        </ul>
        <!-- notificatoin dropdown end-->
      </div>
    </header>
    <!--header end-->
</body>
</html>