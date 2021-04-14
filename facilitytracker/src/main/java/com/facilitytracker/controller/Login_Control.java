package com.facilitytracker.controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;  
import com.facilitytracker.dao.Login_DAO;
import com.facilitytracker.vo.Facility_VO;

@WebServlet("/Login_Control")
public class Login_Control extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		try {
			String name = request.getParameter("uname");
			String pass = request.getParameter("password"); 
			HttpSession session = request.getSession();
			Facility_VO vo = new Facility_VO();
			Login_DAO dao = new Login_DAO();
			
			vo.setName(name);
			vo.setPass(pass);			
			
			dao.login_User(session,vo,response);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
