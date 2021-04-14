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
import com.facilitytracker.dao.MasterData_DAO;
import com.facilitytracker.vo.StockTaking_VO;

@WebServlet("/BulkUploadMaster_Control")
public class BulkUploadMaster_Control extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		PrintWriter out = response.getWriter();
		try {
			InputStream file_Input = null;
			boolean flag = false;
			HttpSession session = request.getSession();
			// ********************************************************************************************************
			StockTaking_VO bean = new StockTaking_VO();
			MasterData_DAO dao = new MasterData_DAO();
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
						if (fieldName.equalsIgnoreCase("contact")) {
							bean.setContact(fieldValue);
						}
						if (fieldName.equalsIgnoreCase("reason")) {
							bean.setReason(fieldValue.toUpperCase());
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
				if (bean.getFile_blob() != null) {
					dao.attachBulkMaster_File(request, response, bean, session);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
