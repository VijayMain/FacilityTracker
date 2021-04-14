<%@page import="java.text.DecimalFormat"%>
<%@page import="com.facilitytracker.connectionUtil.Connection_Util"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.text.DateFormatSymbols"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.util.ArrayList"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
</head>
<body>
<span id="getMonth">
<%
Connection con = Connection_Util.getLocalUserConnection();
Connection con_master = Connection_Util.getConnectionMaster();
String monthSelected = request.getParameter("monthSelected");
String yearsSelected = request.getParameter("yearsSelected");
int uid = Integer.valueOf(session.getAttribute("uid").toString()); 

int monthpass=Integer.valueOf(monthSelected), yearpass = Integer.valueOf(yearsSelected);

Calendar todayCal= Calendar.getInstance();
DecimalFormat df = new DecimalFormat("00");
DecimalFormat df3 = new DecimalFormat( "00.00" );
Calendar cal = Calendar.getInstance(); 
cal.set(Calendar.MONTH,Integer.valueOf(monthSelected));
cal.set(Calendar.YEAR,Integer.valueOf(yearsSelected));
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
int todaymnt = todayCal.get(Calendar.MONTH);
int todayyear = todayCal.get(Calendar.YEAR); 

int todaySelect = cal.get(Calendar.DATE);
int todaymntSelect = cal.get(Calendar.MONTH);
int todayyearSelect = cal.get(Calendar.YEAR); 


/* System.out.println(today + " = = " + todaymnt +" = = " + todayyear);
System.out.println(todaySelect + " = = " + todaymntSelect +" = = " + todayyearSelect); */
boolean flag=false;
if(todaymnt==todaymntSelect && todayyear==todayyearSelect){
	flag=true;
}
Double tot_hoursAp=0.0,todays_tot =0.0;		 
Double tot_PrjhoursAp=0.0,todays_Prjtot =0.0;	
Integer histDay =0;String startDate="",endDate="";

PreparedStatement ps_user=null, ps_check1=null;
ResultSet rs_user=null, rs_check1=null;
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

String view_Conf ="";    
PreparedStatement ps_conf = con_master.prepareStatement("SELECT *  FROM tran_wfh_config where enable_id=1 and parameter='Day Hours'");
ResultSet rs_config = ps_conf.executeQuery();
while(rs_config.next()){
	view_Conf = rs_config.getString("details") +" = " + rs_config.getString("specification2") +" Hours";
}

/*-------------------------------------------------------------------------------------------------------------------*/
%> 
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
					<a href="WFH_DayDetails.jsp?day=<%=daycntFList.get(i).toString()%>&month=<%=todaymntSelect%>&year=<%=todayyearSelect%>"> 
					<%
					}else{
					%>
					<a href="#"> 
					<%	
					}
					if(daycntFList.get(i).toString().equalsIgnoreCase(String.valueOf(today)) && flag==true){
					%>
            		<div class="info-box" style="color: black;background-color: yellow;padding: 5px!important; min-height: 100px!important;margin-bottom: 10px!important;"> 
              		<%
					}else{
					%>
					<div class="info-box" style="color: black;padding: 5px!important; min-height: 100px!important;margin-bottom: 10px!important;">
					<%	
					}
              		%>
              		<div class="count" style="font-size: 16px!important;"><%=daycntFList.get(i).toString() %></div> 
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
					<a href="WFH_DayDetails.jsp?day=<%=disDay%>&month=<%=todaymntSelect%>&year=<%=todayyearSelect%>"> 
					<%
					if(today==disDay && flag==true){
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
					<a href="WFH_DayDetails.jsp?day=<%=disDay%>&month=<%=todaymntSelect%>&year=<%=todayyearSelect%>"> 
            		<%
					if(today==disDay && flag==true){
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
						<a href="WFH_DayDetails.jsp?day=<%=disDay%>&month=<%=todaymntSelect%>&year=<%=todayyearSelect%>"> 
            		<%
					if(today==disDay && flag==true){
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
					<a href="WFH_DayDetails.jsp?day=<%=disDay%>&month=<%=todaymntSelect%>&year=<%=todayyearSelect%>"> 
            		<%
					if(today==disDay && flag==true){
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
					<a href="WFH_DayDetails.jsp?day=<%=disDay%>&month=<%=todaymntSelect%>&year=<%=todayyearSelect%>"> 
            		<%
					if(today==disDay && flag==true){
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
</body>
</html>