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
		Connection con_master = Connection_Util.getConnectionMaster();
				   
		PreparedStatement ps_data = null;
		ResultSet rs_data=null;
		if(request.getParameter("rating")==null){
			String classProject = request.getParameter("classProject");
			String nature = request.getParameter("nature");
			String impact_extCust = request.getParameter("impact_extCust");
			String impact_intCust = request.getParameter("impact_intCust");
			String dataAnalysis = request.getParameter("dataAnalysis");
			String crossfun_rate = request.getParameter("crossfun_rate");
			String exp_Saving = request.getParameter("exp_Saving");
			String baselinePPM = request.getParameter("baselinePPM"); 
			
			float typeProject = 0,natureProject = 0, impintCust=0,impextcust=0,dataAn=0,crossfun=0,expsave=0,baselineppm=0;
			if(classProject!=""){
			ps_data = con_master.prepareStatement("SELECT * FROM rel_pt_masterData WHERE id="+Integer.valueOf(classProject));
			rs_data = ps_data.executeQuery();
			while(rs_data.next()){
				typeProject = rs_data.getFloat("weightage")*rs_data.getFloat("ratingScore");
			}
			}
			
			if(nature!=""){
			ps_data = con_master.prepareStatement("SELECT * FROM rel_pt_masterData WHERE id="+Integer.valueOf(nature));
			rs_data = ps_data.executeQuery();
			while(rs_data.next()){
				natureProject = rs_data.getFloat("weightage")*rs_data.getFloat("ratingScore");
			}
			}
			
			if(impact_extCust!=""){
			ps_data = con_master.prepareStatement("SELECT * FROM rel_pt_masterData WHERE id="+Integer.valueOf(impact_extCust));
			rs_data = ps_data.executeQuery();
			while(rs_data.next()){
				impextcust = rs_data.getFloat("weightage")*rs_data.getFloat("ratingScore");
			}
			}
			
			if(impact_intCust!=""){
			ps_data = con_master.prepareStatement("SELECT * FROM rel_pt_masterData WHERE id="+Integer.valueOf(impact_intCust));
			rs_data = ps_data.executeQuery();
			while(rs_data.next()){
				impintCust = rs_data.getFloat("weightage")*rs_data.getFloat("ratingScore");
			}
			}
			
			if(dataAnalysis!=""){
			ps_data = con_master.prepareStatement("SELECT * FROM rel_pt_masterData WHERE id="+Integer.valueOf(dataAnalysis));
			rs_data = ps_data.executeQuery();
			while(rs_data.next()){
				dataAn = rs_data.getFloat("weightage")*rs_data.getFloat("ratingScore");
			}
			}
			
			if(crossfun_rate!=""){
			ps_data = con_master.prepareStatement("SELECT * FROM rel_pt_masterData WHERE id="+Integer.valueOf(crossfun_rate));
			rs_data = ps_data.executeQuery();
			while(rs_data.next()){
				crossfun = rs_data.getFloat("weightage")*rs_data.getFloat("ratingScore");
			}
			}
			
			if(exp_Saving!=""){
			float expinLakh = Float.valueOf(exp_Saving)*100000; 
			ps_data = con_master.prepareStatement("SELECT * FROM rel_pt_masterData WHERE enable=1  and searchTerm = 'expectedSaving' and "+expinLakh+" between min and max");
			rs_data = ps_data.executeQuery();
			while(rs_data.next()){
				expsave = rs_data.getFloat("weightage")*rs_data.getFloat("ratingScore");
			}
			}
			
			if(baselinePPM!=""){
				ps_data = con_master.prepareStatement("SELECT * FROM rel_pt_masterData WHERE enable=1  and searchTerm = 'baselinePPM' and "+Float.valueOf(baselinePPM)+" between min and max");
				rs_data = ps_data.executeQuery();
			while(rs_data.next()){
				baselineppm = rs_data.getFloat("weightage")*rs_data.getFloat("ratingScore");
			}
			}
			float totalScrore= typeProject + natureProject + impintCust + impextcust + dataAn + crossfun + expsave + baselineppm;
 %>
<span id="scoreajax">
<%= totalScrore %>
<input type="hidden" id="myHid"  name="myHid" value="<%= totalScrore %>">
</span>
<%
		}else{
			 %> 
			 <span id="rateAjax"> 
			 <%
			 if(request.getParameter("rating")!=""){
				 float impact=0;
				 String impactText = "";
				 ps_data = con_master.prepareStatement("select * from rel_pt_masterData where enable=1 and searchTerm='actualProjectScore' and "+Float.valueOf(request.getParameter("rating"))+" between min and max");
					rs_data = ps_data.executeQuery();
					while(rs_data.next()){
						impact = rs_data.getFloat("weightage");
						impactText = rs_data.getString("master_name");
					}
				if(impact==0){
			%>
			<strong style="font-size: 12px;color: white;background-color: red;">&nbsp;&nbsp;<%=impactText %>&nbsp;&nbsp;</strong>
			<%		
				}else if(impact==1){
			%>
			<strong style="font-size: 12px;color: black; background-color: yellow;">&nbsp;&nbsp;<%=impactText %>&nbsp;&nbsp;</strong>	
			<%			
				}else if(impact==2){
			%>
			<strong style="font-size: 12px;color: white; background-color: green;">&nbsp;&nbsp;<%=impactText %>&nbsp;&nbsp;</strong>		
			<%		
				}
			%>
			<input type="hidden" id="rateDefine" name="rateDefine" value="<%=impactText%>">
			<%
			 }
			 %>
			 
			 </span>
			 <%  			
		}
}catch(Exception e){
	e.printStackTrace();
} 
%>  
</body>
</html>