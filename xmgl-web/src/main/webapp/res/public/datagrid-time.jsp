<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>添加时间</title>
    <style>
        .black_overlay{
            display: none;
            position: absolute;
            top: 0%;
            left: 0%;
            width: 100%;
            height: 100%;
            
            z-index:1001;
            -moz-opacity: 0.8;
            opacity:.80;
            filter: alpha(opacity=80);
        }
        .white_content {
            display: none;
            position: absolute;
            top: 10%;
            left: 50%;
            width: 30%;
            height: 25%;
            border-bottom: 1px solid #ccc;
            border-right: 1px solid #ccc;
            border-left: 1px solid #ccc;
            background-color: white;
            z-index:1002;
            overflow: auto;
        }
        .white_content_small {
            display: none;
            position: absolute;
            top: 20%;
            left: 30%;
            width: 40%;
            height: 50%;
            border: 16px solid lightblue;
            background-color: white;
            z-index:1002;
            overflow: auto;
        }
        .MyTmieDiv {
            position: absolute;
        }
        
    </style>
    <script type="text/javascript">
        //å¼¹åºéèå±
        function ShowTimeDiv(show_div,bg_div,fileName){
            $("#fileName").val(fileName);
            document.getElementById(show_div).style.display='block';
            document.getElementById(bg_div).style.display='block' ;
            var bgdiv = document.getElementById(bg_div);
            bgdiv.style.width = document.body.scrollWidth;
// bgdiv.style.height = $(document).height();
            $("#"+bg_div).height($(document).height());

        };
        //å³é­å¼¹åºå±
        function CloseDiv(show_div,bg_div)
        {
            document.getElementById(show_div).style.display='none';
            document.getElementById(bg_div).style.display='none';
        };
        $(document).ready(
                function () {
                    $('#banner').mousedown(
                            function (event) {
                                var isMove = true;
                                var abs_x = event.pageX - $('#banner').offset().left;
                                var abs_y = event.pageY - $('#banner').offset().top;
                                $(document).mousemove(function (event) {
                                            if (isMove) {
                                                var obj = $('#MyTimeDiv');
                                                obj.css({'left':event.pageX - abs_x, 'top':event.pageY - abs_y});
                                            }
                                        }
                                ).mouseup(
                                        function () {
                                            isMove = false;
                                        }
                                );
                            }
                    );
                }
        );
        function doTimeQuery(){
            var fileName=$("#fileName").val();
            var fromTime=$("#fromTime").val();
            var toTime=$("#toTime").val();
            var time=fromTime+"~"+toTime;

             $('#tt').datagrid('addFilterRule', {
                field: fileName,
                op: 'contains',
                value: time
            });
             $('#tt').datagrid('doFilter');

            if(!(fromTime==""&&toTime=="")){
                $("input[name='"+fileName+"']").val(time);
            }
            CloseDiv('MyTimeDiv','fade')
        }
    </script>
</head>
<body>
<input type="hidden" id="fileName" />
<div id="fade" class="black_overlay">
</div>

<div id="MyTimeDiv" class="white_content" style="top:200px;left:450px">
    <!-- <div style="text-align: right; cursor: default; height: 20px;">
    </div> -->
    <div id='banner' style="text-align: right; cursor: default; height: 20px;background-color:#ccc">
</div>
<div  style="text-align: right; cursor: default; height: 20px;">
</div>
    <div class="col-sm-12">
    <div class="form-group">
        <!-- <label class="col-sm-2 control-label">时间从:</label> -->
        <div  class="clockpicker" data-autoclose="true">
        <div class="col-sm-6">
            <input type="text" class=" form-control"
                id="fromTime" name="fromCreateTime"  />
        </div>
        </div>
        <!-- <label class="col-sm-2 control-label">时间到:</label> -->
        <div  class="clockpicker" data-autoclose="true">
        <div class="col-sm-6">
            <input type="text" class="form-control"
                id="toTime" name="toCreateTime"  />
        </div>
        </div>
    </div>
</div>
<div style="text-align: center; margin-top:40px; cursor: default; height: 40px;">
        <span style="font-size: 16px;" onclick="CloseDiv('MyTimeDiv','fade')"><a class='btn btn-danger btn-sm'><i class='fa fa-remove'></i>&nbsp;&nbsp;关闭</a>&nbsp;&nbsp;</span>
        <span style="font-size: 16px;" onclick="doTimeQuery()"><a class='btn btn-primary btn-sm'><i class='fa fa-check'></i>&nbsp;&nbsp;确定</a>&nbsp;&nbsp;</span>
    </div>
</div>
<script src="${pageContext.request.contextPath}/res/hplus/js/plugins/clockpicker/clockpicker.js"></script>
<script type="text/javascript">
    /*    $('#start_time').clockpicker();
     $('#end_time').clockpicker();*/
    $('.clockpicker').clockpicker();
</script>
</body>
</html>