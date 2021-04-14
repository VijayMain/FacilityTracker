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

import com.facilitytracker.dao.WFH_DAO;
import com.facilitytracker.vo.WFH_VO;
 

@WebServlet("/DWMFileUpload_Control")
public class DWMFileUpload_Control extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		try { 
			InputStream file_Input = null;
			String status="";
			boolean flag = false,file_avail=false,file_error=false;
			HttpSession session = request.getSession();
			// ********************************************************************************************************
			WFH_DAO dao = new WFH_DAO();
			WFH_VO bean = new WFH_VO();
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
						if (fieldName.equalsIgnoreCase("task_approver")) {
							bean.setTaskApprover(Integer.valueOf(fieldValue)); 
						}
					} else {
						// *************************************************************************************************************
						// IF FILE inputs === >
						// *************************************************************************************************************
						String file_stored = null;
						fileItem = fileItemTemp;
						fieldName = fileItem.getFieldName();
						fieldValue = fileItem.getString(); 
						 
							// *************************************************************************************************************
							// if multiple files then there names are
							// inputName1,inputName2,inputName3,.......
							// *************************************************************************************************************
							if (fieldName.equalsIgnoreCase("file_doc")) {
								file_stored = fileItem.getName(); 
								bean.setFileName(FilenameUtils.getName(file_stored));
							if(!bean.getFileName().substring(bean.getFileName().length()-4).equalsIgnoreCase(".xls")){
								file_error=true;
							response.sendRedirect("WFH_BulkUpload.jsp?statusNop=File Error...");
							}
								file_Input = new DataInputStream(fileItem.getInputStream());
								bean.setFile_blob(file_Input); 
							}
					}
				}
				if(file_error==false){
				dao.bulk_UploadDWM(bean,response,session);  
				}
			}
			 
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
