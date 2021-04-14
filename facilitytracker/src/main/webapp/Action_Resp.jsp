<%@page import="java.util.Date"%>
<%@page import="java.sql.Timestamp"%>
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
<title>Take Action</title>
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
	
/* 	function myFunc(val) { 
        document.getElementById("modValue").value = val;        
     } */
	 
</script>
<!-- Bootstrap CSS -->
<link href="css/bootstrap.min.css" rel="stylesheet">
<!-- bootstrap theme -->
<link href="css/bootstrap-theme.css" rel="stylesheet">
<!--external css-->
<!-- font icon -->
<link href="css/elegant-icons-style.css" rel="stylesheet" />
<link href="css/font-awesome.min.css" rel="stylesheet" />
<!-- full calendar css-->
<link href="assets/fullcalendar/fullcalendar/bootstrap-fullcalendar.css"
	rel="stylesheet" />
<link href="assets/fullcalendar/fullcalendar/fullcalendar.css"
	rel="stylesheet" />
<!-- easy pie chart-->
<link href="assets/jquery-easy-pie-chart/jquery.easy-pie-chart.css"
	rel="stylesheet" type="text/css" media="screen" />
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
</head>

<body style="color: black;">
	<%
		try {
			int count = 0;
			boolean solflag=false,dept_flag=false,closeTicket=false;
			Connection con = Connection_Util.getLocalUserConnection();
			int dept_id = Integer.valueOf(session.getAttribute("dept_id").toString());
			int uid = Integer.valueOf(session.getAttribute("uid").toString());
			
			PreparedStatement ps_check = null, ps_check1=null, ps_check2=null;
			ResultSet rs_check = null,rs_check1=null,rs_check2=null;
			int fm_ID = Integer.valueOf(request.getParameter("hid"));
		 	String issue_log="";
			ps_check = con.prepareStatement("select * from facility_req_tbl where id="+fm_ID);
			rs_check = ps_check.executeQuery();
			while(rs_check.next()){
				issue_log = rs_check.getString("issue_found");
			} 
			ps_check = con.prepareStatement("SELECT * FROM user_tbl_dept where ft_enable=1 and Dept_Id=" + dept_id);
            rs_check = ps_check.executeQuery();
            while(rs_check.next()){
            	solflag=true;
            } 
            
            ps_check = con.prepareStatement("SELECT * FROM facility_user_access where access_admin=1 and access_company=6 and enable=1 and uid="+uid);
        	rs_check = ps_check.executeQuery();
        	while (rs_check.next()) {
        		solflag=true;
        		dept_flag=true;
        	}
	/*-------------------------------------------------------------------------------------------------------------------*/
	%>
	<!-- container section start -->
	<section id="container" class=""> <!---------------------------------------------------------------  Include Header ---------------------------------------------------------------------------------------->
	<%@include file="Header.jsp"%> <!---------------------------------------------------------------  Include Sidebar ---------------------------------------------------------------------------------------->
	<%@include file="Sidebar.jsp"%> <!----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------->
	<!--main content start--> <section id="main-content"> 
	<section class="wrapper"> <!--overview start-->
	<div class="row">
		<div class="col-lg-12">
			<!-- <h3 class="page-header"><i class="fa fa-laptop"></i> Dashboard</h3> -->
			<ol class="breadcrumb">
				<li><i class="fa fa-home"></i><a href="Home.jsp"> Home </a> </li> 
				<li><i class="icon_tools"></i> Action On REQUEST  
				<%
					if (request.getParameter("success") != null) {
				%> <strong class="alert alert-success fade in"><%=request.getParameter("success")%></strong> 
			<%
 			} 
 			%>
 	</li>
	</ol>
	</div>
</div>

<!-- **************************************************** Data Goes Here ************************************************* -->
	<!-- ********************************************************************************************************************* -->
<% 
String facility ="",assignedUser="",priority="",department="",requester="",company="", statusLog="", statusTop="";
SimpleDateFormat mailDateFormat = new SimpleDateFormat("dd/MM/yyyy hh:mm a"); 
SimpleDateFormat format = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");

Timestamp currentDate = new Timestamp(System.currentTimeMillis());
 
ps_check = con.prepareStatement("select * from facility_req_tbl where id="+fm_ID);
rs_check = ps_check.executeQuery();
while(rs_check.next()){
	
	if(rs_check.getInt("status_id")==5){
		closeTicket=true;
	}
	
	ps_check1 = con.prepareStatement("select * from facility_tbl where id="+rs_check.getInt("facility_for"));
	rs_check1 = ps_check1.executeQuery();
	while(rs_check1.next()){
		facility = rs_check1.getString("name");
	} 
	ps_check1 = con.prepareStatement("select * from status_tbl where Status_Id="+rs_check.getInt("status_id"));
	rs_check1 = ps_check1.executeQuery();
	while(rs_check1.next()){
		statusTop = rs_check1.getString("Status");
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
	  
	if(rs_check.getInt("assigned_dept_id")==dept_id){
		dept_flag=true;
	}
	
	Date d1 = null;
	Date d2 = null;
 
		d2 = new Date(currentDate.getTime());
		d1 = new Date(rs_check.getTimestamp("problem_date").getTime());

		//in milliseconds
		long diff = d2.getTime() - d1.getTime();

		long diffSeconds = diff / 1000 % 60;
		long diffMinutes = diff / (60 * 1000) % 60;
		long diffHours = diff / (60 * 60 * 1000) % 24;
		long diffDays = diff / (24 * 60 * 60 * 1000);

	/* 	System.out.print(diffDays + " days, ");
		System.out.print(diffHours + " hours, ");
		System.out.print(diffMinutes + " minutes, ");
		System.out.print(diffSeconds + " seconds."); */
 %>



<div class="row" style="overflow: scroll;height: 550px;">
          <!-- profile-widget -->
          <div class="col-lg-12">
            <div class="profile-widget profile-widget-info">
            
            
            
              <div class="panel-body"> 
                <div class="col-lg-2 col-sm-2"> 
                  <div class="follow-ava">  
                  <a class="btn btn-warning" data-toggle="modal" href="#myModal2">
                   <img src="DisplayImages.jsp?field=<%=rs_check.getInt("id")%>" alt="No Image"/>
                  </a> 				          
                   </div>
                  <h4><strong><%= facility%></strong> </h4>
                  <h5><strong><%= priority %></strong></h5>
                  <h6><strong> By <%=requester %></strong></h6> 
                  </div>  
                <div class="col-xs-6 col-lg-8 follow-info">
                  <h4> <strong>T. No : <%=rs_check.getInt("id") %>.</strong> <strong> <%=rs_check.getString("issue_found") %></strong></h4> 
                  <div class="panel panel-primary">
                  <div class="panel-heading"><i class="icon_comment_alt"></i>Assigned to : <%= department %> &nbsp;&nbsp;&nbsp;&nbsp;<i class="icon_clock_alt"></i> Registered Date : <%= mailDateFormat.format(rs_check.getTimestamp("sys_date")) %>   &nbsp;&nbsp;&nbsp;&nbsp;<i class="icon_info"></i>Status : <strong style="background-color: #eeff70"><%=statusTop %></strong> </div>
                  <div class="panel-heading">Overdue Days : <strong> <%=diffDays %></strong>  Hours : <strong> <%=diffHours %></strong>  Minutes : <strong> <%=diffMinutes %></strong>  Seconds : <strong> <%=diffSeconds %></strong></div> 
                  <div class="panel-heading"><strong style="color: black;">Evidence Docs : </strong> 
                  <a href="DisplayDocs.jsp?field=<%=rs_check.getInt("id")%>"><strong style="background-color: lime;"><%=rs_check.getString("attach_doc_name") %></strong></a></div>
                  </div>
              </div>
            </div>
            
            <section class="panel">
              <header class="panel-heading tab-bg-info">
                <ul class="nav nav-tabs">
                  <li class="active">
                    <a data-toggle="tab" href="#recent-activity">
                       <i class="icon-home"></i>HISTORY</a>
                  </li> 
                <%
                if((solflag==true && dept_flag==true) || closeTicket==true){
                %>  
                  <li class="">
                    <a data-toggle="tab" href="#edit-profile">
                                          <i class="icon-envelope"></i>
                                         PROVIDE SOLUTION
                                      </a>
                  </li>
                <%
                }
                %>
                </ul>
              </header>
            
            
            <% 
			String attend_By="",status="";
			//System.out.println("fm id = " + fm_ID);
			ps_check1 = con.prepareStatement("SELECT * FROM facility_req_tbl_rel where enable=1 and fm_id=" + fm_ID +" order by Solution_count desc");
			rs_check1 = ps_check1.executeQuery();
            %>
            <div class="panel-body">
                <div class="tab-content">
                  <div id="recent-activity" class="tab-pane active">
                    <div class="profile-activity">
                      <div class="act-time"> 
                         <table class="table"> 
						<tr style="background-color: #fffd8c;color: black;">
							<th width='5%' height='25'>S. No</th>
							<th width="30%">Solution Given</th>
							<th>Attended By</th>
							<th>Status</th> 
							<th>Extra Days Reqd.</th>
							<th style="width: 15%">Solution Date</th>
							<th>Evidence Image</th>
							<th>Evidence Docs</th> 
						</tr>
			<% 
			while (rs_check1.next()) { 
				ps_check2 = con.prepareStatement("select * from user_tbl where U_Id="+rs_check1.getInt("attendedby_Uid"));
				rs_check2 = ps_check2.executeQuery();
				while(rs_check2.next()){
					attend_By = rs_check2.getString("U_Name");
				}
				ps_check2 = con.prepareStatement("select * from status_tbl where Status_Id=" + rs_check1.getInt("status_id"));
				rs_check2 = ps_check2.executeQuery();
				while (rs_check2.next()) {
					status = rs_check2.getString("Status");
				}
			%> 		
						<tr style="color: black;">
						<td align="center"><%=rs_check1.getInt("Solution_count") %></td>
						<td align="left"><%=rs_check1.getString("solution_given") %></td>
						<td align="left"><%=attend_By %></td>
						<td align="left"><%=status %></td>
						<td align="center"><%=rs_check1.getString("next_followup")%></td>
						<td align="left"><%=mailDateFormat.format(rs_check1.getTimestamp("attended_date")) %></td>
						<td align="left">  
					<%  
					if(!rs_check1.getString("attach_img_name").equalsIgnoreCase("")){ 
					%>
					<a href="DisplaySolutionImages.jsp?field=<%=rs_check1.getInt("id")%>">	
					<img style="border-radius: 8px !important; width: 200px !important;height: 150px !important;" data-dismiss="modal" class="btn btn-default" src="DisplaySolutionImages.jsp?field=<%=rs_check1.getInt("id")%>" alt="No Image"/></a>	
				  	<%
					}
				  	%>
				  	 	</td>
						<td align="left"><a href="DisplaySolutionDocs.jsp?field=<%=rs_check1.getInt("id")%>"><%=rs_check1.getString("attach_doc_name") %></a> </td>
						</tr>
			<%
			}
			%> 
				</table> 
                       </div>

                    </div>
                  </div>
                  
        		<%
                if((solflag==true && dept_flag==true) || closeTicket==true){
                %>           
                   <!-- edit-profile -->
                  <div id="edit-profile" class="tab-pane">
                    <section class="panel">
                      <div class="panel-body bio-graph-info"> 

<form action="FM_Act_RequestControl" method="post" enctype="multipart/form-data"  id="feedback_form" class="form-validate form-horizontal">
					<input type="hidden" name="fm_ID" id="fm_ID" value="<%=fm_ID%>">
					<div class="form-group ">
                      <label for="ccomment" class="control-label col-lg-2"><strong>Solution Given/Remark</strong><b style="color: red;"> * </b> </label>
                      <div class="col-lg-10">
                        <textarea class="form-control ckeditor" id="solution" name="solution" rows="1" style="font-weight: bold;color: black;font-size: 15px;" required></textarea>
                      </div>
                    </div>

                    <div class="form-group">
                    <label class="control-label col-lg-2" for="inputSuccess"><strong>Attended By</strong><b style="color: red;"> * </b></label>
                    <div class="col-lg-10">
                      <select name="attended_by" id="attended_by" class="form-control m-bot15" style="font-weight: bold;font-size:15px; color: black;" required>
                      <%
                      ps_check1 = con.prepareStatement("SELECT * FROM user_tbl where Enable_id=1 and U_Id=" + uid);
                      rs_check1 = ps_check1.executeQuery();
                      while(rs_check1.next()){
                      %>
                      <option value="<%=rs_check1.getInt("U_Id") %>"><%=rs_check1.getString("U_Name") %></option>
                      <%
                      }
                      ps_check1 = con.prepareStatement("SELECT * FROM user_tbl where Enable_id=1 and U_Id!=" + rs_check.getInt("requester_id"));
                      rs_check1 = ps_check1.executeQuery();
                      while(rs_check1.next()){
                      %>
                      <option value="<%=rs_check1.getInt("U_Id") %>"><%=rs_check1.getString("U_Name") %></option>
                      <%
                      }
                      %>
                      </select> 
                    </div>
                    </div> 
                   
                   
                   
                   <div class="form-group">
                    <label class="control-label col-lg-2" for="inputSuccess"><strong>Status</strong><b style="color: red;"> * </b></label>
                    <div class="col-lg-10">
                      <select name="status_id" id="status_id" class="form-control m-bot15" style="font-weight: bold;font-size:15px; color: black;" required>
                      <%
                      int statusCheck=0;
                      String query = "";
                      ps_check1 = con.prepareStatement("SELECT * FROM status_tbl where Status_Id="+rs_check.getInt("status_id"));
                      rs_check1 = ps_check1.executeQuery();
                      while(rs_check1.next()){
                    	  statusCheck = rs_check1.getInt("Status_Id");
                      %>
                      <option value="<%=rs_check1.getInt("Status_Id") %>"><%=rs_check1.getString("Status") %></option>
                      <%
                      }
                      query = "SELECT * FROM status_tbl where Status_Id not in("+rs_check.getInt("status_id") +",1,3,4)";
                      if(statusCheck==5){
                      query = "SELECT * FROM status_tbl where Status_Id=4";
                      }
                      ps_check1 = con.prepareStatement(query);
                      rs_check1 = ps_check1.executeQuery();
                      while(rs_check1.next()){
                      %>
                      <option value="<%=rs_check1.getInt("Status_Id") %>"><%=rs_check1.getString("Status") %></option>
                      <%
                      } 
                      %>
                      </select> 
                    </div>
                    </div>
                   
                   
                   
                   
                   
                    <div class="form-group ">
                    <label for="ccomment" class="control-label col-lg-2"><strong>Extra Day Required ?</strong></label>
                    <div class="col-lg-10">
                      <select name="followup" id="followup" class="form-control m-bot15" style="font-weight: bold;font-size:15px; color: black;">
                      <option value="0"> - - - - Select - - - -  </option>
                      <%
                      for(int i=1;i<=100;i++){
                      %>
                      <option value="<%=i %>"><%=i %></option>
                      <%
                      }
                      %>
                      </select> 
                      
                      
                    </div>
                    </div>
                    
                    <div class="form-group">
                    <label class="control-label col-lg-2" for="inputSuccess"><strong>Evidence Image</strong></label>
                    <div class="col-lg-10">
                     <input type="file" id="file_image" name="file_image" accept="image/*">
                     
                    </div>
                    </div>
                    
                    
                     <div class="form-group">
                    <label class="control-label col-lg-2" for="inputSuccess"><strong>Evidence Docs</strong></label>
                    <div class="col-lg-10">
                     <input type="file" id="file_doc" name="file_doc">
                    </div>
                    </div>
                     
                    
                    <div class="form-group">
                      <div class="col-lg-offset-2 col-lg-10"> 
                        <input type="submit" class="btn btn-primary" name="submit" id="submit" value="   Request Submit   " style="font-weight: bold;">
                      </div>
                    </div>
                  </form>




                        
                        
                      </div>
                    </section>
                  </div>
                <%
                }
                %>  
                  
                </div>
              </div>
            
            
            
            
            
            
            
            
            
            
            </section>
          </div>
        </div>
       
   </div>    
        
        <div class="modal fade" id="myModal2" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
                  <div class="modal-dialog">
                    <div class="modal-content">   
							<img title="<%=facility %>" data-dismiss="modal" class="btn btn-default" src="DisplayImages.jsp?field=<%=rs_check.getInt("id")%>" alt="No Image"/>
                    </div>
                  </div>
                </div>  
         
          
           
          
          
            
                
                
<%
}
%>
 


	<!-- project team & activity end --> </section> </section> <%
 	} catch (Exception e) {
 		e.printStackTrace();
 	}
 %> <!--main content end--> </section>
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
	<
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
				'draw' : function() {
					$(this.i).val(this.cv + '%')
				}
			})
		});

		//carousel
		$(document).ready(function() {
			$("#owl-slider").owlCarousel({
				navigation : true,
				slideSpeed : 300,
				paginationSpeed : 400,
				singleItem : true

			});
		});

		//custom select box

		$(function() {
			$('select.styled').customSelect();
		});

		/* ---------- Map ---------- */
		$(function() {
			$('#map').vectorMap({
				map : 'world_mill_en',
				series : {
					regions : [ {
						values : gdpData,
						scale : [ '#000', '#000' ],
						normalizeFunction : 'polynomial'
					} ]
				},
				backgroundColor : '#eef3f7',
				onLabelShow : function(e, el, code) {
					el.html(el.html() + ' (GDP - ' + gdpData[code] + ')');
				}
			});
		});
	</script>

</body>
</html>