<%--
  Created by IntelliJ IDEA.
  User: administror
  Date: 2017/8/22 0022
  Time: 16:50
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  <title>请假信息列表</title>
  <!--hplus-->
  <%@ include file="/res/public/hplus.jsp"%>
  <%@ include file="/res/public/easyui_lib.jsp"%>
  <%@ include file="/res/public/common.jsp"%>
  <jsp:include page="/res/public/float_div.jsp" ></jsp:include>
  <jsp:include page="/res/public/datagrid-date.jsp" ></jsp:include>
  <script type="text/javascript" src="${pageContext.request.contextPath}/res/public/js/easyui-1.3.2/plugins/datagrid-detailview.js" charset="UTF-8"></script>

  <script type="text/javascript">
    $(window).resize(function(){ $("#tt").datagrid("resize"); });
    var _funcArray;
    var _queryConfig;
    $(document).ready(function(){

      _funcArray=getFunctions('${pageContext.request.contextPath}',$("#_curModuleCode").val());
      console.log(_funcArray);
      var height=$(window).height()-160; //浏览器当前窗口可视区域高度
      $("body").css("margin-bottom",'0px');
      var html="";
      html+="<a class='btn btn-danger btn-sm' href='javascript:doHideOrShowPrint();' id='hideOrShowBt'><i class='fa fa-arrow-up'></i>&nbsp;&nbsp;显示条件</a>&nbsp;&nbsp;";
      html+="<a class='btn btn-primary btn-sm' href='javascript:doQuery();'><i class='fa fa-search'></i>&nbsp;&nbsp;查询</a>&nbsp;&nbsp;";
      html+="<a class='btn btn-warning btn-sm' href='javascript:doClear();'><i class='fa fa-refresh'></i>&nbsp;&nbsp;清空</a>&nbsp;&nbsp;";
      html+="<a class='btn btn-success btn-sm' href='javascript:addNew();'><i class='fa fa-plus'></i>&nbsp;&nbsp;新增</a>&nbsp;&nbsp;";
      getLeaveAskingStatusDic();

      $("#operator").html(html);
      initLeaveAskingList(height);
    });
    $(document).keyup(function(event) {
      if (event.keyCode == 13) {
        doQuery();
      }
    });
    function initLeaveAskingList(height){
      $(window).resize(function(){ $("#tt").datagrid("resize"); });
      var height=$(window).height()-120; //浏览器当前窗口可视区域高度
      $(document).ready(function(){
        var options = {
          url:getUrl(),
          sortable:true,
          singleSelect:true,
          pagination:true,
          height:height,
          width:'auto',
          striped:true,
          rownumbers:true,
          remoteSort:true,
          remoteFilter:true,
          filterDelay:2000,
          onSortColumn: function (sort, order) {
            datagridSort(sort, order, "tt", getUrl());
          }
        };
        options.columns = [[
          {field : "id",title : "id",hidden : true},
          {field:"creator_id",title:"申请人id",hidden : true},
          {field:"act",title:"操作", resizable:true,headalign:"center",align:"center",formatter:editf},
          {field:"creator",title:"申请人名称", resizable:true,width:100,headalign:"center",align:"center",sortable:true},
          {field:"create_time",title:"申请日期", resizable:true,headalign:"center",align:"center",sortable:true},
          {field:"leave_start_time",title:"请假开始日期", resizable:true,width:100,headalign:"center",align:"center",sortable:true, order:"asc"},
          {field:"leave_end_time",title:"请假结束日期", resizable:true,width:100,headalign:"center",align:"center",sortable:true, order:"asc"},
          {field:"reason",title:"请假原因", resizable:true,width:200,headalign:"center",align:"center",sortable:true},
          {field:"checker_id",title:"审核人id",hidden : true},
          {field:"checker",title:"审核人名称", resizable:true,width:100,headalign:"center",align:"center",sortable:true},
          {field:"check_time",title:"审核时间", resizable:true,width:100,headalign:"center",align:"center",sortable:true},
          {field:"leader_opinion",title:"领导意见", resizable:true,width:200,headalign:"center",align:"center",sortable:true},
          {field:"status",title:"状态", resizable:true,width:100,headalign:"center",align:"center",sortable:true},
          {field:"actual_resump_time",title:"实际销假时间", resizable:true,width:100,headalign:"center",align:"center",sortable:true},
          {field:"resumpution_status",title:"销假状态", resizable:true,width:100,headalign:"center",align:"center",sortable:true},
          {field:"delay_reason",title:"延迟原因", resizable:true,width:200,headalign:"center",align:"center",sortable:true}
        ]];
        $("#tt").datagrid(options);
        $('#tt').datagrid('getPager').pagination({
          pageList : [ 20, 40, 60,80,100,200 ],
          afterPageText:'页  共{pages}页',
          displayMsg:'当前显示第{from}~{to}条记录，共{total}条记录&nbsp;&nbsp;',
          onSelectPage:function(pageNumber, pageSize){
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




    }

    function oprHandle(itemId,rowData,rowIndex) {
      switch (itemId) {
        case "saveGridStyle":
          saveGridStyle("tt","${root}/manage/leaveAsking/saveGridStyle?_curModuleCode="+$("#_curModuleCode").val());
          break;
        case "showColumns":
          var url="${root}/manage/leaveAsking/showGridColumn" ;
          showOrHiddenColumns("tt",url,0);
          break;
        default:
          break;
      }
    }

    /**
     * 查询日志列表
     * @returns {string|*}
     */
    //右击菜单事件处理

    function getUrl() {
      var url;
      url="${root}/manage/leaveAsking/queryLeaveAskingList/"+getQueryCondition();
      url=encodeURI(encodeURI(url));
      return url;
    }
    /**
     * 获取查询条件
     * @returns {string}
     */
    function getQueryCondition(){

      var url="?id="+$('#id').val()
              +"&creator="+$('#creator').val()
              +"&status="+$('#status').val()
              +"&create_time_date_begin="+$('#create_time_date_begin').val()
              +"&create_time_date_end="+$('#create_time_date_end').val()
              +"&check_time_date_begin="+$('#check_time_date_begin').val()
              +"&check_time_date_end="+$('#check_time_date_end').val()
              +"&actual_resump_time_date_begin="+$('#actual_resump_time_date_begin').val()
              +"&actual_resump_time_date_end="+$('#actual_resump_time_date_end').val()

      return url;
    }
    function editf(value,row,index) {

      var e = '';
      e +='[<a href="###" style="text-decoration:none;color:red;" onclick="editInfo('+index+')">详情</a>]';


      //  e += '[<a href="###" style="text-decoration:none;color:red;" onclick="deleteInfo(' + index + ')">删除</a>]';
      for (var j = 0; j < _funcArray.length; j++) {
        var funcObj = _funcArray[j];
        switch (funcObj) {
          case 'delLeaveAsking':
            if ("草稿" === row.status) {
              e += '[<a href="###" style="text-decoration:none;color:red;" onclick="deleteInfo(' + index + ')">删除</a>]';
             }
            break;
          default:
            break;
        }
      }


      return e ;
    }
    /**
     * 进入日志的详情，进行编辑
     * @param index 行的索引
     */
    function editInfo(index){
      var rows=$('#tt').datagrid('getData').rows;
      var id = rows[index].id;
      var url;
      url="${root}/manage/leaveAsking/initLeaveAskingInfo?id="+id+"&_curModuleCode="+"QJSQ";
      parent.addTab("请假信息详情", url)
    }
    function deleteInfo(index){
      var rows=$('#tt').datagrid('getData').rows;
      var id = rows[index].id;
      var url = "${root}/manage/leaveAsking/delLeaveAsking/"+id;
      layer.confirm(_DELETE_ONE_MSG, {
        btn: ['确定','取消'], //按钮
        shade: false //不显示遮罩
      }, function(index){
        $.ajax({
          url: url,
          type : 'post',
          success: function(response) {
            /**
             * 操作成功
             */
            if(response.msgCode==1) {
              $('#tt').datagrid('reload');
            }
            layer.msg(response.msgDesc);
          },
          error:function(result) {
            layer.msg("系统异常，请联系系统管理员");
          }
        });
      }, function(index){
        layer.close(index);
      });
    }
    /**
     * 执行查询
     */
    function doQuery() {
      $('#tt').datagrid('options').url=getUrl();
      $('#tt').datagrid('load');
    }
    /**
     * 新建请假
     */
    function addNew(){
      var url = "${root}/manage/leaveAsking/initLeaveAskingInfo?id=-1&_curModuleCode="+"QJSQ";
      parent.addTab("新增请假", url);
    }
    var leaveAskingStatusList;

    function getLeaveAskingStatusDic(){
      var url = "${root}/manage/leaveAsking/getLeaveAskingDic";
      url=encodeURI(encodeURI(url));
      $.ajax({
        url: url,
        type : 'post',
        async : false,
        success: function(result) {
          addSelectOption(result.leaveAskingStatusList,"status");
        }
      });
    }
  </script>
</head>
<body>
<input type="hidden" id="_curModuleCode" value="${_curModuleCode}"/>
<input type="hidden" id="cur_creator_id" value="${creator_id}"/>
<div class="row">
  <div class="col-sm-12">
    <div class="ibox float-e-margins">
      <div class="ibox-content" id="searchArea" style="display:none">
        <form method="get" class="form-horizontal">

          <div class="col-sm-4">
            <div class="form-group">
              <label class="col-sm-4 control-label">申请人：</label>
              <div class="col-sm-6">
                <div class="input-group col-sm-12">
                  <input type="text" class="form-control"  name="creator" id="creator">
                </div>
              </div>
            </div>
          </div>
          <div class="col-sm-4">
            <div class="form-group">
              <label class="col-sm-4 control-label">状态：</label>
              <div class="col-sm-6">
                <select type="text" class="form-control"
                        id="status" name="status" >
                </select>
              </div>
            </div>
          </div>

          <div class="col-sm-4">
          <div class="form-group">
            <label class="col-sm-4 control-label">申请日期：</label>
            <div class="col-sm-6">
              <div class="col-sm-12 input-group">
                <input  onclick="laydate()" class="form-control"   name="create_time_date_begin" id="create_time_date_begin"/>
                <span class="input-group-addon"></span>
                <input  onclick="laydate()" class="form-control"  name="create_time_date_end" id="create_time_date_end"/>
              </div>
            </div>
          </div>
        </div>
          <div class="col-sm-4">
            <div class="form-group">
              <label class="col-sm-4 control-label">审核时间：</label>
              <div class="col-sm-6">
                <div class="col-sm-12 input-group">
                  <input  onclick="laydate()" class="form-control"   name="check_time_date_begin" id="check_time_date_begin"/>
                  <span class="input-group-addon"></span>
                  <input  onclick="laydate()" class="form-control"  name="check_time_date_end" id="check_time_date_end"/>
                </div>
              </div>
            </div>
          </div>
          <div class="col-sm-4">
            <div class="form-group">
              <label class="col-sm-4 control-label">实际销假时间：</label>
              <div class="col-sm-6">
                <div class="col-sm-12 input-group">
                  <input  onclick="laydate()" class="form-control"   name="actual_resump_time_date_begin"  id="actual_resump_time_date_begin"/>
                  <span class="input-group-addon"></span>
                  <input  onclick="laydate()" class="form-control"  name="actual_resump_time_date_end" id="actual_resump_time_date_end"/>
                </div>
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
<div id="cntMenu" class="easyui-menu" style="width:150px;">
  <div id="saveGridStyle" class ='rightMenu'>保存列表样式</div>
  <div class="menu-sep"></div>
  <div id="showColumns">显示(隐藏)列</div>
  <div class="menu-sep"></div>
  <div id="doClear" href='javascript:doClear();'>清空查询条件</div>
  <div class="menu-sep"></div>
  <div id="nouse"></div>
</div>
</body>
</html>
