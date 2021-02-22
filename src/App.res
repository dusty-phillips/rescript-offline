%%raw(`import './App.css';`)

@module("./logo.svg") external logo: string = "default"

@react.component
let make = () => {
  let (db, setDb) = React.useState(() => None)
  let (recipes, setRecipes) = React.useState(_ => Belt.Map.String.empty)

  React.useEffect2(() => {
    let dbPromise = Db.make()->Promise.map(db => {
      setDb(_ => Some(db))

      db.recipes->Db.subscribeAll(recipeDocs => {
        let newRecipes =
          recipeDocs
          ->Belt.Array.map(Db.RxDocument.recipe)
          ->Belt.Array.reduce(Belt.Map.String.empty, (recipes, recipe) => {
            recipes->Belt.Map.String.set(recipe.id, recipe)
          })
        setRecipes(_prev => newRecipes)
      })

      db
    })

    Some(
      () => {
        let _ = dbPromise->Promise.then(db => db->Db.destroy)
      },
    )
  }, (setDb, setRecipes))

  Js.log2("db is", db)
  Js.log2("recipes is", recipes->Belt.Map.String.toArray)

  <div className="App">
    <header className="App-header">
      <img src={logo} className="App-logo" alt="logo" />
      <p>
        {React.string("Edit ")}
        <code> {React.string("src/App.js")} </code>
        {React.string(" and save to reload.")}
      </p>
      <a className="App-link" href="https://reactjs.org" target="_blank" rel="noopener noreferrer">
        {React.string("Learn React")}
      </a>
    </header>
  </div>
}
