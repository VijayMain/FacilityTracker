<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Calendar"%> 
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>File Upload</title> 
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
  <style type="text/css">
table.gridtable {
	font-family: verdana, arial, sans-serif;
	
	color: #333333;
	border-width: 1px;
	border-color: #666666;
	border-collapse: collapse;
}

table.gridtable th {
	font-size: 13px;
	border-width: 1px;
	padding: 8px;
	border-style: solid;
	border-color: #666666;
	/* background-color: #dedede; */
}

table.gridtable td {
font-size: 12px;
	border-width: 1px;
	padding: 2px;
	border-style: solid;
	border-color: #666666;
	background-color: #ffffff;
}
</style>
</head> 
<body style="font-family: Arial, Helvetica, sans-serif; color: black;">
<%
try{
/*-------------------------------------------------------------------------------------------------------------------*/
Connection con = Connection_Util.getLocalUserConnection();
Connection con_Master = Connection_Util.getConnectionMaster();
PreparedStatement ps_check=null,ps_check1=null,ps_check2=null;
ResultSet rs_check=null,rs_check1=null,rs_check2=null;
String company="";
SimpleDateFormat mailDateFormat = new SimpleDateFormat("dd/MM/yyyy hh:mm a");
int dept_id = Integer.valueOf(session.getAttribute("dept_id").toString()); 
int comp_id = Integer.valueOf(session.getAttribute("comp_id").toString());
int uid = Integer.valueOf(session.getAttribute("uid").toString());  
String username = session.getAttribute("username").toString(); 
String deptName = session.getAttribute("deptName").toString();
PreparedStatement ps_company = con.prepareStatement("select * from user_tbl_company where Company_Id="+comp_id);
ResultSet rs_company = ps_company.executeQuery();
while (rs_company.next()) {
	company=rs_company.getString("Company_Name");
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
<!-- ********************************************************************************************************************* -->
<!-- ************************************ Tiles to Display**************************************************************** -->
	<div class="row">
          <div class="col-lg-12">
            <section class="panel">
              <header class="panel-heading"><span  style="color: black;font-weight: bold;">Add DWM Task Details</span>
              <%
  		if(request.getParameter("status")!=null){
		%> 
         <strong class="alert alert-success fade in"><%=request.getParameter("status") %> </strong> 
        <%
		}else if(request.getParameter("statusNop")!=null){
			%> 
	         <strong class="alert alert-block alert-danger fade in"><%=request.getParameter("statusNop") %> </strong> 
	        <%
			}
		%>
              </header>
              <div class="panel-body">
                <div class="form"> 
            <form action="DWMFileUpload_Control" method="post" enctype="multipart/form-data" id="feedback_form" class="form-validate form-horizontal">
               	<div class="form-group">
                    <label class="control-label col-lg-2" for="inputSuccess"><strong>User Name</strong> </label>
                    <div class="col-lg-10">
                     <%=username %>
                    </div>
                 </div>
                 
                 <div class="form-group">
                    <label class="control-label col-lg-2" for="inputSuccess"><strong>Company Name</strong> </label>
                    <div class="col-lg-10">
                     <%=company %>
                    </div>
                 </div>
                 
                 <div class="form-group">
                    <label class="control-label col-lg-2" for="inputSuccess"><strong>Department Name</strong> </label>
                    <div class="col-lg-10">
                     <%=dept_name %>
                    </div>
                 </div> 
                  
                 
                 <div class="form-group">
                    <label class="control-label col-lg-2" for="inputSuccess"><strong>Excel Import File</strong><b style="color: red;"> * </b></label>
                    <div class="col-lg-10">
                     <input type="file" id="file_doc" name="file_doc" accept=".xls" required>
                    </div>
                 </div>
                   
                    <div class="form-group">
                    <label class="control-label col-lg-2" for="inputSuccess"><strong>Task Approver</strong><b style="color: red;"> * </b></label>
                    <div class="col-lg-10">  
                      <select name="task_approver" id="task_approver" title="Select the name of your Approver" class="form-control m-bot15" style="font-weight: bold;color: black;" required>
                   <% 
                   if(comp_id!=6){
                	   String comp_user="";
						ps_check1 = con_Master.prepareStatement("select * from rel_userReportingManager where enable_id=1 and u_id=" + uid);
						rs_check1 = ps_check1.executeQuery();
						while(rs_check1.next()){
							ps_check = con.prepareStatement("SELECT * FROM user_tbl where Enable_id=1 and u_id="+rs_check1.getInt("approver_id"));
							rs_check = ps_check.executeQuery();
							while (rs_check.next()) {
								ps_check2 = con.prepareStatement("SELECT * FROM user_tbl_company where Company_Id="+rs_check.getInt("Company_Id"));
								rs_check2 = ps_check2.executeQuery();
								while (rs_check2.next()) {
									comp_user = rs_check2.getString("Company_Name");
								}	
					%>
					<option value="<%=rs_check.getInt("U_Id")%>"><%=rs_check.getString("U_Name") %> &nbsp;&nbsp;- - &nbsp;&nbsp; <%=comp_user %></option> 
					<% 
					comp_user="";
							}
						}
                   }else{ 
                	%>
       				<option value=""> - - - - Select - - - - </option> 
       				<%   
                	   ps_check = con.prepareStatement("SELECT * FROM user_tbl where Enable_id=1 and Company_Id=6");
						rs_check = ps_check.executeQuery();
						while (rs_check.next()) { 
				%>
				<option value="<%=rs_check.getInt("U_Id")%>"><%=rs_check.getString("U_Name") %> </option> 
				<% 
						}
                   }
					%>
                      </select>
                    </div>
                    </div>
                    <% 
                    	if(dept_id==18){
                    %> 
                    <div class="form-group">
                      <div class="col-lg-offset-2 col-lg-10"> 
                        <input type="submit" class="btn btn-primary" name="submit" id="submit" value="   Upload File   " style="font-weight: bold;">
                       &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; <b>Sample Upload Template :</b> 
                        <%
                      ps_check1 = con_Master.prepareStatement("SELECT * FROM wfh_bulkupload where enable_id=1 and file_type like '%Sample%Template%'");
						rs_check1 = ps_check1.executeQuery();
						while(rs_check1.next()){ 
                      %> 
                      <a href="WFH_SampleTemplateView.jsp?field=<%=rs_check1.getInt("id") %>"><strong style="color: blue;"><%=rs_check1.getString("filename") %></strong></a>
                      <%
						}
                      %> 
                      </div>
                    </div>
                    <%
						}else{
					%>
					<marquee behavior = "alternate" scrollamount="1" direction="right"> 
					<b style="background-color: yellow;">Please Note :</b>
					<br>Due to HRD decision file upload is locked, you must update data, daily using Add WFH Tasks tab.
					<br>If you find any issues contact HR Team.
					</marquee>
					<%		
						}
                    %>
                    
                  </form>
                  <br>
                      <b>Note : </b><br>
                      1. Do not make any changes to bulk upload file, also do not upload same file again, will cause same record registration.<br>
                      2. Do not add extra sheets in bulk upload templates. <br>
                      3. Before upload remove all formulas, if any<br>
                      4. To import, file must be saved in <b style="font-size: 14px;">.xls</b> format only<br>
                      5. If file upload status showing <b>'File Uploaded with Errors..'</b>, means you have uploaded file with blanks or null values which are not acceptable.
                      Note that system will not register those records. 
              <div style="height: 400px;overflow: scroll;">    
             <table style="width: 100%;color: white;" class="gridtable">
             	<tr style="background-color: #DACB74;"> 
             		<th align="center"  style="color: black;">Doc No</th>  
					<th align="center"  style="color: black;">Document Name</th> 
					<th align="center"  style="color: black;">Document </th>   
					<th align="center"  style="color: black;">Uploaded By</th>
					<th align="center"  style="color: black;">Upload Date</th>	 					
				</tr>
				<%
				PreparedStatement ps_upload = con_Master.prepareStatement("SELECT id,filename,attachment,sys_date FROM wfh_bulkupload where enable_id=1 and created_by="+uid+" and file_type!='Sample Template' order by sys_date desc");
				ResultSet rs_upload = ps_upload.executeQuery();
				while(rs_upload.next()){
				%>
				<tr style="color: black;">
					<td align="center"><%=rs_upload.getInt("id") %></td>
					<td><%=rs_upload.getString("filename") %></td>
					<td><a href="WFH_SampleTemplateView.jsp?field=<%=rs_upload.getInt("id") %>"><strong style="color: blue;"><%=rs_upload.getString("filename") %></strong></a></td>
					<td><%=username %></td>
					<td><%= mailDateFormat.format(rs_upload.getTimestamp("sys_date")) %></td>
				<%
					}	
				%> 
				</tr>
					
			</table>	     
            </div>
                  
                  
                  
                  
                  
                  
                  
                  
                  
                </div>

              </div>
            </section>
          </div>
        </div>
        
        
        
        <!-- project team & activity end -->

      </section> 
    </section>
    
    <%

	rs_check.close();
	rs_check1.close();
	rs_check2.close();
	
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