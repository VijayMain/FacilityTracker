package com.facilitytracker.controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.facilitytracker.dao.SixSigma_ProblemDAO;
import com.facilitytracker.vo.SixSigma_ProblemVO;

@WebServlet("/SixSigma_ProblemControl")
public class SixSigma_ProblemControl extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		try {
			// plant dept problem MtCode product_descr typeProject
			SixSigma_ProblemVO vo = new SixSigma_ProblemVO();
			SixSigma_ProblemDAO dao = new SixSigma_ProblemDAO();
			HttpSession session = request.getSession();
			String plant = "", problem = "", product_descr = "";
			int mtCode = 0, dept = 0, typeProject = 0;
			
			plant = request.getParameter("plant"); 
			problem = request.getParameter("problem").toUpperCase(); 
			product_descr = request.getParameter("product_descr").toUpperCase();
			//search_product = request.getParameter("search_product");
			  
			mtCode = Integer.valueOf(request.getParameter("MtCode"));
			dept = Integer.valueOf(request.getParameter("dept"));
			typeProject = Integer.valueOf(request.getParameter("typeProject"));
			
			vo.setPlant(plant);
			vo.setProblem(problem);
			vo.setProduct_descr(product_descr);
			vo.setMtCode(mtCode);
			vo.setDept(dept);
			vo.setTypeProject(typeProject);
			
			dao.problemRegistration(vo,response,session);
			
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}