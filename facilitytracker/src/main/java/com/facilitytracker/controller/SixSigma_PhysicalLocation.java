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

@WebServlet("/SixSigma_PhysicalLocation")
public class SixSigma_PhysicalLocation extends HttpServlet {
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
			
			// fiscal   plant   store_loc   loc_owner   phy_location   sub_loc_owner   sub_loc_auditor  
			int fiscal = Integer.valueOf(request.getParameter("fiscal"));
			String plant  = request.getParameter("plant");   
			int store_loc =  Integer.valueOf(request.getParameter("store_loc"));  
			int loc_owner =  Integer.valueOf(request.getParameter("loc_owner"));  
			String phy_location  = request.getParameter("phy_location");  
			int sub_loc_owner =  Integer.valueOf(request.getParameter("sub_loc_owner"));  
			int sub_loc_auditor =  Integer.valueOf(request.getParameter("sub_loc_auditor"));
			
			String loc_ownerName="", sub_loc_ownerName="", sub_loc_auditorName="";
			
			ps_check = con_local.prepareStatement("select U_Name from user_tbl where u_id="+loc_owner);
			rs_check = ps_check.executeQuery();
			while (rs_check.next()) {
				loc_ownerName = rs_check.getString("U_Name");
			}
			
			ps_check = con_local.prepareStatement("select U_Name from user_tbl where u_id="+sub_loc_owner);
			rs_check = ps_check.executeQuery();
			while (rs_check.next()) {
				sub_loc_ownerName = rs_check.getString("U_Name"); 
			}
			
			ps_check = con_local.prepareStatement("select U_Name from user_tbl where u_id="+sub_loc_auditor);
			rs_check = ps_check.executeQuery();
			while (rs_check.next()) {
				sub_loc_auditorName = rs_check.getString("U_Name"); 
			}
			
			
			ps_check = con.prepareStatement("select id from stocktaking_loc_auditors_sub "+
					" where sub_locationName='"+phy_location+"' and enable=1 and loc_owner="+sub_loc_owner+" and loc_auditor="+sub_loc_auditor+
					" and plant="+plant+" and fiscal_year="+fiscal+" and stock_loc_id="+store_loc);
			rs_check = ps_check.executeQuery();
			if (rs_check.next()) {
				error = "Already Available...";
				response.sendRedirect("Stock_Taking_locMaster.jsp?error="+error);
			}else{
				
				int up =0;
				
				PreparedStatement ps_check1 = con.prepareStatement("select * from stocktaking_loc_owner where fiscal_year="+fiscal+" and plant='"+plant+"' and enable=1 and stock_loc_id=" + store_loc +" and loc_owner="+ loc_owner);
				ResultSet rs_check1 = ps_check1.executeQuery();
				if (rs_check1.next()) {
					up=1;
				}else{
				
				ps_check = con.prepareStatement("insert into stocktaking_loc_owner "
						+ "(stock_loc_id,loc_owner,loc_owner_name,fiscal_year,plant,enable,created_by,created_date,changed_by,changed_date) values(?,?,?,?,?,?,?,?,?,?)");
				ps_check.setInt(1, store_loc);
				ps_check.setInt(2, loc_owner);
				ps_check.setString(3, loc_ownerName);
				ps_check.setInt(4, fiscal);
				ps_check.setString(5, plant);
				ps_check.setInt(6, 1);
				ps_check.setInt(7, uid);
				ps_check.setTimestamp(8, timeStamp);
				ps_check.setInt(9, uid);
				ps_check.setTimestamp(10, timeStamp);
				up= ps_check.executeUpdate();
				}
				if(up>0){
					ps_check = con.prepareStatement("insert into stocktaking_loc_auditors_sub "
							+ "(stock_loc_id,sub_locationName,loc_owner,loc_owner_name,loc_auditor,loc_auditor_name,plant,"
							+ "fiscal_year,enable,created_by,created_date,changed_by,changed_date) values (?,?,?,?,?,?,?,?,?,?,?,?,?)");
					ps_check.setInt(1, store_loc);
					ps_check.setString(2,phy_location);
					ps_check.setInt(3,sub_loc_owner);
					ps_check.setString(4,sub_loc_ownerName);
					ps_check.setInt(5,sub_loc_auditor);
					ps_check.setString(6,sub_loc_auditorName);
					ps_check.setString(7,plant);
					ps_check.setInt(8,fiscal);
					ps_check.setInt(9,1);
					ps_check.setInt(10,uid);
					ps_check.setTimestamp(11,timeStamp);
					ps_check.setInt(12,uid);
					ps_check.setTimestamp(13,timeStamp);
 
					int up1 = ps_check.executeUpdate();
					
					if(up1>0){
						response.sendRedirect("Stock_Taking_locMaster.jsp");
					}
				}
			}
			
			
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
