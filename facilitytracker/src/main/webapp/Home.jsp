<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="com.facilitytracker.connectionUtil.Connection_Util"%>
<%@page import="java.sql.Connection"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Home</title> 
  <!-- Bootstrap CSS -->
  <link href="css/bootstrap.min.css" rel="stylesheet">
  <!-- bootstrap theme -->
  <link href="css/bootstrap-theme.css" rel="stylesheet">
  <!--external css-->
  <!-- font icon -->
  <link href="css/elegant-icons-style.css" rel="stylesheet" />
  <link href="css/font-awesome.min.css" rel="stylesheet" />
  <!-- full calendar css-->
  <link href="assets/fullcalendar/fullcalendar/bootstrap-fullcalendar.css" rel="stylesheet" />
  <link href="assets/fullcalendar/fullcalendar/fullcalendar.css" rel="stylesheet" />
  <!-- easy pie chart-->
  <link href="assets/jquery-easy-pie-chart/jquery.easy-pie-chart.css" rel="stylesheet" type="text/css" media="screen" />
  <!-- owl carousel -->
  <link rel="stylesheet" href="css/owl.carousel.css" type="text/css">
  <link href="css/jquery-jvectormap-1.2.2.css" rel="stylesheet">
  <!-- Custom styles -->
  <link rel="stylesheet" href="css/fullcalendar.css">
  <link href="css/widgets.css" rel="stylesheet">
  <link href="css/style.css" rel="stylesheet">
  <link href="css/style-responsive.css" rel="stylesheet" />
  <link href="css/xcharts.min.css" rel=" stylesheet">
  <link href="css/jquery-ui-1.10.4.min.css" rel="stylesheet"> 
  <script type="text/javascript">
	function ChangeColor(tableRow, highLight) {
		if (highLight) {
			tableRow.style.backgroundColor = '#CFCFCF';
		} else {
			tableRow.style.backgroundColor = '#FFFFFF';
		}
	}
	function button1(val) {
		var val1 = val; 
		document.getElementById("hid").value = val1;
		edit.submit();
	}
	function addUsers_call() { 
		var participant = document.getElementById('participant').value;  
		var tot_part = document.getElementById('tot_part').value;  
		var part_group = document.getElementById('part_group').value; 
		if(participant==""){
		alert("No Participants Selected....!!!");
		}else{
		   var xmlhttp;
			if (window.XMLHttpRequest) {
				// code for IE7+, Firefox, Chrome, Opera, Safari
				xmlhttp = new XMLHttpRequest();
			} else {
				// code for IE6, IE5
				xmlhttp = new ActiveXObject("Microsoft.XMLHTTP"); 
			}
			xmlhttp.onreadystatechange = function() {
				if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
					document.getElementById("addMe").innerHTML = xmlhttp.responseText; 
				}
			};
			xmlhttp.open("POST", "WFH_projParticipants_Ajax.jsp?participant=" + participant + "&tot_part=" + tot_part + "&part_group=" + part_group, true);
			xmlhttp.send();
		}
	};
	
	function getDetails(str) {
		var xmlhttp;
		if (window.XMLHttpRequest) {
			// code for IE7+, Firefox, Chrome, Opera, Safari
			xmlhttp = new XMLHttpRequest();
		} else {
			// code for IE6, IE5
			xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
		}
		xmlhttp.onreadystatechange = function() {
			if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
				var a = null;
				document.getElementById("myDetails").innerHTML = xmlhttp.responseText; 
			}
		};
		xmlhttp.open("POST", "WFH_GetUserDetails_Ajax.jsp?q=" + str, true);  
		xmlhttp.send();
	}
	function validateForm() {
		var email=document.getElementById('email').value;  
		var contact=document.getElementById('contact').value;
		var tot_part=document.getElementById('tot_part').value;
		  
		if(tot_part =="" || tot_part=="0" || tot_part==0){
			alert("Reporting Manager is not selected ...!!!");
			document.getElementById("Save").disabled = false;
			return false; 
		}
		
		if(email !="" && email.includes("@")==false){
			alert("Proper E-Mail ID Required...!!!");
			document.getElementById("Save").disabled = false;
			return false; 
		} 
		
		if(contact =="" || contact==null || contact=="" || contact=="null" || contact.length!=10){
			alert("Contact No ...!!!");
			document.getElementById("Save").disabled = false;
			return false; 
		}
		
		
		
		document.getElementById("Save").disabled = true;
		return true;
	}
</script>
</head>

<body style="color: black;">
<%
try{
	int newCount=0, openCount=0, reOpenCount=0, closedCount=0;
	Connection con = Connection_Util.getLocalUserConnection();
	Connection con_master = Connection_Util.getConnectionMaster();
	int comp_id = Integer.valueOf(session.getAttribute("comp_id").toString()); 
	int uid = Integer.valueOf(session.getAttribute("uid").toString());
	boolean availFlag=false,userInfoFlag=false,userreport=false;
	int dept_id = Integer.valueOf(session.getAttribute("dept_id").toString());
	PreparedStatement ps_check = null, ps_check1=null;
	ResultSet rs_check = null,rs_check1=null; 
	
	if(comp_id!=6){
	ps_check = con.prepareStatement("select * from  user_tbl where U_Id="+uid+" and sap_id!='null'");
	rs_check = ps_check.executeQuery();
	while(rs_check.next()){
		userInfoFlag=true;
	}
	
	ps_check = con_master.prepareStatement("select * from  rel_userReportingManager where U_Id="+uid+" and enable_id=1");
	rs_check = ps_check.executeQuery();
	while(rs_check.next()){
		userreport=true;
	}
	}else{
		userInfoFlag=true; 
		userreport=true;
	}
	
	if(userInfoFlag==true && userreport==true){
	
	SimpleDateFormat mailDateFormat = new SimpleDateFormat("dd/MM/yyyy hh:mm a");
	String facility ="",assignedUser="",priority="",department="",requester="",company="", statusLog="", assigned_String="";
	
	ps_check = con.prepareStatement("SELECT * FROM facility_user_access where access_company=6 and enable=1 and uid="+uid);
	rs_check = ps_check.executeQuery();
	while (rs_check.next()) {
		availFlag=true;
	}
	
	if(availFlag==false){
		assigned_String = " and assigned_comp_id ="+comp_id;
	}
	
	//System.out.println("assigned comp = " +assigned_String);
	ps_check = con.prepareStatement("SELECT count(id) as newCount FROM facility_req_tbl where status_id=1 and enable=1 "+assigned_String);
	rs_check = ps_check.executeQuery();
	while (rs_check.next()) {
		newCount = rs_check.getInt("newCount");
	}
	ps_check = con.prepareStatement("SELECT count(id) as newCount FROM facility_req_tbl where status_id=2 and enable=1 "+assigned_String);
	rs_check = ps_check.executeQuery();
	while (rs_check.next()) {
		openCount = rs_check.getInt("newCount");
	}
	ps_check = con.prepareStatement("SELECT count(id) as newCount FROM facility_req_tbl where status_id=4 and enable=1 "+assigned_String);
	rs_check = ps_check.executeQuery();
	while (rs_check.next()) {
		reOpenCount = rs_check.getInt("newCount");
	}
	ps_check = con.prepareStatement("SELECT count(id) as newCount FROM facility_req_tbl where status_id=5 and enable=1"+assigned_String);
	rs_check = ps_check.executeQuery();
	while (rs_check.next()) {
		closedCount = rs_check.getInt("newCount");
	}
/*-------------------------------------------------------------------------------------------------------------------*/
/*-------------------------------------------------------------------------------------------------------------------*/ 
%> 
<!-- container section start -->
<section id="container" class="">
<!---------------------------------------------------------------  Include Header ---------------------------------------------------------------------------------------->
<%@include file="Header.jsp" %>
<!---------------------------------------------------------------  Include Sidebar ---------------------------------------------------------------------------------------->
<%@include file="Sidebar.jsp" %>
<!----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------->	
<!--main content start-->
    <section id="main-content">
      <section class="wrapper">
        <!--overview start-->
        <div class="row">
          <div class="col-lg-12">
            <!-- <h3 class="page-header"><i class="fa fa-laptop"></i> Dashboard</h3> -->
            <ol class="breadcrumb">
              <li><i class="fa fa-home"></i><a href="Home.jsp">Home</a></li>
              <li><i class="fa fa-laptop"></i>Dashboard 
        <%
  		if(request.getParameter("success")!=null){
		%> 
         <strong class="alert alert-success fade in"><%=request.getParameter("success") %> </strong> 
        <%
		}if(request.getParameter("statusNop")!=null){
			%> 
	         <strong class="alert alert-block alert-danger fade in"><%=request.getParameter("statusNop") %> </strong> 
	        <%
			}
		%>
              
              </li>
            </ol> 
          </div>
        </div>


<!-- ********************************************************************************************************************* -->
<!-- ************************************ Tiles to Display**************************************************************** -->
<%-- 
        <div class="row">
          <a href="ActionList.jsp?new=1">
          <div class="col-lg-3 col-md-3 col-sm-12 col-xs-12">
            <div class="info-box facebook-bg">
              <!-- <i class="fa fa-cloud-download"></i> -->
              <i class="icon_download"></i>
              <div class="count"><%=newCount %></div>
              <div class="title">NEW Requests</div>
            </div> 
          </div>  
         </a>

		<a href="ActionList.jsp?new=2">
          <div class="col-lg-3 col-md-3 col-sm-12 col-xs-12">
            <div class="info-box yellow-bg">
              <i class="fa fa-question"></i>
              <div class="count"><%=openCount %></div>
              <div class="title">Open Requests</div>
            </div>
            <!--/.info-box-->
          </div>
          <!--/.col-->
          </a>
          
          <a href="ActionList.jsp?new=4">
 			<div class="col-lg-3 col-md-3 col-sm-12 col-xs-12">
            <div class="info-box red-bg">
              <i class="icon_lock-open"></i>
              <div class="count"><%=reOpenCount %></div>
              <div class="title">Re-Open Requests</div>
            </div>
            <!--/.info-box-->
          </div>
          <!--/.col-->
          </a>
          
          <a href="ActionList.jsp?new=5">
          <div class="col-lg-3 col-md-3 col-sm-12 col-xs-12">
            <div class="info-box green-bg">
              <i class="fa fa-lock"></i>
              <div class="count"><%=closedCount %></div>
              <div class="title">Closed Requests</div>
            </div>
            <!--/.info-box-->
          </div> 
          </a>
          
        </div>
        
   --%>      
	<!-- ********************************************************************************************************************* -->
	<!-- **************************************************** Data Goes Here ************************************************* -->
	<!-- ********************************************************************************************************************* -->
<div class="row" style="height:400px; overflow: scroll;">
          <div class="col-lg-12">
          <!--   <section class="panel"> -->
             <!--  <header class="panel-heading"><strong>My Requests :</strong></header> -->
              <div class="table-responsive">
                <form method="post" name="edit" action="Action_Resp.jsp" id="edit">
			<input type="hidden" name="hid" id="hid">
				<table class="table"> 
				<tr>
				<td colspan="9" align="left" style="background-color: #DACB74;font-size: 16px;font-weight: bold;">My Requests : </td>
				</tr>
						<tr style="background-color: #D8D8D8 !important;">
							<th width='5%' height='25' style="color: black  !important;">T. No</th>
							<th width="25%" style="color: black  !important;">Issue Statement</th>
							<th style="color: black  !important;">Facility</th>
							<th style="color: black  !important;">Requester</th>
							<th style="color: black  !important;">Assigned Company</th>
							<th style="color: black  !important;">Assigned Dept.</th>
							<th style="color: black  !important;">Registered Date</th>
							<th style="color: black  !important;">Priority</th>
							<th style="color: black  !important;">Status</th>
						</tr>  
						<% 
						ps_check = con.prepareStatement("select * from facility_req_tbl where requester_id="+uid+" and enable=1 order by sys_date, assigned_comp_id");
						rs_check = ps_check.executeQuery();
						while(rs_check.next()){
							 
								ps_check1 = con.prepareStatement("select * from facility_tbl where id="+rs_check.getInt("facility_for"));
								rs_check1 = ps_check1.executeQuery();
								while(rs_check1.next()){
									facility = rs_check1.getString("name");
								}  
								ps_check1 = con.prepareStatement("select * from user_tbl where u_id="+rs_check.getInt("requester_id"));
								rs_check1 = ps_check1.executeQuery();
								while(rs_check1.next()){
									requester = rs_check1.getString("U_Name");
								}  
								
								ps_check1 = con.prepareStatement("select * from facility_tbl_priority where id="+rs_check.getInt("priority"));
								rs_check1 = ps_check1.executeQuery();
								while(rs_check1.next()){
									priority = rs_check1.getString("name");
								}  
								ps_check1 = con.prepareStatement("select * from user_tbl_dept where dept_id="+rs_check.getInt("assigned_dept_id"));
								rs_check1 = ps_check1.executeQuery();
								while(rs_check1.next()){
									department = rs_check1.getString("Department");
								}
								ps_check1 = con.prepareStatement("select * from user_tbl_company where Company_Id="+rs_check.getInt("assigned_comp_id"));
								rs_check1 = ps_check1.executeQuery();
								while(rs_check1.next()){
									company = rs_check1.getString("Company_Name");
								}
								ps_check1 = con.prepareStatement("select * from status_tbl where Status_Id="+rs_check.getInt("status_id"));
								rs_check1 = ps_check1.executeQuery();
								while(rs_check1.next()){
									statusLog = rs_check1.getString("Status");
								}
						%>
						<tr onmouseover="ChangeColor(this, true);"
								onmouseout="ChangeColor(this, false);"
								onclick="button1('<%=rs_check.getInt("id")%>');" style="cursor: pointer;font-size: 12px;background-color: white;color: black;">
							<td><%=rs_check.getInt("id") %></td>
							<td><%=rs_check.getString("issue_found") %></td>
							<td><%=facility %></td>
							<td><%=requester %></td>
							<td><%=company %></td>
							<td><%=department %></td>
							<td><%= mailDateFormat.format(rs_check.getTimestamp("sys_date")) %></td>
							<td><%=priority %></td>
							<td><%=statusLog %></td>
						</tr>
						<% 
						}
						%> 
				</table>
				</form>
              </div>

         <!--    </section> -->
          </div>
        </div> 
        
        
        
        <!-- project team & activity end -->

      </section> 
    </section>
    
    
    
    <%
	}else{
	%>
		<!---------------------------------------------------------------------------------- User Profile Screen ----------------------------------------------------------------------->                
		  <!------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------>
		 <!------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------>                
		            <form action="WFH_UserControl" method="post" enctype="multipart/form-data" id="feedback_form" class="form-validate form-horizontal" onsubmit="return validateForm()">
		          <table style="width: 100%;color: white;" class="gridtable">
						<tr> 
							<th  align="right"><b style="color: black;">Please Verify Your Personal Information and update if wrong/missing</b></th> 
						</tr>
					</table> 
		           <%
		        ps_check = con.prepareStatement("select * from  user_tbl where U_Id="+uid);
				rs_check = ps_check.executeQuery();
				while(rs_check.next()){ 
		           %>
		             <table style="width: 60%;color: white;" class="gridtable">
		             	<tr style="background-color: #dedede;color:"> 
							<th align="center"  style="color: black;">Profile Image : </th>
							<td  align="left" style="color: black;">
							<%
							if(rs_check.getString("user_photoName")==null){
							%>
							<input type="file" class="form-control" style="color: black;" name="photo" id="photo"  accept="image/png, image/jpeg">
							<%
							}else{
							%>
							<img src="View_photo.jsp?field=<%=uid%>" height="80" width="80"/><br/>
							<%	
							}
							%>
							</td> 
						</tr>
						<tr style="background-color: #dedede;color:"> 
							<th align="center"  style="color: black;">User Name : </th>
							<td align="left"><b style="color: black;"><%=rs_check.getString("U_Name") %></b></td> 
						</tr>
						<tr style="background-color: #dedede;color:">
							<th align="center"  style="color: black;">SAP Code : </th>
							<td  align="left" style="color: black;"> 
						<select class="form-control" name="sapCode" id="sapCode" onchange="getDetails(this.value)" style="font-weight: bold;color: black;" required>
		                
		                <%  
		                ps_check1 = con.prepareStatement("SELECT * from sap_users where Emp_Code in (SELECT sap_id FROM user_tbl where u_id="+uid+") and enable=1");
		                rs_check1 = ps_check1.executeQuery();
		                while(rs_check1.next()){
		                %>                              
		                  <option value="<%=rs_check1.getString("Emp_Code")%>"><%=rs_check1.getString("Emp_Code")%> - <%=rs_check1.getString("Name_Of_Emp")%></option>  
		                <%
		                }
		                rs_check1.close();
		                %>
		                <option value=""> - - - - Select - - - - </option>
		                 <%  
		                ps_check1 = con.prepareStatement("SELECT * from sap_users where enable=1");
		                rs_check1 = ps_check1.executeQuery();
		                while(rs_check1.next()){
		                %>                              
		                  <option value="<%=rs_check1.getString("Emp_Code")%>"><%=rs_check1.getString("Emp_Code")%> - <%=rs_check1.getString("Name_Of_Emp")%></option>  
		                <%
		                }
		                rs_check1.close();
		                %>
			        </select> 
							</td> 
						</tr>
						<tr style="background-color: #dedede;color:"> 
							<th align="center"  style="color: black;">Company : </th>
							<td  align="left" style="color: black;"> 
							<span id="myDetails"></span>
							</td> 
						</tr>
						<tr style="background-color: #dedede;color:">
							<th align="center"  style="color: black;">Email ID(Company) : </th>
							<td  align="left" style="color: black;">  
							<input style="color: black;" type="text" id="email" name="email" class="form-control" value="<%=rs_check.getString("U_Email") %>" required>
							</td> 
						</tr>
						<tr style="background-color: #dedede;color: black;">
							<th align="center"  style="color: black;">Contact No : </th>
							<td  align="left" style="color: black;">  
							<input style="color: black;" type="text" id="contact" name="contact" class="form-control"  value="<%=rs_check.getString("phone_no") %>" oninput="this.value = this.value.replace(/[^0-9]/g, '').replace(/(\..*)\./g, '$1');" minlength="10" maxlength="10" required>
							</td> 
						</tr> 
						<th align="center"  style="color: black;">Select Reporting manager : </th>
							<td style="background-color: #dedede;color: black;">
							<select class="form-control" name="participant" id="participant" style="font-weight: bold; color: black;font-size: 13px !important;" required>
                <option value=""> - - - - Add New Participants - - - - </option>
                <%
                ps_check = con.prepareStatement("SELECT * FROM user_tbl where enable_id=1 and company_id=6 order by u_name");
                rs_check = ps_check.executeQuery();
                while(rs_check.next()){
                %>                              
                  <option value="<%=rs_check.getString("u_id")%>">Management - <%=rs_check.getString("U_Name").toUpperCase()%></option>  
                <%
                } 
                ps_check = con.prepareStatement("SELECT * FROM user_tbl where enable_id=1 and company_id!=6 and u_id!="+uid +" order by u_name");
                rs_check = ps_check.executeQuery();
                while(rs_check.next()){
                %>                              
                  <option value="<%=rs_check.getString("u_id")%>"><%=rs_check.getString("U_Name").toUpperCase()%></option>  
                <%
                } 
                %>
                <%-- <%
				ps_check = con.prepareStatement("SELECT * FROM user_tbl inner join sap_users on user_tbl.sap_id=sap_users.emp_code where user_tbl.enable_id=1 and user_tbl.dept_id="+dept_id+" and user_tbl.u_id!="+uid);
                rs_check = ps_check.executeQuery();
                while(rs_check.next()){
                %>                              
                  <option value="<%=rs_check.getString("u_id")%>"><%=rs_check.getString("emp_code")%> - <%= rs_check.getString("Name_Of_Emp").replaceAll("Mr.", "").toUpperCase() %></option>  
                <%
                }
                ps_check = con.prepareStatement("SELECT * FROM user_tbl inner join sap_users on user_tbl.sap_id=sap_users.emp_code where user_tbl.enable_id=1 and user_tbl.dept_id!="+dept_id+" and user_tbl.u_id!="+uid);
                rs_check = ps_check.executeQuery();
                while(rs_check.next()){
                %>                              
                  <option value="<%=rs_check.getString("u_id")%>"><%=rs_check.getString("emp_code")%> - <%=rs_check.getString("Name_Of_Emp").replaceAll("Mr.", "").toUpperCase() %></option>  
                <%
                }
                ps_check = con.prepareStatement("SELECT * FROM user_tbl where enable_id=1 and company_id=6");
                rs_check = ps_check.executeQuery();
                while(rs_check.next()){
                %>                              
                  <option value="<%=rs_check.getString("u_id")%>">Management - <%=rs_check.getString("U_Name").toUpperCase()%></option>  
                <%
                } 
                ps_check = con.prepareStatement("SELECT * FROM user_tbl where enable_id=1 and company_id!=6");
                rs_check = ps_check.executeQuery();
                while(rs_check.next()){
                %>                              
                  <option value="<%=rs_check.getString("u_id")%>"><%=rs_check.getString("U_Name").toUpperCase()%></option>  
                <%
                }
                %> --%>
	        </select> <input type="button" class="form-control"  onclick="addUsers_call()" value="Click to Select" style="font-weight: bold;background-color: #b5ffa9;color: black;height: 30px;">
	         	<span id="addMe">
					<input type="hidden" name="tot_part" id="tot_part" value="0" required> 
					<textarea rows="1" id="part_group" class="form-control" style="color: black;" readonly="readonly" required></textarea>
					</span>
							</td>
						<!-- &#13;&#10; -->
						<tr style="background-color: #dedede;color: black;"> 
							<td align="center" style="color: black;" colspan="2">
							<input type="submit" id="Save" name="Save" style="background-color: #99cfff;width: 200px;color: black;font-weight: bold;" value="Save Information" class="form-control">
							</td>
						</tr>
					</table> 
					<%
					}
					%>
			</form>  
			<!------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------>
		 <!---------------------------------------------------------------------------------- User Profile Screen Ends ----------------------------------------------------------------------->                
	<%
	}
    %>
    
    
    <%
	}catch(Exception e){
		e.printStackTrace();
	}
    %>
    
     
    <!--main content end-->
  </section>
  <!-- container section start -->

  <!-- javascripts -->
  <script src="js/jquery.js"></script>
  <script src="js/jquery-ui-1.10.4.min.js"></script>
  <script src="js/jquery-1.8.3.min.js"></script>
  <script type="text/javascript" src="js/jquery-ui-1.9.2.custom.min.js"></script>
  <!-- bootstrap -->
  <script src="js/bootstrap.min.js"></script>
  <!-- nice scroll -->
  <script src="js/jquery.scrollTo.min.js"></script>
  <script src="js/jquery.nicescroll.js" type="text/javascript"></script>
  <!-- charts scripts -->
  <script src="assets/jquery-knob/js/jquery.knob.js"></script>
  <script src="js/jquery.sparkline.js" type="text/javascript"></script>
  <script src="assets/jquery-easy-pie-chart/jquery.easy-pie-chart.js"></script>
  <script src="js/owl.carousel.js"></script>
  <!-- jQuery full calendar -->
  <script src="js/fullcalendar.min.js"></script>
    <!-- Full Google Calendar - Calendar -->
    <script src="assets/fullcalendar/fullcalendar/fullcalendar.js"></script>
    <!--script for this page only-->
    <script src="js/calendar-custom.js"></script>
    <script src="js/jquery.rateit.min.js"></script>
    <!-- custom select -->
    <script src="js/jquery.customSelect.min.js"></script>
    <script src="assets/chart-master/Chart.js"></script>

    <!--custome script for all page-->
    <script src="js/scripts.js"></script>
    <!-- custom script for this page-->
    <script src="js/sparkline-chart.js"></script>
    <script src="js/easy-pie-chart.js"></script>
    <script src="js/jquery-jvectormap-1.2.2.min.js"></script>
    <script src="js/jquery-jvectormap-world-mill-en.js"></script>
    <script src="js/xcharts.min.js"></script>
    <script src="js/jquery.autosize.min.js"></script>
    <script src="js/jquery.placeholder.min.js"></script>
    <script src="js/gdp-data.js"></script>
    <script src="js/morris.min.js"></script>
    <script src="js/sparklines.js"></script>
    <script src="js/charts.js"></script>
    <script src="js/jquery.slimscroll.min.js"></script>
    <script>
      //knob
      $(function() {
        $(".knob").knob({
          'draw': function() {
            $(this.i).val(this.cv + '%')
          }
        })
      });

      //carousel
      $(document).ready(function() {
        $("#owl-slider").owlCarousel({
          navigation: true,
          slideSpeed: 300,
          paginationSpeed: 400,
          singleItem: true

        });
      });

      //custom select box

      $(function() {
        $('select.styled').customSelect();
      });

      /* ---------- Map ---------- */
      $(function() {
        $('#map').vectorMap({
          map: 'world_mill_en',
          series: {
            regions: [{
              values: gdpData,
              scale: ['#000', '#000'],
              normalizeFunction: 'polynomial'
            }]
          },
          backgroundColor: '#eef3f7',
          onLabelShow: function(e, el, code) {
            el.html(el.html() + ' (GDP - ' + gdpData[code] + ')');
          }
        });
      });
    </script>

</body>
</html>