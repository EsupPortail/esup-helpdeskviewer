package org.esupportail.helpdeskviewer.web.springmvc;

import javax.annotation.Resource;
import javax.portlet.PortletRequest;
import javax.portlet.WindowState;

import org.springframework.stereotype.Service;

import net.sourceforge.wurfl.core.Device;
import net.sourceforge.wurfl.core.WURFLManager;

@Service
public class ViewSelectorDefault {
	
	private final String HELPDESKVIEWER_WIDE_VIEW = "helpdeskviewerWideView";
	private final String HELPDESKVIEWER_NARROW_VIEW = "helpdeskviewerNarrowView";
	private final String HELPDESKVIEWER_MOBILE_VIEW = "helpdeskviewerMobileView";
	
	
	@Resource
	protected WURFLManager wurflManager;


	/*
	 * (non-Javadoc)
	 * @see org.esupportail.portlet.helpdeskviewer.mvc.IViewSelector#getCalendarViewName(javax.portlet.PortletRequest)
	 */
	public String getHelpdeskviewerViewName(PortletRequest request) {
		
		String userAgent = request.getProperty("user-agent");
		
    	Device device = wurflManager.getDeviceForRequest(userAgent);
    	boolean isWirelessDevice;
    	if (device.getCapability("is_wireless_device").equals("true")) {
			return HELPDESKVIEWER_MOBILE_VIEW;
		}
		
		// otherwise check the portlet window state
		WindowState state = request.getWindowState();
		if (WindowState.MAXIMIZED.equals(state)) {
			return HELPDESKVIEWER_WIDE_VIEW;
		} else {
			return HELPDESKVIEWER_NARROW_VIEW;
		}
		
	}

	/*
	 * (non-Javadoc)
	 * @see oorg.esupportail.portlet.helpdeskviewer.mvc.IViewSelector#getEventListViewName(javax.portlet.PortletRequest)
	 */
	public String getEventListViewName(PortletRequest request) {
		return "ajaxEventList";
	}

}
