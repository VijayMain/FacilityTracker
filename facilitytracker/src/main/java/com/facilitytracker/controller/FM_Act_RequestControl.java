package com.facilitytracker.controller;

import java.io.DataInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
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
import org.apache.poi.hssf.record.formula.functions.Vlookup;

import com.facilitytracker.dao.Facility_DAO;
import com.facilitytracker.vo.Facility_VO;
 
@WebServlet("/FM_Act_RequestControl")
public class FM_Act_RequestControl extends HttpServlet {
	private static final long serialVersionUID = 1L;
 
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		PrintWriter out = response.getWriter();
		try {
			
			InputStream file_Input = null;
			boolean flag = false;
			HttpSession session = request.getSession();
			// ********************************************************************************************************
			Facility_VO vo = new Facility_VO();
			Facility_DAO dao = new Facility_DAO();
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
							if (fieldName.equalsIgnoreCase("solution")) {
								vo.setSolution(fieldValue); 
								//System.out.println("in loop...." + vo.getSolution());
							}
							if (fieldName.equalsIgnoreCase("attended_by")) {
								vo.setAttended_by(Integer.parseInt(fieldValue)); 
								//System.out.println("in loop...." + vo.getAttended_by());
							}
							if (fieldName.equalsIgnoreCase("followup")) {
								vo.setFollowup(Integer.parseInt(fieldValue)); 
								//System.out.println("in loop...." + vo.getFollowup());
							}
							if (fieldName.equalsIgnoreCase("fm_ID")) {
								vo.setFm_ID(Integer.parseInt(fieldValue)); 
								//System.out.println("in loop...." + vo.getFm_ID());
							}
							if (fieldName.equalsIgnoreCase("status_id")) {
								vo.setStatus_id(Integer.parseInt(fieldValue)); 
								//System.out.println("in loop...." + vo.getStatus_id());
							}
						} else {
							// *************************************************************************************************************
							// IF FILE inputs === >
							// *************************************************************************************************************
							String file_stored = null;
							fileItem = fileItemTemp;
							fieldName = fileItem.getFieldName();
							fieldValue = fileItem.getString();
							
							if (fieldName.equalsIgnoreCase("file_image")) {
								file_stored = fileItem.getName(); 
								vo.setFile_imageName(FilenameUtils.getName(file_stored)); 
								file_Input = new DataInputStream(fileItem.getInputStream()); 
								vo.setFile_image(file_Input); 
								//System.out.println("in loop...." + vo.getFile_imageName());
							}
							if (fieldName.equalsIgnoreCase("file_doc")) {
								file_stored = fileItem.getName(); 
								vo.setFile_docName(FilenameUtils.getName(file_stored)); 
								file_Input = new DataInputStream(fileItem.getInputStream());  
								//System.out.println("in loop...." + vo.getFile_docName());
								vo.setFile_doc(file_Input); 
							}
						}
					}
					dao.facility_ActionUpload(session,vo,response);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}