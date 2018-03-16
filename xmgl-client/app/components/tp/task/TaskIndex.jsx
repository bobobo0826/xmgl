//Created by wjy on 2017/9/26.
import React from 'react'
import '../tp.scss';
import factory from '../../ComponentFactory'
import TabsTmpl, {createTabsModel} from "../../TabsTmpl";
import {actions} from "mirrorx";

const TaskIndex = () => {
    let tabsModelName = "taskTabs";
    if (!actions[tabsModelName]) {
        createTabsModel(tabsModelName);
    }
    return (
        <TabsTmpl modelName={tabsModelName}/>
    )
}

factory.register('TaskIndex', <TaskIndex/>)
