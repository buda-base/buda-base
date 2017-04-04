/** Standalone configuration for qonsole on index page */

define( [], function() {
  return {
    prefixes: {
      "rdf":      "http://www.w3.org/1999/02/22-rdf-syntax-ns#",
      "rdfs":     "http://www.w3.org/2000/01/rdf-schema#",
      "owl":      "http://www.w3.org/2002/07/owl#",
      "xsd":      "http://www.w3.org/2001/XMLSchema#",
      "crp":      "http://purl.bdrc.io/ontology/corporation#",
      "desc":     "http://purl.bdrc.io/ontology/product#",
      "lin":      "http://purl.bdrc.io/ontology/lineage#",
      "ofc":      "http://purl.bdrc.io/ontology/office#",
      "out":      "http://purl.bdrc.io/ontology/outline#",
      "per":      "http://purl.bdrc.io/ontology/person#",
      "plc":      "http://purl.bdrc.io/ontology/place#",
      "prd":      "http://purl.bdrc.io/ontology/product#",
      "root":     "http://purl.bdrc.io/ontology/root#",
      "":         "http://purl.bdrc.io/ontology/root#",
      "top":      "http://purl.bdrc.io/ontology/topic#",
      "vol":      "http://purl.bdrc.io/ontology/volumes#",
      "wor":      "http://purl.bdrc.io/ontology/work#"
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
