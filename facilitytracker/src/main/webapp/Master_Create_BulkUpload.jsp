<%@page import="java.util.LinkedHashSet"%>
<%@page import="java.util.ArrayList"%>
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
<title>Bulk Upload</title> 
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
	font-size: 12px;
	border-width: 1px;
	padding: 8px;
	border-style: solid;
	border-color: #666666;
	text-align: center;
	color: white;
	/* background-color: #dedede; */
}

table.gridtable td {
font-size: 10px;
	border-width: 1px;
	padding: 2px;
	border-style: solid;
	border-color: #666666;
	background-color: #ffffff;
} 
</style>
  <script type="text/javascript">
  window.onload = function() {    
		const reason = document.getElementById('reason');  
		const contact = document.getElementById('contact');  
		 
	 	reason.onpaste = function(e) {
		   e.preventDefault();
	 	};
	 	 
		contact.onpaste = function(e) {
			e.preventDefault();
		}; 
	};
	
	function checkQuote() {
		if(event.keyCode == 39 || event.keyCode == 34 || event.keyCode == 47) {
			event.keyCode = 0;
			return false;
		}
	}
	
	function validatenumerics(key) {
		
		if(event.keyCode == 39 || event.keyCode == 34 || event.keyCode == 47) {
			event.keyCode = 0;
			return false;
		}
		
		//getting key code of pressed key
		var keycode = (key.which) ? key.which : key.keyCode;
		//comparing pressed keycodes	 
		if (keycode > 31 && (keycode < 48 || keycode > 57) && keycode != 46 && keycode != 37 && keycode != 38 && keycode != 39 && keycode != 40) {
		    alert("Only allow numeric Data entry");
		    return false;
		}else 
		{
			return true;
		};
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
              <li><i class="icon_ribbon_alt"></i><a href="Master_Home.jsp" style="font-weight: bold;">My Requests</a></li>
              <li><i class="icon_pencil" style="color: gray;"></i><a href="Master_Create.jsp" style="font-weight: bold;">Create New</a></li>
              <!-- <li><i class="arrow_expand_alt2" style="color: gray;"></i><a href="Master_Create_EXTCode.jsp" style="font-weight: bold;">Extend Material Code</a></li> -->
              <li><i class="icon_upload" style="color: gray;"></i>Bulk Upload 
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
<div class="row" style="height:800px; overflow: scroll;">
          <div class="col-lg-12">
             <div class="table-responsive">
             <div style="width: 60%;float: left;">
             
<form action="BulkUploadMaster_Control" method="post" enctype="multipart/form-data" id="feedback_form" onsubmit="submit.disabled = true; return true;"  class="form-validate form-horizontal">
<table width="100%" border="0">
  <tr>
    <td><strong>Contact No </strong><b style="color: red;"> * </b></td>
    <td><div class="form-group"> <input class="form-control" style="font-weight: bold;color: black;font-size: 18px;"  onkeypress="return validatenumerics(event);" id="contact" name="contact" maxlength="10" minlength="10" type="text" required/></div> </td>
  </tr>
    <tr>
    <td><strong>Remark (If Any) </strong> </td>
    <td> <div class="form-group"><input class="form-control" style="font-weight: bold;color: black;font-size: 18px;" id="reason" name="reason" onkeypress="return checkQuote();" onkeyup="this.value = this.value.toUpperCase();" /></div> </td>
  </tr>
   <tr>
    <td><strong>Bulk Upload File </strong><b style="color: red;"> * </b></td>
    <td><div class="form-group"><input class="form-control"  type="file" id="file_doc" name="file_doc" required></div></td>
  </tr>
  <tr style="height: 50px;">
    <td style="padding-left: 60px;"><div class="form-group"><input type="submit" class="btn btn-primary" name="submit" id="submit" value="   Submit Data  " style="font-weight: bold;"></div></td>
    <td><a href="Master_SampleFile.jsp?field=1"><strong style="color: blue;font-weight: bold;">Sample Upload File</strong></a> </td> 
  </tr>
  <tr>
  <td colspan="2" style="background-color: yellow;"><strong>Note : </strong>More than 10 Records required to uplaod..!!!</td>
  </tr>
</table>   	      
</form>
<br>
<div style="height: 300px;overflow: scroll;">
					<table class="gridtable" width="80%"> 
					<tr style="background-color: #7cc2ff;color: white;"> 
						<th width="2%">No</th>
						<th>File Attached</th> 
					</tr>
					<%
					ps_check = con_master.prepareStatement("select * from rel_SAPmaster_fileUpload where enable=1 and created_by="+uid+" and sampleFlag is null order by id desc");
					rs_check = ps_check.executeQuery();
					while(rs_check.next()){
					%>
					<tr>
						<td align="center"><%=rs_check.getInt("id") %></td>
						<td><a href="Master_DisplayMyDoc.jsp?field=<%=rs_check.getInt("id") %>"><strong style="color: blue;font-weight: bold;"><%=rs_check.getString("filename") %></strong></a> </td>
					</tr>
					<%
					}
					%>
					</table>
</div>              
             </div>
             <div style="width: 39%;float: right; padding-left: 20px;height: 480px;overflow: scroll;">
             <%
            ArrayList log = new ArrayList();
 			if (request.getAttribute("logData") != null) {
 				log = (ArrayList) request.getAttribute("logData");
 				LinkedHashSet hashSet = new LinkedHashSet(log); 
 			    ArrayList final_ErrorLog = new ArrayList(hashSet); 
 			//	System.out.println("There are values in the arraylist" + log); 
 			%>
 			<table class="gridtable"> 
					<tr style="background-color: #f88686;color: white;"> 
						<th>S.No</th>
						<th>Issue Found</th> 
					</tr>
			<%
			for(int i=0;i<final_ErrorLog.size();i++){		
			%>		
					<tr>
						<td align="center"><%=i+1 %></td>
						<td>S.No <strong><%=final_ErrorLog.get(i).toString() %></strong></td>
					</tr>
 			<%	 
 			}
			%>
			</table>
			<%
 			} else {
 				//System.out.println("There are no values in the arraylist");
 			}
             %>
             </div>
              </div>
          </div>
        </div>
      </section> 
    </section>
 <!---------------------------------------------------------------------------------- User Profile Screen Ends ----------------------------------------------------------------------->                
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