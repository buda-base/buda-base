#!/usr/bin/env python3

from SPARQLWrapper import *
import os
import os.path as path
import json
import glob

QueryEndpoint = SPARQLWrapper("http://localhost:13180/fuseki/bdrcrw/query")
QueryEndpoint.setRequestMethod(POSTDIRECTLY)
QueryEndpoint.setMethod(POST)
QueryEndpoint.setReturnFormat(JSON)
UpdateEndpoint = SPARQLWrapper("http://localhost:13180/fuseki/bdrcrw/update")
UpdateEndpoint.setRequestMethod(POSTDIRECTLY)
UpdateEndpoint.setMethod(POST)
ThisPath = os.path.dirname(os.path.abspath(__file__))

def get_all_tests(testgroupname, specifictest=None):
    grouppath = path.join(ThisPath, testgroupname)
    res = []
    if specifictest is not None:
        res.append(path.join(grouppath, specifictest))
        return res
    for dirname in sorted(glob.glob(grouppath+"/*")):
        if path.isdir(dirname):
            res.append(dirname)
    return res

def run_test(testdir):
    queryPath = path.join(testdir, "request.arq")
    queryStr = None
    with open(queryPath, 'r') as myfile:
        queryStr = myfile.read()
    QueryEndpoint.setQuery(queryStr)
    print("executing "+queryPath)
    results = QueryEndpoint.query().convert()
    exprectedPath = path.join(testdir, "expected.json")
    expectedData = None
    with open(exprectedPath) as f:
        expectedData = json.load(f)
    resultsOrderedStr = json.dumps(results, sort_keys=True, indent=4, ensure_ascii=False)
    expectedOrderedStr = json.dumps(expectedData, sort_keys=True, indent=4, ensure_ascii=False)
    testname = path.relpath(testdir)
    if (resultsOrderedStr != expectedOrderedStr):
        print("ERR: test "+testname+" fails, got:")
        print(resultsOrderedStr)
    else:
        print("OK: test "+testname+" passes")

def run_testgroup(testgroupname, specifictest=None):
    prepath = path.join(ThisPath, testgroupname, "pre.arq")
    preStr = None
    with open(prepath, 'r') as myfile:
        preStr = myfile.read()
    UpdateEndpoint.setQuery(preStr)
    print("executing "+prepath)
    UpdateEndpoint.query()
    testdirs = get_all_tests(testgroupname, specifictest)
    for testdir in testdirs:
        run_test(testdir)
    postpath = path.join(ThisPath, testgroupname, "post.arq")
    postStr = None
    with open(postpath, 'r') as myfile:
        postStr = myfile.read()
    print("executing "+postpath)
    UpdateEndpoint.setQuery(postStr)
    UpdateEndpoint.query()

if __name__ == '__main__':
    run_testgroup("lucene-zh")
    #run_testgroup("lucene-sa")