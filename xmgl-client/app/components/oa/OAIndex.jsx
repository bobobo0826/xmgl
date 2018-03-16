import React from "react"
import "./index"
import {LeftMenuTemplate, Page404, TmplFunc} from '../Components.tmpl'
import "../hook";
const menuid = TmplFunc.getUrlParam("menuid");
let OAIndex = () => <Page404 />;
if (menuid) {
    OAIndex = () => (
        <LeftMenuTemplate menuid = {menuid}/>
    );
}
export default OAIndex



