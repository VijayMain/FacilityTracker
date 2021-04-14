<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Login to Facility Tracker</title>

  <!-- Bootstrap CSS -->
  <link href="css/bootstrap.min.css" rel="stylesheet">
  <!-- bootstrap theme -->
  <link href="css/bootstrap-theme.css" rel="stylesheet">
  <!--external css-->
  <!-- font icon -->
  <link href="css/elegant-icons-style.css" rel="stylesheet" />
  <link href="css/font-awesome.css" rel="stylesheet" />
  <!-- Custom styles -->
  <link href="css/style.css" rel="stylesheet">
  <link href="css/style-responsive.css" rel="stylesheet" />
 
</head>

<body class="login-img3-body"> 
		<%
  		if(request.getParameter("error")!=null){
		%>
	  <script type="text/javascript">
	  alert(<%=request.getParameter("error") %>);
	  </script>
		<%
		}
		%>
  <div class="container"  style="float: right;"> 
    
     <form class="login-form" action="Login_Control" method="post"> 
      <div class="login-wrap">
        <p class="login-img"><i class="icon_lock_alt"></i></p>
        <div class="input-group">
          <span class="input-group-addon"><i class="icon_profile"></i></span>
          <input type="text" name="uname" id="uname" class="form-control" placeholder="Username" autofocus required>
        </div>
        <div class="input-group">
          <span class="input-group-addon"><i class="icon_key_alt"></i></span>
          <input type="password" name="password" id="password" class="form-control" placeholder="Password" required>
        </div>
        <label class="checkbox">
                <input type="checkbox" value="remember-me"> Remember me
        </label> 
        <input type="submit" name="commit" value=" Click to Login " class="btn btn-primary btn-lg btn-block"/> 
      </div>
    </form> 
   
  </div> 
</body> 
</html>