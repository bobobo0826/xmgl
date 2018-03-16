import React from 'react'
import mirror, {connect, actions} from 'mirrorx'
import {getJson} from '../../../request'
import {Row, Col, Form, Input, Select, message, Button, Upload, Icon, Modal,} from 'antd';
import '../../tp.scss';
import Cache from "../../../cache"

const FormItem = Form.Item;
const {TextArea} = Input;
const formItemLayout = {
    labelCol: {sm: {span: 6},},
    wrapperCol: {sm: {span: 14},},
};

mirror.model({
    name: 'taskOutputInfo',
    initialState: {
        taskOutputData: {
            id:'',
            doc_name: '',
            output_category: '',
            order_num: '',
            output_type: '',
            output_desc: '',
            task_id: '',
            attachment: undefined,
        },
        loadingData: true,
    },
    reducers: {
        setMirrorState(state, newState) {
            return {
                ...state,
                ...newState,
            }
        },
        handleChange(state, data) {
            let obj = {};
            obj[data.key] = data.value;
            return {
                ...state,
                taskOutputData: Object.assign({}, state.taskOutputData, obj),
            }
        },
    },
    effects: {
        async initLoadData(ownProps, getState) {
            let opInfoState = await actions
                .taskOutputInfo
                .getTaskOutputById({id: ownProps.id, taskId: ownProps.taskId})
            let opDicState = await actions
                .taskOutputInfo
                .getDic();
            let loadingData = false;
            let newState = Object.assign({}, opInfoState, opDicState, {loadingData});
            actions.taskOutputInfo.setMirrorState(newState);
        },
        async getTaskOutputById(data, getState) {
            let response
            if (data.id !== -1) {
                response = await
                    getJson('/api/task/getTaskOutputById/' + data.id, {'method': 'GET'});
            } else {
                response = {task_id: data.taskId}
            }
            return {taskOutputData: response};
        },
        async getDic(data, getState) {
            let outputCategoryList = await getJson('/api/task/getTaskDic/output_category');
            outputCategoryList = outputCategoryList.status ? {} : outputCategoryList; //若返回了status 说明 出错。
            let outputTypeList = await getJson('/api/task/getTaskDic/output_type');
            outputTypeList = outputTypeList.status ? {} : outputTypeList;
            return {outputCategoryList, outputTypeList};
        },
        async saveTaskOutput(data, getState) {
            let dataToSave = data.dataToSave
            let pModelName = data.pModelName
            if (dataToSave.doc_name && dataToSave.doc_name != '') {
                let retData = await  getJson('/api/task/saveTaskOutput',
                    {
                        body: {
                            dataToSave: dataToSave,
                            taskStatustaskStatus: getState()[pModelName].taskStatus,
                        }
                    })
                if (retData.success) {
                    message.success("保存成功")
                } else {
                    message.error("保存失败")
                }
                actions.taskOutputInfo.afterSave({pModelName});
            } else {
                message.warning("有必填项未填写！")
            }

        },
        async handleCancel(data, getState) {
            actions.taskOutputInfo.setMirrorState({taskOutputData: {}});
            actions[data.pModelName].setMirrorState({output_visible: false});
        },
        async afterSave(data, getState) {
            actions.taskOutputInfo.setMirrorState({taskOutputData: {}});
            actions[data.pModelName].setMirrorState({output_visible: false, loadingData: true});
        },
        async handleFileChange(info, getState){
            let fileList = info.fileList;
            let attachments = []
            fileList.map((file) => {
                if (file.response) {
                    let obj = {}
                    //过滤多余的字段
                    obj["name"] = file.name;
                    obj["uid"] = file.response.uid;
                    obj["file_path"] = file.response.file_path;
                    obj["file_id"] = file.response.file_id;
                    obj["url"] = file.response.url;
                    obj["status"] = file.status;
                    attachments.push(obj)
                } else {
                    attachments.push(file)
                }
            })
            actions.taskOutputInfo.handleChange({value: JSON.stringify(attachments), key: 'attachment'})
        },
        async deleteFile(file) {
            if (file.file_path) {
                await getJson("/api/file/deleteFile", {body: {uid: file.uid}});
            }
        },
        async downloadFile(file) {
            if (file.file_path) {
                window.open(encodeURI(encodeURI("/api/file/publicfile/downloadFile?fileId=" + file.file_id + "&filePath=" + file.file_path + "&fileName=" + file.name)))
            }
        },

    }
})

const mapStateToProps = (state, ownProps) => {
    if (state.taskOutputInfo.loadingData && ownProps.id) {
        actions.taskOutputInfo.initLoadData(ownProps)
    }
    return state.taskOutputInfo
}
const TaskOutputInfo = connect(mapStateToProps)(props => {
        let output_visible = props.output_visible /*&& props.taskOutputData.task_id*/;
        let outputCategoryDic
        if (props.outputCategoryList && props.outputCategoryList.length) {
            outputCategoryDic = props.outputCategoryList.map((item) => (
                <Select.Option key={item.data_code}>{item.data_name}</Select.Option>))
        }
        let outputTypeDic
        if (props.outputTypeList && props.outputTypeList.length) {
            outputTypeDic = props.outputTypeList.map((item) => (
                <Select.Option key={item.data_code}>{item.data_name}</Select.Option>))
        }
        const upLoadProps = {
            action: '/api/file/publicfile/uploadFile',
            headers: {token: Cache.getAccessToken()},
            data: function(file){
                return {
                    _fileName : encodeURI(file.name),
                    _id: props.id,//任务输出的id
                    _module: "RWSCWJ"
                }
            },
            onChange: actions.taskOutputInfo.handleFileChange,
            onRemove: actions.taskOutputInfo.deleteFile,
            onPreview: actions.taskOutputInfo.downloadFile,
            multiple: true,
        };
        let content =
            (<div className="info-panel">
                <Form>
                    <Row>
                        <Col sm={12}>
                            <FormItem {...formItemLayout} label={`文档名称：`}
                                      validateStatus={props.taskOutputData.doc_name ? '' : 'error'}>
                                <Input
                                    placeholder="文档名称"
                                    value={props.taskOutputData.doc_name || ''}
                                    onChange={(e) => {
                                        actions.taskOutputInfo.handleChange({value: e.target.value, key: 'doc_name'})
                                    }}
                                />
                            </FormItem>
                        </Col>
                        <Col sm={12}>
                            <FormItem {...formItemLayout} label={`输出类别：`}>
                                <Select
                                    placeholder="输出类别"
                                    className="select"
                                    allowClear
                                    value={props.taskOutputData.output_category || ''}
                                    onChange={(code) => {
                                        actions.taskOutputInfo.handleChange({value: code, key: 'output_category'})
                                    }}
                                >
                                    {outputCategoryDic}
                                </Select>
                            </FormItem>
                        </Col>
                        <Col sm={12}>
                            <FormItem {...formItemLayout} label={`内部序号：`}>
                                <Input
                                    placeholder="内部序号"
                                    value={props.taskOutputData.order_num || ''}
                                    onChange={(e) => {
                                        actions.taskOutputInfo.handleChange({value: e.target.value, key: 'order_num'})
                                    }}
                                />
                            </FormItem>
                        </Col>
                        <Col sm={12}>
                            <FormItem {...formItemLayout} label={`输出类型：`}>
                                <Select className="select"
                                        allowClear
                                        placeholder="输出类型"
                                        value={props.taskOutputData.output_type || ''}
                                        onChange={(e) => {
                                            actions.taskOutputInfo.handleChange({value: e, key: 'output_type'})
                                        }}
                                >
                                    {outputTypeDic}
                                </Select>
                            </FormItem>
                        </Col>
                        <Col sm={24}>
                            <FormItem labelCol={{sm: 3}}
                                      wrapperCol={{sm: 19}} label={`附件：`}>
                                <Upload {...upLoadProps}
                                        fileList={props.taskOutputData.attachment ? JSON.parse(props.taskOutputData.attachment) : null}>
                                    <Button
                                        disabled={ props.id === -1}
                                    >
                                        <Icon type="upload"/> 点击上传
                                    </Button>
                                </Upload>
                            </FormItem>
                        </Col>
                        <Col sm={24}>
                            <FormItem labelCol={{sm: 3}}
                                      wrapperCol={{sm: 19}} label={`输出描述：`}>
                            <TextArea
                                rows={6}
                                placeholder="输出描述"
                                value={props.taskOutputData.output_desc || ''}
                                onChange={(e) => {
                                    actions.taskOutputInfo.handleChange({value: e.target.value, key: 'output_desc'})
                                }}
                            />
                            </FormItem>
                        </Col>
                    </Row>
                </Form>
            </div>)
        return (
            <Modal
                title={'任务输出'}
                maskClosable={false}
                visible={output_visible}
                onCancel={() => {
                    actions.taskOutputInfo.handleCancel({pModelName: props.pModelName});
                }}
                okText="保存"
                cancelText="关闭"
                width="640px"
                footer={
                    <div className="list-action">
                        <Button size="large" onClick={() => {
                            actions.taskOutputInfo.saveTaskOutput({
                                dataToSave: props.taskOutputData,
                                pModelName: props.pModelName
                            })
                        }}>保存</Button>
                        <Button type="danger" size="large" onClick={() => {
                            actions.taskOutputInfo.handleCancel({pModelName: props.pModelName});
                        }}>关闭</Button>
                    </div>}
            >
                <div>{content}</div>
            </Modal>
        )

    }
)
export default TaskOutputInfo