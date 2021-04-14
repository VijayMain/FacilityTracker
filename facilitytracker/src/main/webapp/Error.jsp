<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Error Occurred</title>

  <!-- Bootstrap CSS -->
  <link href="css/bootstrap.min.css" rel="stylesheet">
  <!-- bootstrap theme -->
  <link href="css/bootstrap-theme.css" rel="stylesheet">
  <!--external css-->
  <!-- font icon -->
  <link href="css/elegant-icons-style.css" rel="stylesheet" />
  <link href="assets/font-awesome/css/font-awesome.css" rel="stylesheet" />
  <!-- Custom styles -->
  <link href="css/style.css" rel="stylesheet">
  <link href="css/style-responsive.css" rel="stylesheet" />
 
</head>

<body>
<div class="page-404">
<p>Something went wrong......!!!<br><a href="Home.jsp">Return Home and Retry</a></p>
</div> 
  <%
  Date today = new Date();
  SimpleDateFormat mailDateFormat = new SimpleDateFormat("dd/MM/yyyy HH:mm");
  String date = mailDateFormat.format(today);
  System.out.println("date = " + date);
  %>
<table border='1' width='100%'>
<tr style='font-size: 12px; background-color: #acc8cc; border-width: 1px; padding: 8px; border-style: solid;border-color: #729ea5;text-align: center;'>
<th width='5%' height='25'>S. No</th>
<th>Issue Statement</th>
<th>Requester</th>
<th>Assigned Company</th>
<th>Assigned Dept.</th>
<th>Registered Date</th> 
<th>Priority</th>
<th>Status</th>
</tr>
</table>

</body>
</html>