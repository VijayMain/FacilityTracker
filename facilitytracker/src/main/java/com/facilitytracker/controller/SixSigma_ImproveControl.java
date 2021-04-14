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

@WebServlet("/SixSigma_ImproveControl")
public class SixSigma_ImproveControl extends HttpServlet {
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
							if (fieldName.equalsIgnoreCase("measureCnt")) {
								vo.setMeasureCnt(Integer.parseInt(fieldValue)); 
							}
							
							if (fieldName.equalsIgnoreCase("ssv_measure")) {
								vo.setSsv_measure(Integer.parseInt(fieldValue)); 
							}
							if (fieldName.equalsIgnoreCase("actionImprove")) {
								vo.setActionImprove(fieldValue);
							}
							if (fieldName.equalsIgnoreCase("confirm_completeDate")) {
								vo.setImport_completeDate(fieldValue); 
							}
							if (fieldName.equalsIgnoreCase("responsibleUser")) {
								vo.setResponsibleUser(Integer.parseInt(fieldValue)); 
							}  
							if (fieldName.equalsIgnoreCase("act_status")) {
								vo.setAct_status(Integer.parseInt(fieldValue)); 
							} 
							if (fieldName.equalsIgnoreCase("flag_new")) {
								vo.setFlag_new(fieldValue); 
							}
							if (fieldName.equalsIgnoreCase("his_id")) {
								vo.setHis_id(Integer.valueOf(fieldValue)); 
							}
							if (fieldName.equalsIgnoreCase("act_status"+vo.getHis_id())) {
								vo.setAct_status(Integer.parseInt(fieldValue)); 
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
							if (fieldName.equalsIgnoreCase("analyze_filename"+vo.getHis_id())) {
								file_stored = fileItem.getName(); 
								vo.setAnalyze_filename(FilenameUtils.getName(file_stored)); 
								file_Input = new DataInputStream(fileItem.getInputStream()); 
								vo.setAnalyze_attach(file_Input);  
							}
						}
					}
				dao.importDetails(session,vo,response); 
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
