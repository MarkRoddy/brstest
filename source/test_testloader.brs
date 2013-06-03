'Unit tests for the TestLoader class

Sub testTestLoader_findTestScripts_CompiledIfNotInSources(t as object)
    'Files not in the pkg:/sources directory should be compiled
    tl = brstNewTestLoader("Test", "test")
    tl.ListDir = function (fromdirectory as string)
        return ["TestFile1.brs", "TestFile2.brs", "TestFooBar.txt"]
    end function
    tl.CompiledFiles = 0
    tl.compileScript = function(scriptpath as string)
        m.CompiledFiles = m.CompiledFiles + 1
        return true
    End Function
    files = tl.findTestScripts("foo bar")
    t.assertEqual(2, files.Count())
    t.assertEqual(2, tl.CompiledFiles)
End Sub

Sub testTestLoader_findTestScripts_WithoutBrsIsIgnored(t as object)
    'Files with prefix but not with .brs ending should be ignored
    tl = brstNewTestLoader("Test", "test")
    tl.ListDir = function (fromdirectory as string)
        return ["TestFile1.brs", "TestFile2.brs", "TestFooBar.txt"]
    end function
    files = tl.findTestScripts("pkg:/sources")
    t.assertEqual(2, files.Count())
End Sub

Sub testTestLoader_findTestScripts_WithoutPrefixArentIncluded(t as object)
    'Only files with the prefix are reported
    tl = brstNewTestLoader("Test", "test")
    tl.ListDir = function (fromdirectory as string)
        return ["TestFile1.brs", "TestFile2.brs", "FooBar.brs"]
    end function
    files = tl.findTestScripts("pkg:/sources")
    t.assertEqual(2, files.Count())
End Sub

Sub testTestLoader_fixturesFromScriptContents_FunctionWithoutPrefixNotReturned(t as object)
    'Discovered function that doesn't be with prefix shouldn't be returned
    sub_code = chr(10)   + "Sub MeaninglessSub(t as object)"
    sub_code = sub_code + chr(10)
    sub_code = sub_code + "    i = 1 + 2"
    sub_code = sub_code + chr(10)
    sub_code = sub_code + "End Sub"
    sub_code = sub_code + chr(10)
    
    tl = brstNewTestLoader("Test", "test")
    fixtures = tl.fixturesFromScriptContents(sub_code, "")

    'No fixtures should be returned
    t.assertEqual(0, fixtures.Count())

End Sub


Sub testTestLoader_fixturesFromScriptContents_CommentedOutFunctionNotFound(t as object)
    'No fixtures should be found for commentted out function
sub_code = chr(10)   + "'Sub testTestLoader_fixturesFromScriptContents_TestSubFound(t as object)"
sub_code = sub_code + chr(10)
sub_code = sub_code + "'    i = 1 + 2"
sub_code = sub_code + chr(10)
sub_code = sub_code + "'End Sub"
sub_code = sub_code + chr(10)
    tl = brstNewTestLoader("Test", "test")
    fixtures = tl.fixturesFromScriptContents(sub_code, "")

    'No fixtures should be returned
    t.assertEqual(0, fixtures.Count())

End Sub

Sub testTestLoader_fixturesFromScriptContents_TestSubFound(t as object)
    'Sub declared with target prefix results in test fixture 
sub_code = chr(10)   + "Sub testTestLoader_fixturesFromScriptContents_TestSubFound(t as object)"
sub_code = sub_code + chr(10)
sub_code = sub_code + "    i = 1 + 2"
sub_code = sub_code + chr(10)
sub_code = sub_code + "End Sub"
sub_code = sub_code + chr(10)
    sname = "testTestLoader_fixturesFromScriptContents_TestSubFound"
    subref = testTestLoader_fixturesFromScriptContents_TestSubFound
    sdesc = "" '<--Update once message parsing is added
    tl = brstNewTestLoader("Test", "test")
    fixtures = tl.fixturesFromScriptContents(sub_code, "")

    'Only one fixture should be returned
    t.assertEqual(1, fixtures.Count())

    fixture = fixtures[0]
    actual_name = fixture.FuncName
    actual_func = fixture.TestFunc
    actual_desc = fixture.Descript

    t.assertEqual(sname, actual_name)
    t.assertEqual(subref,actual_func)
    t.assertEqual(sdesc, actual_desc)
End Sub

Function testTestLoader_fixturesFromScriptContents_TestFunctionFound(t as object) as void
    'Function declared with target prefix results in test fixture 
    'Purposely made a function so we have something to parse
func_code = chr(10)   + "Function testTestLoader_fixturesFromScriptContents_TestFunctionFound(t as object) as void"
func_code = func_code + chr(10)
func_code = func_code + "    return 1.5"
func_code = func_code + chr(10)
func_code = func_code + "End Function"
func_code = func_code + chr(10)
    fname = "testTestLoader_fixturesFromScriptContents_TestFunctionFound"
    func = testTestLoader_fixturesFromScriptContents_TestFunctionFound
    fdesc = "" '<--Update once message parsing is added
    tl = brstNewTestLoader("Test", "test")
    fixtures = tl.fixturesFromScriptContents(func_code, "")
    t.assertEqual(1, fixtures.Count())

    fixture = fixtures[0]
    actual_name = fixture.FuncName
    actual_func = fixture.TestFunc
    actual_desc = fixture.Descript

    t.assertEqual(fname, actual_name)
    t.assertEqual(func,actual_func)
    t.assertEqual(fdesc, actual_desc)
End Function

Sub testTestLoader_fixturesFromScriptContents_NoneFound(t as object)
    'Emtpy enumerable return if no tests were found
    tl = brstNewTestLoader("Test", "test")
    fixtures = tl.fixturesFromScriptContents("", "")
    t.assertEqual(0, fixtures.Count())
End Sub

Sub testTestLoader_findTestScripts_InSubDirectories(t as object)
    tl = brstNewTestLoader("Test", "test")

    tl.ListDir = Function(fromdirectory as string)
      if fromdirectory = "directory"
        return ["subDirectory1", "TestFile1.brs"]
      else if fromdirectory = "directory/subDirectory1"
        return ["TestFile2.brs", "subDirectory2", "TestFile3.brs"]
      else if fromdirectory = "directory/subDirectory1/subDirectory2"
        return ["TestFile4.brs", "TestFile5.brs", "TestFooBar.txt"]
      end if
    end Function

    tl.CompiledFiles = 0

    tl.compileScript = function(scriptpath as string)
        m.CompiledFiles = m.CompiledFiles + 1
        return true
    End Function

    files = tl.findTestScripts("directory")
    t.assertEqual(5, files.Count())
    t.assertEqual(5, tl.CompiledFiles)
End Sub

