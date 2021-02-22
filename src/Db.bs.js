// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Rxdb from "rxdb";
import SchemaJson from "./Schema.json";
import PouchdbAdapterIdb from "pouchdb-adapter-idb";

var schema = SchemaJson;

var RxChangeEvent = {};

var RxObservable = {};

var RxDocument = {};

var RxQueryObservable = {};

var RxQuery = {};

var RxCollection = {};

Rxdb.addRxPlugin(PouchdbAdapterIdb);

function make(param) {
  return Rxdb.createRxDatabase({
                name: "recipes",
                adapter: "idb"
              }).then(function (db) {
              var options = {};
              options["recipes"] = {
                schema: schema.recipes
              };
              options["tags"] = {
                schema: schema.tags
              };
              return db.addCollections(options).then(function (param) {
                          return Promise.resolve(db);
                        });
            });
}

function find(collection, options) {
  return collection.find(options);
}

function findAll(collection) {
  return collection.find();
}

function exec(query) {
  return query.exec();
}

function subscribe(query, subscription) {
  query.$.subscribe(subscription);
  
}

function subscribeAll(collection, subscription) {
  return subscribe(collection.find(), subscription);
}

export {
  schema ,
  RxChangeEvent ,
  RxObservable ,
  RxDocument ,
  RxQueryObservable ,
  RxQuery ,
  RxCollection ,
  make ,
  find ,
  findAll ,
  exec ,
  subscribe ,
  subscribeAll ,
  
}
/* schema Not a pure module */
