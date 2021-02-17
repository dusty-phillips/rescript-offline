@module("pouchdb-adapter-idb") external pouchDbAdapter: 'pouch = "default"
@module("rxdb") external addRxPlugin: 'pouch => unit = "addRxPlugin"
@module("./Schema.json") external schema: {"recipes": 'schema, "tags": 'schema} = "default"

module RxDocument = {
  type t<'docType>
  @send external recipe: t<Model.recipe> => Model.recipe = "toJSON"
  @send external taggedRecipes: t<Model.taggedRecipes> => Model.taggedRecipes = "toJSON"
}

module RxQuery = {
  type t<'docType>
  @send external exec: t<'docType> => Promise.t<array<RxDocument.t<'docType>>> = "exec"
}

module RxCollection = {
  type t<'docType>

  @send external insert: (t<'docType>, 'doctype) => Promise.t<RxDocument.t<'docType>> = "insert"
  @send external find: t<'docType> => RxQuery.t<'docType> = "find"
}

type createRxDatabaseOptions = {
  name: string,
  adapter: string,
}

type t = {
  recipes: RxCollection.t<Model.recipe>,
  tags: RxCollection.t<Model.taggedRecipes>,
}

@module("rxdb")
external createRxDatabase: createRxDatabaseOptions => Promise.t<t> = "createRxDatabase"

type addCollectionsOptions<'schema> = {schema: 'schema}

@send
external addCollections: (
  t,
  Js.Dict.t<addCollectionsOptions<'schema>>,
) => Promise.t<Js.Dict.t<RxCollection.t<'docType>>> = "addCollections"

addRxPlugin(pouchDbAdapter)

let make: unit => Promise.t<t> = () => {
  createRxDatabase({name: "recipes", adapter: "idb"})->Promise.then(db => {
    let options = Js.Dict.empty()
    options->Js.Dict.set("recipes", {schema: schema["recipes"]})
    options->Js.Dict.set("tags", {schema: schema["tags"]})

    db->addCollections(options)->Promise.then(_ => Promise.resolve(db))
  })
}

@send external destroy: t => Promise.t<unit> = "destroy"

let find = collection => RxCollection.find(collection)
let exec = query => RxQuery.exec(query)
