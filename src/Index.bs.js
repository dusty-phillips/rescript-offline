// Generated by ReScript, PLEASE EDIT WITH CARE

import * as React from "react";
import * as ReactDom from "react-dom";
import * as Caml_option from "bs-platform/lib/es6/caml_option.mjs";
import ReportWebVitals from "./reportWebVitals";
import * as App$RescriptOffline from "./App.bs.js";
import * as ServiceWorkerRegistration from "./serviceWorkerRegistration";

function reportWebVitals(prim) {
  ReportWebVitals();
  
}

function register(prim) {
  ServiceWorkerRegistration.register();
  
}

var rootQuery = document.querySelector("#root");

if (!(rootQuery == null)) {
  ReactDom.render(React.createElement(App$RescriptOffline.make, {}), rootQuery);
}

ServiceWorkerRegistration.register();

ReportWebVitals();

var rootQuery$1 = (rootQuery == null) ? undefined : Caml_option.some(rootQuery);

export {
  reportWebVitals ,
  register ,
  rootQuery$1 as rootQuery,
  
}
/* rootQuery Not a pure module */