<%@page import="java.text.DecimalFormat"%>
<%@page import="java.text.NumberFormat"%>
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
<span id="tagUpload"> 
<%
try{
	int uid = Integer.valueOf(session.getAttribute("uid").toString());
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
	int multiCode_select = Integer.valueOf(request.getParameter("multiCode_select"));
	int dept_id_check = Integer.valueOf(session.getAttribute("dept_id").toString());
	 
	int idTag=0;
	Connection con = Connection_Util.getConnectionMaster();
	PreparedStatement ps_check = null;
	ResultSet rs_check = null;
	boolean flag = false,flagAvailFlag = false,flagAvailFlag1 = false;
	NumberFormat formatter = new DecimalFormat("#0.###");  
	// *******************************************************************************************************************************************************************
	java.util.Date date = null;
	java.sql.Timestamp timeStamp = null;
	Calendar calendar = Calendar.getInstance();
	calendar.setTime(new Date());
	java.sql.Date dt = new java.sql.Date(calendar.getTimeInMillis());
	java.sql.Time sqlTime = new java.sql.Time(calendar.getTime().getTime());
	SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
	date = simpleDateFormat.parse(dt.toString() + " " + sqlTime.toString());
	timeStamp = new java.sql.Timestamp(date.getTime());
	// *******************************************************************************************************************************************************************
	int extra_select = Integer.valueOf(request.getParameter("extra_select"));
%>
<table class="gridtable" width="100%">
<tr style="font-size: 12px !important;">
 
 <th style="font-size: 12px !important;">
 <%
 if(extra_select!=1){
 %>
 Search SNo
 <%
 }else{
 %>Search Mat Code<%	 
 }
 %>
 </th>
 
 <td>
 <%
 if(extra_select!=1){
 %>
 <input type="text" onkeyup="search_recordCall('<%=data_entryPLant %>','<%=store_loc %>','<%=stockType %>','<%=mat_type %>','<%=phy_location %>','<%=extra_select %>')" name="sno_search" id="sno_search" class="form-control" style="color: black;font-size: 12px;font-weight: bold;"> 
 <input type="hidden" name="mat_search" id="mat_search" value="">
 <%
 }else{
 %>
 <input type="text" onkeyup="search_recordCall('<%=data_entryPLant %>','<%=store_loc %>','<%=stockType %>','<%=mat_type %>','<%=phy_location %>','<%=extra_select %>')" name="mat_search" id="mat_search" class="form-control" style="color: black;font-size: 12px;font-weight: bold;"> 
 <input type="hidden" name="sno_search" id="sno_search" value="">
 <%	 
 }
 %>
 </td>
 <td style="background-color: yellow;font-weight: bold;">OR</td>
 <th style="font-size: 12px !important;">Search Tag</th>
 <td><input type="text" onkeyup="search_recordCall('<%=data_entryPLant %>','<%=store_loc %>','<%=stockType %>','<%=mat_type %>','<%=phy_location %>','<%=extra_select %>')" name="tno_search" id="tno_search" class="form-control" style="color: black;font-size: 12px;font-weight: bold;"></td>
</tr>
</table> 

<span id="search_tagsSno"> 
<table class="gridtable" width="100%">  
 <tr style="font-size: 12px !important;">
 <th style="font-size: 12px !important;">ID</th>
 <th style="font-size: 12px !important;">SNo</th>
 <th style="font-size: 12px !important;">Batch No (If Any)</th>
 <th style="font-size: 12px !important;">Entry Qty</th>
 <th style="font-size: 12px !important;">Tag No</th>
 <th style="font-size: 12px !important;">Action</th>
</tr>
<%

	String storage_location="";
	ps_check = con.prepareStatement("select storage_location from stocktaking_storageLocation where id="+store_loc);
	rs_check = ps_check.executeQuery();
	while(rs_check.next()){
		storage_location=rs_check.getString("storage_location");
	}
	ps_check = con.prepareStatement("select * from stocktaking_summary where sno='"+String.valueOf(sno)+"' and Plant='"+data_entryPLant+"' and fiscal_year='"+
				String.valueOf(fiscal_year)+"' and storage_loc='"+storage_location+"' and mat_type='"+mat_type+"' and stocktype_id="+stockType+" and enable=1");
	rs_check = ps_check.executeQuery();
	while(rs_check.next()){
		idTag = rs_check.getInt("id");
	}
	
	if(multiCode_select==0){
	ps_check = con.prepareStatement("select id from stocktaking_count where plant='"+data_entryPLant+"' and fiscal_year="+Integer.valueOf(fiscal_year)+" and tag_no="+ Integer.valueOf(tag_no) +" and enable=1");
	rs_check = ps_check.executeQuery();
	if(rs_check.next()){
		flag =true;
	}
	}else{
		ps_check = con.prepareStatement("select id from stocktaking_count where plant='"+data_entryPLant+"' and fiscal_year="+Integer.valueOf(fiscal_year)+" and tag_no="+ Integer.valueOf(tag_no) + " and sno="+sno+" and enable=1");
		rs_check = ps_check.executeQuery();
		if(rs_check.next()){
			flag =true;
		}
	}
	
	/* ================================================================================================================ */
	/* ================================================= Tag Allowable ================================================ */			
	ps_check = con.prepareStatement("select id from stocktaking_tags where enable=1 and fiscal_year="+Integer.valueOf(fiscal_year)+" and plant='"+data_entryPLant+"' and "+Integer.valueOf(tag_no)+" between tag_from and tag_to");
	rs_check = ps_check.executeQuery();
	if(rs_check.next()){
		flagAvailFlag =true;
		//System.out.println("tag flag 1 " + tag_no);
	}
	ps_check = con.prepareStatement("select id from stocktaking_tagAssign where enable=1 and plant='"+data_entryPLant+"' and sub_loc_auditors_id="+phy_location+" and fiscal_year="+Integer.valueOf(fiscal_year)+" and "+Integer.valueOf(tag_no)+" between assigned_from and assigned_to");
	rs_check = ps_check.executeQuery();
	if(rs_check.next()){
		flagAvailFlag1 =true;
		//System.out.println("tag flag 2 " + tag_no);
	}
	//System.out.println("tag location " + phy_location);
	/* ================================================================================================================ */
	// System.out.println("loh =  = "+ flag +" = "+ idTag +" = "+ flagAvailFlag +" = "+ flagAvailFlag1);
	// System.out.println("select id from stocktaking_tagAssign where enable=1 and plant='"+data_entryPLant+"' and sub_loc_auditors_id="+phy_location+" and fiscal_year="+Integer.valueOf(fiscal_year)+" and "+Integer.valueOf(tag_no)+" between assigned_from and assigned_to");
			
	if(flag==true || idTag==0 || flagAvailFlag==false || flagAvailFlag1==false){
	%>
 <tr style="height: 30px;">
 	<td colspan="6"><strong style="background-color: red;color: white;">Tag already used or Wrong data Upload.!!!</strong></td> 
 </tr>
	<% 
	}else{
		int loc_owner_id=0;
		ps_check = con.prepareStatement("select id from stocktaking_loc_owner where stock_loc_id="+store_loc+" and fiscal_year="+ Integer.valueOf(fiscal_year)+" and plant='"+ data_entryPLant+"' and enable=1");
		rs_check = ps_check.executeQuery();
		while(rs_check.next()){
			loc_owner_id =rs_check.getInt("id");
		}
	/* 	ps_check = con.prepareStatement("select id from stocktaking_loc_auditors_sub where stock_loc_id="+store_loc+" and plant='"+ data_entryPLant+"' and enable=1 and fiscal_year="+ Integer.valueOf(fiscal_year));
		rs_check = ps_check.executeQuery();
		while(rs_check.next()){
			 rs_check.getInt("id");
		} */  
		ps_check = con.prepareStatement("insert into stocktaking_count "+
		"(stock_summary_id,entry_qty,tag_no,loc_owner_id,loc_audit_id_sub,data_entry_uid,enable,created_by,created_date, "+
			" changed_by,changed_date,batchNo,plant,fiscal_year,sno) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)");
		ps_check.setInt(1,idTag);
		ps_check.setDouble(2,Double.valueOf(entry_qty));
		ps_check.setInt(3,Integer.valueOf(tag_no));
		ps_check.setInt(4,loc_owner_id);
		ps_check.setInt(5,phy_location);
		ps_check.setInt(6,uid);
		ps_check.setInt(7,1);
		ps_check.setInt(8,uid);
		ps_check.setTimestamp(9,timeStamp);
		ps_check.setInt(10,uid);
		ps_check.setTimestamp(11,timeStamp);
		ps_check.setString(12,batchNo);
		ps_check.setString(13,data_entryPLant);
		ps_check.setInt(14,Integer.valueOf(fiscal_year));
		ps_check.setInt(15,sno);

		int up = ps_check.executeUpdate();
		// ******************************************************************************************************************************************
		// ***************************************************** Main Sheet Upload ******************************************************************
		double entry_qty_sum = 0;
		String tagSum="",entrySum="";
		ps_check = con.prepareStatement("select SUM(entry_qty) as sumid from stocktaking_count where enable=1 and fiscal_year="+Integer.valueOf(fiscal_year)+
				   " and stock_summary_id="+idTag+" and plant="+data_entryPLant);
		rs_check = ps_check.executeQuery();
		while(rs_check.next()){
			entry_qty_sum=rs_check.getDouble("sumid");
		}
		
		ps_check = con.prepareStatement("select entry_qty, tag_no from stocktaking_count where enable=1 and fiscal_year="+Integer.valueOf(fiscal_year)+
				   " and stock_summary_id="+idTag+" and plant="+data_entryPLant);
		rs_check = ps_check.executeQuery();
		while(rs_check.next()){
			tagSum= String.valueOf(rs_check.getDouble("tag_no")) + " + " + tagSum;
			entrySum= String.valueOf(formatter.format(rs_check.getDouble("entry_qty"))) + " + " + entrySum;
		}
		 
		ps_check = con.prepareStatement("update stocktaking_summary set entry_qty=?,entry_qty_string=?,tag_no=? where id="+idTag);
		ps_check.setString(1, formatter.format(entry_qty_sum));
		ps_check.setString(2, String.valueOf(entrySum));
		ps_check.setString(3, String.valueOf(tagSum));
		int upt = ps_check.executeUpdate();
		// ****************************************************************************************************************************************** 
		// ******************************************************************************************************************************************
		
	ps_check = con.prepareStatement("select fiscal_year,plant,sno,stock_summary_id,batchNo,entry_qty,tag_no,id from stocktaking_count where enable=1 and loc_audit_id_sub="+phy_location+" and stock_summary_id in ( "+
			" select id from stocktaking_summary where enable=1 and fiscal_year='"+String.valueOf(fiscal_year)+"' and Plant='"+data_entryPLant+"' and storage_loc='"+storage_location+"' "+
			" and enable=1 and mat_type='"+mat_type+"' and stocktype_id="+stockType+") order by id desc");	
	rs_check = ps_check.executeQuery();
	while(rs_check.next()){
	%>
 <tr style="height: 20px !important; font-size: 12px !important;">
 	<td align="right"><%=rs_check.getInt("id") %></td>
	<td style="font-size: 12px !important;" align="right"><%=rs_check.getInt("sno") %></td>
 	<td><input type="text" value="<%=rs_check.getString("batchNo")%>" class="form-control" name="batchNo_ajax<%=rs_check.getInt("id") %>" id="batchNo_ajax<%=rs_check.getInt("id") %>"  style="color: black;font-size: 12px;font-weight: bold;"></td>
 	<td><input type="text" value="<%=formatter.format(rs_check.getDouble("entry_qty")) %>" oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*?)\..*/g, '$1');" name="entry_qty_ajax<%=rs_check.getInt("id") %>" id="entry_qty_ajax<%=rs_check.getInt("id") %>" class="form-control" style="color: black;font-size: 12px;font-weight: bold;"></td>
 	<td><input type="text" value="<%=rs_check.getInt("tag_no") %>" oninput="this.value = this.value.replace(/[^0-9]/g, '').replace(/(\..*?)\..*/g, '$1');" name="tag_no_ajax<%=rs_check.getInt("id") %>" id="tag_no_ajax<%=rs_check.getInt("id") %>" class="form-control" style="color: black;font-size: 12px;font-weight: bold;"></td>
	
	<td align="center" style="font-size: 12px !important;">	
	
	<span id="tag_edit<%=rs_check.getInt("id") %>">
	
	<input type="button" value="Edit" name="submit_tag" id="submit_tag" onclick="upload_TagInformation(<%=rs_check.getInt("id") %>,'<%=rs_check.getString("batchNo") %>',
	<%=rs_check.getDouble("entry_qty") %>,<%=rs_check.getInt("tag_no") %>,'<%=rs_check.getString("plant") %>','<%=rs_check.getString("fiscal_year") %>',0)" class="btn-primary" style="height: 20px;font-weight: bold;font-size: 10px;">
	
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
	}
	%>
</table>
</span>
<%
}catch(Exception e){
	e.printStackTrace();
}
%>
</span>



<%-- <tr style="height: 20px !important; font-size: 12px !important;">
 	<td align="right"><%=rs_check.getInt("id") %></td>
 	<td style="font-size: 12px !important;" align="right"><%=rs_check.getInt("sno") %></td>
 	<td style="font-size: 12px !important;"><%=rs_check.getString("batchNo") %></td>
 	<td align="right" style="font-size: 12px !important;"><%=rs_check.getDouble("entry_qty") %></td>
 	<td align="left" style="font-size: 12px !important;"><%=rs_check.getString("tag_no") %></td>
 	<td align="center" style="font-size: 12px !important;"><input type="button" value="Edit" name="submit_tag" id="submit_tag" class="btn-primary" style="height: 20px;font-weight: bold;font-size: 10px;"></td>
 
	<td><input type="text" value="<%=rs_check.getString("batchNo") %>" oninput="this.value = this.value.replace(/[^0-9]/g, '').replace(/(\..*?)\..*/g, '$1');" onkeyup="getDataSummary(this.value)" name="sno" id="sno" class="form-control" style="color: black;font-size: 12px;font-weight: bold;"></td>
 	<td><input type="text" value="<%=rs_check.getDouble("entry_qty") %>" class="form-control" name="batchNo" id="batchNo"  style="color: black;font-size: 12px;font-weight: bold;"></td>
 	<td><input type="text" value="<%=rs_check.getString("tag_no") %>" oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*?)\..*/g, '$1');" name="entry_qty" id="entry_qty" class="form-control" style="color: black;font-size: 12px;font-weight: bold;"></td>
 	<td><input type="text" oninput="this.value = this.value.replace(/[^0-9]/g, '').replace(/(\..*?)\..*/g, '$1');" name="tag_no" id="tag_no" class="form-control" style="color: black;font-size: 12px;font-weight: bold;"></td>
  --%>
 </tr>

</body>
</html>