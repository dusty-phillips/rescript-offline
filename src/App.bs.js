// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Curry from "bs-platform/lib/es6/curry.mjs";
import * as React from "react";
import LogoSvg from "./logo.svg";
import * as Belt_Array from "bs-platform/lib/es6/belt_Array.mjs";
import * as Belt_MapString from "bs-platform/lib/es6/belt_MapString.mjs";
import * as Db$RescriptOffline from "./Db.bs.js";

import './App.css';
;

var logo = LogoSvg;

function App(Props) {
  var match = React.useState(function () {
        
      });
  var setDb = match[1];
  var match$1 = React.useState(function () {
        
      });
  var setRecipes = match$1[1];
  React.useEffect((function () {
          var dbPromise = Db$RescriptOffline.make(undefined).then(function (db) {
                Curry._1(setDb, (function (param) {
                        return db;
                      }));
                Db$RescriptOffline.subscribeAll(db.recipes, (function (recipeDocs) {
                        var newRecipes = Belt_Array.reduce(Belt_Array.map(recipeDocs, (function (prim) {
                                    return prim.toJSON();
                                  })), undefined, (function (recipes, recipe) {
                                return Belt_MapString.set(recipes, recipe.id, recipe);
                              }));
                        return Curry._1(setRecipes, (function (_prev) {
                                      return newRecipes;
                                    }));
                      }));
                return db;
              });
          return (function (param) {
                    dbPromise.then(function (db) {
                          return db.destroy();
                        });
                    
                  });
        }), [
        setDb,
        setRecipes
      ]);
  console.log("db is", match[0]);
  console.log("recipes is", Belt_MapString.toArray(match$1[0]));
  return React.createElement("div", {
              className: "App"
            }, React.createElement("header", {
                  className: "App-header"
                }, React.createElement("img", {
                      className: "App-logo",
                      alt: "logo",
                      src: logo
                    }), React.createElement("p", undefined, "Edit ", React.createElement("code", undefined, "src/App.js"), " and save to reload."), React.createElement("a", {
                      className: "App-link",
                      href: "https://reactjs.org",
                      rel: "noopener noreferrer",
                      target: "_blank"
                    }, "Learn React")));
}

var make = App;

export {
  logo ,
  make ,
  
}
/*  Not a pure module */
