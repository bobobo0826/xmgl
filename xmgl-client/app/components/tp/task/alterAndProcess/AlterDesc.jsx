import React from 'react'
import factory from '../../../ComponentFactory'
import {actions} from "mirrorx";
import FormItem from "antd/es/form/FormItem";
import {Button,  Modal} from 'antd';
import LzEditor from 'react-lz-editor/editor/index'

let alterDesc ="";

const AlterDescContent = function (props) {
    return (
       <Modal
            title="变更描述"
            cancelText="关闭"
            width="800px"
            visible={props.modalVisible}
            onCancel={() => {
                actions[props.modelName].alterDescShowOrHide(false)
            }}
            footer={
                <div>
                    <Button type="dashed" onClick={() => {
                        actions[props.modelName].submitAlter(alterDesc);
                        actions[props.modelName].alterDescShowOrHide(false)
                    }}>
                        提交
                    </Button>
                    <Button type="danger" onClick={() => {
                        actions[props.modelName].alterDescShowOrHide(false)
                    }}>
                        关闭
                    </Button>
                </div>
            }
        >
            <FormItem labelCol={{span: 2}} wrapperCol={{span: 20}} label="变更描述：">
                <div style={{height: 250, overflowY: 'scroll'}}>
                    <LzEditor
                        active={true} lang="en"
                        video={false}
                        audio={false}
                        cbReceiver={(e) => {
                            alterDesc = e;
                        }}
                        importContent={alterDesc}
                    />
                </div>
            </FormItem>
        </Modal>
    );
}

export default AlterDescContent;