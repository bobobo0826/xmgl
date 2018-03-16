import React from "react"
import {LeftMenuTemplate, Page404, TmplFunc} from '../Components.tmpl'
import "../hook";
const menuid = TmplFunc.getUrlParam("menuid");
let PermissionIndex = () => <Page404 />;
if (menuid) {
    PermissionIndex = () => (
        <LeftMenuTemplate menuid = {menuid}/>
    );
}
export default PermissionIndex



