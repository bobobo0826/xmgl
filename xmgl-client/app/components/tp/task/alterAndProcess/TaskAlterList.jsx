/*create by
wjy
2017-10-18 15:00
*/

import React from 'react'
import mirror, {connect, actions,render} from 'mirrorx'
import {getJson} from '../../../request'
import {ListHead, ListItem, ToolBox} from '../../../public/list_component/index';
import {Form, Row, Col, message, Input, Select, Button, Icon, Radio, DatePicker, Progress, Upload, Collapse} from 'antd';
import TaskAlterInfo, {createTaskAlterInfoModel} from './TaskAlterInfo';
import '../../tp.scss';

const dateFormat = 'YYYY-MM-DD';
const FormItem = Form.Item;
const formItemLayout = {
    labelCol: {span: 6},
    wrapperCol: {span: 14},
};

const createTaskAlterListModel  = function (modelName){
    mirror.model({
        name:modelName,
        initialState:{
            list: undefined,//获取条数据
            queryOptions:{},//数据存储
            forceUpdate:true,//限制查询状态
            columns:[
                {
                    field: 'id',
                    hidden: true,
                    name: 'ID',
                    col: 3,
                },
                {
                    field: 'task_id',
                    hidden: true,
                    name: '任务ID',
                    col: 3,
                },
                {
                    field: 'alter_person',
                    hidden: false,
                    name: '变更人',
                    col: 4,
                },
                {
                    field: 'alter_time',
                    hidden: false,
                    name: '变更时间',
                    col: 4,
                },
                {
                    field: 'alter_desc',
                    hidden: false,
                    name: '变更描述',
                    col: 7,
                },
                {
                    field: 'alter_affect',
                    hidden: false,
                    name: '变更影响',
                    col: 3,
                },{
                    field: '',
                    hidden: false,
                    name: '操作',
                    col: 3,
                    formatter: function (row, data, index) {//显示操作按钮
                        return (
                            <div className="list-item-action">
                                <span className="ac-edit" onClick={()=>{actions[modelName].editInfo({'id': row.id})}}
                                >详情</span>
                            </div>
                        );
                    }
                }
            ]
        },
        reducers:{
            //传值到数据条
            setList(state, data) {
                return {
                    ...state,
                    list: data,
                    forceUpdate: false,
                }
            },
            //导航栏查询操作
            doQuery(state, data) {
                if(data.alter_endtime || data.alter_starttime){
                if(!data.alter_endtime || !data.alter_starttime) {
                    message.error("请填写完整的日期范围！");
                    return;
                }
                }
                return{
                    ...state,
                    queryOptions : data,
                    forceUpdate: true,
                }
            },
            //导航栏清空操作
            doClear(state, data) {
                return{
                    ...state,
                    queryOptions : {},
                    forceUpdate: true,
                }
            },
            //塞值存储
            handleChange(state,data){
                return {
                    ...state,
                    queryOptions:Object.assign({},state.queryOptions,data),
                    forceUpdate:false
                }
            }

        },
        effects: {
            //查询获取数据条
            async getList(taskId, getState) {
                actions[modelName].handleChange({'taskId': taskId})//把任务id塞入queryOptions，传递到后台判断。
                let queryOptions = getState()[modelName].queryOptions
                let response = await getJson('/api/task/getTaskAlterList', {
                    body: {
                        queryOptions: queryOptions,
                        page: 1,
                        pageSize: 20
                    }
                })

                let list = response.list
                if (!list) {
                    list = []
                }
                actions[modelName].setList(list)

            },
            //详情跳转
            async editInfo(data, getState){
                let modelName = `alterInfo${data.id}`;

                if (!actions[modelName]){
                    createTaskAlterInfoModel(modelName);
                }
                let content = (<TaskAlterInfo id = {data.id} modelName = {modelName}/>)
                actions.tabsTmpl.addTab({key:modelName,name :'任务变更详情','content':content})
            }
        }
    });
    render()
};

const TaskAlterList = connect((state,ownProps)=>{
    let taskId=ownProps.taskId;  //任务详情传递的任务id
    let modelName = ownProps.modelName;
    if(state[modelName].forceUpdate){
    actions[modelName].getList(taskId)//根据传递过来的任务id，直接获取数据。
    }
    return state[modelName];
})(props=>{
    let modelName = props.modelName;
    let content = (<div>加载中...</div>);
    if(props.list && props.list.length) {
        content = props.list.map((item)=>(
         <ListItem key={item.id} columns={props.columns} data={item}/>
        ))
    }
    else {content = (<div>暂无变更信息</div>);}

    return(
        <div>
            <Form className="list-search">
                <Row gutter={64}>
                        <Col span={8}>
                            <FormItem{...formItemLayout} label="变更人：">
                                <Input value={props.queryOptions.alter_person} placeholder="变更人"
                                       onChange={(e) => {actions[modelName].handleChange({'alter_person': e.target.value})}}
                                />
                            </FormItem>
                        </Col>
                        <Col span={8}>
                            <FormItem{...formItemLayout} label="变更开始时间：">
                                <DatePicker
                                    format={dateFormat}
                                    placeholder="变更开始时间"
                                    className="datePicker"
                                    onChange={(e,dateString) => {actions[modelName].handleChange({'alter_starttime': dateString});}}
                                />
                            </FormItem>
                        </Col>
                        <Col span={8}>
                            <FormItem{...formItemLayout} label="变更结束时间：">
                                <DatePicker
                                    format={dateFormat}
                                    placeholder="变更结束时间"
                                    className="datePicker"
                                    onChange={(e,dateString) => {actions[modelName].handleChange({'alter_endtime': dateString});}}
                                />
                            </FormItem>
                        </Col>
                </Row>

            </Form>
            <Row type="flex" justify="space-around" >
                <Col span={12} offset={10}>
                    <Button type="primary" size="large" icon="search" onClick={() => {
                        actions[modelName].doQuery(props.queryOptions)
                    }}>查询</Button>
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    <Button type="danger" size="large" icon="reload" onClick={() => {
                        actions[modelName].doClear()
                    }}>清空</Button>
                </Col>
                <Col span={23} className = "list">
                    <ListHead columns={props.columns} />
                    {content}
                </Col>
            </Row>

        </div>
    )
});


export default TaskAlterList;
export {createTaskAlterListModel};