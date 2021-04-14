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
	int extra_select = Integer.valueOf(request.getParameter("extra_select"));	
	String MtCode = request.getParameter("MtCode");
	String batchNo = request.getParameter("batchNo");
	String entry_qty =  request.getParameter("entry_qty");
	String tag_no = request.getParameter("tag_no");
	int stockType = Integer.valueOf(request.getParameter("stockType"));
	String mat_type = request.getParameter("mat_type");
	int phy_location = Integer.valueOf(request.getParameter("phy_location"));
	String fiscal_year = request.getParameter("fiscal_year");
	String data_entryPLant = request.getParameter("data_entryPLant");
	//int multiCode_select = Integer.valueOf(request.getParameter("multiCode_select"));
	int dept_id_check = Integer.valueOf(session.getAttribute("dept_id").toString());
	
	// System.out.println("phy location "  + phy_location);
	
	int idTag=0;
	Connection con = Connection_Util.getConnectionMaster();
	PreparedStatement ps_check = null,ps_check1 = null;
	ResultSet rs_check = null,rs_check1 = null;
	boolean  flagAvailFlag = false,flagAvailFlag1 = false;
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
 <th style="font-size: 12px !important;">Mat Code</th> 
 <th style="font-size: 12px !important;">Batch No (If Any)</th>
 <th style="font-size: 12px !important;">Entry Qty</th>
 <th style="font-size: 12px !important;">Tag No</th>
 <th style="font-size: 12px !important;">Action</th>
</tr>
<% 
	String storage_location="",material_code = "",material_desc="",uom="",storage_locationDesc="",stock_type_descr="",mat_typeDescr="";
	ps_check = con.prepareStatement("select storage_location,storage_locationDesc from stocktaking_storageLocation where id="+store_loc);
	rs_check = ps_check.executeQuery();
	while(rs_check.next()){
		storage_location=rs_check.getString("storage_location");
		storage_locationDesc=rs_check.getString("storage_locationDesc");
	}  
	
	ps_check = con.prepareStatement("select stock_type from stocktaking_stocktype where id="+stockType);
	rs_check = ps_check.executeQuery();
	while(rs_check.next()){
		stock_type_descr=rs_check.getString("stock_type"); 
	}
	 
	 
	ps_check = con.prepareStatement("select mat_typeDescr from stocktaking_mattype where mat_type='"+mat_type+"'");
	rs_check = ps_check.executeQuery();
	while(rs_check.next()){
		mat_typeDescr=rs_check.getString("mat_typeDescr"); 
	}
	
	
	ps_check = con.prepareStatement("SELECT material,material_description,base_unit_of_measure FROM rel_SAPmaster_mm60 where id="+Integer.valueOf(MtCode));
	rs_check = ps_check.executeQuery();
	while(rs_check.next()){
		material_desc = rs_check.getString("material_description");
		uom = rs_check.getString("base_unit_of_measure");
		material_code = rs_check.getString("material");
	}
	
	//************** multi select === > 
	/* if(multiCode_select==0){
	ps_check = con.prepareStatement("select id from stocktaking_count_extra where plant='"+data_entryPLant+"' and fiscal_year="+Integer.valueOf(fiscal_year)+" and tag_no="+ Integer.valueOf(tag_no) +" and enable=1");
	rs_check = ps_check.executeQuery();
	if(rs_check.next()){
		flag =true;
	}
	}else{ */
		
		// ***************** check extra sheet availability in system = 	
		ps_check1 = con.prepareStatement("select id from stocktaking_summary_extra where Plant='"+data_entryPLant+"' and material_no='"+material_code+"' and fiscal_year='"+
					String.valueOf(fiscal_year)+"' and storage_loc='"+storage_location+"' and mat_type='"+mat_type+"' and stocktype_id="+stockType+" and enable=1");
		rs_check1 = ps_check1.executeQuery();
		if(rs_check1.next()){
			idTag = rs_check1.getInt("id");
			
		}else{
			 
			ps_check = con.prepareStatement("insert into stocktaking_summary_extra "+
					" (plant,storage_loc,physical_inv_doc,fiscal_year,countdate,item_no,material_no,material_desc,uom,mat_type,entry_qty,zero_cnt,"+
					" serial_no,posting_date,Reason,batch_no,import_no,entry_qty_string,tag_no,Plant_desc,storage_loc_desc,stocktype_desc,mattype_desc,"+
					" stocktype_id,enable,sys_date,created_by,updated_by,update_date) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)");
			ps_check.setString(1,data_entryPLant);
			ps_check.setString(2,storage_location);
			ps_check.setString(3,"");
			ps_check.setString(4,String.valueOf(fiscal_year));
			ps_check.setString(5,"31032021");
			ps_check.setString(6,"");
			ps_check.setString(7,material_code);
			ps_check.setString(8,material_desc);
			ps_check.setString(9,uom);
			ps_check.setString(10,mat_type);
			ps_check.setString(11,"");
			ps_check.setString(12,"");
			ps_check.setString(13,"");
			ps_check.setString(14,"31032021");
			ps_check.setString(15,"0");
			ps_check.setString(16,"");
			ps_check.setString(17,"");
			ps_check.setString(18,"");	
			ps_check.setString(19,"");	
			ps_check.setString(20,data_entryPLant);	
			ps_check.setString(21,storage_locationDesc);
			ps_check.setString(22,stock_type_descr);
			ps_check.setString(23,mat_typeDescr);
			ps_check.setInt(24,stockType);
			ps_check.setInt(25,1);
			ps_check.setTimestamp(26,timeStamp);
			ps_check.setInt(27,uid);
			ps_check.setInt(28,uid);
			ps_check.setTimestamp(29,timeStamp);
			int upSumm = ps_check.executeUpdate();
   			
			ps_check = con.prepareStatement("select id from stocktaking_summary_extra where Plant='"+data_entryPLant+"' and material_no='"+material_code+"' and fiscal_year='"+
					String.valueOf(fiscal_year)+"' and storage_loc='"+storage_location+"' and mat_type='"+mat_type+"' and stocktype_id="+stockType+" and enable=1");
		rs_check = ps_check.executeQuery();
		while(rs_check.next()){
			idTag = rs_check.getInt("id");
		}
		
		} 	 
// multi select === >
/* 	} */
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
	
	if(idTag==0 || flagAvailFlag==false || flagAvailFlag1==false){
	%>
 <tr style="height: 30px;">
 	<td colspan="5"><strong style="background-color: red;color: white;">Tag already used or Wrong data Upload.!!!</strong></td> 
 </tr>
	<% 
	}else{
		int loc_owner_id=0;
		ps_check = con.prepareStatement("select id from stocktaking_loc_owner where stock_loc_id="+store_loc+" and fiscal_year="+ Integer.valueOf(fiscal_year)+" and plant='"+ data_entryPLant+"' and enable=1");
		rs_check = ps_check.executeQuery();
		while(rs_check.next()){
			loc_owner_id =rs_check.getInt("id");
		}
		
		/* ps_check = con.prepareStatement("select id from stocktaking_loc_auditors_sub where stock_loc_id="+store_loc+" and plant='"+ data_entryPLant+"' and enable=1 and fiscal_year="+ Integer.valueOf(fiscal_year));
		rs_check = ps_check.executeQuery();
		while(rs_check.next()){
			loc_audit_id_sub = rs_check.getInt("id");
		} */
		
		ps_check = con.prepareStatement("insert into stocktaking_count_extra "+
		"(extra_summary_id,entry_qty,tag_no,loc_owner_id,loc_audit_id_sub,data_entry_uid,enable,created_by,created_date, "+
			" changed_by,changed_date,batchNo,plant,fiscal_year,matCode) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)");
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
		ps_check.setString(15,material_code);

		int up = ps_check.executeUpdate();
		// ******************************************************************************************************************************************
		// ***************************************************** Main Sheet Upload ******************************************************************
		double entry_qty_sum = 0;
		String tagSum="",entrySum="";
		ps_check = con.prepareStatement("select SUM(entry_qty) as sumid from stocktaking_count_extra where enable=1 and fiscal_year="+Integer.valueOf(fiscal_year)+
				   " and extra_summary_id="+idTag+" and plant="+data_entryPLant);
		rs_check = ps_check.executeQuery();
		while(rs_check.next()){
			entry_qty_sum=rs_check.getDouble("sumid");
		}
		
		ps_check = con.prepareStatement("select entry_qty, tag_no from stocktaking_count_extra where enable=1 and fiscal_year="+Integer.valueOf(fiscal_year)+
				   " and extra_summary_id="+idTag+" and plant="+data_entryPLant);
		rs_check = ps_check.executeQuery();
		while(rs_check.next()){
			tagSum= String.valueOf(rs_check.getDouble("tag_no")) + " + " + tagSum;
			entrySum= String.valueOf(formatter.format(rs_check.getDouble("entry_qty"))) + " + " + entrySum;
		}
		 
		ps_check = con.prepareStatement("update stocktaking_summary_extra set entry_qty=?,entry_qty_string=?,tag_no=? where id="+idTag);
		ps_check.setString(1, formatter.format(entry_qty_sum));
		ps_check.setString(2, String.valueOf(entrySum));
		ps_check.setString(3, String.valueOf(tagSum));
		int upt = ps_check.executeUpdate();
		// ****************************************************************************************************************************************** 
		// ******************************************************************************************************************************************
		
	ps_check = con.prepareStatement("select matCode,fiscal_year,plant,extra_summary_id,batchNo,entry_qty,tag_no,id from stocktaking_count_extra where loc_audit_id_sub="+phy_location+" and extra_summary_id in ( "+
			" select id from stocktaking_summary_extra where enable=1 and fiscal_year='"+String.valueOf(fiscal_year)+"' and Plant='"+data_entryPLant+"' and storage_loc='"+storage_location+"' "+
			" and enable=1 and mat_type='"+mat_type+"' and stocktype_id="+stockType+") order by id desc");	
	rs_check = ps_check.executeQuery();
	while(rs_check.next()){
	%>
 <tr style="height: 20px !important; font-size: 12px !important;">
 	<td align="right"><%=rs_check.getInt("id") %></td>
 	<td align="right"><%=rs_check.getString("matCode") %></td> 
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
</span>
<%
}catch(Exception e){
	e.printStackTrace();
}
%>




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
  
 </tr>
--%>
</body>
</html>