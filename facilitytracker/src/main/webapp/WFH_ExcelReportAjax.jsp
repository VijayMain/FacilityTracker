<%@page import="jxl.write.WritableSheet"%>
<%@page import="jxl.write.Label"%>
<%@page import="jxl.format.BorderLineStyle"%>
<%@page import="jxl.format.Border"%>
<%@page import="jxl.format.Alignment"%>
<%@page import="jxl.write.WritableCellFormat"%>
<%@page import="jxl.write.WritableFont"%>
<%@page import="jxl.format.Colour"%>
<%@page import="jxl.Workbook"%>
<%@page import="jxl.write.WritableWorkbook"%>
<%@page import="java.io.File"%>
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
<title>Insert title here</title>
</head>
<body>
<span id="excel_data" style="color: black;">

<%
try{ 
	Connection con = Connection_Util.getLocalUserConnection();
	Connection con_master = Connection_Util.getConnectionMaster();
	String monthSelected = request.getParameter("monthSelected");
	String yearsSelected = request.getParameter("yearsSelected");
	int dept_id = Integer.valueOf(session.getAttribute("dept_id").toString());
	int comp_id = Integer.valueOf(session.getAttribute("comp_id").toString());
	String dept_name = request.getParameter("dept_name");
	
	int uid = Integer.valueOf(session.getAttribute("uid").toString());  
	DecimalFormat df = new DecimalFormat("00");
	DecimalFormat df3 = new DecimalFormat( "00.00" );
	DecimalFormat df4 = new DecimalFormat("00.0");
	int monthpass=Integer.valueOf(monthSelected), yearpass = Integer.valueOf(yearsSelected); 
	String layoutType="";
	PreparedStatement ps_check=null,ps_check1=null,ps_check2=null;
	ResultSet rs_check=null,rs_check1=null,rs_check2=null;
	String startDate="",endDate="";
	int ctdecimal=0;
	String ct_valHr="",ct_valApr=""; 
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
	/*--------------------------------------- Calculate Tuesdays --------------------------------------------------------*/
	/*-------------------------------------------------------------------------------------------------------------------*/
   	ArrayList tuesdayList = new ArrayList();  		
	ArrayList dayminutes = new ArrayList();
	
	ArrayList tot_min = new ArrayList();
	ArrayList app_min = new ArrayList();
	ArrayList rej_min = new ArrayList();
	 
	int excnt=2;
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
/*-------------------------------------------------------------------------------------------------------------------*/
			ArrayList alistFile = new ArrayList();
			File folder = new File("C:/reportxls");
			File[] listOfFiles = folder.listFiles();
			String listname = "";

			int val = listOfFiles.length + 1;
			String fileName = "C:/reportxls/WFH_Sheet"+val+".xls";
			File exlFile = new File(fileName);  
			
			WritableWorkbook writableWorkbook = Workbook.createWorkbook(exlFile);  
			Colour bckcolor = Colour.GRAY_25;
			
			Colour bckred_color = Colour.RED;
			Colour bckgreen_color = Colour.GREEN;
			
			WritableFont font = new WritableFont(WritableFont.ARIAL);
			font.setColour(Colour.BLACK); 

			WritableFont fontbold = new WritableFont(WritableFont.ARIAL);
			fontbold.setColour(Colour.BLACK);
			fontbold.setBoldStyle(WritableFont.BOLD);

			WritableCellFormat cellFormat = new WritableCellFormat();
			cellFormat.setBackground(bckcolor);
			cellFormat.setAlignment(Alignment.CENTRE);
			cellFormat.setBorder(Border.ALL, BorderLineStyle.THIN, Colour.BLACK); 
			cellFormat.setFont(fontbold); 

			WritableCellFormat cellRIghtformat = new WritableCellFormat(); 
			cellRIghtformat.setBorder(Border.ALL, BorderLineStyle.THIN, Colour.BLACK);
			font.setColour(Colour.BLACK); 
			cellRIghtformat.setFont(font);
			cellRIghtformat.setAlignment(Alignment.RIGHT);
			
			 
			WritableCellFormat cellRIghtred = new WritableCellFormat();
			cellRIghtred.setBorder(Border.ALL, BorderLineStyle.THIN, Colour.BLACK); 
			cellRIghtred.setFont(font);
			cellRIghtred.setBackground(bckred_color);
			cellRIghtred.setAlignment(Alignment.RIGHT); 
			cellRIghtred.setWrap(true);
			
			WritableCellFormat cellRIghtgreen = new WritableCellFormat();
			cellRIghtgreen.setBorder(Border.ALL, BorderLineStyle.THIN, Colour.BLACK); 
			cellRIghtgreen.setFont(font);
			cellRIghtgreen.setBackground(bckgreen_color);
			cellRIghtgreen.setAlignment(Alignment.RIGHT); 
			cellRIghtgreen.setWrap(true);
			
			
			
			
			WritableCellFormat cellFormatWrap = new WritableCellFormat();
			cellFormatWrap.setBorder(Border.ALL, BorderLineStyle.THIN, Colour.BLACK);
			font.setColour(Colour.BLACK); 
			cellFormatWrap.setFont(font);
			cellFormatWrap.setAlignment(Alignment.RIGHT); 
			cellFormatWrap.setWrap(true);

			WritableCellFormat cellleftformat = new WritableCellFormat(); 
			cellleftformat.setBorder(Border.ALL, BorderLineStyle.THIN, Colour.BLACK);
			font.setColour(Colour.BLACK); 
			cellleftformat.setFont(font); 	
			cellleftformat.setAlignment(Alignment.LEFT);  
			
			WritableSheet writableSheet = writableWorkbook.createSheet("WFH_Hours", 0);
			writableSheet.setColumnView(0, 10);
			writableSheet.setColumnView(1, 20);
			writableSheet.setColumnView(2, 20); 
			writableSheet.setColumnView(3, 7);  
			
			for (int day = 1; day <= (daysInMonth*4); day++) {
			writableSheet.setColumnView((3+day), 7);
			} 
			Label label0 = new Label(0, 0, "SAP Code",cellFormat);
			Label label1 = new Label(1, 0, "Employee Name",cellFormat);
			Label label111 = new Label(2, 0, "Plant",cellFormat);
			Label label122 = new Label(3, 0, "Dept",cellFormat);
			Label label2 = new Label(4, 0, "Emp Code",cellFormat); 
			Label label3 = new Label(5, 0, "Total Worked Days",cellFormat);  
			
			Label label4 = new Label(7, 0, "1",cellFormat); 
			
			writableSheet.mergeCells(0, 0,0, 1);
			writableSheet.mergeCells(1, 0,0, 1);
			writableSheet.mergeCells(2, 0,0, 1);
			writableSheet.mergeCells(3, 0,0, 1);
			writableSheet.mergeCells(4, 0,6, 0); 
			writableSheet.mergeCells(7, 0,9, 0); 
			// Add the created Cells to the sheet
						writableSheet.addCell(label0);
						writableSheet.addCell(label1);
						writableSheet.addCell(label111);
						writableSheet.addCell(label122);
						writableSheet.addCell(label2);  
						writableSheet.addCell(label3);  
						writableSheet.addCell(label4);
						
						
						
						
			Label label5 = new Label(10, 0, "2",cellFormat);
			writableSheet.mergeCells(10, 0,12, 0);
			writableSheet.addCell(label5);
			
			int ex1=13,ex2=15,labex=6;
			Label label6;
			for (int day = 3; day <= daysInMonth; day++) {
				label6 = new Label(ex1, 0, String.valueOf(day),cellFormat);
				writableSheet.mergeCells(ex1, 0,ex2, 0);
				writableSheet.addCell(label6);
				ex1=ex2+1;
				ex2=ex2+3; 
			}
			
			Label label7 = new Label(4, 1, "Tot",cellFormat); 
			writableSheet.addCell(label7);
			Label label8 = new Label(5, 1, "Apr",cellFormat); 
			writableSheet.addCell(label8);
			Label label88 = new Label(6, 1, "Week Off",cellFormat); 
			writableSheet.addCell(label88);
			
			Label label9,label10,label11;
			for (int day = 1; day <= daysInMonth; day++) {
				labex++;
				label9 = new Label(labex, 1, "Tot",cellFormat); 
				writableSheet.addCell(label9);
				labex++;
				label10 = new Label(labex, 1, "Apr",cellFormat); 
				writableSheet.addCell(label10);
				labex++;
				label11 = new Label(labex, 1, "Rej",cellFormat); 
				writableSheet.addCell(label11);
			}
// ------------------------------------------------------------------------------------------------------------------------
// ------------------------------------------------------------------------------------------------------------------------
			ArrayList u_list = new ArrayList();
//			System.out.println("daysInMonth =" + daysInMonth + "u_list = " + u_list + "tuesday = " + tuesday + " = " + dayminutes +"  = " + dayminutes.size());
		 
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
// ------------------------------------------------------------------------------------------------------------------------
// ------------------------------------------------------------------------------------------------------------------------		
			/* Label label13 = new Label(0, j+2,u_list.get(j).toString(),cellRIghtformat); 
			writableSheet.addCell(label13); */
			
			ps_check = con.prepareStatement("SELECT sap_id,U_Name FROM user_tbl where u_id="+ Integer.valueOf(u_list.get(j).toString()));
		    rs_check = ps_check.executeQuery();
		    while(rs_check.next()){
		    	Label label15 = new Label(0, j+2,rs_check.getString("sap_id"),cellRIghtformat); 
				writableSheet.addCell(label15);
		    	Label label14 = new Label(1, j+2,rs_check.getString("U_Name"),cellRIghtformat); 
				writableSheet.addCell(label14); 
				
				ps_check1 = con.prepareStatement("SELECT Location,Orgunit_Text FROM sap_users where Emp_Code='"+ rs_check.getString("sap_id") +"'");
			    rs_check1 = ps_check1.executeQuery();
			    while(rs_check1.next()){
			    	Label label153 = new Label(2, j+2,rs_check1.getString("Location"),cellRIghtformat); 
					writableSheet.addCell(label153);
			    	Label label143 = new Label(3, j+2,rs_check1.getString("Orgunit_Text"),cellRIghtformat); 
					writableSheet.addCell(label143);
			    }
		    }
// ------------------------------------------------------------------------------------------------------------------------
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
	             
	             
			}
		    if(layoutType.equalsIgnoreCase("Cumulative")){
		    	ctdecimal=0; ct_valHr="";ct_valApr="";
		 		if(tot_hr!=0.0){
		        	 // tot_hr=tot_hr/confDay; 
		 			ct_valHr =df3.format(tot_hr/confDay).substring(0, 2); 
		 			ctdecimal = Integer.valueOf(df4.format((tot_hr/confDay)).substring(3)); 
		 			if(ctdecimal>=8){
		 				ct_valHr= df3.format(Double.valueOf(ct_valHr)+1);
		 			}
		 			if(ctdecimal<=7 && ctdecimal>=5){
		 				ct_valHr= df3.format(Double.valueOf(ct_valHr)+0.5); 
		 			} 
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
		  /*   if(tot_hr!=0.0){
	        	 tot_hr=tot_hr/conf; 
	         }
	         if(tot_apr!=0.0){
	        	 tot_apr=tot_apr/conf; 
	         }  */
// ------------------------------------------------------------------------------------------------------------------------		
	       if(!layoutType.equalsIgnoreCase("Cumulative")){
			Label label16 = new Label(4, j+2,df3.format(tot_hr),cellRIghtformat); 
			writableSheet.addCell(label16);
			Label label17 = new Label(5, j+2,df3.format(tot_apr),cellRIghtformat); 
			writableSheet.addCell(label17);
			Label label178 = new Label(6, j+2,String.valueOf(tuesday),cellRIghtformat); 
			writableSheet.addCell(label178);
	       }else{
	    	   Label label16 = new Label(4, j+2,ct_valHr,cellRIghtformat); 
				writableSheet.addCell(label16);
				Label label17 = new Label(5, j+2,ct_valApr,cellRIghtformat); 
				writableSheet.addCell(label17);
				Label label178 = new Label(6, j+2,"",cellRIghtformat); 
				writableSheet.addCell(label178);
				ct_valApr="";
			    ct_valHr="";
			    ctdecimal=0;
	       }
			
// ------------------------------------------------------------------------------------------------------------------------
			tot_hr=0.0; tot_apr=0.0;
			int rowcnt=7;
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
		        Label label18,label19,label20;
		        
		     
		        
		     if(Double.valueOf(tot_min.get(i).toString())==0.0){
		        	label18 = new Label(rowcnt, j+2,tot_min.get(i).toString(),cellRIghtred); 
					writableSheet.addCell(label18); 
					rowcnt++;
		    }else{
		    	label18 = new Label(rowcnt,j+2,df.format(Double.valueOf(tot_min.get(i).toString().substring(0, 2)))+":"+df.format((Double.valueOf(tot_min.get(i).toString())*60)%60),cellRIghtgreen); 
				writableSheet.addCell(label18); 
				rowcnt++;
		    } 
		        
		     if(Double.valueOf(app_min.get(i).toString())==0.0){
		    	 label19 = new Label(rowcnt, j+2,app_min.get(i).toString(),cellRIghtred); 
					writableSheet.addCell(label19); 
					rowcnt++;
		    }else{
		    	 label19 = new Label(rowcnt, j+2,df.format(Double.valueOf(app_min.get(i).toString().substring(0, 2)))+":"+df.format((Double.valueOf(app_min.get(i).toString())*60)%60),cellRIghtgreen); 
					writableSheet.addCell(label19); 
					rowcnt++;
		    } 
		     
		     
		     if(Double.valueOf(rej_min.get(i).toString())==0.0){
		    	 label20 = new Label(rowcnt, j+2,rej_min.get(i).toString(),cellRIghtred); 
				 writableSheet.addCell(label20); 
				 rowcnt++;
		    }else{
		    	 label20 = new Label(rowcnt, j+2,df.format(Double.valueOf(rej_min.get(i).toString().substring(0, 2)))+":"+df.format((Double.valueOf(rej_min.get(i).toString())*60)%60),cellRIghtgreen); 
				 writableSheet.addCell(label20); 
				 rowcnt++;
		    }  
			}
		 // ------------------------------------------------------------------------------------------------------------------------
		 // ------------------------------------------------------------------------------------------------------------------------
			}
			writableWorkbook.write();
			writableWorkbook.close(); 
/*-------------------------------------------------------------------------------------------------------------------*/
	%> 
	<a href="DownloadFile.jsp?filepath=<%=fileName%>" style="margin-left: 10px;"><b><i class="icon_download" title="Download Report"></i> Download Report</b>
	<img alt="#" src="img/load.gif" style="visibility: hidden;height: 50px;" id="loaderExcelId">
</span>
<%	
}catch(Exception e){
	e.printStackTrace();
}
%>
</body>
</html>