package com.facilitytracker.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.DecimalFormat;
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
 
@WebServlet("/WFH_ConfigControl")
public class WFH_ConfigControl extends HttpServlet {
	private static final long serialVersionUID = 1L;
 
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try {
			 int up=0;
			HttpSession session = request.getSession();
			 int uid = Integer.valueOf(session.getAttribute("uid").toString());
				Connection con = Connection_Util.getConnectionMaster(); 
				DecimalFormat formatter = new DecimalFormat( "00.00" );
				String time_reqd = request.getParameter("time_required");
				String id = request.getParameter("id");
				System.out.println("id " + id);
				Double timemm = Double.valueOf(time_reqd);
				String timeHH = formatter.format(timemm/60); 
				// *******************************************************************************************************************************************************************
				java.util.Date date = null;
				java.sql.Timestamp timeStamp = null;
				Calendar calendar = Calendar.getInstance();
				calendar.setTime(new Date());
				java.sql.Date dt = new java.sql.Date(calendar.getTimeInMillis());
				java.sql.Time sqlTime = new java.sql.Time(calendar.getTime()	.getTime());
				SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
				SimpleDateFormat cellDateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
				date = simpleDateFormat.parse(dt.toString() + " "	+ sqlTime.toString());
				timeStamp = new java.sql.Timestamp(date.getTime());

				// *******************************************************************************************************************************************************************
				PreparedStatement ps_config = con.prepareStatement("update tran_wfh_config set specification1=?,specification2=?,changed_by=?,changed_date=?,enable_id=? where id="+Integer.valueOf(id));
				ps_config.setString(1, String.valueOf(timemm));
				ps_config.setString(2, timeHH);
				ps_config.setInt(3, uid);
				ps_config.setTimestamp(4, timeStamp);
				ps_config.setInt(5, 1);
			//	up = ps_config.executeUpdate();
				
				if(up>0){
					response.sendRedirect("WFH_Administration.jsp?status=Upload Success");
				}else{
					response.sendRedirect("WFH_Administration.jsp?statusNop=Upload Fail");
				}
				
		} catch (Exception e) {
			e.printStackTrace();
		} 
	} 
}
