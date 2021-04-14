package com.facilitytracker.dao;
 
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException; 

import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.facilitytracker.connectionUtil.Connection_Util;
import com.facilitytracker.vo.Facility_VO;

public class Login_DAO {
	String uname=null;
	String pwd=null;
	boolean flag=false;
	
	public void login_User(HttpSession session, Facility_VO vo, HttpServletResponse response) throws IOException {
		try {
			uname=vo.getName();
			pwd=vo.getPass();
			int uid = 0, comp_id=0;
			int dept_id=0; 
			String deptName="",plant=""; 
			session.setMaxInactiveInterval(-1);
			Connection con = Connection_Util.getLocalUserConnection(); 
			PreparedStatement ps_user=null, ps_dept=null, ps_plant=null;
			ResultSet rs_user=null, rs_dept=null, rs_plant=null; 
			ps_user = con.prepareStatement("select * from user_tbl where Enable_id=1 and Login_Name='" +vo.getName()+"' and Login_Password='" + vo.getPass() + "'");
			rs_user = ps_user.executeQuery(); 
				while (rs_user.next())
				{
						uid = rs_user.getInt("U_Id"); 
						dept_id=rs_user.getInt("dept_id");  
						comp_id=rs_user.getInt("Company_Id");
						ps_dept = con.prepareStatement("select * from user_tbl_dept where dept_id="+dept_id);
						rs_dept = ps_dept.executeQuery();
						while (rs_dept.next()) {
							deptName=rs_dept.getString("Department");
						} 
						
						ps_plant = con.prepareStatement("select plant from user_tbl_company where Company_Id="+comp_id);
						rs_plant = ps_plant.executeQuery();
						while (rs_plant.next()) {
							plant=rs_plant.getString("plant");
						} 
						
						/*PreparedStatement ps_swAccess=con.prepareStatement("select * from it_software_access_tbl where U_Id="+uid +"");
						ResultSet rs_swAccess=ps_swAccess.executeQuery();
						
						while(rs_swAccess.next())
						{
							if(software_id==rs_swAccess.getInt("Software_Id") && rs_swAccess.getInt("Enable_Id")==1)
							{
								session.setAttribute("uid", rs_user.getInt("U_Id"));
								flag=true;
							}
						}
						rs_swAccess.close(); */ 
						session.setAttribute("uid", uid);
						session.setMaxInactiveInterval(-1);
						session.setAttribute("comp_id", comp_id);
						session.setMaxInactiveInterval(-1);
						session.setAttribute("dept_id", dept_id);
						session.setMaxInactiveInterval(-1);
						session.setAttribute("username", rs_user.getString("U_Name"));
						session.setMaxInactiveInterval(-1);
						session.setAttribute("deptName", deptName);
						session.setMaxInactiveInterval(-1);
						session.setAttribute("email_id", rs_user.getString("U_email"));
						session.setMaxInactiveInterval(-1); 
						session.setAttribute("plant", plant);
						session.setMaxInactiveInterval(-1);  
						/*session.setAttribute("comp_id", comp_id);
						session.setMaxInactiveInterval(-1);*/
						flag=true;
				}
				rs_user.close();
				
				if(flag==true)
				{
					response.sendRedirect("Home.jsp");
				}
				else
				{ 
					response.sendRedirect("Login.jsp?error='Login Fail...Please check User Name and Password...!!!'");  
				}
				
			} catch (SQLException e) { 
				e.printStackTrace();
			}	
		}
	}
