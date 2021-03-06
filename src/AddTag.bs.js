// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Curry from "bs-platform/lib/es6/curry.js";
import * as React from "react";

function AddTag(Props) {
  var recipeId = Props.recipeId;
  var addTag = Props.addTag;
  var match = React.useState(function () {
        return "";
      });
  var setTag = match[1];
  var tag = match[0];
  return React.createElement("div", undefined, React.createElement("input", {
                  placeholder: "Add tag...",
                  value: tag,
                  onChange: (function ($$event) {
                      var tag = $$event.target.value;
                      return Curry._1(setTag, (function (param) {
                                    return tag;
                                  }));
                    })
                }), React.createElement("button", {
                  onClick: (function (param) {
                      Curry._2(addTag, tag, recipeId);
                      
                    })
                }, "Add Tag!"));
}

var make = AddTag;

export {
  make ,
  
}
/* react Not a pure module */
