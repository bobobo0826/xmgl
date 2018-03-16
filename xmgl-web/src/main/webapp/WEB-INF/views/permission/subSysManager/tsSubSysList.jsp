<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<html>
<head>
    <title>子系统管理</title>
    <%@ include file="/res/public/hplus.jsp"%>
    <%@include file="/res/public/easyui_lib.jsp" %><%@ include file="/res/public/hplus.jsp"%>
    <%@ include file="/res/public/easyui_lib.jsp"%>
    <%@ include file="/res/public/common.jsp"%>
    <%@ include file="/res/public/angularjs.jsp"%>
    <%@ include file="/res/public/msg.jsp"%>
    <jsp:include page="/res/public/float_div.jsp"></jsp:include>
    <link href="${root}/res/ui/css/style.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="${root}/res/public/js/common.js"  charset="UTF-8"></script>
    <script type="text/javascript">
        /*****初始化列表*******/
        $(document).ready(function(){
            var html="";
            html+="<a class='btn btn-primary btn-sm' href='javascript:doQuery();'><i class='fa fa-search'></i>&nbsp;&nbsp;查询</a>&nbsp;&nbsp;";
            html+="<a class='btn btn-warning btn-sm' href='javascript:doClear();'><i class='fa fa-refresh'></i>&nbsp;&nbsp;清空</a>&nbsp;&nbsp;";
            html+="<a class='btn btn-success btn-sm' href='javascript:addInfo();' id='dc'><i class='fa fa-plus'></i>&nbsp;&nbsp;新增</a>&nbsp;&nbsp;";
            $("#operator").html(html);

            $("#tt").datagrid({
                url:getUrl(),
                sortable:true,
                singleSelect:true,
                remoteSort:false,
                pagination:true,
                height:'auto',
                width:'auto',
                columns:[[
                    {field:"action",title:"操作", resizable:true,width:90,align:"center",formatter:editf},
                    {field:"subsysid",title:"子系统ID",resizable:true,width:150,headalign:"center",sortable:true
                    },
                    {field:"subsysname",title:"子系统名称",resizable:true,width:300,headalign:"center",sortable:true
                    },
                    {field:"ssdesc",title:"描述",resizable:true,width:300,headalign:"center",sortable:true
                    }
                ]],
                onDblClickRow: function(index,row){
                    editInfo(index);
                }
            });
            $('#tt').datagrid('getPager').pagination({
                pageList:[20,40,60],
                afterPageText:'页  共{pages}页',
                displayMsg:'当前显示第{from}~{to}条记录，共{total}条记录',
                onSelectPage:function(pageNumber, pageSize){
                    var pagination= $('#tt').datagrid('getData').pagination;
                    var param=new Object();
                    param.cpage = pageNumber;
                    param.len = pageSize;
                    $('#tt').datagrid('options').queryParams=param;
                    $('#tt').datagrid('options').url=getUrl();
                    $('#tt').datagrid('reload');
                    $('#tt').datagrid('options').queryParams=null;
                }
            });
        });

        $(document).keyup(function(event) {
            if (event.keyCode == 13) {
                doQuery();
            }
        });

        //动态加载操作栏下面的按钮
        function editf(value,row,index){
            var e = '[<a href="###" style="text-decoration:none;color:red;" onclick="editInfo('+index+')">修改</a>]';
            var c = '[<a href="###" style="text-decoration:none;color:red;" onclick="delInfo('+index+')">删除</a>]';
            var total=e+" "+c;
            return total ;
        }

        function editInfo(index){
            var rows=$('#tt').datagrid('getData').rows;
            var subSysId = rows[index].subsysid;
            var width = $(document).width() * 0.6;
            var height = $(document).height() * 0.6;

            var url ="${root}/manage/tsSubSys/tsSubSysInfoIndex?subSysId="+subSysId;
            parent.addTab("子系统管理修改", url);
            //f_open("newWindows", "子系统管理", width, height, url, true);
        }

        function addInfo(){
            var width = $(document).width() * 0.6;
            var height = $(document).height() * 0.6;
            var url ="${root}/manage/tsSubSys/tsSubSysInfoIndex?subSysId=0";
            parent.addTab("子系统管理新增", url);
            //f_open("newWindows", "子系统管理", width, height, url, true);//小窗口
        }

        function delInfo(index){
            var rows=$('#tt').datagrid('getData').rows;
            var subSysId = rows[index].subsysid;

            layer.confirm('确定删除吗?', {
                btn: ['确定','取消'], //按钮
                shade: false //不显示遮罩
            }, function(index){
                var url = '${root}/manage/tsSubSys/delSubSysInfo?subSysId='+subSysId;
                $.ajax({
                    url: url,
                    type : 'post',
                    cache : false,
                    async : false,
                    success:function(data){
                        if(data.msgCode==1)
                        {
                            $('#tt').datagrid('load');
                        }
                        layer.msg(data.msgDesc);
                    }
                });
            }, function(index){
                layer.close(index);
            });
        }
        function doQuery()
        {
            var url=getUrl();
            $('#tt').datagrid('options').url = url;
            $('#tt').datagrid('load');
        }

        function getUrl()
        {
            var url = "${root}/manage/tsSubSys/tsSubSysQueryList?subSysId="+$('#subSysId').val()
                +"&subSysName="+$('#subSysName').val();
            url=encodeURI(encodeURI(url));
            return url;
        }
    </script>
</head>
<body>
<div class="row">
    <div class="col-sm-12">
        <div class="ibox float-e-margins">
            <div class="ibox-content" id="searchArea" >
                <form method="get" class="form-horizontal">
                    <div class="col-sm-4">
                        <div class="form-group">
                            <label class="col-sm-4 control-label">子系统ID:</label>
                            <div class="col-sm-6">
                                <input type="text" class="form-control" id="subSysId"
                                       name="subSysId">
                            </div>
                        </div>
                    </div>
                    <div class="col-sm-4">
                        <div class="form-group">
                            <label class="col-sm-4 control-label">子系统名称:</label>
                            <div class="col-sm-6">
                                <input type="text" class="form-control" id="subSysName"
                                       name="subSysName">
                            </div>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>
<div align="center" id="operator"></div>
<div id="tt"></div>
</body>
</html>



