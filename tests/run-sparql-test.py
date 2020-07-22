#!/usr/bin/env python3

from SPARQLWrapper import *
import os
import os.path as path
import json
import glob
import time

#BaseUrl="http://buda1.bdrc.io:13180/fuseki/bdrcrw/"
BaseUrl="http://localhost:13180/fuseki/corerw/"

QueryEndpoint = SPARQLWrapper(BaseUrl+"query")
QueryEndpoint.setRequestMethod(POSTDIRECTLY)
QueryEndpoint.setMethod(POST)
QueryEndpoint.setReturnFormat(JSON)
UpdateEndpoint = SPARQLWrapper(BaseUrl+"update")
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
    expectedData = {}
    if (path.isfile(exprectedPath)):
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

def run_pre_post(testgroupname, name):
    prepath = path.join(ThisPath, testgroupname, name+".arq")
    preStr = None
    with open(prepath, 'r') as myfile:
        preStr = myfile.read()
    UpdateEndpoint.setQuery(preStr)
    print("executing "+prepath)
    UpdateEndpoint.query()

def run_testgroup(testgroupname, specifictest=None):
    run_pre_post(testgroupname, "post")
    run_pre_post(testgroupname, "pre")
    print("let a few seconds for the index to be generated")
    time.sleep(5)
    testdirs = get_all_tests(testgroupname, specifictest)
    for testdir in testdirs:
        run_test(testdir)
    #run_pre_post(testgroupname, "post")

if __name__ == '__main__':
    run_testgroup("lucene-zh")
    #run_testgroup("lucene-sa", "test1")
    #run_testgroup("lucene-sa", "test3")
    #run_testgroup("lucene-bo")