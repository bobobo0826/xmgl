import React from 'react'
import mirror, {connect, actions, render} from 'mirrorx'
import {Form, Row, Col, message, Input, Select, Button,Pagination} from 'antd';
import {ListHead, ListItem, ToolBox} from '../../../public/list_component/index';
import {getJson} from '../../../request'

const FormItem = Form.Item;
const formItemLayout = {
    labelCol: {span: 6},
    wrapperCol: {span: 14},
};

const createTaskProcessModel = function (modelName) {
    mirror.model({
        name: modelName,
        initialState: {
            columns: [
                {
                    field: 'id',
                    hidden: true,
                    name: 'ID',
                    col: 2,
                }, {
                    field: 'task_name',
                    hidden: false,
                    name: '任务名称',
                    col: 4,
                }, {
                    field: 'task_type_code',
                    hidden: false,
                    name: '任务类型',
                    col: 2,
                }, {
                    field: 'urgency',
                    hidden: false,
                    name: '紧急性',
                    col: 2,
                }, {
                    field: 'importance',
                    hidden: false,
                    name: '重要性',
                    col: 2,
                }, {
                    field: 'task_condition_code',
                    hidden: false,
                    name: '任务状态',
                    col: 2,
                }, {
                    field: 'sup_project_name',
                    hidden: false,
                    name: '所属项目名称',
                    col: 2,
                }, {
                    field: 'sup_module_name',
                    hidden: false,
                    name: '所属模块名称',
                    col: 2,
                }, {
                    field: 'report_cycle',
                    hidden: false,
                    name: '汇报周期',
                    col: 2,
                }, {
                    field: 'complete',
                    hidden: false,
                    name: '任务完成情况',
                    col: 2,
                }, {
                    field: 'operator',
                    hidden: false,
                    name: '操作人',
                    col: 2,
                }, {
                    field: '',
                    hidden: false,
                    name: '操作',
                    col: 2,
                    formatter: function (row, data, index) {//显示操作按钮
                        return (
                            <div className="list-item-action">
                                <span className="ac-edit" onClick={() => {
                                    actions[modelName].editInfo({'id': row.id})
                                }}
                                >编辑</span>
                                <span className="ac-delete" onClick={()=>{
                                    actions[modelName].deleteTaskProcessList({'id':row.id})
                                }}
                                >删除</span>
                            </div>
                        );
                    }
                }

            ],
            forceUpdate: true,
            list: [],
            queryOptions: {},
            conditionCode:[],
            curPage: 1,
            pageSize: 10,
            totalItem:40,
        },
        reducers: {
            setMirrorState(state, newState) {
                return {
                    ...state,
                    ...newState,
                }
            },
            //塞值存储
            handleChange(state, data) {
                return {
                    ...state,
                    queryOptions: Object.assign({}, state.queryOptions, data),
                }
            },
            //导航栏查询操作
            doQuery(state, data) {
                return {
                    ...state,
                    curPage:1,
                    forceUpdate: true,
                }
            },
            //导航栏清空操作
            doClear(state, data) {
                return {
                    ...state,
                    queryOptions: {},
                    forceUpdate: true,
                }
            },
            //页码每页大小
            onShowSizeChange(state, data) {
                return {
                    ...state,
                    pageSize: data.pageSize,
                    curPage: data.current,
                    forceUpdate: true,
                }
            },
            //页码改变
            onChangePage(state, data) {
                return {
                    ...state,
                    curPage: data,
                    forceUpdate: true,
                }
            },


        },
        effects: {
            async initData(data,getState){
                let processListState = await actions[modelName].getTaskProcessList()
                let processDicState = await actions[modelName].getDic();
                let newState = Object.assign({},processDicState,processListState,{forceUpdate:false});
                actions[modelName].setMirrorState(newState);
            },
            async getTaskProcessList(data, getState) {
                let queryOptions = getState()[modelName].queryOptions;
                let curPage = getState()[modelName].curPage;
                let pageSize = getState()[modelName].pageSize || 10;
                let response = await getJson('/api/task/getTaskProcessList',
                    {
                        body: {
                            queryOptions: queryOptions,
                            page: curPage,
                            pageSize: pageSize
                        }
                    });
                let list = response.list;
                if (!list) {
                    list = []
                }
                return {list,totalItem: response.totalitem};

            },
            async getDic(data, getState){
                let conditionCode = [];
                let taskConditionList = await getJson('/api/task/getTaskDic/task_condition');
                taskConditionList.map((item) =>
                    conditionCode.push(<Select.Option key={item.data_code}>{item.data_name}</Select.Option>));
                return {conditionCode};
            },

            async deleteTaskProcessList(data,getState) {
                let response = await getJson('/api/task/deleteTaskProcessList',{
                    body:{
                        id:Number(data.id)
                    }
                });
                if(response.success) {
                    message.success("删除成功！");
                    actions[modelName].setMirrorState({forceUpdate:true});
                }

            }

        },
    });
    render()
};

const TaskProcess = connect((state, ownProps) => {
    let modelName = ownProps.modelName;
    if (state[modelName].forceUpdate) {
        actions[modelName].initData(ownProps)
    }
    return state[modelName]
})(props => {
    let modelName = props.modelName;
    let content = (<div>加载中...</div>);
    if (props.list && props.list.length) {
        content = props.list.map((item) => (
                <ListItem key={item.id} columns={props.columns} data={item}/>
        ))
    }
    else {
        content = (<div>暂无日志信息</div>);
    }
    return (
        <div>
            <Form className="list-search">
                <Row gutter={64}>
                    <Col span={8}>
                        <FormItem{...formItemLayout} label="任务名称：">
                            <Input value={props.queryOptions.task_name} placeholder="任务名称"
                                   onChange={(e) => {
                                       actions[modelName].handleChange({'task_name': e.target.value})
                                   }}
                            />
                        </FormItem>
                    </Col>
                    <Col span={8}>
                        <FormItem{...formItemLayout} label="任务状态：">
                            <Select value={props.queryOptions.task_condition_code} placeholder="任务状态"
                                   onChange={(e) => {
                                       actions[modelName].handleChange({'task_condition_code': e})
                                   }}
                                    allowClear
                            >
                                {props.conditionCode}
                            </Select>
                        </FormItem>
                    </Col>
                    <Col span={8}>
                        <FormItem{...formItemLayout} label="操作人：">
                            <Input value={props.queryOptions.operator} placeholder="操作人"
                                   onChange={(e) => {
                                       actions[modelName].handleChange({'operator': e.target.value})
                                   }}
                            />
                        </FormItem>
                    </Col>

                </Row>

            </Form>
            <Row >
                <Row>
                    <Col sm={4} offset={10}>
                        <Button type="primary" size="large" icon="search" onClick={actions[modelName].doQuery}>查询</Button>
                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                        <Button type="danger" size="large" icon="reload" onClick={actions[modelName].doClear}>清空</Button>
                    </Col>
                </Row>
                <Col span={23} className="list">
                    <ListHead columns={props.columns}/>
                    {content}
                    <Pagination className="list-pagination"showSizeChanger showQuickJumper defaultCurrent={props.curPage}
                                total={props.totalItem} onChange={(e)=>actions[props.modelName].onChangePage(e)}
                                onShowSizeChange={(current,pageSize)=>(actions[props.modelName].onShowSizeChange({current:current,pageSize:pageSize}))}
                                showTotal = {() => "共"+props.totalItem+"条数据"}
                    />
                </Col>
            </Row>
        </div>
    )
})


export {createTaskProcessModel}
export default TaskProcess;
