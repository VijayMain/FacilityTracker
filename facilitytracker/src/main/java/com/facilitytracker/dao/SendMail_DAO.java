package com.facilitytracker.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.Date;
import java.util.Properties;

import javax.mail.BodyPart;
import javax.mail.Message;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeBodyPart;
import javax.mail.internet.MimeMessage;

import com.facilitytracker.connectionUtil.Connection_Util;

public class SendMail_DAO {

	public boolean senMail(ArrayList emailList, String subject, StringBuilder sb) {
		boolean flag=false;
		try {
			Connection con = Connection_Util.getConnectionMaster();
			String host="",user="",pass="",from="",smtpPort="";
			
			String[] recipients = new String[emailList.size()];
			for (int e = 0; e < emailList.size(); e++) {
				recipients[e] = emailList.get(e).toString();
			}
			
			String query = "select * from domain_config where enable=1";
			PreparedStatement ps_check = con.prepareStatement(query);
			ResultSet rs_check = ps_check.executeQuery();
			while (rs_check.next()) {
				host = rs_check.getString("hostName");
				user = rs_check.getString("userName");
				pass = rs_check.getString("pass");
				from = rs_check.getString("mailFrom");
				smtpPort = rs_check.getString("smtpPort");
			}
 
			boolean sessionDebug = false;

			Properties props = System.getProperties();
			props.put("mail.host", host);
			props.put("mail.transport.protocol", "smtp");
			props.put("mail.smtp.auth", "true");
			props.put("mail.smtp.port", smtpPort);

			Session mailSession = Session.getDefaultInstance(props, null);
			mailSession.setDebug(sessionDebug);
			Message msg = new MimeMessage(mailSession);
			msg.setFrom(new InternetAddress(from));
			InternetAddress[] addressTo = new InternetAddress[recipients.length];

			for (int p = 0; p < recipients.length; p++) {
				addressTo[p] = new InternetAddress(recipients[p]);
			}

			msg.setRecipients(Message.RecipientType.TO, addressTo);

			msg.setSubject(subject);
			msg.setSentDate(new Date());

			

			BodyPart messageBodyPart = new MimeBodyPart();
			messageBodyPart.setContent(sb.toString(), "Text/html"); 
			
				msg.setContent(sb.toString(), "text/html");
				Transport transport = mailSession.getTransport("smtp");
				transport.connect(host, user, pass);
				transport.sendMessage(msg, msg.getAllRecipients());
				transport.close();
			flag=true;
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return flag;
	}
}