<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<html>
<head>
    <title>选择 功能</title>
    <!--hplus-->
    <%@ include file="/res/public/hplus.jsp" %>
    <%@ include file="/res/public/easyui_lib.jsp" %>
    <%@ include file="/res/public/angularjs.jsp" %>
    <%@ include file="/res/public/msg.jsp" %>
    <%@ include file="/res/public/common.jsp" %>
    <script type="text/javascript">
        $(document).ready(function () {
            var url = "${root}/manage/module/getOperList?moduleName=" + '${moduleName}' + "&oprValue=" + "${operValue}";
            url = encodeURI(encodeURI(url));
            var moduleNameList = "";
            var oprValue = "";
            var html = '<div class="col-sm-12 form-group">';
            $.ajax({
                url: url,
                type: 'get',
                cache: false,
                success: function (response) {
                    moduleNameList = response.moduleNameList;
                    oprValue = response.oprValueList;
                    for (var i = 0; i < moduleNameList.length; i++) {
                        var temp = moduleNameList[i];
                        var selected = "";
                        var opr = $("#opr").val();
                        if(opr.indexOf(";" + temp.oprid + ";") >= 0){
                            selected = "checked='checked'";
                        }
                        html += '<div class="col-sm-3 form-group"><input type="checkbox" name="moduleID" class="newTd" value="' + temp.oprid + '"' + selected + '>' + temp.oprname + '</div>';
                    }
                    html += '</div>';
                    html += '<div class="col-sm-12 form-group"><a class="btn btn-success btn-sm" href="javascript:selectAll();"><i class="fa fa-plus"></i>&nbsp;&nbsp;全选</a>&nbsp;&nbsp;';
                    html += '<a class="btn btn-success btn-sm" href="javascript:selectNone();"><i class="fa fa-plus"></i>&nbsp;&nbsp;不选</a>&nbsp;&nbsp;</div></div>';
                    $("#oprList").html(html);
                }
            });
        });

        function selectAll() {
            $(".newTd").attr('checked', 'checked');
        }

        function selectNone() {
            $(".newTd").removeAttr('checked');
        }

        function changeValue() {
            var chkArr = document.getElementsByName("moduleID");
            var param = "";
            for (var i = 0; i < chkArr.length; i++) {
                if (chkArr[i].checked) {
                    param += chkArr[i].value + ";";
                }
            }
            var url = "${root}/manage/module/calcuteOperValue?opr=" + param;
            $.ajax({
                url: url,
                type: 'post',
                cache: false,
                async: false,
                success: function (response) {
                    var result = "" + response.selectOprValue;
                    parent.setSelectOperValue($("#_id").val(), result);
                    f_close("selectOper");
                }
            });
        }
        function closewin() {
            f_close("selectOper");
        }
    </script>
</head>
<body>
<form method="post" name="myform">
    <input type="hidden" id="opr" value="${opr}">
    <input type="hidden" id="operValue" value="${operValue}">
    <input type="hidden" id="_id" value="${id}">
    <div class="box_01  box_01_840">
        <div class="inner6px">
            <div class="cell">
                <table>
                    <tr>
                        <td id="oprList">
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </div>
</form>
<!-- 隐藏div防止底部按钮区域覆盖表单区域 -->
<div style="margin-bottom:50px;"></div>
<div class="main_btnarea">
    <div class="btn_area_setc btn_area_bg" id="operator">
        <a class='btn btn-primary btn-sm' href='javascript:changeValue();'><i class='fa fa-check'></i>&nbsp;&nbsp;保存</a>&nbsp;&nbsp;
        <a class='btn btn-danger btn-sm' href='javascript:closewin();'><i class='fa fa-remove'></i>&nbsp;&nbsp;关闭</a>&nbsp;&nbsp;
    </div>
</div>
</body>
</html>
