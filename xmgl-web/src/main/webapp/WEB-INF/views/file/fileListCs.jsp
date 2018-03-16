<%--
  Created by IntelliJ IDEA.
  User: quangao
  Date: 2017/8/29
  Time: 9:42
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
    <!--hplus-->
    <%@ include file="/res/public/hplus.jsp"%>
    <%@ include file="/res/public/easyui_lib.jsp"%>
    <%@ include file="/res/public/common.jsp"%>
    <script type="application/javascript">
        $(document).ready(function(){
            $.ajax({
                type:'post',
                cache:false,
                async:true,
                url:"http://localhost:8030/api/bugs/getMsg",
                success:function (data) {
                    alert('=================='+data);
                }

            });
        })

    </script>
</head>
<body>

</body>
</html>
