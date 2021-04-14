<%@page import="java.text.DecimalFormat"%>
<%@page import="java.util.GregorianCalendar"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.text.DateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.text.DateFormatSymbols"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
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
<title>Dashboard</title> 
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
	function getFullCalender() {   
	var monthSelected = document.getElementById("monthSelected").value;
	var yearsSelected = document.getElementById("yesrSelected").value;
	 
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
				document.getElementById("getMonth").innerHTML = xmlhttp.responseText; 
			}
		};
		xmlhttp.open("POST", "WFH_FullCalender.jsp?monthSelected=" + monthSelected + "&yearsSelected="+yearsSelected, true);
		xmlhttp.send();
}
</script>
</head>

<body style="color: black;font-family: Arial, Helvetica, sans-serif;">
<%
try{
/*-------------------------------------------------------------------------------------------------------------------*/
Connection con = Connection_Util.getLocalUserConnection();
Connection con_master = Connection_Util.getConnectionMaster();
PreparedStatement ps_check=null;
ResultSet rs_check=null;
int comp_id = Integer.valueOf(session.getAttribute("comp_id").toString());
int dept_id = Integer.valueOf(session.getAttribute("dept_id").toString());
int uid = Integer.valueOf(session.getAttribute("uid").toString()); 
SimpleDateFormat sdf1 = new SimpleDateFormat("MM-dd-yyyy");
Calendar todayCal= Calendar.getInstance();
Calendar cal = Calendar.getInstance();
DecimalFormat df = new DecimalFormat("00");
DecimalFormat df3 = new DecimalFormat( "00.00" );
// Last day of month ===>
int current_mnt_lastDay = cal.getActualMaximum(Calendar.DATE); 
cal.set(Calendar.DATE,1); 
SimpleDateFormat sdf=new SimpleDateFormat("EEEE");

//System.out.println(sdf.format(cal.getTime()) + " = " + current_mnt_lastDay);

// Days Name ==>
String[] namesOfDays = DateFormatSymbols.getInstance().getWeekdays(); 

// first day name
String firstDayName = namesOfDays[cal.get(Calendar.DAY_OF_WEEK)]; 

int today = todayCal.get(Calendar.DATE);
int monthpass = cal.get(Calendar.MONTH);
int yearpass = cal.get(Calendar.YEAR);
Double tot_hoursAp=0.0,todays_tot =0.0;		 
Double tot_PrjhoursAp=0.0,todays_Prjtot =0.0;	
Integer histDay =0;String startDate="",endDate="";
/*-------------------------------------------------------------------------------------------------------------------*/
/*-------------------------------------------------------------------------------------------------------------------*/
/*--------------------------------------- Calculate Tuesdays --------------------------------------------------*/
/*-------------------------------------------------------------------------------------------------------------------*/

    Calendar calendar = Calendar.getInstance(); 
    calendar.set(yearpass, monthpass, 1);
    int daysInMonth = calendar.getActualMaximum(Calendar.DAY_OF_MONTH); 
    int tuesday = 0;
    for (int day = 1; day <= daysInMonth; day++) {
        calendar.set(yearpass, monthpass , day);
        int dayOfWeek = calendar.get(Calendar.DAY_OF_WEEK);
        if (dayOfWeek == Calendar.TUESDAY) {
        	tuesday++;  
        }
    } 
 
String view_Conf ="1 day = ? Hours";    
PreparedStatement ps_conf = con_master.prepareStatement("SELECT *  FROM tran_wfh_config where enable_id=1 and id=1");
ResultSet rs_config = ps_conf.executeQuery();
while(rs_config.next()){
	view_Conf = rs_config.getString("details") +" = " + rs_config.getString("specification2") +" Hours";
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
	<%
	PreparedStatement ps_user=null, ps_check1=null;
	ResultSet rs_user=null, rs_check1=null;
	%>
	<div class="form-group">
                    <div class="col-lg-3"> 
                    <%
                    List<String> monthsList = new ArrayList<String>();
                    String[] months = new DateFormatSymbols().getMonths(); 
                    Calendar now = Calendar.getInstance();
                    %>
                   <b style="font-weight: bold;color: black;">  Month : </b>
                   <select name="monthSelected" id="monthSelected" onchange="getFullCalender()" style="font-weight: bold;color: black;width: 190px;height: 30px;">
                  <%
                  int curr_mth = now.get(Calendar.MONTH); 
                  %>
                  <option value="<%=curr_mth%>"><%=months[curr_mth]%></option>  
                    <%
                      for (int i = curr_mth+1; i < months.length-1; i++) {
                      String month = months[i]; 
                      %>
                      <option value="<%=i%>"><%=month%></option>
                      <%  
                    	} 
                    for (int i = 0; i < curr_mth; i++) {
                      String month = months[i]; 
                      %>
                      <option value="<%=i%>"><%=month%></option>
                      <%  
                    	}
                    %>
                      </select> 
                     </div>
                     
                     <div class="col-lg-3"> 
                <b style="font-weight: bold;color: black;"> Year : </b>
                <select name="yesrSelected" id="yesrSelected" onchange="getFullCalender()" style="font-weight: bold;color: black;width: 190px;height: 30px;">
                   <%
                      int year = Calendar.getInstance().get(Calendar.YEAR);                     
                      for(int i=year;i>=year-2;i--){
                          %>
                          <option value="<%=i%>"><%=i%></option> 
                          <%  
                          }
                      %>
                   </select>
                    </div> </div>   
             <span id="getMonth">
                <div class="col-lg-12"> 
            <table style="width: 100%;color: white;" class="gridtable">
		 	<tr style="background-color: #dedede;color:"> 
					<th align="center"  style="color: black;background-color: white;"><%=view_Conf %></th>
					<th align="center"  style="color: black;background-color: white;">Total Weekoff : <%=tuesday %></th>
					<!-- <th  align="right" style="color: black;background-color: white;"><b>Total Approved Hours :</b></th>  -->
			</tr>
			</table> 
           </div>
             <div class="form-group">   
                    <div class="col-lg-12">    
                    <table style="width: 100%;" class="gridtable">
					<tr style="background-color: #dedede;color: black;">
					<% 
//********************************************************************************************************************************					
///// Calender Header =====> 
					int daycnt =0;
                    /* for (String dayName: namesOfDays) */
                    	for(int i=1;i<namesOfDays.length;i++){ 
                    		if(firstDayName.equalsIgnoreCase(namesOfDays[i].toString())){
                    			daycnt = i;
                    		}
                    		
                    		if(i==3){
                    			%>
                                <th style="background-color: #ff756b; color: black;text-align: center;"><%=namesOfDays[i] %></th>
                                <%			
                    		}else{
                    %>
                    <th style="color: black;text-align: center;"><%=namesOfDays[i] %></th>
                    <%
                    		}
                    }
                    
//********************************************************************************************************************************                   
                    %> 
                    
					</tr>
					<tr>
					<%
//********************************************************************************************************************************
/////   First Calender Row ====> 
					daycnt--;
					int day = current_mnt_lastDay,
					disDay = 1;
					ArrayList daycntFList = new ArrayList();
					for(int i=0;i<7;i++){ 
						if(i>=daycnt){
							disDay= day -(day-disDay);
							daycntFList.add(disDay);
							disDay++;
						}else{
							daycntFList.add("");
						} 
					}
					
					for(int i=0;i<daycntFList.size();i++){ 						
					%>
					<td>
					<%
					if(!daycntFList.get(i).toString().equalsIgnoreCase("")){
					%>
					<a href="WFH_DayDetails.jsp?day=<%=daycntFList.get(i).toString()%>&month=<%=monthpass%>&year=<%=yearpass%>"> 
					<%
					}else{
					%>
					<a href="#"> 
					<%	
					}
					if(daycntFList.get(i).toString().equalsIgnoreCase(String.valueOf(today))){
					%>
            		<div class="info-box" style="color: black;background-color: yellow;padding: 5px!important; min-height: 100px!important;margin-bottom: 10px!important;"> 
              		<%
					}else{
					%>
					<div class="info-box" style="color: black;padding: 5px!important; min-height: 100px!important;margin-bottom: 10px!important;">
					<%	
					}
              		%>
              		<div class="count" style="font-size: 20px!important;font-weight: bold;"><%=daycntFList.get(i).toString() %></div> 
              		<%
              		if(!daycntFList.get(i).toString().equalsIgnoreCase("")){
             // ******************************************************************************************
             // ******************************************************************************************
             histDay = Integer.valueOf(daycntFList.get(i).toString());
             startDate=df.format((monthpass+1)) +"-" +df.format(histDay) +"-" + yearpass;
             endDate=df.format((monthpass+1)) +"-" +df.format(histDay) +"-" + yearpass + " 23:59:59"; 
 			ps_user = con_master.prepareStatement("select SUM(CAST(time_elapsed as decimal)) as totHr from tran_dwm_tasks where u_id="+uid+" and enable_id=1 and tran_date= '"+startDate+"'");
 			rs_user = ps_user.executeQuery();
 			while(rs_user.next()){
 				todays_tot=rs_user.getDouble("totHr");
 			}
 			ps_user = con_master.prepareStatement("select SUM(CAST(time_spent_mins as decimal)) as totHr from tran_wfh_project_task where u_id="+uid+" and enable_id=1 and sys_date between '"+startDate+"' and '" +endDate+"'");
 			rs_user = ps_user.executeQuery();
 			while(rs_user.next()){
 				todays_Prjtot=rs_user.getDouble("totHr");
 			} 
 			ps_user = con_master.prepareStatement("select SUM(CAST(time_elapsed as decimal)) as totHr from tran_dwm_tasks where u_id="+uid+" and approval_id=3 and enable_id=1 and tran_date= '"+startDate+"'");
 			rs_user = ps_user.executeQuery();
 			while(rs_user.next()){
 				tot_hoursAp=rs_user.getDouble("totHr");
 			}
 			ps_user = con_master.prepareStatement("select SUM(CAST(time_spent_mins as decimal)) as totHr from tran_wfh_project_task where u_id="+uid+" and approval_id=3 and enable_id=1 and sys_date between '"+startDate+"' and '" +endDate+"'");
 			rs_user = ps_user.executeQuery();
 			while(rs_user.next()){
 				tot_PrjhoursAp=rs_user.getDouble("totHr");
 			} 
 			   
 			tot_hoursAp = tot_PrjhoursAp+tot_hoursAp; 
 			todays_tot = todays_Prjtot+ todays_tot; 
              // ******************************************************************************************
              // ******************************************************************************************
              		%>
              		<div class="title" style="font-size: 9px!important;"><br>Worked <b style="font-size: 15px;"><%=df3.format(todays_tot/60) %></b></div> 
              		<div class="title" style="font-size: 9px!important;"><br>Approved <b style="font-size: 15px;"> <%= df3.format(tot_hoursAp/60)%></b> </div>
              		 <%	
              	tot_hoursAp=0.0; todays_tot =0.0 ;		 
              	tot_PrjhoursAp=0.0; todays_Prjtot =0.0; 
              	startDate=""; endDate="'";
              		}
              		%>
            		</div>  
         			</a>
					</td>
					<%	 
					}
//********************************************************************************************************************************					
					%>	  
					</tr> 
					<tr>
					<% 
//********************************************************************************************************************************					
//// second row ====> 
					for(int i=0;i<7;i++){
					%>
					<td> 
					<a href="WFH_DayDetails.jsp?day=<%=disDay%>&month=<%=monthpass%>&year=<%=yearpass%>">
					<%
					if(today==disDay){
					%>					
            		<div class="info-box" style="color: black;background-color: yellow;padding: 5px!important; min-height: 100px!important;margin-bottom: 10px!important;"> 
              		<%
					}else{
					%>					
	            	<div class="info-box" style="color: black;padding: 5px!important;min-height: 100px!important;margin-bottom: 10px!important;"> 
	              	<%	
					}
              		%>
              		<div class="count" style="font-size: 16px!important;"><%=disDay %></div>
              		<%
              	// ******************************************************************************************
                // ******************************************************************************************
                    histDay = Integer.valueOf(disDay);
                    startDate=df.format((monthpass+1)) +"-" +df.format(histDay) +"-" + yearpass;
                    endDate=df.format((monthpass+1)) +"-" +df.format(histDay) +"-" + yearpass + " 23:59:59"; 
        			ps_user = con_master.prepareStatement("select SUM(CAST(time_elapsed as decimal)) as totHr from tran_dwm_tasks where u_id="+uid+" and enable_id=1 and tran_date= '"+startDate+"'");
        			rs_user = ps_user.executeQuery();
        			while(rs_user.next()){
        				todays_tot=rs_user.getDouble("totHr");
        			}
        			ps_user = con_master.prepareStatement("select SUM(CAST(time_spent_mins as decimal)) as totHr from tran_wfh_project_task where u_id="+uid+" and enable_id=1 and sys_date between '"+startDate+"' and '" +endDate+"'");
        			rs_user = ps_user.executeQuery();
        			while(rs_user.next()){
        				todays_Prjtot=rs_user.getDouble("totHr");
        			} 
        			ps_user = con_master.prepareStatement("select SUM(CAST(time_elapsed as decimal)) as totHr from tran_dwm_tasks where u_id="+uid+" and approval_id=3 and enable_id=1 and tran_date= '"+startDate+"'");
        			rs_user = ps_user.executeQuery();
        			while(rs_user.next()){
        				tot_hoursAp=rs_user.getDouble("totHr");
        			}
        			ps_user = con_master.prepareStatement("select SUM(CAST(time_spent_mins as decimal)) as totHr from tran_wfh_project_task where u_id="+uid+" and approval_id=3 and enable_id=1 and sys_date between '"+startDate+"' and '" +endDate+"'");
        			rs_user = ps_user.executeQuery();
        			while(rs_user.next()){
        				tot_PrjhoursAp=rs_user.getDouble("totHr");
        			} 
        			   
        			tot_hoursAp = tot_PrjhoursAp+tot_hoursAp; 
        			todays_tot = todays_Prjtot+ todays_tot; 
                     // ******************************************************************************************
                     // ******************************************************************************************
                     		%>
                     		<div class="title" style="font-size: 9px!important;"><br>Worked <b style="font-size: 15px;"><%=df3.format(todays_tot/60) %></b></div> 
                     		<div class="title" style="font-size: 9px!important;"><br>Approved <b style="font-size: 15px;"> <%= df3.format(tot_hoursAp/60)%></b> </div>
                     		 <%	
                     	tot_hoursAp=0.0; todays_tot =0.0 ;		 
                     	tot_PrjhoursAp=0.0; todays_Prjtot =0.0; 
                     	startDate=""; endDate="'";
              		%> 
            		</div>  
         			</a>
					</td>
					<%
					disDay++;
					}
//********************************************************************************************************************************
					%>
					</tr>
					
					<tr>
					<% 
//********************************************************************************************************************************
//// Third row ====> 
					for(int i=0;i<7;i++){
					%>
					<td>
					<a href="WFH_DayDetails.jsp?day=<%=disDay%>&month=<%=monthpass%>&year=<%=yearpass%>"> 
            		<%
					if(today==disDay){
					%>					
            		<div class="info-box" style="color: black;background-color: yellow;padding: 5px!important; min-height: 100px!important;margin-bottom: 10px!important;"> 
              		<%
					}else{
					%>					
	            	<div class="info-box" style="color: black;padding: 5px!important; min-height: 100px!important;margin-bottom: 10px!important;"> 
	              	<%	
					}
              		%> 
              		<div class="count" style="font-size: 16px!important;"><%=disDay %></div>
              		<%
              	// ******************************************************************************************
                    // ******************************************************************************************
                    histDay = Integer.valueOf(disDay);
                    startDate=df.format((monthpass+1)) +"-" +df.format(histDay) +"-" + yearpass;
                    endDate=df.format((monthpass+1)) +"-" +df.format(histDay) +"-" + yearpass + " 23:59:59"; 
        			ps_user = con_master.prepareStatement("select SUM(CAST(time_elapsed as decimal)) as totHr from tran_dwm_tasks where u_id="+uid+" and enable_id=1 and tran_date= '"+startDate+"'");
        			rs_user = ps_user.executeQuery();
        			while(rs_user.next()){
        				todays_tot=rs_user.getDouble("totHr");
        			}
        			ps_user = con_master.prepareStatement("select SUM(CAST(time_spent_mins as decimal)) as totHr from tran_wfh_project_task where u_id="+uid+" and enable_id=1 and sys_date between '"+startDate+"' and '" +endDate+"'");
        			rs_user = ps_user.executeQuery();
        			while(rs_user.next()){
        				todays_Prjtot=rs_user.getDouble("totHr");
        			} 
        			ps_user = con_master.prepareStatement("select SUM(CAST(time_elapsed as decimal)) as totHr from tran_dwm_tasks where u_id="+uid+" and approval_id=3 and enable_id=1 and tran_date= '"+startDate+"'");
        			rs_user = ps_user.executeQuery();
        			while(rs_user.next()){
        				tot_hoursAp=rs_user.getDouble("totHr");
        			}
        			ps_user = con_master.prepareStatement("select SUM(CAST(time_spent_mins as decimal)) as totHr from tran_wfh_project_task where u_id="+uid+" and approval_id=3 and enable_id=1 and sys_date between '"+startDate+"' and '" +endDate+"'");
        			rs_user = ps_user.executeQuery();
        			while(rs_user.next()){
        				tot_PrjhoursAp=rs_user.getDouble("totHr");
        			} 
        			   
        			tot_hoursAp = tot_PrjhoursAp+tot_hoursAp; 
        			todays_tot = todays_Prjtot+ todays_tot; 
                     // ******************************************************************************************
                     // ******************************************************************************************
                     		%>
                     		<div class="title" style="font-size: 9px!important;"><br>Worked <b style="font-size: 15px;"><%=df3.format(todays_tot/60) %></b></div> 
                     		<div class="title" style="font-size: 9px!important;"><br>Approved <b style="font-size: 15px;"> <%= df3.format(tot_hoursAp/60)%></b> </div>
                     		 <%	
                     	tot_hoursAp=0.0; todays_tot =0.0 ;		 
                     	tot_PrjhoursAp=0.0; todays_Prjtot =0.0; 
                     	startDate=""; endDate="'";
              		%> 

					</div>  
         			</a>
					</td>
					<%
					disDay++;
					}
					
//********************************************************************************************************************************
					%>
					</tr>
					
					<tr>
					<% 
//********************************************************************************************************************************
//// Forth row ====> 
					for(int i=0;i<7;i++){
						if(disDay<=current_mnt_lastDay){
					%>
					<td>
						<a href="WFH_DayDetails.jsp?day=<%=disDay%>&month=<%=monthpass%>&year=<%=yearpass%>"> 
            		<%
					if(today==disDay){
					%>					
            		<div class="info-box" style="color: black;background-color: yellow;padding: 5px!important; min-height: 100px!important;margin-bottom: 10px!important;"> 
              		<%
					}else{
					%>					
	            	<div class="info-box" style="color: black;padding: 5px!important; min-height: 100px!important;margin-bottom: 10px!important;">
	              	<%	
					}
              		%>
              		<div class="count" style="font-size: 16px!important;"><%=disDay %></div>
              		<%
              	// ******************************************************************************************
                    // ******************************************************************************************
                    histDay = Integer.valueOf(disDay);
                    startDate=df.format((monthpass+1)) +"-" +df.format(histDay) +"-" + yearpass;
                    endDate=df.format((monthpass+1)) +"-" +df.format(histDay) +"-" + yearpass + " 23:59:59"; 
        			ps_user = con_master.prepareStatement("select SUM(CAST(time_elapsed as decimal)) as totHr from tran_dwm_tasks where u_id="+uid+" and enable_id=1 and tran_date= '"+startDate+"'");
        			rs_user = ps_user.executeQuery();
        			while(rs_user.next()){
        				todays_tot=rs_user.getDouble("totHr");
        			}
        			ps_user = con_master.prepareStatement("select SUM(CAST(time_spent_mins as decimal)) as totHr from tran_wfh_project_task where u_id="+uid+" and enable_id=1 and sys_date between '"+startDate+"' and '" +endDate+"'");
        			rs_user = ps_user.executeQuery();
        			while(rs_user.next()){
        				todays_Prjtot=rs_user.getDouble("totHr");
        			} 
        			ps_user = con_master.prepareStatement("select SUM(CAST(time_elapsed as decimal)) as totHr from tran_dwm_tasks where u_id="+uid+" and approval_id=3 and enable_id=1 and tran_date= '"+startDate+"'");
        			rs_user = ps_user.executeQuery();
        			while(rs_user.next()){
        				tot_hoursAp=rs_user.getDouble("totHr");
        			}
        			ps_user = con_master.prepareStatement("select SUM(CAST(time_spent_mins as decimal)) as totHr from tran_wfh_project_task where u_id="+uid+" and approval_id=3 and enable_id=1 and sys_date between '"+startDate+"' and '" +endDate+"'");
        			rs_user = ps_user.executeQuery();
        			while(rs_user.next()){
        				tot_PrjhoursAp=rs_user.getDouble("totHr");
        			} 
        			   
        			tot_hoursAp = tot_PrjhoursAp+tot_hoursAp; 
        			todays_tot = todays_Prjtot+ todays_tot; 
                     // ******************************************************************************************
                     // ******************************************************************************************
                     		%>
                     		<div class="title" style="font-size: 9px!important;"><br>Worked <b style="font-size: 15px;"><%=df3.format(todays_tot/60) %></b></div> 
                     		<div class="title" style="font-size: 9px!important;"><br>Approved <b style="font-size: 15px;"> <%= df3.format(tot_hoursAp/60)%></b> </div>
                     		 <%	
                     	tot_hoursAp=0.0; todays_tot =0.0 ;		 
                     	tot_PrjhoursAp=0.0; todays_Prjtot =0.0; 
                     	startDate=""; endDate="'";
              		%> 
              		
              		</div>  
         			</a>

					</td>
					<%
					disDay++;
					}else{
					%>
						<td></td>	
					<%	
					}
					}
//********************************************************************************************************************************
					%>
					</tr>
					
					<tr>
					<% 
//********************************************************************************************************************************
//// Fifth row ====> 
					for(int i=0;i<7;i++){
						if(disDay<=current_mnt_lastDay){
					%>
					<td>
					<a href="WFH_DayDetails.jsp?day=<%=disDay%>&month=<%=monthpass%>&year=<%=yearpass%>"> 
            		<%
					if(today==disDay){
					%>					
            		<div class="info-box" style="color: black;background-color: yellow;padding: 5px!important; min-height: 100px!important;margin-bottom: 10px!important;"> 
              		<%
					}else{
					%>					
	            	<div class="info-box" style="color: black;padding: 5px!important; min-height: 100px!important;margin-bottom: 10px!important;">
	              	<%	
					}
              		%>
              		<div class="count" style="font-size: 16px!important;"><%=disDay %></div>
              		<%
              	// ******************************************************************************************
                    // ******************************************************************************************
                    histDay = Integer.valueOf(disDay);
                    startDate=df.format((monthpass+1)) +"-" +df.format(histDay) +"-" + yearpass;
                    endDate=df.format((monthpass+1)) +"-" +df.format(histDay) +"-" + yearpass + " 23:59:59"; 
        			ps_user = con_master.prepareStatement("select SUM(CAST(time_elapsed as decimal)) as totHr from tran_dwm_tasks where u_id="+uid+" and enable_id=1 and tran_date= '"+startDate+"'");
        			rs_user = ps_user.executeQuery();
        			while(rs_user.next()){
        				todays_tot=rs_user.getDouble("totHr");
        			}
        			ps_user = con_master.prepareStatement("select SUM(CAST(time_spent_mins as decimal)) as totHr from tran_wfh_project_task where u_id="+uid+" and enable_id=1 and sys_date between '"+startDate+"' and '" +endDate+"'");
        			rs_user = ps_user.executeQuery();
        			while(rs_user.next()){
        				todays_Prjtot=rs_user.getDouble("totHr");
        			} 
        			ps_user = con_master.prepareStatement("select SUM(CAST(time_elapsed as decimal)) as totHr from tran_dwm_tasks where u_id="+uid+" and approval_id=3 and enable_id=1 and tran_date= '"+startDate+"'");
        			rs_user = ps_user.executeQuery();
        			while(rs_user.next()){
        				tot_hoursAp=rs_user.getDouble("totHr");
        			}
        			ps_user = con_master.prepareStatement("select SUM(CAST(time_spent_mins as decimal)) as totHr from tran_wfh_project_task where u_id="+uid+" and approval_id=3 and enable_id=1 and sys_date between '"+startDate+"' and '" +endDate+"'");
        			rs_user = ps_user.executeQuery();
        			while(rs_user.next()){
        				tot_PrjhoursAp=rs_user.getDouble("totHr");
        			} 
        			   
        			tot_hoursAp = tot_PrjhoursAp+tot_hoursAp; 
        			todays_tot = todays_Prjtot+ todays_tot; 
                     // ******************************************************************************************
                     // ******************************************************************************************
                     		%>
                     		<div class="title" style="font-size: 9px!important;"><br>Worked <b style="font-size: 15px;"><%=df3.format(todays_tot/60) %></b></div> 
                     		<div class="title" style="font-size: 9px!important;"><br>Approved <b style="font-size: 15px;"> <%= df3.format(tot_hoursAp/60)%></b> </div>
                     		 <%	
                     	tot_hoursAp=0.0; todays_tot =0.0 ;		 
                     	tot_PrjhoursAp=0.0; todays_Prjtot =0.0; 
                     	startDate=""; endDate="'";
              		%> 
              		
              		
              		</div>  
         			</a>
					</td>
					<%
					disDay++;
					}else{
					%>
						<td></td>	
					<%	
					}
					}
//********************************************************************************************************************************
					%>
					</tr> 
					<tr>
					<% 
//********************************************************************************************************************************
//// Sixth row ====> 
					for(int i=0;i<7;i++){
						if(disDay<=current_mnt_lastDay){
					%>
					<td>
					<a href="WFH_DayDetails.jsp?day=<%=disDay%>&month=<%=monthpass%>&year=<%=yearpass%>"> 
            		<%
					if(today==disDay){
					%>					
            		<div class="info-box" style="color: black;background-color: yellow;padding: 5px!important; min-height: 100px!important;margin-bottom: 10px!important;"> 
              		<%
					}else{
					%>					
	            	<div class="info-box" style="color: black;padding: 5px!important; min-height: 100px!important;margin-bottom: 10px!important;"> 
	              	<%	
					}
              		%>
              		<div class="count" style="font-size: 16px!important;"><%=disDay %></div> 
              		<%
              	// ******************************************************************************************
                    // ******************************************************************************************
                    histDay = Integer.valueOf(disDay);
                    startDate=df.format((monthpass+1)) +"-" +df.format(histDay) +"-" + yearpass;
                    endDate=df.format((monthpass+1)) +"-" +df.format(histDay) +"-" + yearpass + " 23:59:59"; 
        			ps_user = con_master.prepareStatement("select SUM(CAST(time_elapsed as decimal)) as totHr from tran_dwm_tasks where u_id="+uid+" and enable_id=1 and tran_date= '"+startDate+"'");
        			rs_user = ps_user.executeQuery();
        			while(rs_user.next()){
        				todays_tot=rs_user.getDouble("totHr");
        			}
        			ps_user = con_master.prepareStatement("select SUM(CAST(time_spent_mins as decimal)) as totHr from tran_wfh_project_task where u_id="+uid+" and enable_id=1 and sys_date between '"+startDate+"' and '" +endDate+"'");
        			rs_user = ps_user.executeQuery();
        			while(rs_user.next()){
        				todays_Prjtot=rs_user.getDouble("totHr");
        			} 
        			ps_user = con_master.prepareStatement("select SUM(CAST(time_elapsed as decimal)) as totHr from tran_dwm_tasks where u_id="+uid+" and approval_id=3 and enable_id=1 and tran_date= '"+startDate+"'");
        			rs_user = ps_user.executeQuery();
        			while(rs_user.next()){
        				tot_hoursAp=rs_user.getDouble("totHr");
        			}
        			ps_user = con_master.prepareStatement("select SUM(CAST(time_spent_mins as decimal)) as totHr from tran_wfh_project_task where u_id="+uid+" and approval_id=3 and enable_id=1 and sys_date between '"+startDate+"' and '" +endDate+"'");
        			rs_user = ps_user.executeQuery();
        			while(rs_user.next()){
        				tot_PrjhoursAp=rs_user.getDouble("totHr");
        			} 
        			   
        			tot_hoursAp = tot_PrjhoursAp+tot_hoursAp; 
        			todays_tot = todays_Prjtot+ todays_tot; 
                     // ******************************************************************************************
                     // ******************************************************************************************
                     		%>
                     		<div class="title" style="font-size: 9px!important;"><br>Worked <b style="font-size: 15px;"><%=df3.format(todays_tot/60) %></b></div> 
                     		<div class="title" style="font-size: 9px!important;"><br>Approved <b style="font-size: 15px;"> <%= df3.format(tot_hoursAp/60)%></b> </div>
                     		 <%	
                     	tot_hoursAp=0.0; todays_tot =0.0 ;		 
                     	tot_PrjhoursAp=0.0; todays_Prjtot =0.0; 
                     	startDate=""; endDate="'";
              		%> 
              		
              		
            		</div>  
         			</a>
					</td>
					<%
					disDay++;
					}else{
					%>
						<td></td>	
					<%	
					}
					}
//********************************************************************************************************************************
					%>
					</tr>
					
					
					</table>
                    
                    
                    
                    
                    
                    
                    </div>
                    </div>
                    </span>
                    
  	</div>
        
         

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