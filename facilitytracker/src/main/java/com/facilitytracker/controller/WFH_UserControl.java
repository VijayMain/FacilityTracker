package com.facilitytracker.controller;

import java.io.DataInputStream;
import java.io.IOException;
import java.io.InputStream;
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

import com.facilitytracker.dao.StockTaking_DAO;
import com.facilitytracker.dao.WFH_DAO;
import com.facilitytracker.vo.StockTaking_VO;
import com.facilitytracker.vo.WFH_VO;

@WebServlet("/WFH_UserControl")
public class WFH_UserControl extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		try {
			InputStream file_Input = null;
			boolean flag = false;
			HttpSession session = request.getSession();
			// ********************************************************************************************************
			WFH_VO bean = new WFH_VO();
			WFH_DAO dao = new WFH_DAO();
			/**********************************************************************************************************
			 * For MultipartContent Separate FILE Fields and FORM Fields
			 **********************************************************************************************************/
			if (ServletFileUpload.isMultipartContent(request)) {
				String fieldName, fieldValue = "";
				ServletFileUpload servletFileUpload = new ServletFileUpload(
						new DiskFileItemFactory());
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
						if (fieldName.equalsIgnoreCase("sapCode")) {
							bean.setSapCode(fieldValue);
						} 
						if (fieldName.equalsIgnoreCase("email")) {
							bean.setEmail(fieldValue);
						}  
						if (fieldName.equalsIgnoreCase("contact")) {
							bean.setContact(fieldValue);
						} 
						if (fieldName.equalsIgnoreCase("tot_part")) {
							bean.setTot_part(fieldValue);
						}
					} else {
						// *************************************************************************************************************
						// IF FILE inputs === >
						// *************************************************************************************************************
						String file_stored = null;
						fileItem = fileItemTemp;
						fieldName = fileItem.getFieldName();
						fieldValue = fileItem.getString(); 
						
						file_stored = fileItem.getName();
						bean.setFileName(FilenameUtils.getName(file_stored)); 
						file_Input = new DataInputStream(fileItem.getInputStream()); 
					}
					bean.setFile_blob(file_Input);
				} 
					dao.attach_File(response, bean, session); 
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
