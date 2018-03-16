import React from "react"
import "./index"
import {LeftMenuTemplate, Page404, TmplFunc} from '../Components.tmpl'
import "../hook";
const menuid = TmplFunc.getUrlParam("menuid");
let TPIndex = () => <Page404 />;
if (menuid) {
    TPIndex = () => (
        <LeftMenuTemplate menuid = {menuid}/>
    );
}
export default TPIndex;