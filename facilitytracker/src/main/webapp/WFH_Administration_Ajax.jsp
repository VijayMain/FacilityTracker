<%@page import="java.text.DecimalFormat"%>
<%@page import="com.facilitytracker.connectionUtil.Connection_Util"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
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
	Connection con_Master = Connection_Util.getConnectionMaster();
	DecimalFormat formatter = new DecimalFormat("00.00");
	String layoutType = request.getParameter("val");
	PreparedStatement ps_check = null;
	ResultSet rs_check = null;
	int up=0;
	String check = "";
	ps_check = con_Master.prepareStatement("select * from tran_wfh_config where enable_id=1 and specification3!='"+layoutType+"'");
	rs_check = ps_check.executeQuery();
	while(rs_check.next()){
		check =rs_check.getString("specification3");
	}
	
	if(check!=""){ 
	ps_check = con_Master.prepareStatement("update tran_wfh_config set enable_id=0 where specification3='"+check+"'");
	up = ps_check.executeUpdate();
	ps_check = con_Master.prepareStatement("update tran_wfh_config set enable_id=1 where specification3='"+layoutType+"'");
	up = ps_check.executeUpdate();
	}
%>
<span id="display_layout"><b style="color: green;">You have selected : <%=layoutType %></b>  
<input type="hidden" id="lay_hid" name="lay_hid" value="<%=layoutType%>"> 
             <table style="width: 100%;color: white;" class="gridtable">
             	<tr style="background-color: #DACB74;">
             		<th align="center"  style="color: black;">P.No</th>  
					<th align="center"  style="color: black;">Parameter</th> 
					<th align="center"  style="color: black;">Details</th>   
					<th align="center"  style="color: black;">In Minutes</th>
					<th align="center"  style="color: black;">In hours</th>
					<th align="center"  style="color: black;">Update</th>	 					
				</tr>
				<%
				Double mm=0.0,hh=0.0;
				PreparedStatement ps_upload = con_Master.prepareStatement("SELECT * FROM tran_wfh_config where enable_id =1");
				ResultSet rs_upload = ps_upload.executeQuery();
				while(rs_upload.next()){
					if(rs_upload.getString("specification1")!=null){
						mm =Double.valueOf(rs_upload.getString("specification1"));
					}
					if(rs_upload.getString("specification2")!=null){
						hh =Double.valueOf(rs_upload.getString("specification2"));
					}
				%>
				<tr style="color: black;">
					<td align="center"><%=rs_upload.getInt("id") %></td>
					<td><%=rs_upload.getString("parameter") %></td>
					<td><%=rs_upload.getString("details") %></td>
					<td>
					
					<select name="time_required" id="time_required<%= rs_upload.getInt("id")%>" class="form-control" onchange="time_convert(this.value,<%=rs_upload.getInt("id") %>)" style="font-weight: bold;color: black;width: 80px;font-size: 12px !important;" required>
                     <%
                     if(rs_upload.getString("specification1")!=null){
                     %>
                      	<option value="<%=rs_upload.getString("specification1")%>"><%=rs_upload.getString("specification1") %></option> 
                      <%
                     }else{
                    %>
                      	<option value="">0</option>
                    <%	 
                     }
                      	for(int i=1;i<=1440;i++){
                      	%>
                      	<option value="<%=i%>"><%=i%></option> 
                      	<%
                      	}
                      	%>
                      </select> 
					<input type="hidden" name="id" id="id<%=rs_upload.getInt("id") %>">
					</td>
					<td>
					<span id="inHr<%=rs_upload.getInt("id") %>" style="font-weight: bold;color: black;font-size: 12px;">
					<%
					if(rs_upload.getString("specification2")!=null){
						hh =Double.valueOf(rs_upload.getString("specification2"));
					%>
					<%= formatter.format(hh) %>
					<%
					}else{
					%>
					0.00
					<%
					}
					%>
					</span></td>
	<td><input type="submit" class="form-control" onclick="time_id(<%=rs_upload.getInt("id") %>)" style="font-weight: bold;background-color: #99c9f2" value="Update"> </td>
				<%
					}
				%>
				</tr> 
			</table>
			</span>
<%
}catch(Exception e){
	e.printStackTrace();
}
%>
</body>
</html>