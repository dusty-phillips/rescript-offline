open Belt

@react.component
let make = (~tags: Map.String.t<array<string>>, ~recipes: Map.String.t<Model.recipe>) => {
  let tagComponents =
    tags
    ->Map.String.toArray
    ->Array.map(((tag, recipeIds)) =>
      <div key={tag}> <h2> {React.string(tag)} </h2> <RecipeList recipeIds recipes /> </div>
    )
    ->React.array
  <div className=CardStyles.card> {tagComponents} </div>
}
