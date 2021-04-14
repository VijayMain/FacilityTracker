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
<title>Add New WFH Project</title> 
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
<script type="text/javascript" src="js/tabledeleterow.js"></script>
</head>

<body>
<%
try{
/*-------------------------------------------------------------------------------------------------------------------*/
Connection con = Connection_Util.getLocalUserConnection();
PreparedStatement ps_check=null;
ResultSet rs_check=null;
int comp_id = Integer.valueOf(session.getAttribute("comp_id").toString());
int dept_id = Integer.valueOf(session.getAttribute("dept_id").toString());
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
        <!-- <div class="row">
          <div class="col-lg-12">
            <h3 class="page-header"><i class="fa fa-laptop"></i> Dashboard</h3>
            <ol class="breadcrumb">
              <li><i class="fa fa-home"></i><a href="Home.jsp">Home</a></li>  
              <li><i class="arrow_carrot-right_alt2"></i>Add New Work From Home Project</li>
            </ol>
          </div>
        </div>  -->
<!-- ********************************************************************************************************************* -->
<!-- ************************************ Tiles to Display**************************************************************** -->
	<div class="row">
          <div class="col-lg-12">
            <section class="panel">
              <header class="panel-heading">Create New Project</header>
              <div class="panel-body">
                <div class="form"> 
            <form action="FM_New_RequestControl" method="post" enctype="multipart/form-data" id="feedback_form" class="form-validate form-horizontal">
                    <div class="form-group">
                    <label class="control-label col-lg-2" for="inputSuccess"><strong>Company Name</strong><b style="color: red;"> * </b></label>
                    <div class="col-lg-10"> 
                      <select name="company" id="company" class="form-control m-bot15" style="font-weight: bold;color: black;" required>
                      <%
                      ps_check = con.prepareStatement("SELECT * FROM user_tbl_company where enable=1 and  Company_Id="+comp_id);
                      rs_check = ps_check.executeQuery();
                      while(rs_check.next()){
                      %>
                      <option value="<%=rs_check.getInt("Company_Id") %>"><%=rs_check.getString("Company_Name") %></option>
                      <%
                      } 
                      ps_check = con.prepareStatement("SELECT * FROM user_tbl_company where (enable=1 or company_id=6) and  Company_Id!="+comp_id);
                      rs_check = ps_check.executeQuery();
                      while(rs_check.next()){
                      %>
                      <option value="<%=rs_check.getInt("Company_Id") %>"><%=rs_check.getString("Company_Name") %></option>
                      <%
                      }
                      %>
                      </select> 
                    </div>
                    </div> 
                    
                    <div class="form-group ">
                      <label for="ccomment" class="control-label col-lg-2"><strong>Project Title</strong><b style="color: red;"> * </b></label>
                      <div class="col-lg-10">
                        <input class="form-control" style="font-weight: bold;color: black;font-size: 18px;" id="prj_title" name="prj_title" maxlength="50" minlength="5" type="text" required />
                      </div>
                    </div>
                     
                     <div class="form-group ">
                      <label for="ccomment" class="control-label col-lg-2"><strong>Project Description</strong><b style="color: red;"> * </b></label>
                      <div class="col-lg-10">
                      <textarea rows="2" cols="100" class="form-control" style="font-weight: bold;color: black;font-size: 18px;" id="prj_desc" name="prj_desc" required></textarea>
                          </div>
                    </div>
                    
                    
                    <div class="form-group ">
                      <label for="ccomment" class="control-label col-lg-2"><strong>Remark (If Any)</strong> </label>
                      <div class="col-lg-10">
                      <textarea rows="1" cols="100" class="form-control" style="font-weight: bold;color: black;font-size: 18px;" id="prj_remark" name="prj_remark"></textarea>
                          </div>
                    </div> 
                     
                     <div class="form-group">
                    <label class="control-label col-lg-2" for="inputSuccess"><strong>Support Documents <br>(If Any)</strong></label>
                    <div class="col-lg-10"> 
                     
                     <table id="tblSample">
						 <tr> &nbsp;&nbsp;&nbsp;
							 <strong> <input  type="button" style="background-color:  #d1ffce;" value="  + ADD More Files  " name="button" onclick="addRowToTable();" /></strong> &nbsp;&nbsp;
							 <input  type="button"  style="background-color:  #ffdcd9;" value=" - Delete [Selected] " onclick="deleteChecked();" />&nbsp;&nbsp; 
							 <input class="form-control" type="hidden" id="srno" name="srno" value="">
						 </tr>
						 <tbody></tbody>
					 </table>
                     
                     
                     
                    </div>
                    </div>
                     
                    
                    <div class="form-group">
                      <div class="col-lg-offset-2 col-lg-10"> 
                        <input type="submit" class="btn btn-primary" name="submit" id="submit" value="   Request Submit   " style="font-weight: bold;">
                      </div>
                    </div>
                  </form>
                </div>

              </div>
            </section>
          </div>
        </div>
        
        
        
        <!-- project team & activity end -->

      </section> 
    </section>
    
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
  <<script src="js/fullcalendar.min.js"></script>
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