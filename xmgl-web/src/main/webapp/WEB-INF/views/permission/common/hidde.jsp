<%@ page language="java" contentType="text/html; charset=GBK" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<title>�ޱ����ĵ�</title>
<link href="${root}/css/style.css" rel="stylesheet" type="text/css" />
</head>
<body>
<table width="10" height="100%" border="0" cellpadding="0" cellspacing="0">
  <tr>
    <td align="left" valign="middle" background="${root}/images/sb_004.gif">
      <img src="${root}/images/ico_02.gif" width="6" height="79" onclick="hidFrame()" onMouseOver="this.style.cursor='hand'" alt="���ز˵�"  name="img1">
    </td>
  </tr>
</table>
</body>
 <script>
    var currentChoice = true;
	arrow1=new Image;
	arrow2=new Image;
	arrow1.src="../images/ico_02.gif";
	arrow2.src="../images/ico_03.gif";
	if (currentChoice) {
		document.img1.src=arrow1.src;
		document.img1.alt="���ز˵�";
	} else {
	    document.img1.src=arrow2.src;
	    document.img1.alt="��ʾ�˵�";
	}

	function hidFrame()
	{
		if(currentChoice){
			if (parent.mainframe.cols=="173,10,*"){
				parent.mainframe.cols="0,10,*";
				document.img1.src=arrow2.src;
				document.img1.alt="��ʾ�˵�";
			} 
		}if(!currentChoice){
			if (parent.mainframe.cols=="0,10,*"){
				parent.mainframe.cols="173,10,*";
				document.img1.src=arrow1.src;
				document.img1.alt="���ز˵�";
			} 
        }
	  currentChoice = !currentChoice;
    }
</script>
    
</html>
