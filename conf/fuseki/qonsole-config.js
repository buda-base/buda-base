/** Standalone configuration for qonsole on index page */

define( [], function() {
  return {
    prefixes: {
        "rdf"   : "http://www.w3.org/1999/02/22-rdf-syntax-ns#",
        "rdfs"  : "http://www.w3.org/2000/01/rdf-schema#",
        "owl"   : "http://www.w3.org/2002/07/owl#",
        "skos"  : "http://www.w3.org/2004/02/skos/core#",
        "text"  : "http://jena.apache.org/text#",
        "xsd"   : "http://www.w3.org/2001/XMLSchema#",
        ""      : "http://purl.bdrc.io/ontology/core/",
        "adm"   : "http://purl.bdrc.io/ontology/admin/",
        "adr"   : "http://purl.bdrc.io/resource-auth/",
        "aut"   : "http://purl.bdrc.io/ontology/ext/auth/",
        "bda"   : "http://purl.bdrc.io/admindata/",
        "bdg"   : "http://purl.bdrc.io/graph/",
        "bdo"   : "http://purl.bdrc.io/ontology/core/",
        "bdr"   : "http://purl.bdrc.io/resource/",
        "bdan"  : "http://purl.bdrc.io/annotation/",
        "bdac"  : "http://purl.bdrc.io/anncollection/",
        "tbr"   : "http://purl.bdrc.io/ontology/toberemoved/",
        "oa"	  : "http://www.w3.org/ns/oa#",
        "as"    : "http://www.w3.org/ns/activitystreams#",
        "bd"    : "http://www.bigdata.com/rdf#",
        "foaf"  : "http://xmlns.com/foaf/0.1/",
        "dila"  : "http://purl.dila.edu.tw/resource/",
        "eftr"  : "http://purl.84000.co/resource/core/",
        "lcsh"  : "http://id.loc.gov/authorities/subjects/",
        "mbbt"  : "http://mbingenheimer.net/tools/bibls/",
        "vcard" : "http://www.w3.org/2006/vcard/ns#",
        "viaf"  : "http://viaf.org/viaf/",
        "wd"    : "http://www.wikidata.org/entity/"
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
