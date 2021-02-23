%%raw(`import './App.css';`)

@module("./logo.svg") external logo: string = "default"

@react.component
let make = () => {
  let (dbOption, setDb) = React.useState(() => None)
  let (recipes, setRecipes) = React.useState(_ => Belt.Map.String.empty)
  let (tags, setTags) = React.useState(_ => Belt.Map.String.empty)
  let url = RescriptReactRouter.useUrl()

  React.useEffect3(() => {
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

      db.tags->Db.subscribeAll(tagDocs => {
        let newTags =
          tagDocs
          ->Belt.Array.map(Db.RxDocument.taggedRecipes)
          ->Belt.Array.reduce(Belt.Map.String.empty, (tags, taggedRecipes) => {
            tags->Belt.Map.String.set(taggedRecipes.tag, taggedRecipes.recipes)
          })
        setTags(_prev => newTags)
      })

      db
    })

    Some(
      () => {
        let _ = dbPromise->Promise.then(db => db->Db.destroy)
      },
    )
  }, (setDb, setRecipes, setTags))

  switch dbOption {
  | None => <div> {React.string("Loading your database...")} </div>
  | Some(db) => {
      let component = switch url.path {
      | list{"recipes", "add"} =>
        <AddRecipeForm
          addRecipe={recipe => db.recipes->Db.RxCollection.insert(recipe)->Promise.map(_ => ())}
        />
      | list{"recipes", title} => <div> {<ViewRecipe state title dispatch />} </div>
      | list{"tags"} => <AllTags tags recipes />
      | list{} => <div> {React.string("Home page")} </div>
      | _ => <div> {React.string("Route not found")} </div>
      }

      <div> <NavBar /> {component} </div>
    }
  }
}
