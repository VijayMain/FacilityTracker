package com.facilitytracker.controller;

import java.io.IOException;
import java.util.ArrayList;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.facilitytracker.dao.GenerateMatExcel_DAO;
import com.facilitytracker.vo.StockTaking_VO; 

@WebServlet("/Generate_MatExcel")
public class Generate_MatExcel extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		try {
			StockTaking_VO vo = new StockTaking_VO();
			GenerateMatExcel_DAO dao = new GenerateMatExcel_DAO();
			ArrayList idList = new ArrayList();
			
			if(request.getParameterValues("cheked_id")!=null){
			
			String[] names = request.getParameterValues("cheked_id");
			
			for(int i=0; i< names.length; i++){
				idList.add(names[i]);
			}
			
			javax.servlet.ServletContext context = getServletContext();
			 
			dao.generateExcel(vo,response,idList,context);
			
			}else{
				response.sendRedirect("Master_Generate.jsp?statusNop='No Data Selected...!!!'");
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}