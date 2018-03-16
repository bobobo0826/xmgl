import React from 'react'
import BaseComponent from '../../BaseComponent'
import {Row,Col,message, Input, Select,Form,Button} from 'antd';
class ListButton extends BaseComponent
{
    constructor(props)
    {
        super(props)
        this.state = {
            curModuleCode: this.props.curModuleCode,
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
        let btna=(
            <Button  size="large" icon="search" className="btn-query" onClick={this.props.doQuery} style={{marginRight:20}}>查询</Button>
        )
        let btnb=(
            <Button  size="large" icon="reload" className="btn-clear" onClick={this.props.doClear} style={{marginRight:20}}>清空</Button>
        )
        let list =arrayObj.map((item) => {
            if(item=='listAdd'){
               return (
                   <Button  size="large"icon="plus" className="btn-add"  onClick={this.props.doAdd} style={{marginRight:20}}>添加</Button>
               )
            }
        })
        return (<Row> <Col span={24} style={{ textAlign: 'center' }}>{btna}{btnb}{list} </Col> </Row>)
    }
}
export default ListButton