package com.facilitytracker.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.facilitytracker.connectionUtil.Connection_Util;

@WebServlet("/StockTaking_TagAssign")
public class StockTaking_TagAssign extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		try {
			Connection con = Connection_Util.getConnectionMaster();
			Connection con_local = Connection_Util.getLocalUserConnection();
			
			HttpSession session = request.getSession();
			int uid = Integer.valueOf(session.getAttribute("uid").toString());
			PreparedStatement ps_check=null;
			ResultSet rs_check=null;
			String error = "";
			
			// *******************************************************************************************************************************************************************
						java.util.Date date = null;
						java.sql.Timestamp timeStamp = null;
						Calendar calendar = Calendar.getInstance();
						calendar.setTime(new Date());
						java.sql.Date dt = new java.sql.Date(calendar.getTimeInMillis());
						java.sql.Time sqlTime = new java.sql.Time(calendar.getTime().getTime());
						SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
						SimpleDateFormat cellDateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
						SimpleDateFormat format = new SimpleDateFormat("dd-MM-YYYY");
						
						date = simpleDateFormat.parse(dt.toString() + " "	+ sqlTime.toString());
						timeStamp = new java.sql.Timestamp(date.getTime());
						long millis=System.currentTimeMillis();
					    java.sql.Date todaysdate=new java.sql.Date(millis); 
			// *******************************************************************************************************************************************************************
					
			
			// fiscal   plant    store_loc   phy_location   tag_noFrom   tag_noTo         
			int fiscal = Integer.valueOf(request.getParameter("fiscal"));
			String plant  = request.getParameter("plant");   
			int store_loc =  Integer.valueOf(request.getParameter("store_loc"));   
			String phy_location  = request.getParameter("phy_location");  
			int tag_noFrom =  Integer.valueOf(request.getParameter("tag_noFrom"));  
			int tag_noTo =  Integer.valueOf(request.getParameter("tag_noTo"));
			
			int totAssigned = tag_noTo-tag_noFrom;
			
			
			String loc_ownerName="";
			
			ps_check = con.prepareStatement("select loc_owner_name from stocktaking_loc_auditors_sub where id="+phy_location);
			rs_check = ps_check.executeQuery();
			while (rs_check.next()) {
				loc_ownerName = rs_check.getString("loc_owner_name");
			}
			int up1 = 0;
			ps_check = con.prepareStatement("select * from stocktaking_tagAssign where enable=1 and sub_loc_auditors_id="+Integer.valueOf(phy_location)+" and assigned_from='"+tag_noFrom+"' and assigned_to='"+tag_noTo+"' "+
					" and plant='"+plant+"' and fiscal_year="+fiscal);
			rs_check = ps_check.executeQuery();
			if (rs_check.next()) {
				up1 = 0;
			}else{
			ps_check = con.prepareStatement("insert into stocktaking_tagAssign (plant,sub_loc_auditors_id,loc_owner_name,assigned_from,assigned_to,total_assigned,enable,created_by,created_date,changed_by,changed_date,fiscal_year,store_loc_id) values(?,?,?,?,?,?,?,?,?,?,?,?,?)");
			 
					ps_check.setString(1, plant);
					ps_check.setInt(2,Integer.valueOf(phy_location));
					ps_check.setString(3,loc_ownerName);
					ps_check.setInt(4,tag_noFrom);
					ps_check.setInt(5,tag_noTo);
					ps_check.setInt(6,totAssigned);
					ps_check.setInt(7,1);
					ps_check.setInt(8,3);
					ps_check.setTimestamp(9,timeStamp);
					ps_check.setInt(10,3);
					ps_check.setTimestamp(11,timeStamp); 
					ps_check.setInt(12,fiscal);
					ps_check.setInt(13,store_loc);
					
					up1 = ps_check.executeUpdate(); 
			}
					if(up1>0){
						response.sendRedirect("Stock_Taking_AssignTag.jsp?doneTag='Success'");
					}else{
						response.sendRedirect("Stock_Taking_AssignTag.jsp?doneTag='Error Found..!!!'");
					}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
