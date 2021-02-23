open Belt

let displayRecipe = (recipe: Model.recipe, addTag: (Model.tag, Model.id) => Promise.t<unit>) => {
  <div className=CardStyles.card>
    <h2> {React.string(recipe.title)} </h2>
    <div>
      <h3> {React.string("Ingredients")} </h3> <div> {React.string(recipe.ingredients)} </div>
    </div>
    <div>
      <h3> {React.string("Instructions")} </h3> <div> {React.string(recipe.instructions)} </div>
    </div>
    <div>
      <h3> {React.string("Tags")} </h3>
      <div> {recipe.tags->Array.map(tag => <div> {React.string(tag)} </div>)->React.array} </div>
      <AddTag addTag recipeId={recipe.id} />
    </div>
  </div>
}

@react.component
let make = (
  ~recipes: Map.String.t<Model.recipe>,
  ~id: Model.id,
  ~addTag: (Model.tag, Model.id) => Promise.t<unit>,
) => {
  switch recipes->Map.String.get(id) {
  | None => <div> {React.string("Recipe with id " ++ id ++ " is not in your database")} </div>
  | Some(recipe) => displayRecipe(recipe, addTag)
  }
}
