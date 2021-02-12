@module("pouchdb-adapter-idb") external pouchDbAdapter: 'pouch = "default"
@module("rxdb") external addRxPlugin: 'pouch => unit = "addRxPlugin"

type createRxDatabaseOptions = {
  name: string,
  adapter: string,
}

type t

@module("rxdb")
external createRxDatabase: createRxDatabaseOptions => Promise.t<t> = "createRxDatabase"

addRxPlugin(pouchDbAdapter)

let make: unit => Promise.t<t> = () => {
  createRxDatabase({name: "recipes", adapter: "idb"})->Promise.then(db => {
    Js.log2(`Loaded database`, db)
    db->Promise.resolve
  })
}

@send external destroy: t => Promise.t<unit> = "destroy"
