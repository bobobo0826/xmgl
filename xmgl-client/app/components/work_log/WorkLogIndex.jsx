import React from "react"
import {LeftMenuTemplate, Page404, TmplFunc} from '../Components.tmpl'
import "../hook";
const menuid = TmplFunc.getUrlParam("menuid");
let WorkLogIndex = () => <Page404 />;
if (menuid) {
    WorkLogIndex = () => (
        <LeftMenuTemplate menuid = {menuid}/>
    );
}
export default WorkLogIndex



