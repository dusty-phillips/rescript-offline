// Generated by ReScript, PLEASE EDIT WITH CARE

import * as React from "react";
import * as Belt_Array from "bs-platform/lib/es6/belt_Array.js";
import * as Belt_MapString from "bs-platform/lib/es6/belt_MapString.js";
import * as AddTag$RescriptOffline from "./AddTag.bs.js";
import * as CardStyles$RescriptOffline from "./CardStyles.bs.js";

function displayRecipe(recipe, addTag) {
  return React.createElement("div", {
              className: CardStyles$RescriptOffline.card
            }, React.createElement("h2", undefined, recipe.title), React.createElement("div", undefined, React.createElement("h3", undefined, "Ingredients"), React.createElement("div", undefined, recipe.ingredients)), React.createElement("div", undefined, React.createElement("h3", undefined, "Instructions"), React.createElement("div", undefined, recipe.instructions)), React.createElement("div", undefined, React.createElement("h3", undefined, "Tags"), React.createElement("div", undefined, Belt_Array.map(recipe.tags, (function (tag) {
                            return React.createElement("div", undefined, tag);
                          }))), React.createElement(AddTag$RescriptOffline.make, {
                      recipeId: recipe.id,
                      addTag: addTag
                    })));
}

function ViewRecipe(Props) {
  var recipes = Props.recipes;
  var id = Props.id;
  var addTag = Props.addTag;
  var recipe = Belt_MapString.get(recipes, id);
  if (recipe !== undefined) {
    return displayRecipe(recipe, addTag);
  } else {
    return React.createElement("div", undefined, "Recipe with id " + id + " is not in your database");
  }
}

var make = ViewRecipe;

export {
  displayRecipe ,
  make ,
  
}
/* react Not a pure module */
