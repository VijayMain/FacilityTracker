<%@page import="java.sql.ResultSet"%>
<%@page import="com.facilitytracker.connectionUtil.Connection_Util"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.PreparedStatement"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Sidebar</title>
</head>
<body>
<%
try{
%>
<!--sidebar start-->
    <aside>
      <div id="sidebar" class="nav-collapse ">
        <!-- sidebar menu start-->
        <ul class="sidebar-menu">
          <li class="active">
            <a class="" href="Home.jsp">
                    <i class="icon_house_alt"></i>
                    <span>Dashboard</span>
             </a>
          </li>
         <li class="sub-menu">
         <a href="javascript:;" class="">
                          <i class="icon_desktop"></i>
                          <span>FM Requests</span>
                          <span class="menu-arrow arrow_carrot-right"></span>
         </a>
         <ul class="sub">
              <li><a class="" href="ActionList.jsp?new=1"><i class="icon_pencil"></i> NEW</a></li>
              <li><a class="" href="ActionList.jsp?new=2"><i class="icon_question"></i> OPEN</a></li>
              <li><a class="" href="ActionList.jsp?new=4"><i class="icon_lock-open"></i> RE-OPEN</a></li>
              <li><a class="" href="ActionList.jsp?new=5"><i class="icon_lock"></i> CLOSED</a></li>
              <li><a class="" href="Reports.jsp"><i class="icon_datareport"></i> REPORTS</a></li>
         </ul>
         </li>
          <% 
        boolean flagCheck=false, account_flagCheck=false;
        PreparedStatement ps_user=null;
		ResultSet rs_user=null; 
		String plant_id = session.getAttribute("plant").toString();
		int user_id = Integer.valueOf(session.getAttribute("uid").toString());
		int dept_idCheck = Integer.valueOf(session.getAttribute("dept_id").toString());
		Connection connection = Connection_Util.getLocalUserConnection();
		Connection connMaster = Connection_Util.getConnectionMaster();
		ps_user = connection.prepareStatement("SELECT * FROM user_tbl_dept where ft_enable=1 and dept_id in (11,50,"+dept_idCheck+")");
		rs_user = ps_user.executeQuery();
		while(rs_user.next()){
			flagCheck = true;
		}
		
        if(flagCheck==true){
          %>
          <li class="sub-menu">
            <a href="javascript:;" class="">
                          <i class="icon_images"></i>
                          <span>Covid-19 Data</span>
                          <span class="menu-arrow arrow_carrot-right"></span>
                      </a>
            <ul class="sub">
              <li><a class="" href="covid_data.jsp"><i class="icon_bag_alt"></i>Data Received</a></li> 
            </ul>
          </li>
          <%
          }  
        flagCheck=false;
        boolean flagAvilopr=false;
        ps_user = connection.prepareStatement("SELECT * FROM user_tbl where dept_id in(18,31) and enable_id=1");
		rs_user = ps_user.executeQuery();
		while(rs_user.next()){
			if(rs_user.getInt("dept_id")==dept_idCheck){
				flagCheck=true;
			}
		}  
		ps_user = connection.prepareStatement("SELECT * FROM user_tbl where dept_id in(18,31,22) and enable_id=1");
		rs_user = ps_user.executeQuery();
		while(rs_user.next()){
			if(rs_user.getInt("dept_id")==dept_idCheck){
				account_flagCheck=true;
			}
		}  
          %>
          
          <li class="sub-menu">
            <a href="javascript:;" class="">
                          <i class="icon_images"></i>
                          <span>Stock Taking</span>
                          <span class="menu-arrow arrow_carrot-right"></span>
                      </a>
            <ul class="sub">
            <%
            if(flagCheck==true){
            %>
              <li><a class="" href="Stock_Taking.jsp"><i class="icon_upload"></i>File Upload</a></li>
            <%
            }
            %>
              <li><a class="" href="Stock_TakingCheck.jsp"><i class="icon_check"></i>Check Upload</a></li>
            <%
              if(account_flagCheck==true){
            %>
              <li><a class="" href="Stock_TakingFiles.jsp"><i class="icon_tags_alt"></i>All Uploads</a></li>
            <%
              }
            %>
            <li><a class="" href="Stock_TakingSearch.jsp"><i class="icon_search"></i>Search Record</a></li>
          	<%
            ps_user = connMaster.prepareStatement("SELECT * FROM stocktaking_dataEntry_opr where enable=1 and u_id="+user_id);
    		rs_user = ps_user.executeQuery();
    		while(rs_user.next()){
    			flagAvilopr = true;
    		}
    		if(flagAvilopr==true){
    		%>
    		<li><a class="" href="Stock_Taking_Count.jsp"><i class="icon_tag_alt"></i>Tag Data Punch</a></li>
    		<%	
    		}
            if(flagCheck==true){
            %>
            <li><a class="" href="Stock_Taking_Count.jsp"><i class="icon_tag_alt"></i>Tag Data Punch</a></li>
            <li><a class="" href="Stock_Taking_locMaster.jsp"><i class="icon_tools"></i>Location Master</a></li>
            <li><a class="" href="Stock_Taking_AssignTag.jsp"><i class="icon_tools"></i>Assign Tag</a></li>
            <%
            }
            %>
            </ul>
          </li> 
          
           
          
          <li class="sub-menu">
            <a href="javascript:;" class="">
                          <i class="icon_menu-circle_alt2"></i>
                          <span>MIS</span>
                          <span class="menu-arrow arrow_carrot-right"></span>
                      </a>
            <ul class="sub">
              <!-- <li><a class="" href="WFH_Transaction.jsp?none=1"><i class="arrow_carrot-right_alt2"></i> Add WFH Tasks</a></li> 
                  <li><a class="" href="Add_New_DWM.jsp"><i class="icon_document_alt"></i> DWM</a></li> -->
              <li><a class="" href="WFH_TaskPerformed.jsp"><i class="icon_ol"></i> Task Performed</a></li> 
             <!--  <li><a class="" href="WFH_BulkUpload.jsp"><i class="icon_upload"></i>File Upload</a></li>  -->
              <%
              if(dept_idCheck==18  || dept_idCheck==26){
              %>
              <li><a class="" href="WFH_Administration.jsp"><i class="icon_toolbox_alt"></i>Administration</a></li>
              <%
              }
              %>
             <li><a class="" href="WFH_Reports.jsp"><i class="icon_datareport"></i> Reports</a></li>
             
             <li><a class="" href="WFH_UploadedData.jsp"><i class="icon_datareport"></i>All WFH data</a></li>
            
            <!--  <li><a class="" href="WFH_PendingApprovals.jsp"><i class="icon_check"></i>Approval</a></li> -->
            </ul>
          </li> 
          
          
          
          
          
          
           <li class="sub-menu">
            <a href="javascript:;" class="">
               <i class="icon_documents_alt"></i>
               <span>Master Create</span>
               <span class="menu-arrow arrow_carrot-right"></span>
               </a>
            <ul class="sub">
              <li><a class="" href="Master_Home.jsp"><i class="icon_pencil"></i> New / Pending</a></li>
             <%
            Connection con_SAPlink = Connection_Util.getConnectionMaster();
            ps_user = con_SAPlink.prepareStatement("SELECT * FROM rel_SAPmaster_releaseStrategy where user_type='pur' and enable=1 and u_id="+Integer.valueOf(session.getAttribute("uid").toString()));
     		rs_user = ps_user.executeQuery();
     		if(rs_user.next()){
             %> 
              	<li><a class="" href="Master_Approval.jsp"><i class="icon_box-checked"></i> Approval</a></li>
            <%
     		}else if(dept_idCheck==18){
     		%> 
            	<li><a class="" href="Master_Approval.jsp"><i class="icon_box-checked"></i> Approval</a></li>
            <%	
     		}
     		ps_user = con_SAPlink.prepareStatement("SELECT * FROM rel_SAPmaster_releaseStrategy where user_type='mst' and enable=1 and u_id="+Integer.valueOf(session.getAttribute("uid").toString()));
     		rs_user = ps_user.executeQuery();
     		if(rs_user.next()){
            %>  
              <li><a class="" href="Master_Generate.jsp"><i class="icon_star"></i>Master Generate</a></li>
            <%
     		}else if(dept_idCheck==18){
     		%>  
              <li><a class="" href="Master_Generate.jsp"><i class="icon_star"></i>Master Generate</a></li>
            <%	
     		}
     		%>  
              <li><a class="" href="Master_Reject.jsp"><i class="icon_error-circle_alt"></i> Rejected</a></li>
              <li><a class="" href="Master_Done.jsp"><i class="icon_check"></i> Done</a></li>
               <li><a class="" href="Master_Requested.jsp"><i class="icon_menu-square_alt2"></i> All Requests</a></li>
              <%
              if(dept_idCheck==18){
              %>
              <li><a class="" href="Master_Data_Upload.jsp"><i class="icon_upload"></i>MM60</a></li> 
              <%
              }
              %>
              <li><a class="" href="Master_HSNCode.jsp"><i class="icon_id-2_alt"></i>HSN Search</a></li>
            </ul>
          </li>
           <li class="sub-menu">
            <a href="javascript:;" class="">
               <i class="icon_building_alt"></i>
               <span>Project Tracker</span>
               <span class="menu-arrow arrow_carrot-right"></span>
               </a>
            <ul class="sub">
            <%
            /* boolean checkFlag=false;
            ps_user = con_SAPlink.prepareStatement("select id from rel_pt_releaseMaster where enable=1 and app_uid="+user_id);
    		rs_user = ps_user.executeQuery();
    		while(rs_user.next()){
    			checkFlag=true;
    		}
    		ps_user = con_SAPlink.prepareStatement("select id from rel_pt_reviewer where enable=1 and u_id="+user_id);
    		rs_user = ps_user.executeQuery();
    		while(rs_user.next()){
    			checkFlag=true;
    		}
    		if(checkFlag==true){ */
            %>
              <li><a class="" href="SixSigma_DashBoard.jsp"><i class="icon_id-2_alt"></i>Dashboard</a></li>
            <%
            	ps_user = con_SAPlink.prepareStatement("SELECT * FROM rel_pt_releaseMaster where enable=1 and app_uid="+Integer.valueOf(session.getAttribute("uid").toString()));
       			rs_user = ps_user.executeQuery();
       			if(rs_user.next()){
              %>
              <li><a class="" href="SixSigma_NewApp.jsp"><i class="icon_like"></i>Approvals</a></li>
              <%
       			}
              %>
              <li><a class="" href="SixSigma_NewProject.jsp"><i class="icon_pencil-edit_alt"></i>New Problem</a></li>
              <li><a class="" href="SixSigma_Define.jsp"><i class="icon_pencil"></i>Define</a></li> 
              <li><a class="" href="SixSigma_Measure.jsp"><i class="icon_easel"></i> Measure</a></li>
              <li><a class="" href="SixSigma_Analyze.jsp"><i class="icon_box-checked"></i> Analyze</a></li>
              <li><a class="" href="SixSigma_Improve.jsp"><i class="icon_genius"></i> Improve</a></li>
              <li><a class="" href="SixSigma_Control.jsp"><i class="icon_cogs"></i> Control</a></li> 
              <li><a class="" href="SixSigma_Result.jsp"><i class="icon_datareport"></i> Result</a></li>  
              <li><a class="" href="SixSigma_Sustain.jsp"><i class="icon_bag_alt"></i>Sustain</a></li>
              <!-- <li><a class="" href="SixSigma_Master.jsp"><i class="icon_tools"></i>Master Config</a></li> -->
            </ul>
          </li>
        </ul>
      </div>
    </aside>
    <%
}catch(Exception e){
	e.printStackTrace();
}
    %>
</body>
</html>