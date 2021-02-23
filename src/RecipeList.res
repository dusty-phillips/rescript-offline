open Belt

@react.component
let make = (~recipeIds: array<string>, ~recipes: Map.String.t<Model.recipe>) => {
  <div>
    {recipeIds
    ->Array.map(recipeId => {
      recipes
      ->Map.String.get(recipeId)
      ->Option.map(recipe =>
        <div key={recipeId} onClick={_ => RescriptReactRouter.push(`/recipes/${recipe.id}`)}>
          {React.string(recipe.title)}
        </div>
      )
    })
    ->Array.keep(Option.isSome)
    ->Array.map(Option.getUnsafe)
    ->React.array}
  </div>
}
