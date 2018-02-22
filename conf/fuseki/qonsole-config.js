/** Standalone configuration for qonsole on index page */

define( [], function() {
  return {
    prefixes: {
      "" : "http://purl.bdrc.io/ontology/core/",
      "adm" : "http://purl.bdrc.io/ontology/admin/",
      "bdd" : "http://purl.bdrc.io/data/",
      "bdo" : "http://purl.bdrc.io/ontology/core/",
      "bdr" : "http://purl.bdrc.io/resource/",
      "owl" : "http://www.w3.org/2002/07/owl#",
      "rdf" : "http://www.w3.org/1999/02/22-rdf-syntax-ns#",
      "rdfs" : "http://www.w3.org/2000/01/rdf-schema#",
      "skos" : "http://www.w3.org/2004/02/skos/core#",
      "tbr" : "http://purl.bdrc.io/ontology/toberemoved/",
      "text" : "http://jena.apache.org/text#",
      "vcard" : "http://www.w3.org/2006/vcard/ns#",
      "xsd" : "http://www.w3.org/2001/XMLSchema#"
    },
    queries: [
      { "name": "Selection of triples",
        "query": "SELECT ?subject ?predicate ?object\nWHERE {\n" +
                 "  ?subject ?predicate ?object\n}\n" +
                 "LIMIT 25"
      },
      { "name": "Selection of classes",
        "query": "SELECT DISTINCT ?class ?label ?description\nWHERE {\n" +
                 "  ?class a owl:Class.\n" +
                 "  OPTIONAL { ?class rdfs:label ?label}\n" +
                 "  OPTIONAL { ?class rdfs:comment ?description}\n}\n" +
                 "LIMIT 25",
        "prefixes": ["owl", "rdfs"]
      }
    ]
  };
} );
