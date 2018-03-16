import React from 'react'
import mirror, {connect, actions,render} from 'mirrorx'
import {Form, Row, Col, message, Input, Select, Button, Icon, Radio, DatePicker, Table , Upload, Column} from 'antd';
import {getJson} from "../../../request";
import LzEditor from 'react-lz-editor/editor/index'
import '../../tp.scss';
const FormItem = Form.Item;
const formItemLayout = {
    labelCol: {sm: {span: 7},},
    wrapperCol: {sm: {span: 13},},
};
const columns = [
    {  dataIndex:'fieldName', width:200},
    {  dataIndex:'by', width:10},
    {  dataIndex:'oldValue', width:600},
    {  dataIndex:'change', width:55},
    {  dataIndex:'newValue', width:600}
];

const createTaskAlterInfoModel = function (modelName) {
    mirror.model({
        name: modelName,
        initialState:{
            forceUpdate:true, //限制查询1次数
            alterData:{},     //数据存储
        },

        reducers:{
            //赋值
            inAlterInfoList(state,data) {
                return{
                    ...state,
                    alterData: data,
                    forceUpdate:false,
                }
            },
        },
        effects:{
            //根据临时id查找数据
            async loadAlterData(data,getState) {
                let alterInfoList = await getJson('/api/task/getTaskAlterInfoById/' + data.id, {'method': 'GET'});
                actions[modelName].inAlterInfoList(alterInfoList)

            }
        },
    });
    render();
};

const TaskAlterInfo = connect((state, ownProps) => {
    let modelName = ownProps.modelName;
    if(state[modelName].forceUpdate) {
        actions[modelName].loadAlterData(ownProps);
    }
return state[modelName]
})(props =>{
    if(!props.forceUpdate) {
        let alterContent = JSON.parse(props.alterData.alter_content)
        var contents;
        contents = alterContent.map((item) => {
            return (
                {
                    key: item.old_value,
                    fieldName: <b>{item.field_name}</b>,
                    by: '由',
                    oldValue: <span className="alterContentValues">{item.old_value}</span>, //class绿色波浪线
                    change: '变更成',
                    newValue: <span className="alterContentValue">{item.new_value}</span>,  //class红色波浪线
                }
            )
        })
    }

        return (
            <div>
                <Row  type="flex" justify="space-around" >
                    <Col span={5}>
                        <FormItem {...formItemLayout} label={`任务名称：`}>
                            <Input
                                value={props.alterData.task_name}
                            />
                        </FormItem>
                    </Col>
                    <Col span={5}>
                        <FormItem {...formItemLayout} label={`变更人：`}>
                            <Input
                                value={props.alterData.alter_person}
                            />
                        </FormItem>
                    </Col>
                    <Col span={5}>
                        <FormItem {...formItemLayout} label={`变更时间：`}>
                            <Input
                                value={props.alterData.alter_time}
                            />
                        </FormItem>
                    </Col>
                    <Col span={5}>
                        <FormItem {...formItemLayout} label={`变更影响：`}>
                            <Input
                                value={props.alterData.alter_affect}
                            />
                        </FormItem>
                    </Col>
                </Row>
                <Row  >
                    <Col span={24}>
                        <div>
                            <FormItem labelCol={{span: 2}} wrapperCol={{span: 21}} label={`变更内容：`}>
                                <Table columns={columns} dataSource={contents} size="small" pagination={false} showHeader={false}>
                                </Table>
                            </FormItem>
                        </div>
                    </Col>
                </Row>
                <Row >
                    <Col span={24}>
                        <FormItem labelCol={{span: 2}} wrapperCol={{span: 21}} label="变更描述：">
                            <div style={{height: 300, overflowY: 'scroll'}}>
                                <LzEditor
                                    active={true} lang="en"
                                    cbReceiver={(e) => {
                                        props.alterData.alter_desc = e
                                    }}
                                    importContent={props.alterData.alter_desc}
                                    video={false}
                                    audio={false}
                                    />
                            </div>
                        </FormItem>
                    </Col>
                </Row>

                <Row>
                    <Col span={8} offset={10}>
                        <div className="closeButton">
                            <Button size="large" icon="close-circle"
                                    onClick={() => {
                                        actions.tabsTmpl.closeCurTab()
                                    }}
                            >关闭</Button>
                        </div>
                    </Col>
                </Row>

            </div>
        )

})
export default TaskAlterInfo
export {createTaskAlterInfoModel};