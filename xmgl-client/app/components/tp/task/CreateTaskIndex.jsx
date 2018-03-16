import React from 'react'
import TaskInfo, {createTaskInfoModel} from './TaskInfo'
import factory from '../../ComponentFactory'
import {actions} from "mirrorx";

const CreateTaskIndex =  function () {
    let name;
    do {
        name = `newTask${Math.random()}`;
    }while (actions[name]);
    if (!actions[name]) {
        createTaskInfoModel(name);
    }
    return (
        <div >
            <TaskInfo taskId = {-1} modelName = {name}/>
        </div>
    )
}

factory.register('CreateTaskIndex', <CreateTaskIndex />)
export default CreateTaskIndex