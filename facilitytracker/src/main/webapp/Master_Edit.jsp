<%@page import="java.util.Arrays"%>
<%@page import="java.text.SimpleDateFormat"%>
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
<title>Edit Request</title> 
  <!-- Bootstrap CSS -->
  <link href="css/bootstrap.min.css" rel="stylesheet">
  <!-- bootstrap theme -->
  <link href="css/bootstrap-theme.css" rel="stylesheet">
  <!--external css-->
  <!-- font icon -->
  <link href="css/elegant-icons-style.css" rel="stylesheet" />
  <link href="css/font-awesome.min.css" rel="stylesheet" />
  <!-- full calendar css-->
  <link href="assets/fullcalendar/fullcalendar/bootstrap-fullcalendar.css" rel="stylesheet" />
  <link href="assets/fullcalendar/fullcalendar/fullcalendar.css" rel="stylesheet" />
  <!-- easy pie chart-->
  <link href="assets/jquery-easy-pie-chart/jquery.easy-pie-chart.css" rel="stylesheet" type="text/css" media="screen" />
  <!-- owl carousel -->
  <link rel="stylesheet" href="css/owl.carousel.css" type="text/css">
  <link href="css/jquery-jvectormap-1.2.2.css" rel="stylesheet">
  <!-- Custom styles -->
  <link rel="stylesheet" href="css/fullcalendar.css">
  <link href="css/widgets.css" rel="stylesheet">
  <link href="css/style.css" rel="stylesheet">
  <link href="css/style-responsive.css" rel="stylesheet" />
  <link href="css/xcharts.min.css" rel=" stylesheet">
  <link href="css/jquery-ui-1.10.4.min.css" rel="stylesheet"> 
  <script type="text/javascript">
  window.onload = function() {   
		const mat_name = document.getElementById('mat_name');
		const reason = document.getElementById('reason'); 
		const hsn_no = document.getElementById('hsn_no');
		const contact = document.getElementById('contact'); 
		const rate = document.getElementById('rate'); 
		
		mat_name.onpaste = function(e) {
		   e.preventDefault();
	 	};  
	 	reason.onpaste = function(e) {
		   e.preventDefault();
	 	};
	 	
	 	hsn_no.onpaste = function(e) {
			e.preventDefault();
		};
		contact.onpaste = function(e) {
			e.preventDefault();
		};
		rate.onpaste = function(e) {
			e.preventDefault();
		};
	};
	
	function checkQuote() {
		if(event.keyCode == 39 || event.keyCode == 34 || event.keyCode == 47) {
			event.keyCode = 0;
			return false;
		}
	}
	
	function validatenumerics(key) {
		
		if(event.keyCode == 39 || event.keyCode == 34 || event.keyCode == 47) {
			event.keyCode = 0;
			return false;
		}
		
		//getting key code of pressed key
		var keycode = (key.which) ? key.which : key.keyCode;
		//comparing pressed keycodes	 
		if (keycode > 31 && (keycode < 48 || keycode > 57) && keycode != 46 && keycode != 37 && keycode != 38 && keycode != 39 && keycode != 40) {
		    alert("Only allow numeric Data entry");
		    return false;
		}else 
		{
			return true;
		};
		}	
	function GetAssetCode(val) {
		var xmlhttp;
			if (window.XMLHttpRequest) {
				// code for IE7+, Firefox, Chrome, Opera, Safari
				xmlhttp = new XMLHttpRequest();
			} else {
				// code for IE6, IE5
				xmlhttp = new ActiveXObject("Microsoft.XMLHTTP"); 
			}
			xmlhttp.onreadystatechange = function() {
				if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
					document.getElementById("qtyColumn").innerHTML = xmlhttp.responseText; 
				}
			};
			xmlhttp.open("POST", "Master_Create_GetQtyColumn.jsp?matType=" + val, true);
			xmlhttp.send();
	}; 
	
	function GetLocationCode(val) {
		var /* xmlhttp, */ xmlhttp1;
			if (window.XMLHttpRequest) {
				// code for IE7+, Firefox, Chrome, Opera, Safari
				/* xmlhttp = new XMLHttpRequest(); */
				xmlhttp1 = new XMLHttpRequest();
			} else {
				// code for IE6, IE5
				/* xmlhttp = new ActiveXObject("Microsoft.XMLHTTP"); */
				xmlhttp1 = new ActiveXObject("Microsoft.XMLHTTP");
			}
			/* xmlhttp.onreadystatechange = function() {
				if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
					document.getElementById("loc_ajax").innerHTML = xmlhttp.responseText; 
				}
			}; */
			xmlhttp1.onreadystatechange = function() {
				if (xmlhttp1.readyState == 4 && xmlhttp1.status == 200) {
					document.getElementById("ext_ajax").innerHTML = xmlhttp1.responseText; 
				}
			};
			/* xmlhttp.open("POST", "Master_Create_Getlocation.jsp?plant=" + val, true); */
			xmlhttp1.open("POST", "Master_Create_GetPlant.jsp?plant=" + val, true);
			/* xmlhttp.send(); */
			xmlhttp1.send();
	}; 
	
	function checkAvail(val) {
		// document.getElementById('mat_name').value = val.toUpperCase();
		
		var plant = document.getElementById("plant").value;
		var mat_type = document.getElementById("mat_type").value; 
		
		if(plant!="" && mat_type!=""){
			var xmlhttp;
			if (window.XMLHttpRequest) {
				// code for IE7+, Firefox, Chrome, Opera, Safari
				xmlhttp = new XMLHttpRequest();
			} else {
				// code for IE6, IE5
				xmlhttp = new ActiveXObject("Microsoft.XMLHTTP"); 
			}
			xmlhttp.onreadystatechange = function() {
				if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
					document.getElementById("avail_mat").innerHTML = xmlhttp.responseText; 
				}
			};
			xmlhttp.open("POST", "Master_Create_GetAvailMat.jsp?matName=" + val, true);
			xmlhttp.send();
		
		}else{
			alert("Plant and Material Type is Mandatory...!!!");
			document.getElementById('mat_name').value ="";
		}	
	}; 
	
	
	function checkAvailHSN(val) {
		if(val!=""){
			var xmlhttp;
			if (window.XMLHttpRequest) {
				// code for IE7+, Firefox, Chrome, Opera, Safari
				xmlhttp = new XMLHttpRequest();
			} else {
				// code for IE6, IE5
				xmlhttp = new ActiveXObject("Microsoft.XMLHTTP"); 
			}
			xmlhttp.onreadystatechange = function() {
				if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
					document.getElementById("avail_mat").innerHTML = xmlhttp.responseText; 
				}
			};
			xmlhttp.open("POST", "Master_Create_GetAvailHSN.jsp?hsn_no=" + val, true);
			xmlhttp.send();
		}
	}; 
	
	
	
	
	function decision_call(val) {
		var retVal = confirm("Are you sure to delete...?"); 
	      if( retVal == true ) {
	      alert("You Pressed OK!");
	      
		var xmlhttp;
			if (window.XMLHttpRequest) {
				// code for IE7+, Firefox, Chrome, Opera, Safari
				xmlhttp = new XMLHttpRequest();  
			} else {
				// code for IE6, IE5
				xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");   
			}
			xmlhttp.onreadystatechange = function() {
				if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
					document.getElementById("delete_file").innerHTML = xmlhttp.responseText; 
				}
			};  
			xmlhttp.open("POST", "Master_DeleteDoc.jsp?id=" + val, true);  
			xmlhttp.send();   
			
	      } else {
	    	  alert("You Pressed Cancel!");
	    	  return false;
	      }
	};
</script>
<style type="text/css">
table.gridtable {
	font-family: verdana, arial, sans-serif; 
	color: #333333;
	border-width: 1px;
	border-color: #666666;
	border-collapse: collapse;
}

table.gridtable th {
	font-size: 12px;
	border-width: 1px;
	padding: 8px;
	border-style: solid;
	border-color: #666666;
	/* background-color: #dedede; */
}

table.gridtable td {
font-size: 10px;
	border-width: 1px;
	padding: 2px;
	border-style: solid;
	border-color: #666666;
	background-color: #ffffff;
}
</style>
</head>

<body style="color: black;">
<%
try{
	int newCount=0, openCount=0, reOpenCount=0, closedCount=0;
	Connection con = Connection_Util.getLocalUserConnection();
	Connection con_master = Connection_Util.getConnectionMaster();
	int comp_id = Integer.valueOf(session.getAttribute("comp_id").toString()); 
	int uid = Integer.valueOf(session.getAttribute("uid").toString());
	boolean availFlag=false,userInfoFlag=false,userreport=false;
	int dept_id = Integer.valueOf(session.getAttribute("dept_id").toString());
	PreparedStatement ps_check = null, ps_check1=null;
	ResultSet rs_check = null,rs_check1=null; 
	
	int id = Integer.valueOf(request.getParameter("id"));
	int appr = Integer.valueOf(request.getParameter("appr")); 
	
	if(comp_id!=6){
	ps_check = con.prepareStatement("select * from  user_tbl where U_Id="+uid+" and sap_id!='null'");
	rs_check = ps_check.executeQuery();
	while(rs_check.next()){
		userInfoFlag=true;
	}
	
	ps_check = con_master.prepareStatement("select * from  rel_userReportingManager where U_Id="+uid+" and enable_id=1");
	rs_check = ps_check.executeQuery();
	while(rs_check.next()){
		userreport=true;
	}
	}else{
		userInfoFlag=true; 
		userreport=true;
	}
/*-------------------------------------------------------------------------------------------------------------------*/ 
%> 
<!-- container section start -->
<section id="container" class="">
<!---------------------------------------------------------------  Include Header ---------------------------------------------------------------------------------------->
<%@include file="Header.jsp" %>
<!---------------------------------------------------------------  Include Sidebar ---------------------------------------------------------------------------------------->
<%@include file="Sidebar.jsp" %>
<!----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------->	
<!--main content start-->
    <section id="main-content">
      <section class="wrapper">
        <!--overview start-->
        <div class="row">
          <div class="col-lg-12">
            <!-- <h3 class="page-header"><i class="fa fa-laptop"></i> Dashboard</h3> -->
            <ol class="breadcrumb">
            <%
            if(appr==0){
            %> 
              <li><i class="icon_ribbon_alt"></i><a href="Master_Home.jsp" style="font-weight: bold;color: blue;">My Requests</a></li>
              <li><i class="icon_pencil" style="color: gray;"></i><a href="Master_Create.jsp" style="font-weight: bold;">Create New</a></li>
            <!--   <li><i class="arrow_expand_alt2" style="color: gray;"></i><a href="Master_Create_EXTCode.jsp" style="font-weight: bold;">Extend Material Code</a></li> -->
              <li><i class="icon_upload" style="color: gray;"></i><a href="Master_Create_BulkUpload.jsp"  style="font-weight: bold;">Bulk Upload</a> </li>
             <%
            }else if(appr==2){
            %>
             <li><i class="icon_ribbon_alt"></i><a href="Master_Generate.jsp" style="font-weight: bold;">Master Generate</a></li>
              <li><i class="icon_box-checked" style="color: gray;"></i><a href="Master_Approval.jsp" style="font-weight: bold;">All Approvals</a>  </li> 
              <li><a href="Master_Approval.jsp" style="font-weight: bold;"><i class="icon_floppy" style="color: black;"></i>Generate Excel</a>  </li>
            <%
            }else{
            %>
             <li><i class="icon_ribbon_alt"></i><a href="Master_Approval.jsp" style="font-weight: bold;color: blue;">Provide Approval</a></li>
           <!--    <li><i class="icon_box-checked" style="color: gray;"></i><a href="Master_Approval.jsp" style="font-weight: bold;">All Approvals</a>  </li> -->
            <%
            }
  				if(request.getParameter("success")!=null){
				%> 
      		   <strong class="alert alert-success fade in" style="font-size:12px;background-color: green;color: white;"><%=request.getParameter("success") %> </strong> 
      			  <%
				}if(request.getParameter("statusNop")!=null){
			%> 
	         <strong class="alert alert-block alert-danger fade in"  style="font-size:12px;"><%=request.getParameter("statusNop") %> </strong> 
	        <%
				}
			%> 
		
		
         </ol>
         </div>
        </div>
<!-- ********************************************************************************************************************* -->
<div class="row" style="height:800px; overflow: scroll;">
<div class="col-lg-12">
<div class="table-responsive">
<div style="width: 53%;float: left;">
<form action="Master_Create_New" method="post" enctype="multipart/form-data" id="feedback_form" onsubmit="submit.disabled = true; return true;" class="form-validate form-horizontal">
<input type="hidden" name="editid" id="editid" value="<%=id%>">
<input type="hidden" name="appr" id="appr" value="<%=appr%>"> 
 <input type="hidden" name="location" id="location" value="MS01" readonly="readonly">
<%  
PreparedStatement ps_edit = con_master.prepareStatement("select * from tran_SAPmaster_create where enable=1 and id="+id);
ResultSet rs_edit = ps_edit.executeQuery();
while(rs_edit.next()){
%>
<table width="100%" border="0">
  <tr>
    <td><strong>Plant</strong><b style="color: red;"> * </b></td>
    <td>
    <div class="form-group">
    <select name="plant" id="plant"  onchange="GetLocationCode(this.value)" class="form-control m-bot15" style="color: black;" required>
                      <%
                      ps_check = con_master.prepareStatement("SELECT  id,code,descr  FROM master_data where tablekey='plant' and plant='' and enable=1 and code='"+rs_edit.getString("plant")+"' union all SELECT  id,code,descr  FROM master_data where tablekey='plant' and plant='' and enable=1 and code!='"+rs_edit.getString("plant")+"'");
                      rs_check = ps_check.executeQuery();
                      while(rs_check.next()){
                      %>
                      <option value="<%=rs_check.getString("code") %>"><%=rs_check.getString("code") %> - - <%=rs_check.getString("descr") %></option>
                      <%
                      }
                      %>
    </select></div>
    </td>
  </tr>
  <tr>
    <td><strong>Material Type</strong><b style="color: red;"> * </b></td>
    <td><div class="form-group"><select name="mat_type" id="mat_type" onchange="GetAssetCode(this.value)" class="form-control m-bot15" style="color: black;" required>
                      <%
                      ps_check = con_master.prepareStatement("SELECT id,mat_type,mat_typeDescr FROM stocktaking_mattype where enable=1 and mat_type='"+rs_edit.getString("materialType")+"'");
                      rs_check = ps_check.executeQuery();
                      while(rs_check.next()){
                      %>
                      <option value="<%=rs_check.getString("mat_type") %>"><%=rs_check.getString("mat_type") %> - - <%=rs_check.getString("mat_typeDescr") %></option>
                      <%
                      } 
                      ps_check = con_master.prepareStatement("SELECT id,mat_type,mat_typeDescr FROM stocktaking_mattype where enable=1 and mat_type not in ('HALB','FERT') and mat_type!='"+rs_edit.getString("materialType")+"' order by mat_typeDescr");
                      rs_check = ps_check.executeQuery();
                      while(rs_check.next()){
                      %>
                      <option value="<%=rs_check.getString("mat_type") %>"><%=rs_check.getString("mat_type") %> - - <%=rs_check.getString("mat_typeDescr") %></option>
                      <%
                      }
                      %>
                      </select></div> </td>
  </tr>
  <tr>
    <td><strong>Material Name</strong><b style="color: red;"> * </b></td>
    <td><div class="form-group"><input class="form-control" style="font-weight: bold;color: black;font-size: 14px;" id="mat_name" name="mat_name" maxlength="40" 
    			onkeypress="return checkQuote();" onkeyup="checkAvail(this.value)" type="text" required  value="<%=rs_edit.getString("materialName")%>"/></div> </td>
  </tr>
   <tr>
    <td><strong>Qty<br> (For Asset Only)</strong><b style="color: red;"> * </b></td>
    <td><div class="form-group">
    <span id="qtyColumn">
    <input type="text" name="qty" id="qty" maxlength="6" class="form-control m-bot15" style="color: black;" onkeypress="return validatenumerics(event);"  value="<%=rs_edit.getString("qty")%>">
	</span>
    </div> </td>
  </tr>
  <%-- <tr>
    <td><strong>Location Used</strong><b style="color: red;"> * </b></td>
    <td><div class="form-group">
    <span id="loc_ajax"> 
<select name="location" id="location" class="form-control m-bot15" style="color: black;" required> 
         <%
             PreparedStatement ps_loc = con_master.prepareStatement("SELECT id,code,descr FROM master_data where  tablekey='storage_loc' and enable=1 and plant='"+rs_edit.getString("plant")+"' and code='"+rs_edit.getString("location_id")+"'union all SELECT id,code,descr FROM master_data where  tablekey='storage_loc' and enable=1 and plant='"+rs_edit.getString("plant")+"' and code!='"+rs_edit.getString("location_id")+"'");
             ResultSet rs_loc = ps_loc.executeQuery();
             while(rs_loc.next()){
          %>
       <option value="<%=rs_loc.getString("code") %>"><%=rs_loc.getString("code") %> - - <%=rs_loc.getString("descr") %></option>
          <%
               }
          %>
 </select>
	</span>
    </div> </td>
  </tr> --%>
  <tr>
    <td> <strong>Unit Of Measure</strong><b style="color: red;"> * </b></td>
    <td><div class="form-group"><select name="uom" id="uom" class="form-control m-bot15" style="color: black;" required> 
                      <%
                      ps_check = con_master.prepareStatement("SELECT id,code,descr  FROM master_data where tablekey='baseUOM' and enable=1 and code='"+rs_edit.getString("uom")+"' union all  SELECT id,code,descr  FROM master_data where tablekey='baseUOM' and enable=1 and code!='"+rs_edit.getString("uom")+"'");
                      rs_check = ps_check.executeQuery();
                      while(rs_check.next()){
                      %>
                      <option value="<%=rs_check.getString("code") %>"><%=rs_check.getString("code") %> - - <%=rs_check.getString("descr") %></option>
                      <%
                      }
                      %>
                      </select></div> </td>
  </tr>
  <tr>
    <td> <strong>Material Group</strong><b style="color: red;"> * </b></td>
    <td><div class="form-group">
    			<select name="mat_group" id="mat_group" class="form-control m-bot15" style="color: black;" required> 
                      <%
                      ps_check = con_master.prepareStatement("SELECT  id,code,descr  FROM master_data where tablekey='matGroup' and plant='' and enable=1 and code='"+rs_edit.getString("materialGroup")+"' order by descr");
                      rs_check = ps_check.executeQuery();
                      while(rs_check.next()){
                      %>
                      <option value="<%=rs_check.getString("code") %>"><%=rs_check.getString("descr") %> . . [ <%=rs_check.getString("code") %> ]</option>
                      <%
                      } 
                      ps_check = con_master.prepareStatement("SELECT  id,code,descr  FROM master_data where tablekey='matGroup' and plant='' and enable=1 and code!='"+rs_edit.getString("materialGroup")+"' order by descr");
                      rs_check = ps_check.executeQuery();
                      while(rs_check.next()){
                      %>
                      <option value="<%=rs_check.getString("code") %>"><%=rs_check.getString("descr") %> . . [ <%=rs_check.getString("code") %> ]</option>
                      <%
                      }
                      %>
                </select></div> </td>
  </tr>
  <tr>
    <td><label class="control-label" for="inputSuccess"><strong>Extend to (If Reqd.)</strong></label></td>
    <td><div class="form-group">
    		<span id="ext_ajax">
    	<%  
    	String[] values = rs_edit.getString("plant_toExtend").split("\\s*,\\s*");  
    	String checkPlant="";	
		PreparedStatement ps_plant = con.prepareStatement("SELECT plant,seq FROM user_tbl_company where enable=1 and plant !='All' order by seq");
        ResultSet rs_plant = ps_plant.executeQuery();
        while(rs_plant.next()){
        for(String name : values){
    	if(rs_plant.getString("plant").equalsIgnoreCase(name)){
    		checkPlant=name;
    		if(checkPlant.equalsIgnoreCase(rs_edit.getString("plant"))){
    	%>	 
		<input type="checkbox" name="plant<%=rs_plant.getString("plant") %>" value="<%=rs_plant.getString("plant") %>"  checked="checked" onclick="return false">&nbsp;<%=rs_plant.getString("plant") %>&nbsp;	 
  		<%
    		}else{
    	%>
    	<input type="checkbox" name="plant<%=rs_plant.getString("plant") %>" value="<%=rs_plant.getString("plant") %>"  checked="checked">&nbsp;<%=rs_plant.getString("plant") %>&nbsp;
    	<%		
    		}
    			}
        } 
        if(!rs_plant.getString("plant").equalsIgnoreCase(checkPlant)){
    	%>	 
		<input type="checkbox" name="plant<%=rs_plant.getString("plant") %>" value="<%=rs_plant.getString("plant") %>">&nbsp;<%=rs_plant.getString("plant") %>&nbsp;	 
  		<%
  		checkPlant="";
    			}
        	}
			%>
            </span>        
        </div>
    </td>
  </tr>
  <tr>
    <td><strong>Material Rate/Amount</strong><b style="color: red;"> * </b></td>
    <td><div class="form-group"><input class="form-control" style="font-weight: bold;color: black;font-size: 14px;"   value="<%=rs_edit.getString("price")%>" onkeypress="return validatenumerics(event);" id="rate" name="rate" maxlength="20" type="text" required/></div> </td>
  </tr>
  <tr>
    <td><strong>Contact No</strong><b style="color: red;"> * </b></td>
    <td><div class="form-group"> <input class="form-control" style="font-weight: bold;color: black;font-size: 14px;"  value="<%=rs_edit.getString("contactNo")%>" onkeypress="return validatenumerics(event);" id="contact" name="contact" maxlength="10" minlength="10" type="text" required/></div> </td>
  </tr>
  <tr>
    <td><strong>HSN No</strong><b style="color: red;"> * </b></td>
    <td><div class="form-group">
    <%
      if(appr==0){
    %> 
    <input class="form-control" onkeyup="checkAvailHSN(this.value)" style="font-weight: bold;color: black;font-size: 14px;" value="<%=rs_edit.getString("hsn_code")%>"  onkeypress="return validatenumerics(event);" id="hsn_no" name="hsn_no" maxlength="8" type="text" minlength="4"/>
    <%
      }else{
    %> 
    <input class="form-control" onkeyup="checkAvailHSN(this.value)" style="font-weight: bold;color: black;font-size: 14px;" value="<%=rs_edit.getString("hsn_code")%>"  onkeypress="return validatenumerics(event);" id="hsn_no" name="hsn_no" maxlength="8" type="text" minlength="4" required />
   	<%	  
      }
    %>
    </div> 
    </td>
  </tr>
  <tr>
    <td><strong>Reason </strong><b style="color: red;"> * </b></td>
    <td> <div class="form-group"><input class="form-control" maxlength="100" style="font-weight: bold;color: black;font-size: 14px;" value="<%=rs_edit.getString("reason")%>" id="reason" name="reason" onkeypress="return checkQuote();" required /></div> </td>
  </tr> 
   
  <tr>
    <td><strong>Reference(If Any)</strong></td>
    <td><div class="form-group"> 
    <span id="delete_file">
    <%
    if(rs_edit.getString("filename")!=null){
    %> 
  	<a href="Master_DisplayDoc.jsp?id=<%=id%>"><%=rs_edit.getString("filename") %></a>
  	<button onclick="decision_call(<%=id %>); return false;"><strong style="font-size: 11px;background-color: red;color: white;">Delete</strong></button>
    <%
    }else{
    %>
    <input class="form-control m-bot15" style="font-weight: bold;color: blue;text-align: left;font-size: 13px;" type="file" id="file_doc" name="file_doc">
    <%	
    }
  	%>
  	</span>
  	</div></td>
  </tr>
  <tr style="height: 50px;">
    <td colspan="2" style="padding-left: 60px;"><div class="form-group">
    <input type="submit" class="btn btn-primary" name="submit" id="submit" value="   Submit Data  " style="font-weight: bold;"></div></td> 
  </tr>
</table>    	
<%
}
%>      
             </form>
             </div>
             <div style="width: 44%;height:400px;overflow:scroll; float: right;">
             <table style="width: 100%;" class="gridtable">
             	<tr>
             		<th>Materials Availability in SAP</th>
             	</tr> 
			</table>		
             <span id="avail_mat"></span>
             </div>
              </div>
          </div>
        </div>
      </section> 
    </section>
    
 <!---------------------------------------------------------------------------------- User Profile Screen Ends ----------------------------------------------------------------------->                
 
    <%
	}catch(Exception e){ 
		e.printStackTrace();
	}
    %>
    
     
    <!--main content end-->
  </section>
  <!-- container section start -->

  <!-- javascripts -->
  <script src="js/jquery.js"></script>
  <script src="js/jquery-ui-1.10.4.min.js"></script>
  <script src="js/jquery-1.8.3.min.js"></script>
  <script type="text/javascript" src="js/jquery-ui-1.9.2.custom.min.js"></script>
  <!-- bootstrap -->
  <script src="js/bootstrap.min.js"></script>
  <!-- nice scroll -->
  <script src="js/jquery.scrollTo.min.js"></script>
  <script src="js/jquery.nicescroll.js" type="text/javascript"></script>
  <!-- charts scripts -->
  <script src="assets/jquery-knob/js/jquery.knob.js"></script>
  <script src="js/jquery.sparkline.js" type="text/javascript"></script>
  <script src="assets/jquery-easy-pie-chart/jquery.easy-pie-chart.js"></script>
  <script src="js/owl.carousel.js"></script>
  <!-- jQuery full calendar -->
  <script src="js/fullcalendar.min.js"></script>
    <!-- Full Google Calendar - Calendar -->
    <script src="assets/fullcalendar/fullcalendar/fullcalendar.js"></script>
    <!--script for this page only-->
    <script src="js/calendar-custom.js"></script>
    <script src="js/jquery.rateit.min.js"></script>
    <!-- custom select -->
    <script src="js/jquery.customSelect.min.js"></script>
    <script src="assets/chart-master/Chart.js"></script>

    <!--custome script for all page-->
    <script src="js/scripts.js"></script>
    <!-- custom script for this page-->
    <script src="js/sparkline-chart.js"></script>
    <script src="js/easy-pie-chart.js"></script>
    <script src="js/jquery-jvectormap-1.2.2.min.js"></script>
    <script src="js/jquery-jvectormap-world-mill-en.js"></script>
    <script src="js/xcharts.min.js"></script>
    <script src="js/jquery.autosize.min.js"></script>
    <script src="js/jquery.placeholder.min.js"></script>
    <script src="js/gdp-data.js"></script>
    <script src="js/morris.min.js"></script>
    <script src="js/sparklines.js"></script>
    <script src="js/charts.js"></script>
    <script src="js/jquery.slimscroll.min.js"></script>
    <script>
      //knob
      $(function() {
        $(".knob").knob({
          'draw': function() {
            $(this.i).val(this.cv + '%')
          }
        })
      });

      //carousel
      $(document).ready(function() {
        $("#owl-slider").owlCarousel({
          navigation: true,
          slideSpeed: 300,
          paginationSpeed: 400,
          singleItem: true

        });
      });

      //custom select box

      $(function() {
        $('select.styled').customSelect();
      });

      /* ---------- Map ---------- */
      $(function() {
        $('#map').vectorMap({
          map: 'world_mill_en',
          series: {
            regions: [{
              values: gdpData,
              scale: ['#000', '#000'],
              normalizeFunction: 'polynomial'
            }]
          },
          backgroundColor: '#eef3f7',
          onLabelShow: function(e, el, code) {
            el.html(el.html() + ' (GDP - ' + gdpData[code] + ')');
          }
        });
      });
    </script>

</body>
</html>