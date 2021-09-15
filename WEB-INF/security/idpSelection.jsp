<%@ page import="org.springframework.security.saml.metadata.MetadataManager" %>
<%@ page import="org.springframework.web.context.WebApplicationContext" %>
<%@ page import="org.springframework.web.context.support.WebApplicationContextUtils" %>
<%@ page import="java.util.Set" %>
<%@ page import="java.util.Iterator" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<body>
                        <%
                            WebApplicationContext context = WebApplicationContextUtils.getWebApplicationContext(getServletConfig().getServletContext());
                            MetadataManager mm = context.getBean("metadata", MetadataManager.class);
                            Iterator<String> idps = mm.getIDPEntityNames().iterator();
                            while(idps.hasNext()){
                                pageContext.setAttribute("idp", idps.next());   
                            }
                        %>                      
                       <c:redirect url="${requestScope.idpDiscoReturnURL}&${requestScope.idpDiscoReturnParam}=${idp}"/>
                        <%-- <% response.sendRedirect("http://localhost:8080/SWMApiService/saml/login?disco=true&idp=localhost"); %> --%>
</body>
</html>