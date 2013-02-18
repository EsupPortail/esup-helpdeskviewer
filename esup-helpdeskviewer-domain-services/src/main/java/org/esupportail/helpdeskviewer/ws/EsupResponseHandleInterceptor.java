package org.esupportail.helpdeskviewer.ws;

import java.io.ByteArrayInputStream;
import java.io.InputStream;

import org.apache.cxf.helpers.IOUtils;
import org.apache.cxf.interceptor.Fault;
import org.apache.cxf.io.CachedOutputStream;
import org.apache.cxf.message.Message;
import org.apache.cxf.phase.AbstractPhaseInterceptor;
import org.apache.cxf.phase.Phase;
import org.esupportail.commons.services.logging.Logger;
import org.esupportail.commons.services.logging.LoggerImpl;


public class EsupResponseHandleInterceptor extends AbstractPhaseInterceptor<Message> {

	private final Logger log = new LoggerImpl(this.getClass());
	
	public EsupResponseHandleInterceptor() {
		super(Phase.RECEIVE);
	}

	@Override
	public void handleMessage(Message message) throws Fault {
		InputStream is = message.getContent(InputStream.class);

		if (is == null) {
			return;
		}

		CachedOutputStream bos = new CachedOutputStream();
		try {
			IOUtils.copy(is, bos);
			is.close();
			bos.flush();

			String input = new String(bos.getBytes());
			bos.close();

			// fix the XML.
			log.debug("Fix the XML : input.replaceAll(\"\\p{Cntrl}\", \" \")");	
			input = input.replaceAll("\\p{Cntrl}", " ");

			InputStream backup = new ByteArrayInputStream((input).getBytes());
			message.setContent(InputStream.class, backup);
		} catch(Exception e) {
			throw new RuntimeException(e);
		}
	}

}


