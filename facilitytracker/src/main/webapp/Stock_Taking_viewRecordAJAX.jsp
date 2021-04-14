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
<span id="getPHYLoc">
<%
try{
	int store_loc = Integer.valueOf(request.getParameter("store_loc"));
	int sno = Integer.valueOf(request.getParameter("sno"));
	String batchNo = request.getParameter("batchNo"); 
	String entry_qty =  request.getParameter("entry_qty"); 
	String tag_no = request.getParameter("tag_no"); 
	int stockType = Integer.valueOf(request.getParameter("stockType"));
	String mat_type = request.getParameter("mat_type");  
	int phy_location = Integer.valueOf(request.getParameter("phy_location"));
	String fiscal_year = request.getParameter("fiscal_year");
	String data_entryPLant = request.getParameter("data_entryPLant");
	Connection con = Connection_Util.getConnectionMaster();
	PreparedStatement ps_check = null;
	ResultSet rs_check = null;
	boolean flag = false; 
	String storage_location="";
	ps_check = con.prepareStatement("select storage_location from stocktaking_storageLocation where id="+store_loc);
	rs_check = ps_check.executeQuery();
	while(rs_check.next()){
		storage_location=rs_check.getString("storage_location");
	}
	
  
	ps_check = con.prepareStatement("select uom,sno, Plant, storage_loc, physical_inv_doc, material_no, material_desc, mat_type from stocktaking_summary where sno='"+String.valueOf(sno)+"' and Plant='"+data_entryPLant+"' and fiscal_year='"+
				String.valueOf(fiscal_year)+"' and storage_loc='"+storage_location+"' and mat_type='"+mat_type+"' and stocktype_id="+stockType+" and enable=1");
	rs_check = ps_check.executeQuery();
	
	%>
<table class="gridtable" width="100%"> 
<tr> 
 <th>SNO</th>
 <th>Plant</th> 
 <th>Location</th>
 <th>Inv Doc</th>
 <th>Material Code</th>
 <th>Material Descr</th>
 <th>UOM</th>
 <th>Material Type</th>
 </tr>
<%
while(rs_check.next()){
	flag=true;
%>
 <tr style="height: 30px;">
 	<td align="center"><%=rs_check.getString("sno") %></td>
 	<td><%=rs_check.getString("Plant") %></td>
 	<td><%=rs_check.getString("storage_loc") %></td>
 	<td><%=rs_check.getString("physical_inv_doc") %></td>
 	<td><%=rs_check.getString("material_no") %></td>
 	<td><%=rs_check.getString("material_desc") %></td>
 	<td><%=rs_check.getString("uom") %></td>
 	<td><%=rs_check.getString("mat_type") %></td>
 </tr> 
<%
 }
if(flag==false){
%>
<tr style="height: 30px;">
<td colspan="7"><strong style="background-color: red;color: white;font-size: 15px;">Not Found...!!!</strong></td>
</tr>
<%	
}
%>
</table>
<%
}catch(Exception e){
	e.printStackTrace();
}
%>
</span>
</body>
</html>