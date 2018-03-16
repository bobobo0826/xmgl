 <%--
  Created by IntelliJ IDEA.
  User: qince
  Date: 2015/7/3
  Time: 16:56
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ include file="/common/taglibs.jsp" %>
<html>
<head>
    <title>添加用户</title>
    <link rel="stylesheet" href="${root}/resources/js/jquery-loadmask-0.4/jquery.loadmask.css">
</head>
<body>
<form action="${root}/manage/user/saveUser" method="post">
<table>
    <tr>
        <td>姓名：</td>
        <td><input type="text" name="name"/></td>
    </tr>
    <tr>
        <td>生日：</td>
        <td><input type="text" name="birthday" onclick="WdatePicker()"/></td>
    </tr>
    <tr>
        <td><input type="button" value="保存" id="saveBtn"></td>
    </tr>
</table>
</form>

<script src="${root}/resources/js/jquery-1.10.2.min.js"></script>
<script src="${root}/resources/js/jquery-loadmask-0.4/jquery.loadmask.min.js"></script>
<script src="${root}/resources/js/jquery-html5Validate.js"></script>
<script src="${root}/resources/js/date/WdatePicker.js"></script>
<script>
    $(function(){
        $('#saveBtn').click(function(){
            // 字段校验
            var name = $('input[name=name]');
            if ($.trim(name.val()).length == 0) {
                name.testRemind("请输入姓名！");
                return;
            }

            $('form')[0].submit();

        });
    });
</script>
</body>
</html>
