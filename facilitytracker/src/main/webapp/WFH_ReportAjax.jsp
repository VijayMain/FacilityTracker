<%@page import="java.util.HashSet"%>
<%@page import="java.util.Set"%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.util.ArrayList"%>
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
<title>Ajax</title>
</head>
<body>
<span id="getDetails" style="color: black;">
<img alt="#" src="img/load.gif" style="visibility: hidden;height: 50px;margin-left: 50px;" id="loaderId">
<%
try{ 
	Connection con = Connection_Util.getLocalUserConnection();
	Connection con_master = Connection_Util.getConnectionMaster();
	String monthSelected = request.getParameter("monthSelected");
	String yearsSelected = request.getParameter("yearsSelected");   
	String dept_name = request.getParameter("dept_name");
	 
	String layoutType="";
	
	int dept_id = Integer.valueOf(session.getAttribute("dept_id").toString());
	int comp_id = Integer.valueOf(session.getAttribute("comp_id").toString());
	int uid = Integer.valueOf(session.getAttribute("uid").toString());  
	DecimalFormat df = new DecimalFormat("00"); 
	DecimalFormat df3 = new DecimalFormat("00.00");
	DecimalFormat df4 = new DecimalFormat("00.0");
	int monthpass=Integer.valueOf(monthSelected), yearpass = Integer.valueOf(yearsSelected); 
	PreparedStatement ps_check=null,ps_check2=null;
	ResultSet rs_check=null,rs_check2=null;
	String startDate="",endDate="";
	String stringTotal="",stringTotal_apr="",stringTotal_rej="";
	Double confDay=0.0,confhalfDay=0.0;
	ps_check = con_master.prepareStatement("select * from tran_wfh_config where enable_id=1");
	rs_check = ps_check.executeQuery();
	while(rs_check.next()){
		layoutType=	rs_check.getString("specification3");
		 
		if(rs_check.getString("specification1")!=null && rs_check.getString("parameter").equalsIgnoreCase("Day")){
			// System.out.println("day = " + rs_check.getString("parameter"));
			confDay = Double.valueOf(rs_check.getString("specification1"));
		}
		if(rs_check.getString("specification1")!=null && rs_check.getString("parameter").equalsIgnoreCase("Half Day")){
			// System.out.println("day = " + rs_check.getString("parameter"));
			confhalfDay = Double.valueOf(rs_check.getString("specification1"));
		}
	}
	/*-------------------------------------------------------------------------------------------------------------------*/
	/*--------------------------------------- Calculate Tuesdays --------------------------------------------------*/
	/*-------------------------------------------------------------------------------------------------------------------*/
   	ArrayList tuesdayList = new ArrayList();   		
	ArrayList dayminutes = new ArrayList();
	
	ArrayList tot_min = new ArrayList();
	ArrayList app_min = new ArrayList();
	ArrayList rej_min = new ArrayList();
	 
	
		Calendar calendar = Calendar.getInstance(); 
	    calendar.set(yearpass, monthpass, 1);
	    int daysInMonth = calendar.getActualMaximum(Calendar.DAY_OF_MONTH); 
	    
	    
	    int tuesday = 0;
	    for (int day = 1; day <= daysInMonth; day++) {
	    	dayminutes.add(day-1,"");
	    	app_min.add(day-1,"");
	    	tot_min.add(day-1,"");
	    	rej_min.add(day-1,""); 
	    	
	        calendar.set(yearpass, monthpass , day);
	        int dayOfWeek = calendar.get(Calendar.DAY_OF_WEEK);
	        if (dayOfWeek == Calendar.TUESDAY) {
	        	tuesday++;  
	        	tuesdayList.add(day);
	        } 
	    } 
	    //System.out.println("Tuesday =  " + tuesdayList);
/*-------------------------------------------------------------------------------------------------------------------*/
/*-------------------------------------------------------------------------------------------------------------------*/
%> 
	<span id="excel_data">
	<a href="javascript:generateExcel('<%=monthSelected%>','<%=yearsSelected%>','<%=dept_name %>');" style="color: black;font-weight: bold;margin-left: 50px;" class="btn btn-warning btn-sm" >Generate Excel</a>
	<img alt="#" src="img/load.gif" style="visibility: hidden;height: 50px;margin-left: 50px;" id="loaderExcelId">
	</span>
<%
if(confDay==0.0){
	%>
	<br>
	<b style="color: black;background-color: yellow;">1 Day = ? Hours....Please update configuration.</b>
<%
}

%>
<div style="height: 450px;overflow: scroll;margin-left: 10px;margin-right: 5px;">
	<table style="width: 300%;color: white;" class="gridtable">
     <tr align="center" style="color: black;">
    <!-- <th rowspan="2">UNo</th> -->
    <th rowspan="2">Emp Code</th>
    <th rowspan="2">Employee Name</th>
    <th rowspan="2">Plant</th>
    <th rowspan="2">Dept</th>    
    <%
    if(!layoutType.equalsIgnoreCase("Cumulative")){
    %>
    <th colspan="3" style="text-align: center;font-weight: bold;color: blue;background-color: #cfde1f;">Total Worked Days</th>
    <%
	}else{
	%>
	<th colspan="2" style="text-align: center;font-weight: bold;color: blue;background-color: #cfde1f;">Total Worked Days</th>
	<%	
	}
    for (int day = 1; day <= daysInMonth; day++) {
    %>
    <th colspan="3" style="text-align: center;font-weight: bold;color: blue;"><%=day %></th> 
    <%
    }
    %>     
  </tr>
  <tr style="color: black;">
  	<td style="font-weight: bold;color: blue;background-color: #cfde1f;">Total</td>
    <td style="font-weight: bold;color: blue;background-color: #cfde1f;">App</td>
    <%
    if(!layoutType.equalsIgnoreCase("Cumulative")){
    %>
    <td style="font-weight: bold;color: blue;background-color: #cfde1f;">Week off</td> 
  <%
    }
  for (int day = 1; day <= daysInMonth; day++) {
  %>
    <td style="font-weight: bold;color: blue;">Total</td>
    <td style="font-weight: bold;color: blue;">Approved</td>
    <td style="font-weight: bold;color: blue;">Rej</td> 
  <%
	}
  %>
  </tr>
<%
	ArrayList u_list = new ArrayList();
//	System.out.println("daysInMonth =" + daysInMonth + "u_list = " + u_list + "tuesday = " + tuesday + " = " + dayminutes +"  = " + dayminutes.size());
 
if(dept_id==18 || dept_id==26 || comp_id==6){
	 startDate=df.format((monthpass+1)) +"-" + df.format(1) +"-" + yearpass;
     endDate=df.format((monthpass+1)) +"-" + dayminutes.size() +"-" + yearpass;
     //  System.out.println("test = " + dayminutes.size() + " = " + startDate + " = " + endDate);
	if(dept_name.equalsIgnoreCase("All")){
	ps_check = con_master.prepareStatement("select distinct(u_id) u_id from tran_dwm_tasks where enable_id=1 and tran_date  between '"+startDate+"' and '"+endDate+"'");
	rs_check = ps_check.executeQuery();
	while(rs_check.next()){
		u_list.add(rs_check.getInt("u_id"));
	}
	}else{
		ps_check2 =con.prepareStatement("SELECT u_id FROM user_tbl where sap_id in (SELECT emp_code FROM sap_users where orgunit_text like '%"+dept_name+"%')");
		rs_check2 = ps_check2.executeQuery();
		while(rs_check2.next()){
		ps_check = con_master.prepareStatement("select distinct(u_id) u_id from tran_dwm_tasks where enable_id=1 and u_id="+rs_check2.getInt("u_id")+" and tran_date between '"+startDate+"' and '"+endDate+"'");
		rs_check = ps_check.executeQuery();
		while(rs_check.next()){
			u_list.add(rs_check.getInt("u_id"));
		}
		}
	}
}else{
	u_list.add(uid);
}
	 
	  
	  
	Set<Integer> set = new HashSet(u_list);
	u_list.clear();
	u_list.addAll(set);
	
	double tot_hr=0.0,tot_apr=0.0,tot_rej=0.0; 
	/* int tot_dayshr=0, tot_aprhr=0; */
	
	for(int j=0;j<u_list.size();j++){
/*---------------------------------------------------------------------------------------------------------------------------*/
/*----------------------------------------------- User Details Header ---------------------------------------------------*/
/*---------------------------------------------------------------------------------------------------------------------------*/
		%>
		<tr style="color: black;">
		<%-- <td><%=u_list.get(j).toString() %></td> --%>
		<% 
		String sap_id="" , U_Name="" , Location="" , Orgunit_Text="";
		int ctdecimal=0;
		String ct_valHr="",ct_valApr="";
		ps_check = con.prepareStatement("SELECT sap_id,U_Name FROM user_tbl where u_id="+ Integer.valueOf(u_list.get(j).toString()));
	    rs_check = ps_check.executeQuery();
	    while(rs_check.next()){
	    	sap_id=rs_check.getString("sap_id");
	    	U_Name=rs_check.getString("U_Name");  
		ps_check2 = con.prepareStatement("SELECT Location,Orgunit_Text FROM sap_users where Emp_Code='"+ rs_check.getString("sap_id") +"'");
	    rs_check2 = ps_check2.executeQuery();
	    while(rs_check2.next()){
	    	Location=rs_check2.getString("Location");
	    	Orgunit_Text=rs_check2.getString("Orgunit_Text");
	    }
	    }
	    %>
	    <td><%=sap_id %></td>
	    <td><%=U_Name %></td>
	    <td><%=Location %></td>
	    <td><%=Orgunit_Text %></td>
	    <%
	    sap_id=""; U_Name=""; Location=""; Orgunit_Text="";
	    /*---------------------------------------------------------------------------------------------------------------------------*/
	    /*---------------------------------------------------------------------------------------------------------------------------*/
	  	for(int i=0;i<dayminutes.size();i++){
			 startDate=df.format((monthpass+1)) +"-" +df.format(i+1) +"-" + yearpass;
             endDate=df.format((monthpass+1)) +"-" +df.format(i+1) +"-" + yearpass + " 23:59:59";
             
             if(tuesdayList.contains(i+1)){
            // -------------------------------------------- Tuesday Logic ------------------------------------------------------------------
            	 ps_check = con_master.prepareStatement("select SUM(CAST(time_elapsed as decimal)) as totHr from tran_dwm_tasks where u_id="+ Integer.valueOf(u_list.get(j).toString()) +" and enable_id=1 and tran_date='"+startDate+"' union all select SUM(CAST(time_spent_mins as decimal)) as totHr from tran_wfh_project_task where u_id="+ Integer.valueOf(u_list.get(j).toString()) +" and enable_id=1 and sys_date between '"+startDate+"' and '"+endDate+"'");
                 rs_check = ps_check.executeQuery();
                 while(rs_check.next()){
                	 if(rs_check.getString("totHr")!=null){
                	
                	if(layoutType.equalsIgnoreCase("Daywise")){
                		 
                	// tot_hr = (tot_hr + rs_check.getDouble("totHr"));
                	 if(rs_check.getDouble("totHr")>=confDay){
                		 tot_hr=tot_hr+1;            		 
                		// System.out.println((i+1) + "data  = ="+ confDay +" = = " + rs_check.getDouble("totHr") + " = " + tot_hr);
                	 }
                	 if((rs_check.getDouble("totHr")>=confhalfDay) && (rs_check.getDouble("totHr")<confDay)){
                		 tot_hr=tot_hr+0.5;
                		 
                		// System.out.println((i+1) + "data  = =" + confhalfDay +  " = " + confDay +" = " + (rs_check.getDouble("totHr")>=confhalfDay) + "  = " + (rs_check.getDouble("totHr")<confDay) + " = = " + rs_check.getDouble("totHr") + " = " + tot_hr);
                	 }
                	 
                	}else if(layoutType.equalsIgnoreCase("Cumulative")){
                		tot_hr = (tot_hr + rs_check.getDouble("totHr"));
                	}
                	}
               	}
                 ps_check = con_master.prepareStatement("select SUM(CAST(time_elapsed as decimal)) as totHr from tran_dwm_tasks where u_id="+ Integer.valueOf(u_list.get(j).toString()) +" and approval_id=3 and enable_id=1 and tran_date='"+startDate+"' union all select SUM(CAST(time_spent_mins as decimal)) as totHr from tran_wfh_project_task where u_id="+ Integer.valueOf(u_list.get(j).toString()) +"  and approval_id=3 and enable_id=1 and sys_date between '"+startDate+"' and '"+endDate+"'");
                 rs_check = ps_check.executeQuery();
                 while(rs_check.next()){
                	 if(rs_check.getString("totHr")!=null){
                		 
                		 if(layoutType.equalsIgnoreCase("Daywise")){	
                	// tot_apr = (tot_apr + rs_check.getDouble("totHr")); 
                		 if(rs_check.getDouble("totHr")>=confDay){
                			 tot_apr=tot_apr+1; 
                			// System.out.println((i+1) + "data approve  = =" + rs_check.getDouble("totHr") + " = " + tot_apr);
                    	 }
                    	 if(rs_check.getDouble("totHr")>=confhalfDay && rs_check.getDouble("totHr")<confDay){
                    		 tot_apr=tot_apr+0.5; 
                    		// System.out.println((i+1) + "data approve  = =" + rs_check.getDouble("totHr") + " = " + tot_apr);
                    	 }
                	}else if(layoutType.equalsIgnoreCase("Cumulative")){
                		tot_apr = (tot_apr + rs_check.getDouble("totHr")); 
                	}
                		
                	}
               	}
            /*---------------------------------------------------------------------------------------------------------------------------*/
           	/*---------------------------------------------------------------------------------------------------------------------------*/
             }else{
            	/*---------------------------------------------------------------------------------------------------------------------------*/
                /*---------------------------------------------------------------------------------------------------------------------------*/ 
             ps_check = con_master.prepareStatement("select SUM(CAST(time_elapsed as decimal)) as totHr from tran_dwm_tasks where u_id="+ Integer.valueOf(u_list.get(j).toString()) +" and enable_id=1 and tran_date='"+startDate+"' union all select SUM(CAST(time_spent_mins as decimal)) as totHr from tran_wfh_project_task where u_id="+ Integer.valueOf(u_list.get(j).toString()) +" and enable_id=1 and sys_date between '"+startDate+"' and '"+endDate+"'");
             rs_check = ps_check.executeQuery();
             while(rs_check.next()){
            	 if(rs_check.getString("totHr")!=null){
            	
            	if(layoutType.equalsIgnoreCase("Daywise")){
            		 
            	// tot_hr = (tot_hr + rs_check.getDouble("totHr"));
            	 if(rs_check.getDouble("totHr")>=confDay){
            		 tot_hr=tot_hr+1;            		 
            		// System.out.println((i+1) + "data  = ="+ confDay +" = = " + rs_check.getDouble("totHr") + " = " + tot_hr);
            	 }
            	 if((rs_check.getDouble("totHr")>=confhalfDay) && (rs_check.getDouble("totHr")<confDay)){
            		 tot_hr=tot_hr+0.5;
            		 
            		// System.out.println((i+1) + "data  = =" + confhalfDay +  " = " + confDay +" = " + (rs_check.getDouble("totHr")>=confhalfDay) + "  = " + (rs_check.getDouble("totHr")<confDay) + " = = " + rs_check.getDouble("totHr") + " = " + tot_hr);
            	 }
            	 
            	}else if(layoutType.equalsIgnoreCase("Cumulative")){
            		tot_hr = (tot_hr + rs_check.getDouble("totHr"));
            	} 
            	}
           	}
             ps_check = con_master.prepareStatement("select SUM(CAST(time_elapsed as decimal)) as totHr from tran_dwm_tasks where u_id="+ Integer.valueOf(u_list.get(j).toString()) +" and approval_id=3 and enable_id=1 and tran_date='"+startDate+"' union all select SUM(CAST(time_spent_mins as decimal)) as totHr from tran_wfh_project_task where u_id="+ Integer.valueOf(u_list.get(j).toString()) +"  and approval_id=3 and enable_id=1 and sys_date between '"+startDate+"' and '"+endDate+"'");
             rs_check = ps_check.executeQuery();
             while(rs_check.next()){
            	 if(rs_check.getString("totHr")!=null){
            		 
            		 if(layoutType.equalsIgnoreCase("Daywise")){	
            	// tot_apr = (tot_apr + rs_check.getDouble("totHr")); 
            		 if(rs_check.getDouble("totHr")>=confDay){
            			 tot_apr=tot_apr+1; 
            			// System.out.println((i+1) + "data approve  = =" + rs_check.getDouble("totHr") + " = " + tot_apr);
                	 }
                	 if(rs_check.getDouble("totHr")>=confhalfDay && rs_check.getDouble("totHr")<confDay){
                		 tot_apr=tot_apr+0.5; 
                		// System.out.println((i+1) + "data approve  = =" + rs_check.getDouble("totHr") + " = " + tot_apr);
                	 }
            	}else if(layoutType.equalsIgnoreCase("Cumulative")){
            		tot_apr = (tot_apr + rs_check.getDouble("totHr")); 
            	}
            		
            	}
           	}
            /*---------------------------------------------------------------------------------------------------------------------------*/
            /*---------------------------------------------------------------------------------------------------------------------------*/  
           }  
            /*   
            if(tot_hr!=0.0){
            	 tot_hr=tot_hr/conf;
            	 
            	 if(tot_hr>=1){
            		 tot_dayshr++;
            	 }
             }
             if(tot_apr!=0.0){
            	 tot_apr=tot_apr/conf;
            	 if(tot_apr>=1){
            		 tot_aprhr++;
            	 }
             }
             tot_hr=0.0; tot_apr=0.0; 
             
             */
             
           // System.out.println((i+1) + " day " + tot_hr + " = " + tot_apr + " = " + tuesdayList.contains(i+1));
            /*  System.out.println( df.format((tot_hr*60)%60) + " = " + df.format(tot_hr)); */
		} 
	    
	 	if(layoutType.equalsIgnoreCase("Cumulative")){
	 		ctdecimal=0; ct_valHr="";ct_valApr="";
	 		if(tot_hr!=0.0){
	 			// System.out.println(confDay +" hr = " + tot_hr + " = = "  + df.format(tot_hr/confDay) + " = "  +  df.format(tot_hr%60));
	 			// tot_hr=tot_hr/confDay;
	 			// System.out.println("tot_hr = " + tot_hr + " = " + tot_hr/confDay);
	 			// System.out.println((tot_hr/confDay) + "    =   " + df4.format(tot_hr/confDay).length() + "   data = = " + df4.format((tot_hr/confDay)).substring(3));
	 			
	 			ct_valHr =df3.format(tot_hr/confDay).substring(0, 2); 
	 			ctdecimal = Integer.valueOf(df4.format((tot_hr/confDay)).substring(3)); 
	 			if(ctdecimal>=8){
	 				ct_valHr= df3.format(Double.valueOf(ct_valHr)+1);
	 			}
	 			if(ctdecimal<=7 && ctdecimal>=5){
	 				ct_valHr= df3.format(Double.valueOf(ct_valHr)+0.5); 
	 			} 
	 			// hr_cumString=df.format((int)Math.round(tot_hr/confDay));	 			
	         }
	         if(tot_apr!=0.0){ 
	        	
	        	 ct_valApr =df3.format(tot_apr/confDay).substring(0, 2);
		 			
	        	 ctdecimal = Integer.valueOf(df4.format((tot_apr/confDay)).substring(3));
	        	 
		 			if(ctdecimal>=8){
		 				ct_valApr= df3.format(Double.valueOf(ct_valApr)+1); 
		 			}
		 			if(ctdecimal<=7 && ctdecimal>=5){
		 				ct_valApr= df3.format(Double.valueOf(ct_valApr)+0.5);  
		 			}
	         }
    	}
	    
	 	 /* if(tot_hr!=0.0){
        	 tot_hr=tot_hr/conf; 
         }
         if(tot_apr!=0.0){
        	 tot_apr=tot_apr/conf; 
         }  */ 
         if(!layoutType.equalsIgnoreCase("Cumulative")){
	 	%>
        <td style="background-color: red;color: white;background-color: #52561d;font-weight: bold;" align="right"><%=df3.format(tot_hr)%><%-- ... <%=df3.format(tot_hr)%> --%></td>
        <td style="background-color: red;color: white;background-color: #52561d;font-weight: bold;" align="right"><%=df3.format(tot_apr)%> <%-- <%=df3.format(tot_apr) %> --%></td>
     	<td style="background-color: red;color: white;background-color: #52561d;font-weight: bold;" align="right"><%=tuesday%></td> 
      <%
    	}else{
      %>
      <td style="background-color: red;color: white;background-color: #52561d;font-weight: bold;" align="right"><%=ct_valHr%><%-- ... <%=df3.format(tot_hr)%> --%></td>
      <td style="background-color: red;color: white;background-color: #52561d;font-weight: bold;" align="right"><%=ct_valApr%> <%-- <%=df3.format(tot_apr) %> --%></td>
     <%	
     ct_valApr="";
     ct_valHr="";
     ctdecimal=0;
    	}
      tot_hr=0.0; tot_apr=0.0; 
  	for(int i=0;i<dayminutes.size();i++){
 		
		 startDate=df.format((monthpass+1)) +"-" +df.format(i+1) +"-" + yearpass;
        endDate=df.format((monthpass+1)) +"-" +df.format(i+1) +"-" + yearpass + " 23:59:59";
        
        ps_check = con_master.prepareStatement("select SUM(CAST(time_elapsed as decimal)) as totHr from tran_dwm_tasks where u_id="+ Integer.valueOf(u_list.get(j).toString()) +" and enable_id=1 and tran_date='"+startDate+"' union all select SUM(CAST(time_spent_mins as decimal)) as totHr from tran_wfh_project_task where u_id="+ Integer.valueOf(u_list.get(j).toString()) +" and enable_id=1 and sys_date between '"+startDate+"' and '"+endDate+"'");
        rs_check = ps_check.executeQuery();
        while(rs_check.next()){
       	 if(rs_check.getString("totHr")!=null){
       	 tot_hr = (tot_hr + rs_check.getDouble("totHr")); 
       	} 
      	}
        
        ps_check = con_master.prepareStatement("select SUM(CAST(time_elapsed as decimal)) as totHr from tran_dwm_tasks where u_id="+ Integer.valueOf(u_list.get(j).toString()) +" and approval_id=3 and enable_id=1 and tran_date='"+startDate+"' union all select SUM(CAST(time_spent_mins as decimal)) as totHr from tran_wfh_project_task where u_id="+ Integer.valueOf(u_list.get(j).toString()) +"  and approval_id=3 and enable_id=1 and sys_date between '"+startDate+"' and '"+endDate+"'");
        rs_check = ps_check.executeQuery();
        while(rs_check.next()){
       	 if(rs_check.getString("totHr")!=null){
       	 tot_apr = (tot_apr + rs_check.getDouble("totHr")); 
       	 }
      	}
        
        ps_check = con_master.prepareStatement("select SUM(CAST(time_elapsed as decimal)) as totHr from tran_dwm_tasks where u_id="+ Integer.valueOf(u_list.get(j).toString()) +" and approval_id=2 and enable_id=1 and tran_date='"+startDate+"' union all select SUM(CAST(time_spent_mins as decimal)) as totHr from tran_wfh_project_task where u_id="+ Integer.valueOf(u_list.get(j).toString()) +"  and approval_id=2 and enable_id=1 and sys_date between '"+startDate+"' and '"+endDate+"'");
        rs_check = ps_check.executeQuery();
        while(rs_check.next()){
       	 if(rs_check.getString("totHr")!=null){
       	 tot_rej = (tot_rej + rs_check.getDouble("totHr"));  
       	 } 
      	}
         	tot_min.set(i, df3.format(tot_hr/60));
        	app_min.set(i, df3.format(tot_apr/60)); 
			rej_min.set(i, df3.format(tot_rej/60));

        tot_hr=0.0;tot_apr=0.0;tot_rej=0.0; 
   
        if(Double.valueOf(tot_min.get(i).toString())==0.0){ 
   %>
 <td style="background-color: red;color: white;" align="right"><%=tot_min.get(i).toString() %></td>  
   <%	  
    }else{
    	/* System.out.println("test = " + df.format(Double.valueOf(tot_min.get(i).toString().substring(0, 2))) + " = " + Double.valueOf(tot_min.get(i).toString()) + " = " + df.format((Double.valueOf(tot_min.get(i).toString())*60)%60)); */
   %>
   <td style="background-color: green;color: white;" align="right"><%=df.format(Double.valueOf(tot_min.get(i).toString().substring(0, 2)))%>:<%=df.format((Double.valueOf(tot_min.get(i).toString())*60)%60) %>  <%-- <%=tot_min.get(i).toString() %> --%></td> 
   <%	 
    } 
     if(Double.valueOf(app_min.get(i).toString())==0.0){
   %>
 <td style="background-color: red;color: white;" align="right"><%=app_min.get(i).toString() %></td>  
   <%	  
    }else{
    	//System.out.println(app_min.get(i).toString() + " = " + df.format(Double.valueOf(app_min.get(i).toString().substring(0, 2))) + " = " + df.format((Double.valueOf(app_min.get(i).toString())*60)%60));
   %>
   <td style="background-color: green;color: white;" align="right"><%=df.format(Double.valueOf(app_min.get(i).toString().substring(0, 2)))%>:<%=df.format((Double.valueOf(app_min.get(i).toString())*60)%60) %></td> 
   <%	 
    } 
     if(Double.valueOf(rej_min.get(i).toString())==0.0){
   %>
 <td style="background-color: red;color: white;" align="right"><%=rej_min.get(i).toString() %></td>  
   <%	  
    }else{
   %>
   <td style="background-color: green;color: white;" align="right"><%=df.format(Double.valueOf(rej_min.get(i).toString().substring(0, 2)))%>:<%=df.format((Double.valueOf(rej_min.get(i).toString())*60)%60) %></td> 
   <%	 
    }  
	}  
    %>  
         
	</tr>
	<%	 
	} 
	%> 
</table>
</div>
<!-- <marquee><b>Please Note : Weekly Off Included in Total Worked Days and Total Approved Days.</b></marquee> -->
</span>
<%	
}catch(Exception e){
	e.printStackTrace();
}
%>
</body>
</html>