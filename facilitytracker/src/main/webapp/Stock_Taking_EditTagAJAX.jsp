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
<%
try{
	int id = Integer.valueOf(request.getParameter("id"));
	String batch = request.getParameter("batch");
	String entry_qty = request.getParameter("entry_qty");
	String tagNo = request.getParameter("tagNo");
	String plant = request.getParameter("plant");
	String fiscal_year = request.getParameter("fiscal_year");		
	NumberFormat formatter = new DecimalFormat("#0.###"); 
	String entry_qty_ajax = request.getParameter("entry_qty_ajax");
	String batchNo_ajax = request.getParameter("batchNo_ajax");
	String tag_no_ajax = request.getParameter("tag_no_ajax");		
	String extra_select = request.getParameter("extra_select");		
	
	int deleteFlag = Integer.valueOf(request.getParameter("deleteFlag"));
	
	
	System.out.println(id+batch+entry_qty+tagNo+plant+fiscal_year+formatter+entry_qty_ajax+batchNo_ajax+tag_no_ajax+extra_select+deleteFlag);
	
	Connection con = Connection_Util.getConnectionMaster();
	PreparedStatement ps_check = null, ps_check1 = null;
	ResultSet rs_check = null, rs_check1 = null;
	boolean flag = false,flagAvailFlag = false,flagAvailFlag1 = false;
	String query_count = "";
%>
<span id="tag_edit<%=id%>">
<% 
	int sub_loc_auditors_id=0,idTag=0;

	if(Integer.valueOf(extra_select)!=1){
	query_count = "select id from stocktaking_count where plant='"+plant+"' and fiscal_year="+
		Integer.valueOf(fiscal_year)+" and tag_no="+ Integer.valueOf(tag_no_ajax) +	" and id!="+ id +" and enable=1";
	}else{
		query_count = "select id from stocktaking_count_extra where plant='"+plant+"' and fiscal_year="+
		Integer.valueOf(fiscal_year)+" and tag_no="+ Integer.valueOf(tag_no_ajax) +	" and id!="+ id +" and enable=1";
	}
	ps_check = con.prepareStatement(query_count);
	rs_check = ps_check.executeQuery();
	while(rs_check.next()){
		flag=true;
	}
	
	if(Integer.valueOf(extra_select)==1){
		flag=false;
	}
	query_count="";
	
	
	if(Integer.valueOf(extra_select)!=1){
		query_count = "select stock_summary_id,loc_audit_id_sub from stocktaking_count where id="+ id;
	}else{
		query_count = "select extra_summary_id,loc_audit_id_sub from stocktaking_count_extra where id="+ id;
	}
	ps_check = con.prepareStatement(query_count);
	rs_check = ps_check.executeQuery();
	while(rs_check.next()){
		sub_loc_auditors_id = rs_check.getInt("loc_audit_id_sub");
		
		if(Integer.valueOf(extra_select)!=1){
			idTag = rs_check.getInt("stock_summary_id"); 
		}else{
			idTag = rs_check.getInt("extra_summary_id");	
		}
	}
	
	/* ================================================================================================================ */
	/* ================================================= Tag Allowable ================================================ */			
	ps_check = con.prepareStatement("select id from stocktaking_tags where enable=1 and fiscal_year="+Integer.valueOf(fiscal_year)+" and plant='"+plant+"' and "+Integer.valueOf(tag_no_ajax)+" between tag_from and tag_to");
	rs_check = ps_check.executeQuery();
	if(rs_check.next()){
		flagAvailFlag =true;
		//System.out.println("tag flag 1 " + tag_no_ajax);
	}
	ps_check = con.prepareStatement("select id from stocktaking_tagAssign where enable=1 and plant='"+plant+"' and sub_loc_auditors_id="+sub_loc_auditors_id+" and fiscal_year="+Integer.valueOf(fiscal_year)+" and "+Integer.valueOf(tag_no_ajax)+" between assigned_from and assigned_to");
	rs_check = ps_check.executeQuery();
	if(rs_check.next()){
		flagAvailFlag1 =true;
		//System.out.println("tag flag 2 " + tag_no_ajax);
	}
	//System.out.println("tag location " + sub_loc_auditors_id);
	/* ================================================================================================================ */
	
	if(deleteFlag==1){
		flag=false; 
		flagAvailFlag=true;
		flagAvailFlag1=true;
	}
	
	
	if(flag==true || flagAvailFlag==false || flagAvailFlag1==false){
	%>
	<strong style="color: red;">Error..!!</strong>
	<%
	}else{
		query_count="";
		int up =0;
		
		if(deleteFlag==0){
		
		if(Integer.valueOf(extra_select)!=1){
			query_count="update stocktaking_count set tag_no=?,entry_qty=?,batchNo=? where id="+id;
		}else{
			query_count="update stocktaking_count_extra set tag_no=?,entry_qty=?,batchNo=? where id="+id;
		}
		
		ps_check = con.prepareStatement(query_count);
		ps_check.setInt(1, Integer.valueOf(tag_no_ajax));
		ps_check.setDouble(2, Double.valueOf(entry_qty_ajax));
		ps_check.setString(3, batchNo_ajax);
		up = ps_check.executeUpdate();
		
		}else{
			
			if(Integer.valueOf(extra_select)!=1){
				query_count="update stocktaking_count set enable=? where id="+id;
			}else{
				query_count="update stocktaking_count_extra set enable=? where id="+id;
			}
			
			ps_check = con.prepareStatement(query_count);
			ps_check.setInt(1, 0);
			up = ps_check.executeUpdate();
		}
		
		// ******************************************************************************************************************************************
		// ***************************************************** Main Sheet Upload ******************************************************************
				double entry_qty_sum = 0;
				String tagSum="",entrySum="";
				query_count="";
				if(Integer.valueOf(extra_select)!=1){
				query_count= "select SUM(entry_qty) as sumid from stocktaking_count where enable=1 and fiscal_year="+Integer.valueOf(fiscal_year)+
					   " and stock_summary_id="+idTag+" and plant="+plant;
				}else{
				query_count= "select SUM(entry_qty) as sumid from stocktaking_count_extra where enable=1 and fiscal_year="+Integer.valueOf(fiscal_year)+
					   " and extra_summary_id="+idTag+" and plant="+plant;
				}
				 
				ps_check = con.prepareStatement(query_count);
				rs_check = ps_check.executeQuery();
				while(rs_check.next()){
					entry_qty_sum=rs_check.getDouble("sumid");
				}
				
				
				
				query_count="";
				if(Integer.valueOf(extra_select)!=1){
				query_count = "select entry_qty, tag_no from stocktaking_count where enable=1 and fiscal_year="+Integer.valueOf(fiscal_year)+
					   " and stock_summary_id="+idTag+" and plant="+plant;
				}else{
				query_count = "select entry_qty, tag_no from stocktaking_count_extra where enable=1 and fiscal_year="+Integer.valueOf(fiscal_year)+
					   " and extra_summary_id="+idTag+" and plant="+plant;
				}
				
				
				ps_check = con.prepareStatement(query_count);
				rs_check = ps_check.executeQuery();
				while(rs_check.next()){
					tagSum= String.valueOf(rs_check.getDouble("tag_no")) + " + " + tagSum;
					entrySum= String.valueOf(formatter.format(rs_check.getDouble("entry_qty"))) + " + " + entrySum;
				}
				 
				query_count="";
				if(Integer.valueOf(extra_select)!=1){
					query_count="update stocktaking_summary set entry_qty=?,entry_qty_string=?,tag_no=? where id="+idTag;
				}else{
					query_count="update stocktaking_summary_extra set entry_qty=?,entry_qty_string=?,tag_no=? where id="+idTag;
				}
				
				ps_check = con.prepareStatement(query_count);
				ps_check.setString(1, formatter.format(entry_qty_sum));
				ps_check.setString(2, String.valueOf(entrySum));
				ps_check.setString(3, String.valueOf(tagSum));
				int upt = ps_check.executeUpdate();
		// ****************************************************************************************************************************************** 
		// ******************************************************************************************************************************************
		
		
	if(up>0){
	%>
	<strong style="background-color: green;color: white;">Done</strong>
	<%	
	}
	}
}catch(Exception e){
	e.printStackTrace();
}
%>
</span>
</body>
</html>