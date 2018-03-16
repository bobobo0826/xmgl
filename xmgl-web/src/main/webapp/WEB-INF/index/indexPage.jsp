<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://"
            + request.getServerName() + ":" + request.getServerPort()
            + path;
%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <title>首页</title>
    <!--hplus-->
    <%@ include file="/res/public/hplus.jsp" %>
    <%@ include file="/res/public/common.jsp" %>

    <script>
        $(function () {
            getIndexPageByRole();
        });

        function getIndexPageByRole() {
            var url = "${pageContext.request.contextPath}/index/getIndexPageByRole.action";
            url = encodeURI(encodeURI(url));
            $.ajax({
                type: 'post',
                cache: false,
                url: url,
                async: false,
                success: function (result) {
                    if (result) {
                        indexUrl = "<%=basePath%>" + result;
                        window.location.href = indexUrl;
                    }
                }
            });
        }
    </script>
</head>
<body class="gray-bg">

</body>

</html>
