@module("pouchdb-adapter-idb") external pouchDbAdapter: 'pouch = "default"
@module("rxdb") external addRxPlugin: 'pouch => unit = "addRxPlugin"
@module("./Schema.json") external schema: {"recipes": 'schema, "tags": 'schema} = "default"

type createRxDatabaseOptions = {
  name: string,
  adapter: string,
}

type t

@module("rxdb")
external createRxDatabase: createRxDatabaseOptions => Promise.t<t> = "createRxDatabase"

type addCollectionsOptions<'schema> = {schema: 'schema}

@send
external addCollections: (t, Js.Dict.t<addCollectionsOptions<'schema>>) => Promise.t<'collections> =
  "addCollections"

addRxPlugin(pouchDbAdapter)

let make: unit => Promise.t<t> = () => {
  createRxDatabase({name: "recipes", adapter: "idb"})->Promise.then(db => {
    Js.log2(`Loaded database`, db)
    db->Promise.resolve
  })
}

@send external destroy: t => Promise.t<unit> = "destroy"
