import React from 'react'
import mirror, {connect, actions, Link, Route, Switch} from "mirrorx";
import "../styles/comtmpl.scss"
import "../styles/index.scss";
import {Button, Layout, Menu} from 'antd'
import cache from './cache'
// import { Icon } from "react-fa";
import factory from './ComponentFactory'
import {createTabsModel} from "./TabsTmpl";
const WEB_URL = "http://192.168.117.177:8080/"
const TmplFunc = {
    generateMenuTree(menus) {
        return menus.map(item => {
            if (item.menus && item.menus.length) {
                return (
                    <Menu.SubMenu key={"link_" + item.menuid} title={item.menuname}
                                  onTitleClick={()=>{actions.leftmenutmpl.setParentContent(item)}}
                    >
                        {TmplFunc.generateMenuTree(item.menus)}
                    </Menu.SubMenu>
                );
            } else {
                return (
                    <Menu.Item key={"link_" + item.menuid} tag = {item}>
                            {/*<Icon className="menu-icon" name={item.icon || "chain"}/>*/}
                            {item.menuname}
                    </Menu.Item>
                );
            }
        });
    },
    getUrlParam(name) {
        var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)");
        var r = window.location.search.substr(1).match(reg);
        if (r != null) return unescape(r[2]);
        return null;
    },
};
const getComponentName = function (data){
    let url = data.replace("/", "");
    let component
    if (url.indexOf("?") != -1) {
        var str = url.split("?")
        component = str[0]
    }
    return component;
};

mirror.model({
    name: 'leftmenutmpl',
    initialState: {
        rightContent: ''
    },
    reducers: {
        setMenus(state, menuid) {
            let menus = [];
            let all = cache.getData("menus");
            if (all && all[menuid] && all[menuid].menus) {
                menus = all[menuid].menus;
            }
            console.log(all);
            let submenus = TmplFunc.generateMenuTree(menus);
            return {
                ...state,
                menus,
                submenus,
            };
        },
        updateContent(state, data) {
            return {
                ...state,
                rightContent: data
            }
        }
    },
    effects: {
        setParentContent(data, getState) {
            let menus = cache.getData('menus')
            let content = ''
            if (data.type === "ZJ") {
                content = factory.getComponents("TabsIndex");
            }else if(data.type==="LJ"){
                content = (<iframe src={WEB_URL + "/init?url="+data.url+"&token="+cache.token+"&name="+data.menuname}/>)
            }
            actions.leftmenutmpl.updateContent(content);
        },
        setContent(obj, getState) {
            var data = obj.item.props.tag;
            var level = obj.item.props.level;
            let content = ''
            if (data.type === "ZJ") {
                let component = getComponentName(data.url);
                content = factory.getComponents(component);
                if (level>=2) { // 2 实际上表示 3级菜单，三级及以上的组件菜单，使用标签页，组件和链接嵌套的情况没考虑----wjy 17/11/9
                    if (!actions.tabsTmpl){
                        createTabsModel("tabsTmpl");
                    }
                    actions.tabsTmpl.addTab({key: data.menuid, name: data.menuname, content: content})
                }else {
                    content = factory.getComponents("TabsIndex");
                    let component = getComponentName(data.url);
                    let content2 = factory.getComponents(component);
                    if (!actions.tabsTmpl){
                        createTabsModel("tabsTmpl");
                    }
                    actions.tabsTmpl.addTab({key: data.menuid, name: data.menuname, content: content2})
                    actions.leftmenutmpl.updateContent(content);
                }
            } else if (data.type === "LJ") {
                content = (<iframe
                        src={
                            WEB_URL + "init?url=" +
                            data.url +
                            "&token=" +
                            cache.token +
                            "&name=" +
                            data.menuname
                        }
                    />
                );
                actions.leftmenutmpl.updateContent(content);
            }
        }
    }
})
const LeftMenuTemplate = connect((state,ownProps) => {
        if (ownProps.menuid && !state.leftmenutmpl.menus) {
            actions.leftmenutmpl.setMenus(ownProps.menuid);
        }
        return state.leftmenutmpl
    })(props => {
        return (<div className="maintmpl">
            <div className="leftmenu">
                <Menu
                    className='menu'
                    onClick={
                        (obj)=>{actions.leftmenutmpl.setContent(obj)}
                    }
                    theme="light"
                    mode="inline"
                    defaultSelectedKeys={undefined}
                    style={{lineHeight: '64px'}}
                >
                    {props.submenus}
                </Menu>
            </div>
            <div className="content">{props.rightContent}</div>
        </div>)
    })

const ContentIframe = props => {
    var url = props.src || props.url;
    if (url && url != "/") {
        if (props.menuid) {
            return <iframe className="content-iframe" src={url + "?menuid=" + props.menuid}/>;
        } else {
            return <iframe className="content-iframe" src={url}/>;
        }
    }
    return <Page404/>;
};

const Page404 = (props) => (
    <div>
        <h1>404</h1>
    </div>
)

export {LeftMenuTemplate, ContentIframe, Page404, TmplFunc}