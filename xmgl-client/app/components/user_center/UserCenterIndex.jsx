import React from "react"
import {LeftMenuTemplate, Page404, TmplFunc} from '../Components.tmpl'
import "../hook";
const menuid = TmplFunc.getUrlParam("menuid");
let UserCenterIndex = () => <Page404 />;
if (menuid) {
    UserCenterIndex = () => (
        <LeftMenuTemplate menuid = {menuid}/>
    );
}
export default UserCenterIndex



