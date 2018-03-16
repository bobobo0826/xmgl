import React from 'react'
import factory from '../../ComponentFactory'


const MyMaterialsIndex = () => {
    return (
        <div>
            <h1>我的物品管理</h1>
        </div>
    )
}
factory.register("MyMaterialsIndex", <MyMaterialsIndex/>)