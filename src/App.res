open Belt

let addTagCallback = (
  db: Db.t,
  recipes: Map.String.t<Model.recipe>,
  tags: Map.String.t<array<Model.id>>,
  tag: Model.tag,
  id: Model.id,
) => {
  switch recipes->Map.String.get(id) {
  | None => Promise.resolve()
  | Some(recipe) => {
      let tagRecord: Model.taggedRecipes = {
        tag: tag,
        recipes: tags->Map.String.get(tag)->Option.getWithDefault([])->Array.concat([id]),
      }
      let newRecipe = {...recipe, tags: recipe.tags->Array.concat([tag])}

      Promise.all([
        db.recipes->Db.RxCollection.upsert(newRecipe)->Promise.map(_ => ()),
        db.tags->Db.RxCollection.upsert(tagRecord)->Promise.map(_ => ()),
      ])->Promise.map(_ => ())
    }
  }
}

@react.component
let make = () => {
  let (dbOption, setDb) = React.useState(() => None)
  let (recipes, setRecipes) = React.useState(_ => Map.String.empty)
  let (tags, setTags) = React.useState(_ => Map.String.empty)
  let url = RescriptReactRouter.useUrl()

  React.useEffect3(() => {
    let dbPromise = Db.make()->Promise.map(db => {
      setDb(_ => Some(db))

      db.recipes->Db.subscribeAll(recipeDocs => {
        let newRecipes =
          recipeDocs
          ->Array.map(Db.RxDocument.recipe)
          ->Array.reduce(Map.String.empty, (recipes, recipe) => {
            recipes->Map.String.set(recipe.id, recipe)
          })
        setRecipes(_prev => newRecipes)
      })

      db.tags->Db.subscribeAll(tagDocs => {
        let newTags =
          tagDocs
          ->Array.map(Db.RxDocument.taggedRecipes)
          ->Array.reduce(Map.String.empty, (tags, taggedRecipes) => {
            tags->Map.String.set(taggedRecipes.tag, taggedRecipes.recipes)
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
      | list{"recipes", id} =>
        <div>
          {<ViewRecipe
            recipes id addTag={(tag, id) => addTagCallback(db, recipes, tags, tag, id)}
          />}
        </div>
      | list{"tags"} => <AllTags tags recipes />
      | list{} => <div> {React.string("Home page")} </div>
      | _ => <div> {React.string("Route not found")} </div>
      }

      <div> <NavBar /> {component} </div>
    }
  }
}
