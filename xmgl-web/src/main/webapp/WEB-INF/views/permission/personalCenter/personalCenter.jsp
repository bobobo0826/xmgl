<%--
  Created by IntelliJ IDEA.
  User: wangchao
  Date: 2017-08-14
  Time: 16:09 下午
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>个人中心</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
    <!--hplus-->
    <%@ include file="/res/public/hplus.jsp" %>
    <%@ include file="/res/public/easyui_lib.jsp" %>
    <%@ include file="/res/public/angularjs.jsp" %>
    <%@ include file="/res/public/msg.jsp" %>
    <%@ include file="/res/public/common.jsp" %>
    <%--<%@ include file="/res/public/loginStyle.jsp"%>--%>
    <script type="text/javascript">
        $(document).ready(function () {
            var displayPage = $("#displayPage").val();
            if (displayPage != null && displayPage === "pwd") {
                $("#myInfo").attr("class", "");
                $("#pwd").attr("class", "active");
                $("#loginInfo").attr("class", "");
                init("pwd");
            } else if(displayPage != null && displayPage === "loginInfo"){
                $("#myInfo").attr("class", "");
                $("#pwd").attr("class", "");
                $("#loginInfo").attr("class", "active");
                init("loginInfo");
            }
            else {
                init("myInfo");
            }
        });
        function init(type) {
            var frame = document.getElementById('displayContent');
            if (type === "myInfo") {
                frame.src = "${root}/manage/employee/initMyEmployeeInfo?_curModuleCode=GRZX";
            } else if (type === "pwd") {
                frame.src = "${root}/manage/user/updatePasswordIndex";
            } else if (type === "loginInfo") {
                frame.src = "${root}/manage/loginRecord/initLoginRecord";
            } else if(type === "visitRecord")
                frame.src = "${root}/manage/permission/initVisitRecordsList";
        }
        function closeCurTab() {
            parent.closeCurTab();
        }

    </script>
</head>
<body>
<input type="hidden" id="displayPage" value="${displayPage}"/>
<div class="page-content">
    <div class="row">
        <div class="col-md-12">
            <div class="panel">
                <div class="panel-heading">
                    <div class="panel-options">
                        <ul class="nav nav-tabs" role="tablist">
                            <li class="active" role="presentation" id="myInfo" novalidate="novalidate">
                                <a href="#" onclick="init('myInfo')" aria-expanded="true" data-toggle="tab">
                                    <i class="icon fa-file-text-o" aria-hidden="true"></i> 我的个人信息
                                </a>
                            </li>
                            <li class="" role="presentation" id="pwd">
                                <a href="#" onclick="init('pwd')" aria-expanded="false" data-toggle="tab">
                                    <i class="icon fa-key" aria-hidden="true"></i> 修改密码
                                </a>
                            </li>
                            <li class="" role="presentation" id="loginInfo">
                                <a href="#" onclick="init('loginInfo')" aria-expanded="false" data-toggle="tab">
                                    <i class="icon fa-key" aria-hidden="true"></i> 登录日志
                                </a>
                            </li>
                            <li class="" role="presentation" id="visitRecord">
                                <a href="#" onclick="init('visitRecord')" aria-expanded="false" data-toggle="tab">
                                    <i class="icon fa-key" aria-hidden="true"></i> 访问记录
                                </a>
                            </li>
                        </ul>
                    </div>
                </div>
                <div class="panel-body">
                    <div class="tab-content margin-top-15">
                        <div class="animation-slide-left tab-message active" id="accountContent">
                            <IFRAME ID="displayContent" Name="displayContent" FRAMEBORDER=0 SCROLLING=AUTO
                                    width=100% height=100% SRC=""></IFRAME>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
</div>
</body>

</html>
