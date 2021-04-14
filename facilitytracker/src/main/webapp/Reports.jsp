<!DOCTYPE html>
<%@page import="java.util.ArrayList"%>
<%@page import="java.sql.Timestamp"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.util.Date"%>
<%@page import="com.facilitytracker.connectionUtil.Connection_Util"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<html lang="en"> 
<head> 
  <title>Reports</title> 
  <!-- Bootstrap CSS -->
  <link href="css/bootstrap.min.css" rel="stylesheet">
  <!-- bootstrap theme -->
  <link href="css/bootstrap-theme.css" rel="stylesheet">
  <!--external css-->
  <!-- font icon -->
  <link href="css/elegant-icons-style.css" rel="stylesheet" />
  <link href="css/font-awesome.min.css" rel="stylesheet" />
  <link href="css/daterangepicker.css" rel="stylesheet" />
  <link href="css/bootstrap-datepicker.css" rel="stylesheet" />
  <link href="css/bootstrap-colorpicker.css" rel="stylesheet" />
  <!-- date picker -->
<script type="text/javascript">
    $(".form_datetime").datetimepicker({format: 'yyyy/mm/dd hh:ii'});
     
    function button1(val) {
		var val1 = val; 
		document.getElementById("hid").value = val1;
		edit.submit();
	}
    function ChangeColor(tableRow, highLight) {
		if (highLight) {
			tableRow.style.backgroundColor = '#CFCFCF';
		} else {
			tableRow.style.backgroundColor = '#FFFFFF';
		}
	}
</script>          
  <link href="css/style.css" rel="stylesheet">
  <link href="css/style-responsive.css" rel="stylesheet" />  
</head> 
<body>
<%
try{
	int newCount=0, openCount=0, reOpenCount=0, closedCount=0;
	Connection con = Connection_Util.getLocalUserConnection();
	int comp_id = Integer.valueOf(session.getAttribute("comp_id").toString()); 
	int uid = Integer.valueOf(session.getAttribute("uid").toString());
	boolean flag = false;
	PreparedStatement ps_check = null, ps_check1=null;
	ResultSet rs_check = null,rs_check1=null;
	ArrayList queryList = new ArrayList();
	
	if (request.getAttribute("queryList") != null){
		queryList = (ArrayList) request.getAttribute("queryList");
		flag=true;
	}

	Date date = new Date();
	String toDate = new SimpleDateFormat("MM/dd/yyyy").format(date); 
	
	Calendar c = Calendar.getInstance();
	c.set(Calendar.DAY_OF_MONTH, 1);
	String fromDate = new SimpleDateFormat("MM/dd/yyyy").format(c.getTime());
/* 
	// ------------------Next Date for sql between loop ---------------------------		    
	Calendar c1 = Calendar.getInstance();
	c1.setTime(date);
	c1.add(Calendar.DATE, 1);
	Date currentDatePlusOne = c1.getTime();
	String nextDate = new SimpleDateFormat("dd/MM/yyyy").format(currentDatePlusOne);

	Date datesql_from = new SimpleDateFormat("dd/MM/yyyy").parse(fromDate);
	Timestamp timeStampFromDate = new Timestamp(datesql_from.getTime());
	 
	Date datesql_to = new SimpleDateFormat("dd/MM/yyyy").parse(toDate);
	Timestamp timeStampToDate = new Timestamp(datesql_to.getTime());
	
	Date datesql_Nextto = new SimpleDateFormat("dd/MM/yyyy").parse(nextDate);
	Timestamp timeStampToNextDate = new Timestamp(datesql_Nextto.getTime()); */
	 
/*-------------------------------------------------------------------------------------------------------------------*/
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
              <li><i class="fa fa-home"></i><a href="Home.jsp">Home</a></li>
              <li><i class="fa fa-laptop"></i>Dashboard  
              </li>
            </ol> 
          </div>
        </div>
 
        
	<!-- ********************************************************************************************************************* -->
	<!-- **************************************************** Data Goes Here ************************************************* -->
	<!-- ********************************************************************************************************************* -->
<div class="row" style="height:550px; overflow: scroll;">
          <div class="col-lg-12"> 
              <form action="Generate_ReportControl" method="post">
				<table class="table">
				<tr>
				<td align="left" style="background-color: #DACB74;font-size: 13px;font-weight: bold;">
				<div class="col-lg-2">
                    Date From<input id="dp2" name="fromdate" style="font-weight: bold;" type="text" value="<%=fromDate %>" size="16" class="form-control">
                        </div>
                 <div class="col-lg-2">
                    To Date<input id="dp3" name="todate" style="font-weight: bold;" type="text" value="<%=toDate %>" size="16" class="form-control">
                 </div>
                 <div class="col-lg-2">
                    Company  : 
                    <select name="company" id="company" style="font-weight: bold;" class="form-control">
                   <%
                   ps_check =con.prepareStatement("SELECT * FROM user_tbl_company where enable=1 or company_id=6 order by company_id desc");
                   rs_check = ps_check.executeQuery();
                   while(rs_check.next()){
                   %> 
                    <option value="<%=rs_check.getInt("Company_Id")%>"><%=rs_check.getString("Company_Name") %></option>
                   <%
                   }
                   %> 
                    </select>
                 </div> 
                 <div class="col-lg-2">
                    Priority  : 
                    <select name="priority" id="priority" style="font-weight: bold;" class="form-control">
                    <option value="0">- - - - - All - - - - -</option>
                   <%
                      ps_check = con.prepareStatement("SELECT * FROM facility_tbl_priority where enable=1");
                      rs_check = ps_check.executeQuery();
                      while(rs_check.next()){
                      %>
                      <option value="<%=rs_check.getInt("id") %>"><%=rs_check.getString("name") %></option>
                      <%
                      }
                      %> 
                    </select>
                 </div>  
                 <div class="col-lg-2">
                    Required for  : 
                    <select name="facility" id="facility" style="font-weight: bold;" class="form-control">
                    <option value="0">- - - - - All - - - - -</option>
                   <%
                      ps_check = con.prepareStatement("SELECT * FROM facility_tbl where enable=1");
                      rs_check = ps_check.executeQuery();
                      while(rs_check.next()){
                      %>
                      <option value="<%=rs_check.getInt("id") %>"><%=rs_check.getString("name") %></option>
                      <%
                      }
                      %>
                    </select>
                 </div>  
                 <div class="col-lg-2">
                    Responsible Dept  : 
                    <select name="resp_dept" id="resp_dept" style="font-weight: bold;" class="form-control">
                    <option value="0">- - - - - All - - - - -</option> 
                      <%
                      ps_check = con.prepareStatement("SELECT * FROM user_tbl_dept where ft_enable=1");
                      rs_check = ps_check.executeQuery();
                      while(rs_check.next()){
                      %>
                      <option value="<%=rs_check.getInt("dept_id") %>"><%=rs_check.getString("Department") %></option>
                      <%
                      }
                      %>
                    </select>
                 </div>  
				</td> 
				</tr> 	
				<tr>
				<td> 
				<input type="submit" value="Generate Report"> 
				<% if(flag==true){ %>
				<a href="DownloadFile.jsp?filepath=<%=queryList.get(1).toString() %>" style="margin-left: 10px;"><b><i class="icon_download" title="Download Report"></i> Download Report</b>
				<% }%>
				</td>
				 </tr> 
				</table> 
				</form>
				
				<%
				if(flag==true){
				%>
				<form method="post" name="edit" action="Action_Resp.jsp" id="edit">
				<input type="hidden" name="hid" id="hid">
				 <table class="table"> 
						<tr style="background-color: #03c6fc">
							<th width='5%' height='25'>T. No</th>
							<th width="25%">Issue Statement</th>
							<th>Facility</th>
							<th>Requester</th>
							<th>Assigned Company</th>
							<th>Assigned Dept.</th>
							<th>Registered Date</th>
							<th>Priority</th>
							<th>Status</th>
						</tr>  
						<% 
						String facility ="",assignedUser="",priority="",department="",requester="",company="", statusLog="";
						SimpleDateFormat mailDateFormat = new SimpleDateFormat("dd/MM/yyyy hh:mm a");
						ps_check = con.prepareStatement(queryList.get(0).toString());
						rs_check = ps_check.executeQuery();
						while(rs_check.next()){
							 
								ps_check1 = con.prepareStatement("select * from facility_tbl where id="+rs_check.getInt("facility_for"));
								rs_check1 = ps_check1.executeQuery();
								while(rs_check1.next()){
									facility = rs_check1.getString("name");
								}  
								ps_check1 = con.prepareStatement("select * from user_tbl where u_id="+rs_check.getInt("requester_id"));
								rs_check1 = ps_check1.executeQuery();
								while(rs_check1.next()){
									requester = rs_check1.getString("U_Name");
								}  
								
								ps_check1 = con.prepareStatement("select * from facility_tbl_priority where id="+rs_check.getInt("priority"));
								rs_check1 = ps_check1.executeQuery();
								while(rs_check1.next()){
									priority = rs_check1.getString("name");
								}  
								ps_check1 = con.prepareStatement("select * from user_tbl_dept where dept_id="+rs_check.getInt("assigned_dept_id"));
								rs_check1 = ps_check1.executeQuery();
								while(rs_check1.next()){
									department = rs_check1.getString("Department");
								}
								ps_check1 = con.prepareStatement("select * from user_tbl_company where Company_Id="+rs_check.getInt("assigned_comp_id"));
								rs_check1 = ps_check1.executeQuery();
								while(rs_check1.next()){
									company = rs_check1.getString("Company_Name");
								}
								ps_check1 = con.prepareStatement("select * from status_tbl where Status_Id="+rs_check.getInt("status_id"));
								rs_check1 = ps_check1.executeQuery();
								while(rs_check1.next()){
									statusLog = rs_check1.getString("Status");
								}
						%>
						<tr onmouseover="ChangeColor(this, true);"
								onmouseout="ChangeColor(this, false);"
								onclick="button1('<%=rs_check.getInt("id")%>');" style="background-color:white; cursor: pointer;font-size: 12px;">
							<td><%=rs_check.getInt("id") %></td>
							<td><%=rs_check.getString("issue_found") %></td>
							<td><%=facility %></td>
							<td><%=requester %></td>
							<td><%=company %></td>
							<td><%=department %></td>
							<td><%= mailDateFormat.format(rs_check.getTimestamp("sys_date")) %></td>
							<td><%=priority %></td>
							<td><%=statusLog %></td>
						</tr>
						<% 
						}
						%> 
				</table>
				</form>		
				<%
				}
				%>				
              </div>  
          </div> 
        <!-- project team & activity end --> 
      </section> 
    </section>
    
    <%
	}catch(Exception e){
		e.printStackTrace();
	}
    %>
    
     
    <!--main content end-->
  </section>
  <!-- container section end -->
  <!-- javascripts -->
  <script src="js/jquery.js"></script>
  <script src="js/bootstrap.min.js"></script>
  <!-- nice scroll -->
  <script src="js/jquery.scrollTo.min.js"></script>
  <script src="js/jquery.nicescroll.js" type="text/javascript"></script> 
  <!-- jquery ui -->
  <script src="js/jquery-ui-1.9.2.custom.min.js"></script> 
  <!--custom checkbox & radio-->
  <script type="text/javascript" src="js/ga.js"></script>
  <!--custom switch-->
  <script src="js/bootstrap-switch.js"></script>
  <!--custom tagsinput-->
  <script src="js/jquery.tagsinput.js"></script> 
  <!-- colorpicker --> 
  <!-- bootstrap-wysiwyg -->
  <script src="js/jquery.hotkeys.js"></script>
  <script src="js/bootstrap-wysiwyg.js"></script>
  <script src="js/bootstrap-wysiwyg-custom.js"></script>
  <script src="js/moment.js"></script>
  <script src="js/bootstrap-colorpicker.js"></script>
  <script src="js/daterangepicker.js"></script>
  <script src="js/bootstrap-datepicker.js"></script>
  <!-- ck editor -->
  <script type="text/javascript" src="assets/ckeditor/ckeditor.js"></script>
  <!-- custom form component script for this page-->
  <script src="js/form-component.js"></script>
  <!-- custome script for all page -->
  <script src="js/scripts.js"></script>


</body>

</html>
