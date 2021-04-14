package com.facilitytracker.controller;

import java.io.DataInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.apache.commons.io.FilenameUtils;

import com.facilitytracker.dao.SixSigma_Measure_DAO;
import com.facilitytracker.vo.SixSigma_ProblemVO;

@WebServlet("/SixSigma_AnalyzeControl")
public class SixSigma_AnalyzeControl extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		try {
			InputStream file_Input = null;
			boolean flag = false;
			ArrayList toolList = new ArrayList();
			HttpSession session = request.getSession();
			// ********************************************************************************************************
			SixSigma_ProblemVO vo = new SixSigma_ProblemVO();
			SixSigma_Measure_DAO dao = new SixSigma_Measure_DAO();
			/**********************************************************************************************************
			 * For MultipartContent Separate FILE Fields and FORM Fields
			 **********************************************************************************************************/
			if (ServletFileUpload.isMultipartContent(request)) {
				String fieldName, fieldValue = "";
				ServletFileUpload servletFileUpload = new ServletFileUpload(new DiskFileItemFactory());
				List fileItemsList; 
					fileItemsList = servletFileUpload.parseRequest(request);
					// Collect data into list
					FileItem fileItem = null;
					Iterator it = fileItemsList.iterator();
					// iterate list to sort data(i.e. form / file Fields)
					while (it.hasNext()) {
						FileItem fileItemTemp = (FileItem) it.next();
						// if data is form field ==== >
						if (fileItemTemp.isFormField()) {
							// INPUT FORM FIELDS are ==== >
							fieldName = fileItemTemp.getFieldName();
							fieldValue = fileItemTemp.getString();
							// TO SELECT PARTICULAR FORM FIELD ====>
							if (fieldName.equalsIgnoreCase("measurePID")) {
								vo.setMeasurePID(Integer.parseInt(fieldValue)); 
							}
							if (fieldName.equalsIgnoreCase("measurePhaseID")) {
								vo.setMeasurePhaseID(Integer.parseInt(fieldValue)); 
							}
							if (fieldName.equalsIgnoreCase("ssv_measure")) {
								vo.setSsv_measure(Integer.parseInt(fieldValue)); 
							}
							if (fieldName.equalsIgnoreCase("ssv_confirm")) {
								vo.setSsv_confirm(Integer.parseInt(fieldValue)); 
							}
							if (fieldName.equalsIgnoreCase("measureCnt")) {
								vo.setMeasureCnt(Integer.parseInt(fieldValue)); 
							}
						} else {
							// *************************************************************************************************************
							// IF FILE inputs === >
							// *************************************************************************************************************
							String file_stored = null;
							fileItem = fileItemTemp;
							fieldName = fileItem.getFieldName();
							fieldValue = fileItem.getString();
							
							if (fieldName.equalsIgnoreCase("analyze_filename")) {
								file_stored = fileItem.getName(); 
								vo.setAnalyze_filename(FilenameUtils.getName(file_stored)); 
								file_Input = new DataInputStream(fileItem.getInputStream()); 
								vo.setAnalyze_attach(file_Input); 
							}
						}
					}
				dao.analyzeDetails(session,vo,response); 
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
