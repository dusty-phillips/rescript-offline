@module("pouchdb-adapter-idb") external pouchDbAdapter: 'pouch = "default"
@module("rxdb") external addRxPlugin: 'pouch => unit = "addRxPlugin"
@module("./Schema.json") external schema: {"recipes": 'schema, "tags": 'schema} = "default"

module RxDocument = {
  type t<'docType>
}

module RxCollection = {
  type t<'docType>

  @send external insert: (t<'docType>, 'doctype) => Promise.t<RxDocument.t<'docType>> = "insert"
}

type createRxDatabaseOptions = {
  name: string,
  adapter: string,
}

type t

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
