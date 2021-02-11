@module("pouchdb-adapter-idb") external pouchDbAdapter: 'pouch = "default"
@module("rxdb") external addRxPlugin: 'pouch => unit = "addRxPlugin"
@module("rxdb") external createRxDatabase: 'whatever = "createRxDatabase"

addRxPlugin(pouchDbAdapter)
