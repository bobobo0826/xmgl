import React from 'react'
import factory from '../../ComponentFactory'

const Materials = () => {
    return (
        <div>
            <h1>物品管理</h1>
        </div>
    )
}

factory.register("Materials", <Materials/>)