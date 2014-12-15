'Unit tests for the TestSuite class


Sub testTestSuite_addTests_EmptySet(t as object)
    'No tests added when empty collection passed to addTests()
    ts = brstNewTestSuite(CreateObject("roList"))
    t.assertEqual(0, ts.countTestCases())

    ts.addTests(CreateObject("roList"))
    t.assertEqual(0, ts.countTestCases())

    ts.addTests(CreateObject("roAssociativeArray"))
    t.assertEqual(0, ts.countTestCases())

    ts.addTests(CreateObject("roArray", 0, False))
    t.assertEqual(0, ts.countTestCases())

End Sub

Sub testTestSuite_EmptySetToConstructor(t as Object)
    'No tests should be added if created with an empty collection
    ts = brstNewTestSuite(CreateObject("roList"))
    t.assertEqual(0, ts.countTestCases())
    ts = brstNewTestSuite(CreateObject("roArray", 0, False))
    t.assertEqual(0, ts.countTestCases())
    ts = brstNewTestSuite(CreateObject("roAssociativeArray"))
    t.assertEqual(0, ts.countTestCases())

End Sub

Sub testtsAddTestsAllTestsAreRun(t as object)
    'All tests added via addTests() should be run via the suite's run() method
    mock_result = CreateObject("roAssociativeArray")
    mock_result.TotalRunCalls = 0
    mock_result.shouldStop = False

    mock_test1 = CreateObject("roAssociativeArray")
    mock_test1.countTestCases = function() 
        return 1
    end function
    mock_test1.run = function(r)
        r.TotalRunCalls = r.TotalRunCalls + 1
    end function

    mock_test2 = CreateObject("roAssociativeArray")
    mock_test2.countTestCases = function() 
        return 1
    end function
    mock_test2.run = function(r)
        r.TotalRunCalls = r.TotalRunCalls + 1
    end function

    ts = brstNewTestSuite(CreateObject("roList"))
    test_set = CreateObject("roArray", 2, false)
    test_set.push(mock_test1)
    test_set.push(mock_test2)
    ts.addTests(test_set)
    ts.run(mock_result)    
    t.assertEqual(2, mock_result.TotalRunCalls)
End Sub

Sub testtsAddTestNewTestIsRun(t as object)
    'After adding test case to suite it should be run with the suite
    mock_result = CreateObject("roAssociativeArray")
    mock_result.mock_test_run = False
    mock_result.shouldstop = False

    mock_test1 = CreateObject("roAssociativeArray")
    mock_test1.countTestCases = function() 
        return 1
    end function
    mock_test1.run = function(r)
        r.mock_test_run = True
    end function

    ts = brstNewTestSuite(CreateObject("roList"))
    ts.addTest(mock_test1)
    ts.run(mock_result)    
    t.assertTrue(mock_result.mock_test_run)
End Sub


Sub testtsRunNothingAfterShouldStopSetToTrue(t as object)
    'run() should stop running tests after ShouldStop on result is true
    mock_result = CreateObject("roAssociativeArray")
    mock_result.TotalRunCalls = 0
    mock_result.shouldStop = False

    mock_test1 = CreateObject("roAssociativeArray")
    mock_test1.countTestCases = function() 
        return 1
    end function
    mock_test1.run = function(r)
        r.TotalRunCalls = r.TotalRunCalls + 1
        r.shouldStop = True
    end function

    mock_test2 = CreateObject("roAssociativeArray")
    mock_test2.countTestCases = function() 
        return 1
    end function
    mock_test2.run = function(r)
        r.TotalRunCalls = r.TotalRunCalls + 1
    end function

    ts = brstNewTestSuite(CreateObject("roList"))
    ts.addTest(mock_test1)
    ts.addTest(mock_test2)
    ts.run(mock_result)    
    t.assertEqual(1, mock_result.TotalRunCalls)
End Sub

Sub testtsRunCalledForEachTest(t as object)
    'run() should call run for each test case
    mock_result = CreateObject("roAssociativeArray")
    mock_result.TotalRunCalls = 0
    mock_result.shouldStop = False

    mock_test1 = CreateObject("roAssociativeArray")
    mock_test1.countTestCases = function() 
        return 1
    end function
    mock_test1.run = function(r)
        r.TotalRunCalls = r.TotalRunCalls + 1
    end function

    mock_test2 = CreateObject("roAssociativeArray")
    mock_test2.countTestCases = function() 
        return 1
    end function
    mock_test2.run = function(r)
        r.TotalRunCalls = r.TotalRunCalls + 1
    end function

    ts = brstNewTestSuite(CreateObject("roList"))
    ts.addTest(mock_test1)
    ts.addTest(mock_test2)
    ts.run(mock_result)    
    t.assertEqual(2, mock_result.TotalRunCalls)

End Sub


Sub testtsCountTestCasesSumsTestsAdded(t as object)
    'CountTestCases() returns sum of same method for all test
    mock_test1 = CreateObject("roAssociativeArray")
    mock_test1.countTestCases = function() 
        return 4
    end function
    mock_test1.run = function()
        return ""
    end function

    mock_test2 = CreateObject("roAssociativeArray")
    mock_test2.countTestCases = function() 
        return 3
    end function
    mock_test2.run = function()
        return ""
    end function

    expected_tests = 7
    ts = brstNewTestSuite(CreateObject("roList"))
    ts.addTest(mock_test1)
    ts.addTest(mock_test2)
    actual_tests = ts.countTestCases()
    t.assertEqual(expected_tests, actual_tests)
End Sub
    

Sub testtsCountTestCasesZeroIfNoTests(t as object)
    'CountTestCases() returns 0 if no tests added
    faketests = CreateObject("roList")
    ts = brstNewTestSuite(faketests)
    actual_tests = ts.countTestCases()
    t.assertEqual(0, actual_tests)
End Sub

Sub testttsPrintFileNameOnFailure(t as object)
    tl = brstNewTestLoader("Test", "test")
    fixtures = tl.fixturesFromScript("pkg:/source/examples/test_examples.brs")
    t.assertEqual("pkg:/source/examples/test_examples.brs", fixtures[0].testScriptPath)
End Sub



