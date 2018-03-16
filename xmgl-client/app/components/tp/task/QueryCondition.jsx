//Created by wjy on 2017/9/26.
import React from 'react'
import mirror, {connect, actions} from 'mirrorx'
import {Form, Row, Col, message, Input, Select, Button} from 'antd';
import {getJson} from "../../request";
import CreateTaskIndex from "./CreateTaskIndex";
const FormItem = Form.Item;
const formItemLayout = {
    labelCol: {sm: {span: 6},},
    wrapperCol: {sm: {span: 14},},
};

mirror.model({
    name:'queryCondition',
    initialState:{
        queryOptions:{
            task_name : ''
        },
        taskTypeDic:[]
    },
    reducers:{
        handleChange(state,data){
         return {
             ...state,
             queryOptions:Object.assign({},state.queryOptions,data)
         }
        },
        doClear(state){
            let queryOptions = {};
            return {
                ...state,
                queryOptions:queryOptions
            }
        },
        setTaskTypeDic(state, data){
            return {
                ...state,
                taskTypeDic: data.taskTypeDic,
            }
        },
    },
    effects: {
        async getTaskTypeDic(data, getState){
            let taskTypeDic = [];
            let response = await getJson('/api/task/getTaskDic/task_type');
            if (!response) {
                response = []
            }
            if (response && response.length) {
                response.map((item) =>
                    taskTypeDic.push(<Select.Option key={item.data_code}>{item.data_name}</Select.Option>));
            }
            actions
                .queryCondition
                .setTaskTypeDic({taskTypeDic: taskTypeDic})
        },
        async doAdd(data,getState){
            let content = (<CreateTaskIndex />);
            actions.tabsTmpl.addTab({key:"taskInfoNew","name": "任务录入", "content":content});
        }
    }
})

const QueryCondition =connect((state,ownProps) =>{
    if (!(state.queryCondition.taskTypeDic) || !state.queryCondition.taskTypeDic.length) {
        actions.queryCondition.getTaskTypeDic()
    }
    return state.queryCondition
})(props =>{
    return(
    <div>
        <Form>
        <Row gutter={64}>
        <Col sm={8}>
            <FormItem {...formItemLayout} label={`任务名称：`}>
                <Input
                    placeholder="任务名称"
                    value = {props.queryOptions.task_name || ''}
                    onChange={(e) => {
                        actions.queryCondition.handleChange({'task_name': e.target.value})
                    }}
                />
            </FormItem>
        </Col>
        <Col sm={8}>
            <FormItem {...formItemLayout} label={`任务类别：`}>
                <Select
                    defaultValue=""
                    value={props.queryOptions.task_type}
                    style={{width: '100%'}}
                    onChange={(val) => {
                        actions.queryCondition.handleChange({'task_type':val})
                    }}
                    allowClear
                >
                    {props.taskTypeDic}
                </Select>
            </FormItem>
        </Col>
        <Col sm={8}>
            <FormItem {...formItemLayout} label={`创建人：`}>
                <Input
                placeholder="创建人"
                value = {props.queryOptions.creator}
                onChange={(e) => {
                    actions.queryCondition.handleChange({'creator':e.target.value})
                }}
                />
            </FormItem>
        </Col>
        </Row>
        </Form>
        <Row>
        <Col sm={8} offset={8}>
            <Button size="large" icon="plus" onClick={()=>{actions.queryCondition.doAdd()}}>添加</Button>
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            <Button type="primary" size="large" icon="search" onClick={()=>{actions[props.parentModel].doQuery(props.queryOptions)}}>查询</Button>
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            <Button type="danger" size="large" icon="reload" onClick={()=>{actions[props.parentModel].doQuery({}); actions.queryCondition.doClear()}}>清空</Button>
        </Col>
        </Row>
    </div>
    )}
)

export default QueryCondition