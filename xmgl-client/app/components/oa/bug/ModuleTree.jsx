import { Tree ,Alert} from 'antd';
import React from 'react';
import BaseComponent from '../../BaseComponent'
const TreeNode = Tree.TreeNode;
class ModuleTree extends BaseComponent {
    constructor(props){
        super(props)
        this.onSelect = this.onSelect.bind(this)
        this.state = {
            treeData: this.props.treeData||[],
            forceUpdate:true,
        }
    }

    onSelect(info){
        this.props.getTreeResult(info);

    }

    render() {
        const loop = data => data.map((item) => {
            if (item.children) {
                return <TreeNode title={item.name} key={item.name}>{loop(item.children)}</TreeNode>;
            }
            return <TreeNode title={item.name} key={item.name}  />;
        });
        const treeNodes = loop(this.props.treeData);
        return (
            <Tree onSelect={this.onSelect}>
                {treeNodes}
            </Tree>
        );
    }
}

export default ModuleTree