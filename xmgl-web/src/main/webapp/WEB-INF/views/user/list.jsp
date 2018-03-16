<%--
  Created by IntelliJ IDEA.
  User: qince
  Date: 2015/7/3
  Time: 16:56
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/common/taglibs.jsp" %>
<html>
<head>
    <title>用户列表</title>
    <link rel="stylesheet" href="${root}/resources/js/jquery-loadmask-0.4/jquery.loadmask.css">
</head>
<body>
<form>
<table>
    <tr>
        <td>用户</td>
        <td>生日</td>
        <td>操作</td>
    </tr>
    <c:forEach items="${users}" var="item">
        <tr>
            <td>${item.name}</td>
            <td><fmt:formatDate value="${item.birthday}" pattern="yyyy-MM-dd"/></td>
            <td><a href="javascript:void(0);" class="view-user">查看</a><input type="hidden" name="id" value="${item.id}"/> </td>
        </tr>
    </c:forEach>
</table>
</form>

<script src="${root}/resources/js/jquery-1.10.2.min.js"></script>
<script src="${root}/resources/js/jquery-loadmask-0.4/jquery.loadmask.min.js"></script>
<script>
    $(function(){
        $('tr td a.view-user').click(function(){
            var id=$(this).next().val();
            $.ajax({
                url:'${root}/manage/user/view/' + id,
                type:"post",
                dataType:"json",
                data:{time:new Date()},
                contentType:'application/x-www-form-urlencoded;charset=utf-8',
                beforeSend:function(){
                    $('table').mask("Waiting...");
                },
                complete:function(){
                    $('table').unmask();
                },
                success:function(data){
                    alert("用户：" + data.name);
                },
                error:function() {
                    alert('查询出错');
                }
            });

        });
    });
</script>
</body>
</html>
