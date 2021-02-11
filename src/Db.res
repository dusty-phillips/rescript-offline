@module("pouchdb-adapter-idb") external pouchDbAdapter: 'pouch = "default"
@module("rxdb") external addRxPlugin: 'pouch => unit = "addRxPlugin"
@module("rxdb") external createRxDatabase: 'whatever = "createRxDatabase"

addRxPlugin(pouchDbAdapter)

let make = () => {
  createRxDatabase({"name": "recipes", "adapter": "idb"})->Promise.then(db => {
    Js.log2(`Loaded database`, db)
    db
  })
}
