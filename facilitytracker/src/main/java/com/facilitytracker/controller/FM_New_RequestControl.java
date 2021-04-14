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

import com.facilitytracker.dao.Facility_DAO;
import com.facilitytracker.vo.Facility_VO;
 
 
@WebServlet("/FM_New_RequestControl")
public class FM_New_RequestControl extends HttpServlet {
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
							if (fieldName.equalsIgnoreCase("company")) {
								vo.setCompany(Integer.parseInt(fieldValue)); 
							}
							if (fieldName.equalsIgnoreCase("facility_for")) {
								vo.setFacility_for(Integer.parseInt(fieldValue)); 
							}
							if (fieldName.equalsIgnoreCase("issue")) {
								vo.setIssue(fieldValue); 
							}
							if (fieldName.equalsIgnoreCase("priority")) {
								vo.setPriority(Integer.parseInt(fieldValue)); 
							}
							if (fieldName.equalsIgnoreCase("resp_dept")) {
								vo.setResp_dept(Integer.parseInt(fieldValue)); 
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
							}
							if (fieldName.equalsIgnoreCase("file_doc")) {
								file_stored = fileItem.getName(); 
								vo.setFile_docName(FilenameUtils.getName(file_stored)); 
								file_Input = new DataInputStream(fileItem.getInputStream());  
								vo.setFile_doc(file_Input); 
							}
						}  
					} 
					dao.facility_Upload(session,vo,response);
				
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
