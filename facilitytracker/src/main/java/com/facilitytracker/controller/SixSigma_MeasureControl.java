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
 

@WebServlet("/SixSigma_MeasureControl")
public class SixSigma_MeasureControl extends HttpServlet {
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
							
							if (fieldName.equalsIgnoreCase("month_minRejection")) { 
								if(!fieldValue.equalsIgnoreCase("")){
								vo.setMonth_minRejection(Integer.parseInt(fieldValue));
								}
							}
							if (fieldName.equalsIgnoreCase("year_minRejection")) {
								if(!fieldValue.equalsIgnoreCase("")){
								vo.setYear_minRejection(Integer.parseInt(fieldValue));
								}
							}
							if (fieldName.equalsIgnoreCase("month_maxRejection")) {
								if(!fieldValue.equalsIgnoreCase("")){
								vo.setMonth_maxRejection(Integer.parseInt(fieldValue));
								}
							}
							if (fieldName.equalsIgnoreCase("year_maxRejection")) {
								if(!fieldValue.equalsIgnoreCase("")){
								vo.setYear_maxRejection(Integer.parseInt(fieldValue));
								}
							}
							if (fieldName.equalsIgnoreCase("min_rejectPPM")) {
								if(!fieldValue.equalsIgnoreCase("")){
								vo.setMin_rejectPPM(Integer.parseInt(fieldValue));
								}
							}
							if (fieldName.equalsIgnoreCase("max_rejectPPM")) {
								if(!fieldValue.equalsIgnoreCase("")){
								vo.setMax_rejectPPM(Integer.parseInt(fieldValue));
								}
							}
							if (fieldName.equalsIgnoreCase("no_machinesUsed")) {
								if(!fieldValue.equalsIgnoreCase("")){
								vo.setNo_machinesUsed(Integer.parseInt(fieldValue));
								}
							}
							if (fieldName.equalsIgnoreCase("no_streams")) {
								if(!fieldValue.equalsIgnoreCase("")){
								vo.setNo_streams(Integer.parseInt(fieldValue));
								}
							}
							if (fieldName.equalsIgnoreCase("response")) {
								if(!fieldValue.equalsIgnoreCase("")){
								vo.setResponse(Integer.parseInt(fieldValue));
								}
							}
							if (fieldName.equalsIgnoreCase("abnormal_equipmentCond")) {
								if(!fieldValue.equalsIgnoreCase("")){
								vo.setAbnormal_equipmentCond(Integer.parseInt(fieldValue));
								}
							}
							if (fieldName.equalsIgnoreCase("abnormal_processParameters")) {
								if(!fieldValue.equalsIgnoreCase("")){
								vo.setAbnormal_processParameters(Integer.parseInt(fieldValue));
								}
							}
							if (fieldName.equalsIgnoreCase("rejection_trnd6Month")) {
								if(!fieldValue.equalsIgnoreCase("")){
								vo.setRejection_trnd6Month(Integer.parseInt(fieldValue));
								}
							}
							if (fieldName.equalsIgnoreCase("concentration_chart")) {
								if(!fieldValue.equalsIgnoreCase("")){
								vo.setConcentration_chart(Integer.parseInt(fieldValue));
								}
							}
							if (fieldName.equalsIgnoreCase("measureVariation_studyreq")) {
								if(!fieldValue.equalsIgnoreCase("")){
								vo.setMeasureVariation_studyreq(Integer.parseInt(fieldValue));
								}
							}
							if (fieldName.equalsIgnoreCase("measureCnt")) {
								if(!fieldValue.equalsIgnoreCase("")){
								vo.setMeasureCnt(Integer.parseInt(fieldValue));
								}
							}
							
							if (fieldName.equalsIgnoreCase("measurePID")) {
								if(!fieldValue.equalsIgnoreCase("")){
								vo.setProblem_id(Integer.parseInt(fieldValue));
								}
							}
							
							if (fieldName.equalsIgnoreCase("measurePhaseID")) {
								if(!fieldValue.equalsIgnoreCase("")){
								vo.setPhaseID(Integer.parseInt(fieldValue));
								}
							} 
							if (fieldName.equalsIgnoreCase("scientific_reason")) {
								vo.setScientific_reason(fieldValue); 
							} 
							if (fieldName.equalsIgnoreCase("problem_lastManProcess")) {
								vo.setProblem_lastManProcess(fieldValue); 
							} 
							if (fieldName.equalsIgnoreCase("problem_processStages")) {
								vo.setProblem_processStages(fieldValue); 
							} 
							if (fieldName.equalsIgnoreCase("specification")) {
								vo.setSpecification(fieldValue); 
							}
							
							if (fieldName.equalsIgnoreCase("measureVar_studyreq_filename_flag")) {
								vo.setMeasureVar_studyreq_filename_flag(fieldValue); 
							}
							if (fieldName.equalsIgnoreCase("concentration_chart_filename_flag")) {
								vo.setConcentration_chart_filename_flag(fieldValue); 
							}
							if (fieldName.equalsIgnoreCase("rejection_trnd6Month_fileName_flag")) {
								vo.setRejection_trnd6Month_fileName_flag(fieldValue); 
							}
							if (fieldName.equalsIgnoreCase("abnormal_processPara_filename_flag")) {
								vo.setAbnormal_processPara_filename_flag(fieldValue); 
							}
							if (fieldName.equalsIgnoreCase("abnormal_eqCond_fileName_flag")) {
								vo.setAbnormal_eqCond_fileName_flag(fieldValue); 
							}
							if (fieldName.equalsIgnoreCase("editMeasure")) {
								vo.setEditMeasure(Integer.valueOf(fieldValue)); 
							}   
							if (fieldName.equalsIgnoreCase("measureID")) {
								vo.setMeasureID(Integer.valueOf(fieldValue)); 
							}
							
						} else {
							// *************************************************************************************************************
							// IF FILE inputs === >
							// *************************************************************************************************************
							String file_stored = null;
							fileItem = fileItemTemp;
							fieldName = fileItem.getFieldName();
							fieldValue = fileItem.getString();
							
							if (fieldName.equalsIgnoreCase("abnormal_eqCond_fileName")) {
								file_stored = fileItem.getName(); 
								vo.setAbnormal_eqCond_fileName(FilenameUtils.getName(file_stored)); 
								file_Input = new DataInputStream(fileItem.getInputStream()); 
								vo.setAbnormal_eqCond_attach(file_Input); 
							}
							if (fieldName.equalsIgnoreCase("abnormal_processPara_filename")) {
								file_stored = fileItem.getName(); 
								vo.setAbnormal_processPara_filename(FilenameUtils.getName(file_stored)); 
								file_Input = new DataInputStream(fileItem.getInputStream()); 
								vo.setAbnormal_processPara_attach(file_Input); 
							}
							if (fieldName.equalsIgnoreCase("rejection_trnd6Month_fileName")) {
								file_stored = fileItem.getName(); 
								vo.setRejection_trnd6Month_fileName(FilenameUtils.getName(file_stored)); 
								file_Input = new DataInputStream(fileItem.getInputStream()); 
								vo.setRejection_trnd6Month_attach(file_Input); 
							}
							if (fieldName.equalsIgnoreCase("concentration_chart_filename")) {
								file_stored = fileItem.getName(); 
								vo.setConcentration_chart_filename(FilenameUtils.getName(file_stored)); 
								file_Input = new DataInputStream(fileItem.getInputStream()); 
								vo.setConcentration_chart_attach(file_Input); 
							}
							if (fieldName.equalsIgnoreCase("measureVar_studyreq_filename")) {
								file_stored = fileItem.getName(); 
								vo.setMeasureVar_studyreq_filename(FilenameUtils.getName(file_stored)); 
								file_Input = new DataInputStream(fileItem.getInputStream()); 
								vo.setMeasureVar_studyreq_attach(file_Input); 
							}
						}
					}
				dao.measureDetails(session,vo,response); 
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
