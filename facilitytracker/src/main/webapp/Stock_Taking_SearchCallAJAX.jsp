<%@page import="java.text.DecimalFormat"%>
<%@page import="java.text.NumberFormat"%>
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
<span id="search_tagsSno">
<%
try{
	String plant = request.getParameter("plant");
	int fiscal_year = Integer.valueOf(request.getParameter("fiscal"));
	int store_loc = Integer.valueOf(request.getParameter("store_loc"));
	int stockType = Integer.valueOf(request.getParameter("stockType"));
	String mat_type = request.getParameter("mat_type");
	String phy_location = request.getParameter("phy_loc");
	int dept_id_check = Integer.valueOf(session.getAttribute("dept_id").toString());
	int extra_select = Integer.valueOf(request.getParameter("extra_select"));
	
	int sno=0,tno=0;
	String logQuery = "",mat_search="";
	if(request.getParameter("tno_search")!=""){
		tno = Integer.valueOf(request.getParameter("tno_search"));
		logQuery = logQuery + "  tag_no=" + tno + " and ";
	}
	if(request.getParameter("sno_search")!=""){
		sno = Integer.valueOf(request.getParameter("sno_search"));
		logQuery = logQuery + " sno=" + sno + " and ";
	}
	if(request.getParameter("mat_search")!=""){
		mat_search = request.getParameter("mat_search");
		logQuery = logQuery + " matCode like '%" + mat_search + "%' and ";
	}
	
//	System.out.println(" = = = " + logQuery); 
//	System.out.println(request.getParameter("sno_search") + "  = " + request.getParameter("tno_search") + " = " + sno+" = "+tno+
//			" = "+store_loc+" = "+stockType+" = "+mat_type+" = "+phy_location+" = "+extra_select + plant);
	
	Connection con = Connection_Util.getConnectionMaster();
	PreparedStatement ps_check = null;
	ResultSet rs_check = null;
	boolean flag = false;
	String query_count="";
%>
 	<table class="gridtable" width="100%">
<tr style="font-size: 12px !important;">
 <th style="font-size: 12px !important;">ID</th>
 <%
 if(extra_select!=1){
 %>
 <th style="font-size: 12px !important;">SNo</th>
 <%
 }else{
 %>
 <th style="font-size: 12px !important;">Mat Code</th>
 <%
 }
 %>
 <th style="font-size: 12px !important;">Batch No (If Any)</th>
 <th style="font-size: 12px !important;">Entry Qty</th>
 <th style="font-size: 12px !important;">Tag No</th>
 <th style="font-size: 12px !important;">Action</th>
</tr>
<% 	 
	NumberFormat formatter = new DecimalFormat("#0.###");  
	String storage_location="";
	ps_check = con.prepareStatement("select storage_location from stocktaking_storageLocation where id="+store_loc);
	rs_check = ps_check.executeQuery();
	while(rs_check.next()){
		storage_location=rs_check.getString("storage_location");
	}
	
	if(extra_select!=1){
	
	query_count = "select fiscal_year,plant,sno,stock_summary_id,batchNo,entry_qty,tag_no,id from stocktaking_count where  "+logQuery+" enable=1 and loc_audit_id_sub="+phy_location+" and stock_summary_id in ( "+
			" select id from stocktaking_summary where enable=1 and fiscal_year='"+String.valueOf(fiscal_year)+"' and Plant='"+plant+"' and storage_loc='"+storage_location+"' "+
			" and enable=1 and mat_type='"+mat_type+"' and stocktype_id="+stockType+") order by id desc";
	
//	System.out.println("loop =  " + " query ="+   tno + query_count);
	
	}else{
	query_count = "select matCode,fiscal_year,plant,extra_summary_id,batchNo,entry_qty,tag_no,id from stocktaking_count_extra where "+logQuery+" enable=1 and loc_audit_id_sub="+phy_location+" and extra_summary_id in ( "+
				" select id from stocktaking_summary_extra where enable=1 and fiscal_year='"+String.valueOf(fiscal_year)+"' and Plant='"+plant+"' and storage_loc='"+storage_location+"' "+
				" and enable=1 and mat_type='"+mat_type+"' and stocktype_id="+stockType+") order by id desc";
	}
	
	//System.out.println("test case = = " + query_count);
	
	ps_check = con.prepareStatement(query_count);	
	rs_check = ps_check.executeQuery();
	while(rs_check.next()){
	%>
 <tr style="height: 20px !important; font-size: 10px !important;">
 	<td align="right"><%=rs_check.getInt("id") %></td>
 	<%
 	if(extra_select!=1){
 	%>
	<td style="font-size: 12px !important;" align="right"><%=rs_check.getInt("sno") %></td>
	<%
	}else{
	%>
	<td align="right"><%=rs_check.getString("matCode") %></td>
	<%	
	}
	%>
 	<td><input type="text" value="<%=rs_check.getString("batchNo")%>" class="form-control" name="batchNo_ajax<%=rs_check.getInt("id") %>" id="batchNo_ajax<%=rs_check.getInt("id") %>"  style="color: black;font-size: 12px;font-weight: bold;"></td>
 	<td><input type="text" value="<%=formatter.format(rs_check.getDouble("entry_qty")) %>" oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*?)\..*/g, '$1');" name="entry_qty_ajax<%=rs_check.getInt("id") %>" id="entry_qty_ajax<%=rs_check.getInt("id") %>" class="form-control" style="color: black;font-size: 12px;font-weight: bold;"></td>
 	<td>
 	
 	<input type="text" value="<%=rs_check.getInt("tag_no") %>" oninput="this.value = this.value.replace(/[^0-9]/g, '').replace(/(\..*?)\..*/g, '$1');" name="tag_no_ajax<%=rs_check.getInt("id") %>" id="tag_no_ajax<%=rs_check.getInt("id") %>" class="form-control" style="color: black;font-size: 12px;font-weight: bold;">
 	
 	</td>
	<td align="center" style="font-size: 12px !important;">
	<span id="tag_edit<%=rs_check.getInt("id") %>">
	
	<input type="button" value="Edit" name="submit_tag" id="submit_tag" onclick="upload_TagInformation(<%=rs_check.getInt("id") %>,'<%=rs_check.getString("batchNo") %>',
	<%=rs_check.getDouble("entry_qty") %>,<%=rs_check.getInt("tag_no") %>,<%=rs_check.getString("plant") %>,'<%=rs_check.getString("fiscal_year") %>',0)" class="btn-primary" style="height: 20px;font-weight: bold;font-size: 10px;">
	
	<%
	if(dept_id_check==18 || dept_id_check==31){
	%>
	<input type="button" value="Delete" name="submit_tag" id="submit_tag" onclick="upload_TagInformation(<%=rs_check.getInt("id") %>,'<%=rs_check.getString("batchNo") %>',
	<%=rs_check.getDouble("entry_qty") %>,<%=rs_check.getInt("tag_no") %>,<%=rs_check.getString("plant") %>,'<%=rs_check.getString("fiscal_year") %>',1)" class="btn-primary" style="height: 20px;font-weight: bold;font-size: 10px;background-color: red;">
	<%	
	}
	%>
	</span>
	</td> 
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