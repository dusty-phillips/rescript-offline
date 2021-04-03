@module("pouchdb-adapter-idb") external pouchDbAdapter: 'pouch = "default"
@module("rxdb") external addRxPlugin: 'pouch => unit = "addRxPlugin"
@module("./Schema.json") external schema: {"recipes": 'schema, "tags": 'schema} = "default"

module RxChangeEvent = {
  type t<'docType> = {
    documentData: 'docType,
    id: string,
    operation: [#INSERT | #UPDATE | #REMOVE],
    collectionName: [#recipes | #tags],
  }
}

module RxObservable = {
  type t<'docType>

  @send external subscribe: (t<'docType>, RxChangeEvent.t<'docType> => unit) => unit = "subscribe"
}

module RxDocument = {
  type t<'docType>
  @send external recipe: t<Model.recipe> => Model.recipe = "toJSON"
  @send external taggedRecipes: t<Model.taggedRecipes> => Model.taggedRecipes = "toJSON"
}

module RxQueryObservable = {
  type t<'docType>

  @send
  external subscribe: (t<'docType>, array<RxDocument.t<'docType>> => unit) => unit = "subscribe"
}

module RxQuery = {
  type t<'docType>
  @send external exec: t<'docType> => Promise.t<array<RxDocument.t<'docType>>> = "exec"
  @get external observable: t<'docType> => RxQueryObservable.t<'docType> = "$"
}

module RxCollection = {
  type t<'docType>

  @send external insert: (t<'docType>, 'doctype) => Promise.t<RxDocument.t<'docType>> = "insert"
  @send external upsert: (t<'docType>, 'doctype) => Promise.t<RxDocument.t<'docType>> = "upsert"
  @send external find: (t<'docType>, option<Js.t<'options>>) => RxQuery.t<'docType> = "find"
  @send external findAll: t<'docType> => RxQuery.t<'docType> = "find"
  @send
  external syncGraphQL: (t<'docType>, Sync.syncGraphQLOptions<'docType>) => unit = "syncGraphQL"

  @get external observable: t<'docType> => RxObservable.t<'docType> = "$"
  @get external insertObservable: t<'docType> => RxObservable.t<'docType> = "insert$"
  @get external updateObservable: t<'docType> => RxObservable.t<'docType> = "update$"
  @get external removeObservable: t<'docType> => RxObservable.t<'docType> = "remove$"
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

@get external observable: t => RxObservable.t<'docType> = "$"

addRxPlugin(pouchDbAdapter)
addRxPlugin(Sync.graphqlReplicationPlugin)

let make: unit => Promise.t<t> = () => {
  createRxDatabase({name: "recipes", adapter: "idb"})->Promise.then(db => {
    let options = Js.Dict.empty()
    options->Js.Dict.set("recipes", {schema: schema["recipes"]})
    options->Js.Dict.set("tags", {schema: schema["tags"]})

    db->addCollections(options)->Promise.then(_ => Promise.resolve(db))
  })
}

@send external destroy: t => Promise.t<unit> = "destroy"

let find = (collection, options) => RxCollection.find(collection, options)
let findAll = collection => RxCollection.findAll(collection)
let exec = query => RxQuery.exec(query)
let subscribe = (query, subscription) =>
  query->RxQuery.observable->RxQueryObservable.subscribe(subscription)
let subscribeAll = (collection, subscription) => collection->findAll->subscribe(subscription)
