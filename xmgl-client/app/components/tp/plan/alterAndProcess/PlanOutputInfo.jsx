import React from 'react'
import mirror, {connect, actions} from 'mirrorx'
import {getJson} from '../../../request'
import {Row, Col, Form, Input, Select, message, Button, Upload, Icon, Modal,} from 'antd';
import Cache from "../../../cache"
const FormItem = Form.Item;
const {TextArea} = Input;
const formItemLayout = {
    labelCol: {sm: {span: 6},},
    wrapperCol: {sm: {span: 14},},
};

mirror.model({
     name:"planOutputInfo",
    initialState:{
         planOutputData:{
             output_category:'',
             order_num:'',
             output_type:'',
             doc_name:'',
             output_desc:'',
             plan_id:'',
         },
        getOpen : true

    },
    reducers:{
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
                planOutputData: Object.assign({}, state.planOutputData, obj)
            }
        }
    },
    effects:{
         async initData(data,getState){
           let opInfoState =await actions.planOutputInfo.getPlanInfo({id: data.id,planId: data.planId})
           let outputDic =await actions.planOutputInfo.getDict();
           let getOpen=false;
           let newState = Object.assign({},opInfoState,outputDic,{getOpen});
            actions.planOutputInfo.setMirrorState(newState);
         },
         async handleClose(data, getState){
             actions.planOutputInfo.setMirrorState({planOutputData:{}})
             actions[data.pModelName].setMirrorState({outputShow:false})
         },
        async afterSave(data, getState) {
            actions.planOutputInfo.setMirrorState({planOutputData:{}})
            actions[data.pModelName].setMirrorState({outputShow:false,forceQuery:true})
        },
        async getPlanInfo(data,getState){
            let response
            if (data.id !== -1 ) {
                response= await getJson('/api/plan/getPlanOutputById/' + data.id, {'method': 'GET'})
            }
            else {response = {plan_id: data.planId}}
            return {planOutputData:response};
        },
        async getDict(data, getState) {
            let outputCategory = await getJson('/api/plan/getPlanDic/output_category')
            outputCategory = outputCategory.status ? {} : outputCategory;
            let outputType = await getJson('/api/plan/getPlanDic/output_type')
            outputType = outputType.status ? {} : outputType;
            return{outputCategory, outputType}
        },
        async saveOutputInfo(data,getState){
            let pModelName = data.pModelName
            let planOutputData = data.planOutputData
            if(planOutputData.doc_name && planOutputData.doc_name != '') {
                let saveReturn = await getJson('/api/plan/savePlanOutput',
                {
                    body: {
                        planOutputData: planOutputData,
                        planStatus: getState()[pModelName].planStatus,
                    }
                })
                if (saveReturn.success){
                    message.success("保存成功！")
                }
                else {
                    message.error("保存失败！")
                }
                actions.planOutputInfo.afterSave({pModelName});
            }
            else {message.warning("有必填项未填写！")}

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
            actions.planOutputInfo.handleChange({value: JSON.stringify(attachments), key: 'attachment'})
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

const PlanOutputInfo = connect ((state,ownProps) =>{

    if(state.planOutputInfo.getOpen && ownProps.id) {
        actions.planOutputInfo.initData(ownProps);
    }
    return state.planOutputInfo
})(props=>{
    let outputShow = props.outputShow;
    let selectOutputCategory
    let selectOutputType
    if(props.outputCategory && props.outputCategory.length>0){
        selectOutputCategory = props.outputCategory.map((item)=>
            <Select.Option key={item.data_code} >{item.data_name}</Select.Option>
        )
    }
    if(props.outputType && props.outputType.length>0) {
        selectOutputType = props.outputType.map((item) =>
            <Select.Option key={item.data_code} >{item.data_name}</Select.Option>
        )
    }
    const upLoadProps = {
        action: '/api/file/publicfile/uploadFile',
        headers: {token: Cache.getAccessToken()},
        data: function(file){
            return {
                _fileName : encodeURI(file.name),
                _id: props.id,//计划输出的id
                _module: "JHSCWJ"
            }
        },
        onChange: actions.planOutputInfo.handleFileChange,
        onRemove: actions.planOutputInfo.deleteFile,
        onPreview: actions.planOutputInfo.downloadFile,
        multiple: true,
    };

    let content = (<div>
        <Form>
            <Row>
                <Col sm={12}>
                    <FormItem {...formItemLayout} label={'文档名称：'}
                              validateStatus={props.planOutputData.doc_name ? '' : 'error'}>
                    <Input placeholder={"文档名称"} value={props.planOutputData.doc_name}
                           onChange={(e)=>{actions.planOutputInfo.handleChange({value:e.target.value,key:'doc_name'})}}
                    />

                    </FormItem>
                </Col>
                <Col sm={12}>
                    <FormItem {...formItemLayout} label={'输出类别：'}>
                        <Select placeholder={"输出类别"} className={"select"}
                                allowClear
                                value={props.planOutputData.output_category}
                                onChange={(e)=>{actions.planOutputInfo.handleChange({value:e,key:'output_category'})}}
                        >
                            {selectOutputCategory}
                        </Select>

                    </FormItem>
                </Col>
                <Col sm={12}>
                    <FormItem {...formItemLayout} label={'内部序号：'}>
                        <Input placeholder={"内部序号"} value={props.planOutputData.order_num}
                               onChange={(e)=>{actions.planOutputInfo.handleChange({value:e.target.value,key:'order_num'})}}
                        />

                    </FormItem>
                </Col>
                <Col sm={12}>
                    <FormItem {...formItemLayout} label={'输出类型：'}>
                        <Select placeholder={"输出类别"} className={"select"}
                                allowClear
                                value={props.planOutputData.output_type}
                                onChange={(e)=>{actions.planOutputInfo.handleChange({value:e,key:'output_type'})}}
                        >
                            {selectOutputType}
                        </Select>
                    </FormItem>
                </Col>
                <Col sm={24}>
                    <FormItem labelCol={{sm: 3}}
                              wrapperCol={{sm: 19}} label={`附件：`}>
                        <Upload {...upLoadProps}
                                fileList={props.planOutputData.attachment ? JSON.parse(props.planOutputData.attachment) : null}>
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
                            value={props.planOutputData.output_desc}
                            onChange={(e)=>{actions.planOutputInfo.handleChange({value:e.target.value,key:'output_desc'})}}
                            />

                    </FormItem>
                </Col>
            </Row>
        </Form>
    </div>)

    return(<Modal
        title={'计划输出'}
        maskClosable={false}
        visible={outputShow}
        onCancel={() => {
            actions.planOutputInfo.handleClose({pModelName: props.pModelName});

        }}
        okText={"保存"}
        cancelText={"关闭"}
        width={"640px"}
        footer={<div className="list-action">
            <Button type={"primary"} size={"large"} onClick={()=>{actions.planOutputInfo.saveOutputInfo({pModelName: props.pModelName,
                planOutputData:props.planOutputData })}} >保存</Button>
            <Button type={"danger"} size={"large"} onClick={()=>{actions.planOutputInfo.handleClose({pModelName: props.pModelName})}}>关闭</Button>
        </div>}
    >
        {content}
    </Modal>)
})

export default PlanOutputInfo