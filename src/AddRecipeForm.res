@module("uuid") external uuid: unit => string = "v4"

module Styles = {
  open CssJs
  let longEntry = style(. [
    width(100.0->#percent),
    maxWidth(20.0->#rem),
    borderRadius(0.5->#rem),
    padding(0.5->#rem),
  ])
}

@react.component
let make = (~addRecipe: Model.recipe => Promise.t<unit>) => {
  let (title, setTitle) = React.useState(() => "")
  let (ingredients, setIngredients) = React.useState(() => "")
  let (instructions, setInstructions) = React.useState(() => "")
  <div className=CardStyles.formCard>
    <div>
      <input
        className=Styles.longEntry
        placeholder="Title"
        value={title}
        onChange={event => {
          let title = ReactEvent.Form.target(event)["value"]
          setTitle(_ => title)
        }}
      />
    </div>
    <div>
      <label>
        <h3> {React.string("Ingredients")} </h3>
        <textarea
          className=Styles.longEntry
          onChange={event => {
            let ingredients = ReactEvent.Form.target(event)["value"]
            setIngredients(_ => ingredients)
          }}
          value={ingredients}
        />
      </label>
    </div>
    <div>
      <label>
        <h3> {React.string("Instructions")} </h3>
        <textarea
          className=Styles.longEntry
          onChange={event => {
            let instructions = ReactEvent.Form.target(event)["value"]
            setInstructions(_ => instructions)
          }}
          value={instructions}
        />
      </label>
    </div>
    <button
      onClick={_ => {
        let id = uuid()
        addRecipe({
          id: id,
          title: title,
          ingredients: ingredients,
          instructions: instructions,
          tags: [],
          updatedAt: Js.Date.now(),
        })
        ->Promise.map(_ => RescriptReactRouter.push(`/recipes/${id}`))
        ->ignore
      }}>
      {React.string("Add!")}
    </button>
  </div>
}
