//Created by wangchao on 2017/10/16.
import React from 'react'
import mirror, {connect, actions, render} from 'mirrorx'
import {getJson} from '../../../request'
import {ListHead, ListItem, ToolBox} from '../../../public/list_component/index';
import {Row, Col, Form, Input, message, Select, Button} from 'antd';
import '../../tp.scss';
import TaskOutputInfo from './OutputInfo';

const createTaskOutputModel = function (modelName) {
    mirror.model({
        name: modelName,
        initialState: {
            list: undefined,
            columns: [
                {
                    field: 'id',
                    hidden: true,
                    name: 'ID',
                    col: 2,
                },
                {
                    field: 'task_id',
                    hidden: true,
                    name: '任务ID',
                    col: 2,
                },
                {
                    field: 'doc_name',
                    hidden: false,
                    name: '文档名称',
                    col: 4,
                },
                {
                    field: 'output_category',
                    hidden: false,
                    name: '输出类别',
                    col: 4,
                },
                {
                    field: 'order_num',
                    hidden: false,
                    name: '内部序号',
                    col: 4,
                },
                {
                    field: 'output_type',
                    hidden: false,
                    name: '输出类型',
                    col: 4,
                },
                {
                    field: 'output_desc',
                    hidden: false,
                    name: '输出描述',
                    col: 6,
                },
                {
                    field: '',
                    hidden: false,
                    name: '操作',
                    col: 2,
                    formatter: function (row, data, index) {//显示操作按钮
                        return (
                            <div className="list-item-action">
                            <span onClick={() => {
                                actions[modelName].editInfo(row.id)
                            }} className="ac-edit">编辑</span>
                                <span onClick={() => {
                                    actions[modelName].delOutputById(row.id)
                                }} className="ac-delete">删除</span>
                            </div>
                        )
                    }
                }
            ],
            loadingData: true,
            output_visible: false,
            check_id:null,
            taskId: null,
        },
        reducers: {
            setMirrorState(state, newState) {
                return {
                    ...state,
                    ...newState,
                }
            },
        },

        effects: {
            async initLoadData(ownProps, getState) {
                let listState = await actions[modelName].getOutPutList(ownProps.taskId);
                let newState = Object.assign({}, {taskStatus: ownProps.taskStatus}, listState,
                    {taskId: ownProps.taskId}, {loadingData: false});
                actions[modelName].setMirrorState(newState);
            },
            async getOutPutList(taskId, getState) {
                let response = await
                    getJson('/api/task/getTaskOutputList/' + taskId, {'method': 'GET'});
                if (response.status) {
                    response = []
                }
                return {list: response};
            },
            async delOutputById(id, getState) {
                let response = await getJson('/api/task/delOutputById', {
                    body: {
                        id: id,
                        taskStatus: getState()[modelName].taskStatus,
                    },
                    method: 'DELETE'
                })
                if (response.success) {
                    message.success("删除成功")
                } else {
                    message.error("刪除失败")
                }
                actions[modelName].setMirrorState({loadingData: true});
            },
            async editInfo(id, getState) {
                if (actions.taskOutputInfo) {
                    actions.taskOutputInfo.initLoadData({id: id});
                }
                actions[modelName].setMirrorState({ output_visible: true,check_id: id})
            },
        }
    });
    render();
};
const mapStateToProps = (state, ownProps) => {
    let modelName = ownProps.modelName;
    if (state[modelName].loadingData && ownProps.taskId && ownProps.taskId > 0) {
        actions[modelName].initLoadData(ownProps)
    }
    return state[modelName]
}
const TaskOutput = connect(mapStateToProps)(props => {
        let content = (<div>正在加载中...</div>);
        if (props.list && props.list.length > 0) {
            content = props.list.map((item) => (
                    <ListItem key={item.id} columns={props.columns} data={item}/>
                )
            )
        } else {
            content = (<div>暂无数据</div>)
        }
        let taskOutputInfo = null;
        if (props.output_visible) {
             taskOutputInfo = (
                <TaskOutputInfo id={props.check_id} taskId={props.taskId} pModelName={props.modelName}
                                output_visible={props.output_visible}/>)
        }
        return (
            <div>
                <Row className="add-info-button">
                    <Col sm={4} offset={2}>
                        <Button type="primary"
                                onClick={() => actions[props.modelName].editInfo(-1)}>新增</Button>
                    </Col>
                </Row>
                <div className="list">
                    <ListHead columns={props.columns}/>
                    {content}
                </div>
                <div>
                    {taskOutputInfo}
                </div>
            </div>
        )
    }
)
export default TaskOutput
export {createTaskOutputModel};