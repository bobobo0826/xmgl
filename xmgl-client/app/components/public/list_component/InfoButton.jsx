import React from 'react'
import BaseComponent from '../../BaseComponent'
import {Row,Col,message, Input, Select,Form,Button} from 'antd';
class InfoButton extends BaseComponent
{
    constructor(props)
    {
        super(props)
        this.state = {
            curModuleCode: this.props.curModuleCode,
            content:this.props.content,
            permissionCode:[]
        }
    }
    componentDidMount(){
        fetch('/api/permission/manage/rolePermission/getFunctionListReact/'+this.props.curModuleCode, {
            headers :{
                'Context-type' : 'application/json',
                'token' : this.getAccessToken()
            },
            method : 'POST',
        }).then((response)=>{
            if(response.status == 200)
            {
                return response.json()
            }

        }).then((obj)=>{
            var funcObjList = obj.funcObjs;
            var arrayObj = new Array();
            arrayObj = funcObjList.split(",");

            this.setState({
                permissionCode: arrayObj
            })

        }).catch((error)=>{
            console.error(error)
        })
    }
    render() {
        var arrayObj = new Array();
        arrayObj=this.state.permissionCode
        let contentArray = new Array();
        contentArray=this.props.content
        let list=new Array()
        for(var item of contentArray)
        {
            list.push( <Button className={item.class}  onClick={item.function}>{item.name}</Button>)
        }
      let btna=(
          <Button  className="btn-close" onClick={this.props.handleCancel}>关闭</Button>
        )
       /* let list =arrayObj.map((item) => {
            if(item=='listAdd'){
               return (
                   <Button  size="large"icon="plus" className="btn-add"  onClick={this.props.doAdd} style={{marginRight:20}}>添加</Button>
               )
            }
        })*/
        return (<Row> <Col span={24} style={{ textAlign: 'center' }}>{list} {btna}</Col> </Row>)
    }
}
export default InfoButton