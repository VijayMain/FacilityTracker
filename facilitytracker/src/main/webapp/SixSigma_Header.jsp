<%
if(request.getParameter("define").equalsIgnoreCase("define")){
%>
	<ol class="breadcrumb"> 
            	<li><i class="icon_menu-square_alt2" style="color: gray;"></i>Project Definition and Charter</li>
             	<li><i class="icon_refresh" style="color: gray;"></i><a href="SixSigma_Define.jsp" style="font-weight: bold;">Refresh</a>  </li>
 
<li><i class="icon_id-2_alt" style="color: gray;"></i><a href="SixSigma_DashBoard.jsp" style="font-weight: bold;">Dashboard</a>  </li> 
 </ol>
<%
}
if(request.getParameter("define").equalsIgnoreCase("new_project")){
%>
	<ol class="breadcrumb"> 
            	<li><i class="icon_pencil-edit_alt" style="color: gray;"></i>Create New</li> 
              	<li><i class="icon_refresh" style="color: gray;"></i><a href="SixSigma_NewProject.jsp" style="font-weight: bold;">Refresh</a>  </li>
 
<li><i class="icon_id-2_alt" style="color: gray;"></i><a href="SixSigma_DashBoard.jsp" style="font-weight: bold;">Dashboard</a>  </li> 
         	
	</ol>
<%
}
if(request.getParameter("define").equalsIgnoreCase("define_charter")){
%>
	<ol class="breadcrumb">  
            	<li><i class="icon_menu-square_alt2" style="color: gray;"></i><a href="SixSigma_Define.jsp" style="font-weight: bold;">Project Definition and Charter</a></li>
 
<li><i class="icon_id-2_alt" style="color: gray;"></i><a href="SixSigma_DashBoard.jsp" style="font-weight: bold;">Dashboard</a>  </li> 
  
  	</ol>
<%
}
if(request.getParameter("define").equalsIgnoreCase("define_approvals")){
%>
	<ol class="breadcrumb"> 
          <li><i class="icon_like" style="color: gray;"></i>Approvals</li> 
          <li><i class="icon_refresh" style="color: gray;"></i><a href="SixSigma_NewApp.jsp" style="font-weight: bold;">Refresh</a>  </li>
 
<li><i class="icon_id-2_alt" style="color: gray;"></i><a href="SixSigma_DashBoard.jsp" style="font-weight: bold;">Dashboard</a>  </li> 
   </ol>
<%
}
if(request.getParameter("define").equalsIgnoreCase("dashboard")){
%>
	<ol class="breadcrumb"> 
          <li><i class="icon_id-2_alt" style="color: gray;"></i>Dashboard</li> 
    </ol>
<%
}
if(request.getParameter("define").equalsIgnoreCase("measure")){
%>
	<ol class="breadcrumb"> 
            	<li><i class="icon_easel" style="color: gray;"></i>Measure</li> 
              	<li><i class="icon_refresh" style="color: gray;"></i><a href="SixSigma_Measure.jsp" style="font-weight: bold;">Refresh</a>  </li>
 
<li><i class="icon_id-2_alt" style="color: gray;"></i><a href="SixSigma_DashBoard.jsp" style="font-weight: bold;">Dashboard</a>  </li> 
</ol>
<%
}
if(request.getParameter("define").equalsIgnoreCase("measure_data")){
%>
	<ol class="breadcrumb"> 
            	<li><i class="icon_easel" style="color: gray;"></i><a href="SixSigma_Measure.jsp" style="font-weight: bold;">Measure</a></li>

<li><i class="icon_id-2_alt" style="color: gray;"></i><a href="SixSigma_DashBoard.jsp" style="font-weight: bold;">Dashboard</a>  </li> 
	</ol>
<%
}
if(request.getParameter("define").equalsIgnoreCase("analyze")){
%>
	<ol class="breadcrumb">
            	<li><i class="icon_box-checked" style="color: gray;"></i>Analyze</li> 
              	<li><i class="icon_refresh" style="color: gray;"></i><a href="SixSigma_Analyze.jsp" style="font-weight: bold;">Refresh</a>  </li>
 
<li><i class="icon_id-2_alt" style="color: gray;"></i><a href="SixSigma_DashBoard.jsp" style="font-weight: bold;">Dashboard</a>  </li> 
  	</ol>
<%
}
if(request.getParameter("define").equalsIgnoreCase("analyze_data")){
%>
	<ol class="breadcrumb">
            	<li><i class="icon_box-checked" style="color: gray;"></i><a href="SixSigma_Analyze.jsp" style="font-weight: bold;">Analyze</a></li>
 <li><i class="icon_id-2_alt" style="color: gray;"></i><a href="SixSigma_DashBoard.jsp" style="font-weight: bold;">Dashboard</a>  </li> 
</ol>
<%
}
if(request.getParameter("define").equalsIgnoreCase("improve")){
%>
	<ol class="breadcrumb">
            	<li><i class="icon_genius" style="color: gray;"></i>Improve</li> 
              	<li><i class="icon_refresh" style="color: gray;"></i><a href="SixSigma_Improve.jsp" style="font-weight: bold;">Refresh</a>  </li>
<li><i class="icon_id-2_alt" style="color: gray;"></i><a href="SixSigma_DashBoard.jsp" style="font-weight: bold;">Dashboard</a>  </li> 
</ol>
<%
}
if(request.getParameter("define").equalsIgnoreCase("improve_data")){
%>
	<ol class="breadcrumb">
            	<li><i class="icon_genius" style="color: gray;"></i><a href="SixSigma_Improve.jsp" style="font-weight: bold;">Improve</a></li>
<li><i class="icon_id-2_alt" style="color: gray;"></i><a href="SixSigma_DashBoard.jsp" style="font-weight: bold;">Dashboard</a>  </li> 
</ol>
<%
}
if(request.getParameter("define").equalsIgnoreCase("control")){
%>
	<ol class="breadcrumb">
            	<li><i class="icon_genius" style="color: gray;"></i>Control</li> 
              	<li><i class="icon_refresh" style="color: gray;"></i><a href="SixSigma_Control.jsp" style="font-weight: bold;">Refresh</a>  </li>
<li><i class="icon_id-2_alt" style="color: gray;"></i><a href="SixSigma_DashBoard.jsp" style="font-weight: bold;">Dashboard</a>  </li> 
</ol>
<%
}
if(request.getParameter("define").equalsIgnoreCase("control_data")){
%>
	<ol class="breadcrumb">
            	<li><i class="icon_genius" style="color: gray;"></i><a href="SixSigma_Control.jsp" style="font-weight: bold;">Control</a></li>
 <li><i class="icon_id-2_alt" style="color: gray;"></i><a href="SixSigma_DashBoard.jsp" style="font-weight: bold;">Dashboard</a>  </li> 
</ol>
<%
}
if(request.getParameter("define").equalsIgnoreCase("result")){
%>
	<ol class="breadcrumb">
            	<li><i class="icon_datareport" style="color: gray;"></i>Result</li> 
              	<li><i class="icon_refresh" style="color: gray;"></i><a href="SixSigma_Result.jsp" style="font-weight: bold;">Refresh</a>  </li>
    			<li><i class="icon_id-2_alt" style="color: gray;"></i><a href="SixSigma_DashBoard.jsp" style="font-weight: bold;">Dashboard</a>  </li> 
	</ol>
<%
}
if(request.getParameter("define").equalsIgnoreCase("result_data")){
%>
	<ol class="breadcrumb">
            	<li><i class="icon_datareport" style="color: gray;"></i><a href="SixSigma_Result.jsp" style="font-weight: bold;">Result</a></li>
<li><i class="icon_id-2_alt" style="color: gray;"></i><a href="SixSigma_DashBoard.jsp" style="font-weight: bold;">Dashboard</a>  </li> 
</ol>
<%
}
if(request.getParameter("define").equalsIgnoreCase("actPlan")){
%>
	<ol class="breadcrumb">
            	<li><i class="icon_documents_alt" style="color: gray;"></i>Review and Action planning</li> 
              	<li><i class="icon_refresh" style="color: gray;"></i><a href="SixSigma_ActPlan.jsp" style="font-weight: bold;">Refresh</a>  </li>
				<li><i class="icon_id-2_alt" style="color: gray;"></i><a href="SixSigma_DashBoard.jsp" style="font-weight: bold;">Dashboard</a>  </li> 
</ol>
<%
}
if(request.getParameter("define").equalsIgnoreCase("actPlan_data")){
%>
	<ol class="breadcrumb">
            	<li><i class="icon_documents_alt" style="color: gray;"></i><a href="SixSigma_ActPlan.jsp" style="font-weight: bold;">Review and Action planning</a></li> 
              	<li><i class="icon_refresh" style="color: gray;"></i><a href="SixSigma_ActPlan_Data.jsp" style="font-weight: bold;">Refresh</a>  </li>
				<li><i class="icon_id-2_alt" style="color: gray;"></i><a href="SixSigma_DashBoard.jsp" style="font-weight: bold;">Dashboard</a>  </li> 
	</ol>
<%
}
if(request.getParameter("define").equalsIgnoreCase("sustPlan")){
%>
	<ol class="breadcrumb">
            	<li><i class="icon_documents_alt" style="color: gray;"></i>Sustenance planning</li> 
              	<li><i class="icon_refresh" style="color: gray;"></i><a href="SixSigma_Sustain.jsp" style="font-weight: bold;">Refresh</a>  </li>
 				<li><i class="icon_id-2_alt" style="color: gray;"></i><a href="SixSigma_DashBoard.jsp" style="font-weight: bold;">Dashboard</a>  </li> 
	</ol>
<%
}
if(request.getParameter("define").equalsIgnoreCase("sustPlan_data")){
%>
	<ol class="breadcrumb">
            	<li><i class="icon_documents_alt" style="color: gray;"></i><a href="SixSigma_Sustain.jsp" style="font-weight: bold;">Sustenance planning</a></li>
				<li><i class="icon_id-2_alt" style="color: gray;"></i><a href="SixSigma_DashBoard.jsp" style="font-weight: bold;">Dashboard</a>  </li> 
	</ol>
<%
}
%>