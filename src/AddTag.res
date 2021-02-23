@react.component
let make = (~recipeId: Model.id, ~addTag: (Model.tag, Model.id) => Promise.t<unit>) => {
  let (tag, setTag) = React.useState(() => "")
  <div>
    <input
      placeholder="Add tag..."
      value={tag}
      onChange={event => {
        let tag = ReactEvent.Form.target(event)["value"]
        setTag(_ => tag)
      }}
    />
    <button
      onClick={_ => {
        addTag(tag, recipeId)->ignore
      }}>
      {React.string("Add Tag!")}
    </button>
  </div>
}
