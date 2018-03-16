<%--
  Created by IntelliJ IDEA.
  User: quangao
  Date: 2017/9/8
  Time: 16:23
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
    <%@ include file="/res/public/hplus.jsp"%>
    <%@ include file="/res/public/easyui_lib.jsp"%>
    <%@ include file="/res/public/common.jsp"%>
    <link rel="shortcut icon" href="../../logo/favicon.ico">
    <link rel="icon" type="image/gif" href="../../logo/animated_favicon1.gif" >

    <style type="text/css">
        html,body{
            width: 100%;
            height: 100%;
        }
        #J_iframe{
            height: 100% !important;
            width: 100% !important;
        }
    </style>
</head>
<body >
<div id="J_iframe" >
</div>
<script type="text/javascript" src="${pageContext.request.contextPath}/res/public/js/jquery.slimscroll.min.js" charset="UTF-8"></script>
<script type="text/javascript">
    $(function(){
        $('body').slimScroll({
            width: '100%',
            height: '100%',
            size: '1px',
            position: 'right',
            color: '#ffffff',
            alwaysVisible: true,
            distance: '20px',
            railVisible: true,
            railColor: '#ffffff',

        });
        $('#J_iframe').tabs({
            border:false,
            onSelect:function(title){

            },
            onLoad: function(title){

            }
        });


        $('#J_iframe').tabs('add',{
            title:'${name}',
            content:'<iframe class="J_iframe" frameborder="0" src="${url}" width="100%" height="90%" seamless allowfullscreen mozallowfullscreen msallowfullscreen webkitallowfullscreen></iframe>',
            closable:true,
            tools:[{
                iconCls:'icon-mini-refresh',
                handler:function(){
                    alert('refresh');
                }
            }]
        });
    })

    function addTab(name,url){
        $('#J_iframe').tabs('add',{
            title:name,
            content:'<iframe class="J_iframe" frameborder="0" src='+url+' width="100%" height="90%" seamless allowfullscreen mozallowfullscreen msallowfullscreen webkitallowfullscreen></iframe>',
            closable:true,
            tools:[{
                iconCls:'icon-mini-refresh',
                handler:function(){
                    alert('refresh');
                }
            }]
        });
    }
    function closeCurTab(){
        var tab=$('#J_iframe').tabs('getSelected');//获取当前选中tabs
        var index = $('#J_iframe').tabs('getTabIndex',tab);//获取当前选中tabs的index
        $('#J_iframe').tabs('close',index);//关闭对应index的tabs
    }

</script>
</body>

</html>
