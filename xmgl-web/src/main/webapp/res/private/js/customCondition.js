	
	//用户条件类                                      field, title,   "single","equal", conent,    '',      '',    ''
	function UserCondtion( fieldName,filedTitle,kind,operator_1,value_1,connector,operator_2,value_2)
	{
		this.fieldName=fieldName;//字段名称
		this.filedTitle=filedTitle;//字段对应中文名
		this.kind=kind;//条件类别    single 单个 ,complex 复杂--有两个条件
		this.operator_1= operator_1;//操作符1
		this.value_1=value_1;//值1
		this.connector=connector;//连接符 and or
		this.operator_2=operator_2;//操作符2
		this.value_2=value_2;//值2
		//组织sql语句，可以执行
		this._pf_OrganizeExe=function(operator,value)
		{
			var tempfieldName="cb."+this.fieldName;
			
			var sql="";
			if( operator=="equal")
				sql= sql+tempfieldName+"='"+ value+"' ";
			else if( operator=="notEqual")
				sql= sql+tempfieldName+" !='"+ value+"' ";
			else if( operator=="bigger")
				sql= sql+tempfieldName+" >'"+value+"' ";
			else if( operator=="biggerEqual")
				 sql= sql+tempfieldName+" >='"+value+"' ";
			else if( operator=="less")
			     sql= sql+tempfieldName+" <'"+value+"' ";
			else if( operator=="lessEqual")
				sql= sql+tempfieldName+" <='"+value+"' "; 
			else if( operator=="equalNull")
				sql= sql+tempfieldName+" is null   "; 
			else if( operator=="notequalNull")
				sql= sql+tempfieldName+"  is  not  null   ";
			else if( operator=="contain")
				sql= sql+ tempfieldName+ " like '%"+value+"%' ";
			else if( operator=="notContain")
				sql= sql+tempfieldName+" not like '%"+ value+"%' ";
			return sql;
		};  
		//组织sql语句， 
		this._pf_OrganizeDisplaySql=function(operator,value)
		{
			var fieldTile="["+this.filedTitle+"]";
			var sql="";
			if( operator=="equal")
				sql= sql+fieldTile+" 等于  '"+ value+"'" ;
			else if( operator=="notEqual")
				sql= sql+fieldTile+" 不等于  '"+ value +"'" ;
			else if( operator=="bigger")
				sql= sql+fieldTile+" 大于 '"+value +"'" ;
			else if( operator=="biggerEqual")
				 sql= sql+fieldTile+" 大于等于'"+value +"'" ;
			else if( operator=="less")
			     sql= sql+fieldTile+" 小于 '"+value +"'" ;
			else if( operator=="lessEqual")
				sql= sql+fieldTile+" 小于等于'"+value +"'" ; 
			else if( operator=="equalNull")
				sql= sql+fieldTile+" 为空   "; 
			else if( operator=="notequalNull")
				sql= sql+fieldTile+"  不为空   ";
			else if( operator=="contain")
				sql= sql+ fieldTile+ " 包含 '"+value+"' ";
			else if( operator=="notContain")
				sql= sql+fieldTile+" 不包含 '"+ value+"' ";
			return sql;
		}; 
		//重新组织sql语句
		this._f_getExeSql=function()
		{ 
			//简单sql语句
			if(this.kind=="single")
			{  
				return " ("+ this._pf_OrganizeExe(this.operator_1,this.value_1)+")";
			}
			else  //复杂sql语句
			{ 
				var sql =" ("+ this._pf_OrganizeExe(this.operator_1,this.value_1);
				if(this.operator_2!=""&&this.operator_2!=null)
				{ 
					sql=sql+ " " +connector+ " " + this._pf_OrganizeExe(this.operator_2,this.value_2) ;
				} 
				 sql=sql+")";
				return sql;
			} 
		}; 
		//组织用户可以看懂的sql描述
		this._f_getDispalySql=function()
		{
			//简单sql语句
			if(this.kind=="single")
			{  
				return "("+ this._pf_OrganizeDisplaySql(this.operator_1,this.value_1)+")";
			}
			else  //复杂sql语句
			{  
				var sql =" ("+ this._pf_OrganizeDisplaySql(this.operator_1,this.value_1);
				if(this.operator_2!=""&&this.operator_2!=null)
				{ 
					sql=sql+ " " +connector+ " " + this._pf_OrganizeDisplaySql(this.operator_2,this.value_2) ;
				} 
				sql=sql+")";
				return sql;
			} 
		}; 
		//深度拷贝用户条件
		this._pf_deepCopy=function()
		{
			var newUserCondition=new UserCondtion( this.fieldName,this.filedTitle,this.kind,this.operator_1,this.value_1,this.connector,this.operator_2,this.value_2);
			return newUserCondition;
		};
	}
	function UserConditionSimple(fieldName,value)
	{
		this.fieldName=fieldName;
		this.value=value;
	}
	
	//条件容器类，只实例化一次 ，保存用户条件 该对象内部维护一个一维数组  该数组存储条件
	function UserConditionContainer(guid)
	{
		this.changeFlag=false;//检测该容器是否改变
		//condition对象数组
		this.conditionArr=new Array();
		this.guid=guid;
		//获取condition对象个数
		this._f_size=function()
		{
			return this.conditionArr.length;
		};
		//获取指定字段下的所有条件个数
		this._f_size=function(fieldName)
		{ 
			return this.conditionArr.length;
		};
		this._f_push=function(condition)
		{ 
			var existFlag=false;
			for(var i=0;i<this.conditionArr.length;i++)
			{
				var cdTemp=this.conditionArr[i]; 
				if(cdTemp.fieldName==condition.fieldName)
				{
					this.conditionArr[i]=condition;  
					existFlag=true;
				}
			} 
			if(!existFlag)
			{
				this.conditionArr.push(condition); 
			}   
		};
		this._f_get=function(index)
		{ 
			return this.conditionArr[index];
		};
		//获取指定字段下的所有条件,内部实现为遍历，效率比较差
		this._f_getConditionArr=function(fieldName)
		{
			var tempConditionArr=new Array();
			for(var i=0;i<this.conditionArr.length;i++)
			{
				var condition=this.conditionArr[i];
				if(condition.fieldName==fieldName)
				{
					if(condition.value_1&&condition.operator_1=="equal")
					{
						var temp=new UserConditionSimple(fieldName,condition.value_1);
						tempConditionArr.push(temp);
					}
					if(condition.value_2&&condition.operator_2=="equal")
					{ 
						var temp=new UserConditionSimple(fieldName,condition.value_2);
						tempConditionArr.push(temp);
					}
				}
			}
			return tempConditionArr;
		};
		//清空所有条件
		this._f_clearCondition=function()
		{
			this.conditionArr.splice(0,this.conditionArr.length);
		};
		//清空指定field对应的条件
		this._f_removeCondition=function(fieldName)
		{
			for(var i=this.conditionArr.length-1;i>=0;i--)
			{
				var tempCondition=this.conditionArr[i];
				if(fieldName==tempCondition.fieldName)
				{
					this.conditionArr.splice(i,1);
				}
			}
		};
		//获取指定fieldName对应条件的可执行sql
		this._f_getExeSql=function(fieldName)
		{
			for(var i=this.conditionArr.length-1;i>=0;i--)
			{
				var tempCondition=this.conditionArr[i];
				if(fieldName==tempCondition.fieldName)
				{
					return tempCondition._f_getExeSql();
				}
			}
			return "";
		};
		this._f_getExeSqlAll=function()
		{
			var sql=""; 
			for(var i=this.conditionArr.length-1;i>=0;i--)
			{
				var tempCondition=this.conditionArr[i]; 
				sql=sql+" and "+tempCondition._f_getExeSql(); 
			}
			return sql;
		};
		this._f_getDispalySqlAll=function()
		{
			var sql=""; 
			for(var i=0;i<=this.conditionArr.length-1;i++)
			{
				var tempCondition=this.conditionArr[i]; 
				if(i==0)
					sql=sql+ tempCondition._f_getDispalySql(); 
				else
				{ 
					sql=sql+" and "+tempCondition._f_getDispalySql();
				}
			} 
			if(sql.length>80)
			{
				sql=sql.substring(0, 79);
				sql=sql+"...";
				alert(sql);
			}
			return sql;
		};
		
		
		//获取指定fieldName对应条件 条件对象
		this._f_getCondition=function(fieldName)
		{ 
			for(var i=this.conditionArr.length-1;i>=0;i--)
			{
				var tempCondition=this.conditionArr[i];  
				if(fieldName==tempCondition.fieldName)
				{
					return tempCondition ;
				}
			}
			return null;
		};	
		//深度拷贝，但是不拷贝guid
		this._pf_deepCopy=function( )
		{
		    var userConditionContainer=new UserConditionContainer(null);
		    for(var i=0;i<this.conditionArr.length;i++)
		    {
		    	var tempCondition= this.conditionArr[i];
		    	userConditionContainer._f_push(tempCondition._pf_deepCopy());
		    }
		    return userConditionContainer;
		};
	}  
	//用户条件历史 ,内部维护一个数组
	function UserConditionHistory()
	{ 
		this.userConditionContainerArr=new Array();
		this._f_getByIndex=function(index)
		{ 
			return this.userConditionContainerArr[index];
		}; 
		//获取指定字段下的所有条件个数
		this._f_size=function()
		{ 
			return this.userConditionContainerArr.length;
		};   
		//压入一个历史记录
		this._f_push=function(userConditionContainer)
		{  
			this.userConditionContainerArr.push(userConditionContainer);
		};
		this._f_removeUdContainer=function(guid)
		{
			for(var i=this.userConditionContainerArr.length-1;i>=0;i--)
			{
				var userConditionContainer=this.userConditionContainerArr[i];
				if(guid==userConditionContainer.guid)
				{
					this.userConditionContainerArr.splice(i,1);
					return;
				}
			}
		};
		//选择之后放到stack 顶部 
		this._f_get=function(guid)
		{
			//查找条件容器
			for(var i=this.userConditionContainerArr.length-1;i>=0;i--)
			{
				var userConditionContainer=this.userConditionContainerArr[i];
				if(guid==userConditionContainer.guid)
				{
					//拷贝一个用户条件container
					var tempUdContainer=userConditionContainer._pf_deepCopy() ;
					this._f_removeUdContainer(guid);
					return tempUdContainer;
				}
			}
			//将该条件置于顶部 ,现在 未处理不处理
			return null;
		};  
		this._f_checkifSameValue=function(newArr,value)
		{ 
			for(var k=0;k<newArr.length;k++)
			{ 
				var temp=newArr[k]; 
				if(temp.value==value)
				{
					return true;
				}
			}  
			return false;
		};
		this._f_getContionArr=function(fieldName)
		{
			var newArr=new Array();  
			for(var i=this.userConditionContainerArr.length-1;i>=0;i--)
			{
				var userConditionContainer=this.userConditionContainerArr[i];
				var tempArr=userConditionContainer._f_getConditionArr(fieldName);
				for(var k=0;k<tempArr.length;k++)
				{
					var temp=tempArr[k]; 
					if(!this._f_checkifSameValue(newArr,temp.value))
					{
						newArr.push(tempArr[k]);
					}
				}  
			} 
			return newArr;
		};
		
	}
	function S4() 
	{   
	   return (((1+Math.random())*0x10000)|0).toString(16).substring(1);   
	}    
	function NewGuid() 
	{   
	   return (S4()+S4()+"-"+S4()+"-"+S4()+"-"+S4()+"-"+S4()+S4()+S4());   
	}
