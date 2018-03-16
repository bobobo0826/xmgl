<%--
  Created by IntelliJ IDEA.
  User: quangao
  Date: 2017/6/12
  Time: 15:38
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
    <%@ include file="/res/public/hplus.jsp" %>
    <%@ include file="/res/public/easyui_lib.jsp" %>
    <%@ include file="/res/public/common.jsp" %>
    <script type="text/javascript"
            src="${pageContext.request.contextPath}/res/public/js/easyui-1.3.2/plugins/datagrid-detailview.js"
            charset="UTF-8"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            init()
        });

        function init() {
            var str = $("#detailInfo").val();
            var arrStr = str.split(";");
            var tableStr = new Array();
            for (var i = 0; i < arrStr.length; i++) {
                if (arrStr[i] != "") {
                    tableStr.push("<tr><td align=\"left\">" + arrStr[i] + "</td></tr>");
                }
            }
            document.getElementById("logTable").innerHTML = tableStr.join("");
        }

        function doClose() {
            f_close("LogInfoWindow");
        }
    </script>
</head>

<body>
<input type="hidden" id="detailInfo" value="${detailInfo}"/>
<form>

    <div class="ibox-title"><label>详细信息</label></div>
    <div class="ibox-content">
        <table class="table table-bordered table-striped" id="logTable">
        </table>
    </div>
</form>
<div class="main_btnarea">
    <div class="btn_area_setc btn_area_bg" id="operator">
        <a class='btn btn-danger btn-sm' href='javascript:doClose();'><i class='fa fa-remove'></i>&nbsp;&nbsp;关闭</a>&nbsp;&nbsp;
    </div>
</div>


</body>
</html>
