//Created by wjy on 2017/9/26.
import React from 'react'
import mirror, {connect, actions, render} from 'mirrorx'
import {Tabs} from 'antd';

const TabPane = Tabs.TabPane;
import './tp/tp.scss';

const createTabsModel = function (modelName) {
    mirror.model({
        name: modelName,
        initialState: {
            tabs: [],//标签列表，key:标签页的key，同时也是子model的name。name：展示的标题。content：标签页内容。
            activeKey: ''
        },
        reducers: {
            //增加tabs或切换tabs
            addTab(state, data) {
                let tabs = state.tabs;
                let flag = false;
                for (let i in tabs) {
                    if (tabs[i].key === data.key) {
                        tabs[i] = data;
                        flag = true;
                    }
                }
                if (!flag) {
                    tabs.push(data);
                }
                return {
                    ...state,
                    activeKey: data.key,
                    tabs: tabs,
                }
            },
            //切换tabs
            changeActive(state, data) {
                return {
                    ...state,
                    activeKey: data
                }
            },
            setTabs(state, data) {
                return {
                    ...state,
                    activeKey: data.activeKey,
                    tabs: data.tabs
                }
            }

        },
        effects: {
            async onEdit(data, getState) {
                actions[modelName][data.action](data.targetKey);
            },
            //点击X按钮，移除标签页
            async remove(data, getState) {
                console.log("remove============");
                console.log(data);

                let targetKey = data;
                let state = getState()[modelName];
                let activeKey = state.activeKey;
                let lastKey;
                let tmp = [];
                let tabs = state.tabs;
                console.log(tabs);
                for (let i in tabs) {
                    if (targetKey !== tabs[i].key) {
                        tmp.push(tabs[i]);
                        lastKey = tabs[i].key;
                    }
                }
                if (targetKey === activeKey) {
                    activeKey = lastKey;
                }
                if (actions.hasOwnProperty(targetKey) && actions[targetKey].hasOwnProperty("reloadData")) {
                    actions[targetKey].reloadData();
                }
                actions[modelName].setTabs({
                    activeKey: activeKey,
                    tabs: tmp
                });
            },
            async closeCurTab(data, getState) {
                actions[modelName].remove(getState()[modelName].activeKey);
            }

        }
    })
    render();
}


const TabsTmpl = connect((state, ownProps) => {
    let modelName = ownProps.modelName;
    return state[modelName]
})(props => {
        let modelName = props.modelName;
        return (
            <div>
                <Tabs
                    activeKey={props.activeKey}
                    onChange={(e) => {
                        actions[modelName].changeActive(e);
                    }}
                    type="editable-card"
                    onEdit={(targetKey, action) => {
                        actions[modelName].onEdit({targetKey: targetKey, action: action})
                    }}
                    hideAdd
                >
                    {
                        props.tabs.map(item => <TabPane tab={item.name} key={item.key}>{item.content}</TabPane>)
                    }
                </Tabs>
            </div>
        )
    }
)

export default TabsTmpl
export {createTabsModel}