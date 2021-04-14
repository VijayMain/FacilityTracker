<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Calendar"%>
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
<title>AJAX</title>
</head>
<body>
<%
try{ 
	Connection con = Connection_Util.getConnectionMaster();  
	int uid = Integer.valueOf(session.getAttribute("uid").toString());
	java.util.Date date = null;
	java.sql.Timestamp timeStamp = null;
	Calendar calendar = Calendar.getInstance();
	calendar.setTime(new Date());
	java.sql.Date dt = new java.sql.Date(calendar.getTimeInMillis());
	java.sql.Time sqlTime = new java.sql.Time(calendar.getTime().getTime());
	SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
	SimpleDateFormat cellDateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	date = simpleDateFormat.parse(dt.toString() + " " + sqlTime.toString());
	timeStamp = new java.sql.Timestamp(date.getTime()); 
	
	String comp = request.getParameter("comp"); 
	String location = request.getParameter("location"); 
	String ct = request.getParameter("ct"); 
	String fiscal = request.getParameter("fiscal");    
	String stockType = request.getParameter("stockType"); 
	boolean flag = false; 
	
	PreparedStatement ps_del = con.prepareStatement("delete FROM stocktaking_summary where enable=1 and Plant='"
			+ comp + "' and storage_loc='" + location + "' and fiscal_year='" +fiscal +"' and stocktype_desc='"+stockType+"'");
	int del = ps_del.executeUpdate();
	
	ps_del = con.prepareStatement("update stocktaking_attachments set enable=0, updated_by="+uid+",update_date='"+timeStamp+"' where enable=1 and Plant='"
			+ comp + "' and storage_loc='" + location + "' and fiscal_year='" +fiscal +"' and  stocktype_desc='"+stockType+"'");
	del = ps_del.executeUpdate();
	
	
	
%>
 <span id="deleteData">
				<table style="width: 100%;" class="gridtable">
					<tr>
						<th>SNO</th>
						<th>Plant</th> 
						<th>Inv Doc</th>
						<th>FSYr</th>
						<th>CountDate</th>
						<th>ItemNo</th>
						<th>Mat Code</th>
						<th>Mat Descr</th>
						<th>UOM</th>
						<th>Mat Type</th>
						<th>Entry Qty</th>
						<th>Zero cnt</th>
						<th>Serial no</th>
						<th>Reason</th>
						<th>Batch</th>
						<th>Tag No</th>
					</tr>
					<%
						PreparedStatement ps_check = con.prepareStatement("SELECT  * FROM stocktaking_summary where enable=1 and Plant='"
											+ comp + "' and storage_loc='" + location + "' and fiscal_year='" +fiscal +"' and stocktype_desc='"+stockType+"'");
						ResultSet rs_check = ps_check.executeQuery();
							while (rs_check.next()) {
								flag=true;
					%>
					<tr>
						<td><%=rs_check.getString("sno")%></td>
						<td><%=rs_check.getString("Plant")%></td> 
						<td><%=rs_check.getString("physical_inv_doc")%></td>
						<td><%=rs_check.getString("fiscal_year")%></td>
						<td><%=rs_check.getString("countdate")%></td>
						<td><%=rs_check.getString("item_no")%></td>
						<td><%=rs_check.getString("material_no")%></td>
						<td><%=rs_check.getString("material_desc")%></td>
						<td><%=rs_check.getString("uom")%></td>
						<td><%=rs_check.getString("mat_type")%></td>
						<td><%=rs_check.getString("entry_qty")%></td>
						<td><%=rs_check.getString("zero_cnt")%></td>
						<td><%=rs_check.getString("serial_no")%></td>
						<td><%=rs_check.getString("Reason")%></td>
						<td><%=rs_check.getString("batch_no")%></td> 
						<td><%=rs_check.getString("tag_no")%></td> 
					</tr>
					<%
						}
							if(flag==false){
					%>
					<tr>
						<td colspan="16" style="font-family: Arial, Helvetica, sans-serif; color: black;background-color: yellow;">Delete Successful.....!!!</td>
					</tr>
					<%			
							}							
					%>
					
				</table>
				</span>                      
<%	
}catch(Exception e){
	e.printStackTrace();
}
%>
</body>
</html>