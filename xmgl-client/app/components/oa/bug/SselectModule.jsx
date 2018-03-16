import { Modal, Button,Icon ,Alert} from 'antd';
import React from 'react'
import ModuleTree from './ModuleTree'
import BaseComponent from '../../BaseComponent'

class SselectModule extends BaseComponent {
    constructor(props){
        super(props)
        this.showModal = this.showModal.bind(this);
        this.hideModal = this.hideModal.bind(this);
        this.getTreeResult = this.getTreeResult.bind(this);
        this.state = {
            visible: false,
            treeData:this.props.treeData||[],
            treeResult:"",
        }
    }
    showModal(){
        this.setState({
            visible: true,
        });
    }
    hideModal(){
        this.setState({
            visible: false,
        });
    }
    getTreeResult(treeResult){
        this.setState({
            treeResult:treeResult
        },()=>{
            this.props.getTreeResult(this.state.treeResult);
            }
        )
    }
    render() {
        let tree
            if(this.props.treeData && JSON.stringify(this.props.treeData).length>2){
                tree=<ModuleTree treeData={this.props.treeData} getTreeResult={this.getTreeResult.bind(this)}/>

            }else{
                tree=<Alert
                    message="该项目下无模块可选择"
                    type="warning"
                    showIcon
                />
            }

        return (
            <div>
                <Icon type="search"
                      style={{ fontSize: 22, color: '#08c' ,marginTop:5,}}
                      onClick={this.showModal}
                />
                <Modal
                    title="选择模块"
                    visible={this.state.visible}
                    onOk={this.hideModal}
                    onCancel={this.hideModal}
                    okText="确认"
                    cancelText="取消"
                    width="640px"
                >
                    {tree}
                </Modal>
            </div>
        );
    }
}

export default SselectModule