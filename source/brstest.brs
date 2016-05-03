'
'brstest - A framework for writing xUnit style tests in the BrightScript programming language
'
'Example test fixture:
'
'Sub testAddition(t as object)
'    a = 1
'    b = 2
'    t.assertEqual(3, a + b)
'End Sub
'
'
'  Copyright (c) 2010 Mark Roddy
'
'  Permission is hereby granted, free of charge, to any person
'  obtaining a copy of this software and associated documentation
'  files (the "Software"), to deal in the Software without
'  restriction, including without limitation the rights to use,
'  copy, modify, merge, publish, distribute, sublicense, and/or sell
'  copies of the Software, and to permit persons to whom the
'  Software is furnished to do so, subject to the following
'  conditions:
'
'  The above copyright notice and this permission notice shall be
'  included in all copies or substantial portions of the Software.
'
'  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
'  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
'  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
'  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
'  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
'  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
'  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
'  OTHER DEALINGS IN THE SOFTWARE.

Sub BrsTestMain(socket=Invalid as Object, TestFilePrefix="Test" as string, TestMethodPrefix="test" as string, TestDirectory="pkg:/source" as string)

    if socket <> Invalid AND socket.isConnected() then m.socket = socket

    'Run all test fixtures found in the package using
    'the standard naming conventions
    'Discovers and runs test fixtures based upon the supplied arguments
    tl = brstNewTestLoader(TestFilePrefix, TestMethodPrefix)
    suite=tl.suiteFromDirectory(TestDirectory)
    runner=brstNewTextTestRunner()
    runner.run(suite)
End Sub

'====================
'Begin Class TestResult
'Holds information on the result of a series of executed tests.  These are
'automatically managed TestRunner and TestCase classes so test writers
'should not need to consider them.
Function brstNewTestResult() as object
    new_result=CreateObject("roAssociativeArray")
    new_result.init=brstTrInit
    new_result.init()
    return new_result
End Function

Sub brstTrInit()
    m.failures = []
    m.errors = []
    m.testsRun = 0
    m.shouldStop = False

    'Add Functions
    m.startTest=brstTrStartTest
    m.stopTest=brstTrStopTest
    m.addError=brstTrAddError
    m.addFailure=brstTrAddFailure
    m.addSuccess=brstTrAddSuccess
    m.wasSuccessful=brstTrWasSuccessful
    m.errToSting=trerrToSting
    m.stop = brstTrStop
EndSub

Sub brstTrStartTest(test as object)
    'Called when the given test is about to be run
    m.testsRun = m.testsRun + 1
End Sub

Sub brstTrStopTest(test)
    'Called when the given test has been run
End Sub

Sub brstTrLogToSocket(msg as String)
  if m.socket <> Invalid AND m.socket.isConnected()
    m.socket.sendStr(msg)
  end if
End Sub

Sub brstPrint(msg as String, newLine=true)
  if newLine
    Print msg
    brstTrLogToSocket(msg + " \r\n ")
  else
    Print msg;
    brstTrLogToSocket(msg)
  end if
End Sub

Sub brstTrAddError(test as object, err as object)
    'Called when an error has occurred. 'err' is a tuple of values as
    'returned by sys.exc_info().
    err_inf= CreateObject("roArray",2,false)
    err_inf[0]=test
    err_inf[1]=m.errToSting(err, test)
    m.errors.push(err_inf)
End Sub

Sub brstTrAddFailure(test as object, err as object)
    'Called when an error has occurred. 'err' is a tuple of values as
    'returned by sys.exc_info()
    err_inf= CreateObject("roArray",2,false)
    err_inf[0]=test
    err_inf[1]=m.errToSting(err, test)
    m.failures.push(err_inf)
End Sub

Sub brstTrAddSuccess(test as object)
    'Called when a test has completed successfully"
End Sub

Function brstTrWasSuccessful() as object
    'Tells whether or not this result was a success"
    if m.failures.Count() = 0 and m.errors.Count() = 0 Then
        return true
    else
        return false
    end if
End Function

Sub brstTrStop()
    'Indicates that the tests should be aborted"
    m.shouldStop = True
End Sub

Function trerrToSting( err as object, test as object) as string
    'Converts error representation to a string
    return err
End Function
'End Class TestResult
'====================


'=======================
'Begin Class TestFixture
'A single test to be executed which is utilized by the TestCase class
'for execution and the TestResult class for reporting on the result.
Function brstNewTestFixture(TestFunc as Object, TestName as String, TestDescription as String, TestScriptPath as String) as Object
    new_fix = CreateObject("roAssociativeArray")
    new_fix.TestFunc = TestFunc
    new_fix.FuncName = TestName
    new_fix.Descript = TestDescription
    new_fix.TestScriptPath = TestScriptPath
    return new_fix
End Function
'End Class TestFixture
'=====================


'====================
'Begin Class TestCase
'A class that manages running a single test fixture as well
'as determining it's outcome.  An instance of this class is
'passed to each test fixture method.
Function brstNewTestCase(Fixture as object) as object
    new_case=CreateObject("roAssociativeArray")
    new_case.init = brstTcInit
    new_case.init(Fixture)
    return new_case
End Function

Sub brstTcInit(Fixture as object)

    'Attributes
    m._Fixture = Fixture
    'this will be constructor argument in future version
    m._PropegateErrors = false
    ' m._PropegateErrors = true

    'Assertion methods which determine test failure
    m.fail = brstTcFail
    m.assertFalse = brstTcAssertFalse
    m.assertTrue = brstTcAssertTrue
    m.assertEqual = brstTcAssertEqual
    m.assertNotEqual = brstTcAssertNotEqual
    m.assertInvalid = brstTcAssertInvalid
    m.assertNotInvalid = brstTcAssertNotInvalid

    'Other general purpose methods
    m.endedInFailure = brstTcEndedInFailure
    m.countTestCases = brstTcCountTestCases
    m.shortDescription = brstTcShortDescription
    m.toString = brstTcToString
    m.run = brstTcRun

    'String Casting Functionality
    m.valueToString = brstTcValueToString
    m.assocArrayToString = brstTcAssocArrayToString
    m.integerToString = brstTcIntegerToString
    m.floatToString = brstTcFloatToString
    m.stringToString = brstTcStringToString
    m.booleanToString = brstTcBooleanToString
    m.roListToString = brstTcRoListToString
    m.roArrayToString = brstTcRoArrayToString
    m.roInvalidToString = brstTcRoInvalidToString

    'Type Comparison Functionality
    m.eqValues = brstTcEqValues
    m.eqIntegers = brstTcEqInteger
    m.eqFloats = brstTcEqFloat
    m.eqStrings = brstTcEqString
    m.eqBools = brstTcEqBool
    m.eqLists = brstTcEqList
    m.eqAssocArrays = brstTcEqAssocArray
    m.eqArrays = brstTcEqArray
    m.eqFunction = brstTcEqFunction

End Sub

Function brstTcCountTestCases() as Integer
    'Returns the number of TestCases an instance
    'of this object intends to run.
    'Always 1, as apposed to TestSuite objects
    return 1
End Function

Function brstTcShortDescription() as string
    'Returns a one-line description of the test, or empty string if no
    'description has been provided.
    doc = m._Fixture.Descript
    nl_idx = Instr(1, doc, Chr(10))
    if 0 = nl_idx then
        return doc
    else
        doc_obj = box(doc)
        return doc_obj.Tokenize(chr(10))[0]
    end if
End Function

Function brstTcToString() as string
    'Returns a string representation of the test
    'to be execute
    return m._Fixture.FuncName
End Function

Function brstTcEndedInFailure() as Boolean
   'True if the result of test was a failed assertion
   return m.DoesExist("ErrorMessage")
End Function


Sub brstTcRun(result as object)
    'Execute the test in this instance, and record
    'the outcome in 'result'
    result.startTest(m)
    testMethod = m._Fixture.TestFunc

    if m._PropegateErrors then
        testMethod(m)
        eval_result = &hFC
    else
        eval_result = eval("testMethod(m)")
    end if

    if m.endedInFailure()
       result.addFailure(m,m.ErrorMessage)
    else if eval_result <> &hFC and eval_result <> &hE2 then
       result.addError(m, ErrorMessageFromCode(eval_result))
    else
        result.addSuccess(m)
    end if

    result.stopTest(m)
End Sub

Sub brstTcFail(msg)
    'Fail immediately, with the given message
    m.ErrorMessage=msg
    stop
End Sub

Sub brstTcAssertFalse(expr as boolean)
    'Fail the test if the expression is true.
    if expr then
        m.fail("expression evaluates to true")
    end if
End Sub

Sub brstTcAssertTrue(expr as object)
    'Fail the test unless the expression is true.
    if not expr then
        m.fail("expression evaluates to false")
    End if
End Sub

Sub brstTcAssertEqual(first as object, second as object)
    'Fail if the two objects are unequal as determined by the '<>' operator.
    if not m.eqValues(first, second) then
        first_as_string = m.valueToString(first)
        second_as_string = m.valueToString(second)
        m.fail(first_as_string + " != " + second_as_string)
    end if
End Sub

Sub brstTcAssertNotEqual(first as object, second as object)
    'Fail if the two objects are equal as determined by the '=' operator.
    if m.eqValues(first, second) then
        first_as_string = m.valueToString(first)
        second_as_string = m.valueToString(second)
        m.fail(first_as_string + " == " + second_as_string)
    end if
End Sub

Sub brstTcAssertInvalid(value as dynamic)
    'Fail if the value is not invalid
    if value <> Invalid then
        expr_as_string = m.valueToString(value)
        m.fail(expr_as_string + " <> Invalid")
    end if
End Sub

Sub brstTcAssertNotInvalid(value as dynamic)
    'Fail if the value is invalid
    if value = Invalid then
        expr_as_string = m.valueToString(value)
        m.fail(expr_as_string + " = Invalid")
    end if
End Sub

'String conversion functions used to coerce types so that can
'be outputted upon test failure
Function brstTcValueToString(SrcValue as Object) as String
    'Converts an arbitrary value to a string representation

    'A dispatch table would be better approach here than
    'this switch/case like approach, but one was attempted
    'and needed to be abandonded due to a bug in the only
    'mechinism of doing so.  See the following forum thread
    'for more information on the issue:
    'http://forums.roku.com/viewtopic.php?f=34&t=27338
    value_type = type(SrcValue)
    if value_type = "roInt" then
        return m.integerToString(SrcValue)
    else if value_type = "roFloat" then
        return m.floatToString(SrcValue)
    else if value_type = "roString" then
        return m.stringToString(SrcValue)
    else if value_type = "roBoolean" then
        return m.booleanToString(SrcValue)
    else if value_type = "roList" then
        return m.roListToString(SrcValue)
    else if value_type = "roAssociativeArray" then
        return m.assocArrayToString(SrcValue)
    else if value_type = "roArray" then
        return m.roArrayToString(SrcValue)
    else if value_type = "roInvalid" then
        return m.roInvalidToString(SrcValue)
    else
        return "Unknown type: " + value_type
    end if
End Function

Function brstTcIntegerToString(SrcInt as Object) as String
    'Converts an roInt to a string
    return SrcInt.ToStr()
End Function

Function brstTcFloatToString(SrcFloat as Object) as String
    'Converts an roFloat object to a string
    return Box(Str(SrcFloat.GetFloat())).Trim()
End Function

Function brstTcStringToString(SrcStr as Object) as String
    'Convert an roString object to a string
    return Chr(34) + SrcStr.GetString() + Chr(34)
    'Exists so that any object can be passed to the ValueToString()
    'method, otherwise doesn't serve any real purpose
End Function

Function brstTcBooleanToString(SrcBool as Object) as String
    'Convert roBoolean value to string
    if SrcBool then
        return "True"
    else
        return "False"
    end if
End Function

Function brstTcRoInvalidToString(InvalidObj as Object) as String
    'Convert the roInvalid global into a string
    return "roInvalid"
End Function

Function brstTcRoListToString(SrcList as Object) as String
    'Convert an roList object to a string
    if SrcList.IsEmpty() then
       return "->/"
    end if
    strvalue = ""

    'Not using enum interface as this results in intermintant
    'crashes or the DVP box
    SrcList.ResetIndex()
    i = SrcList.GetIndex()
    while i <> invalid
        strvalue = strvalue + m.ValueToString(i)
        strvalue = strvalue + " -> "
        i = SrcList.GetIndex()
    end while
    strvalue = strvalue + "/"
    return strvalue
End Function

Function brstTcAssocArrayToString(SrcAssocArray as Object) as String
    'Converts an roAssociativeArray to a string representation
    strvalue = "{ "
    first_entry = True
    for each k in SrcAssocArray
        if not first_entry then
            strvalue = strvalue + ", "
        else
            first_entry = False
        end if
        strvalue = strvalue + k
        strvalue = strvalue + " : "
        strvalue = strvalue + m.ValueToString(SrcAssocArray[k])
    end for
    strvalue = strvalue + " }"
    return strvalue
    return "{}"
End Function

Function brstTcRoArrayToString(SrcArray as Object, DisplayTrailingInvalid=False as boolean) as String
    'Convert an roArray to a string representation
    strvalue = "["
    first_entry = True

    'Purposely not using ifEnum interface for the roArray.
    'Bug in Roku firmware causes crash when
    'iterating over array that has an uninitialized
    'element.  See discussion here:
    'http://forums.roku.com/viewtopic.php?f=34&t=25979
    array_length = SrcArray.Count()
    for i = 0 to array_length - 1 step 1
        entry = SrcArray[i]
        if first_entry then
            first_entry = False
        else
            strvalue = strvalue + ","
        end if
        strvalue = strvalue + " " + m.ValueToString(entry)
    end for
    strvalue = strvalue + " ]"
    return strvalue
End Function

Function brstTcEqValues(Value1 as Object, Value2 as Object) as Boolean
    'Compare two arbtrary values to eachother

    'Upcast int to float, if other is float
    if type(Value1) = "roFloat" and type(Value2) = "roInt"
        Value2 = box(Cdbl(Value2))
    else if type(Value2) = "roFloat" and type(Value1) = "roInt"
        Value1 = box(Cdbl(Value1))
    end if

    if type(Value1) <> type(Value2) then
        return False
    else
        'A dispatch table would be better approach here than
        'this switch/case like approach, but one was attempted
        'and needed to be abandonded due to a bug in the only
        'mechinism of doing so.  See the following forum thread
        'for more information on the issue:
        'http://forums.roku.com/viewtopic.php?f=34&t=27338
        valtype = type(Value1)
        if valtype = "roInt" then
            return m.eqIntegers(Value1, Value2)
        else if valtype = "roFloat" then
            return m.eqFloats(Value1, Value2)
        else if valtype = "roString" then
            return m.eqStrings(Value1, Value2)
        else if valtype = "roBoolean" then
            return m.eqBools(Value1, Value2)
        else if valtype = "roList" then
            return m.eqLists(Value1, Value2)
        else if valtype = "roAssociativeArray" then
            return m.eqAssocArrays(Value1, Value2)
        else if valtype = "roArray" then
            return m.eqArrays(Value1, Value2)
        else if valtype = "roFunction" then
            return m.eqFunction(Value1, Value2)
        else
            'todo: This isn't the best approach to
            'handling an unknown type, but will
            'suffice for now
            return False
        end if
    end if
End Function

Function brstTcEqInteger(Value1 as Object, Value2 as Object) as Boolean
    'Compare to integer objects for equality
    return Value1 = Value2
End Function

Function brstTcEqFloat(Value1 as Object, Value2 as Object) as Boolean
    'Compare to float objects for equality
    return Value1 = Value2
End Function

Function brstTcEqString(Value1 as Object, Value2 as Object) as Boolean
    'Compare to string objects for equality
    return Value1 = Value2
End Function

Function brstTcEqBool(Value1 as Object, Value2 as Object) as Boolean
    'Compare to boolean objects for equality
    return Value1 = Value2
End Function

Function brstTcEqList(Value1 as Object, Value2 as Object) as Boolean
    'Compare to roList objects for equality
    l1 = Value1.Count()
    l2 = Value2.Count()
    if l1 <> l2 then
        return False
    else
        for i = 0 to l1 - 1 step 1
            v1 = Value1[i]
            v2 = Value2[i]
            if not m.eqValues(v1, v2) then
                return False
            end if
        end for
        return True
    end if
End Function

Function brstTcEqAssocArray(Value1 as Object, Value2 as Object) as Boolean
    'Compare to roAssociativeArray objects for equality
    len1 = 0
    for each k in Value1
        len1 = len1 + 1
        if not Value2.DoesExist(k) then
            return False
        else
            v1 = Value1[k]
            v2 = Value2[k]
            if not m.eqValues(v1, v2) then
                return False
            end if
        end if
    end for
    len2 = AssocArrayCount(Value2)
    if len1 <> len2 then
        return False
    else
        return True
    end if
End Function

Function brstTcEqArray(Value1 as Object, Value2 as Object) as Boolean
    'Compare to roArray objects for equality
    l1 = Value1.Count()
    l2 = Value2.Count()
    if not l1 = l2 then
        return False
    else
        for i = 0 to l1 - 1 step 1
            v1 = Value1[i]
            v2 = Value2[i]
            if not m.eqValues(v1, v2) then
                return False
            end if
        end for
        return True
    end if
End Function

Function brstTcEqFunction(Value1 as Object, Value2 as Object) as Boolean
    'Compare two function pointers (?) for equality
    return Value1 = Value2
End Function


'End Class TestCase
'==================


'=====================
'Begin Class TestSuite
'A test suite is an aggregation of TestCase objects that is runnable with
'the same semantics.
Function brstNewTestSuite(tests as object) as object
    new_suite=CreateObject("roAssociativeArray")
    new_suite._tests = CreateObject("roArray", 10, true)

    new_suite.countTestCases = brstTsCountTestCases
    new_suite.addTest = brstTsAddTest
    new_suite.addTests = brstTsAddTests
    new_suite.run = brstTsRun
    new_suite.toString = brstTsToString
    new_suite.addTests(tests)

    return new_suite
End Function

Function brstTsToString() as String
    'Return a string representaiton of the test suite
    st_str = "<Test Suite, " + str(m.countTestCases()) +" Test Cases="
    for each test in m._tests
        st_str = st_str + test.toString() + ", "
    end for
    st_str = st_str + ">"
    return st_str
End Function

Function brstTsCountTestCases() as integer
    'Return the number of tests encapsulated
    'by the test suite
    cases = 0
    for each test in m._tests
        cases = cases + test.countTestCases()
    end for
    return cases
End Function

Sub brstTsAddTest(test as object)
    'Add a single test to be in the test suite
    m._tests.push(test)
End Sub

Sub brstTsAddTests(tests as object)
    'Add each item in an enumberable object
    'to the suite
    for each test in tests
        m.addTest(test)
    end for
End Sub

Function brstTsRun(result as object) as object
    'Execute each test in the suite, collecting
    'their outcomes in the supplied result object
    for each test in m._tests
        if result.shouldStop then
            return result
        else
            test.run(result)
        end if
    end for
    return result
End Function
'End Class TestSuite
'===================


'==========================
'Begin Class TextTestResult
'A 'sub-class' of the TestResult class which prints
'the result of each test executed as it is reported
Function brstNewTextTestResult(descriptions as object, verbosity as integer) as object
    new_result=CreateObject("roAssociativeArray")
    new_result.init=brstTrInit
    new_result.init()
    new_result.init=brstTtrInit
    new_result.init(descriptions, verbosity)

    return new_result
End Function

Sub brstTtrInit(show_descriptions as integer, verbosity as integer)
    if verbosity > 1 then
        m.showAll = true
    else
        m.showAll = false
    end if
    if verbosity = 1 then
        m.dots = true
    else
        m.dots = false
    end if

    m.show_descriptions = show_descriptions
    m.separator1 = string(70, "=")
    m.separator2 = string(70, "-")

    'Attach functions
    m.getDescription = brstTtrGetDescription
    m.startTest = brstTtrStartTest
    m.addSuccess = brstTtrAddSuccess
    m.addError = brstTtrAddError
    m.addFailure =brstTtrAddFailure
    m.printErrors = brstTtrPrintErrors
    m.printErrorList = brstTtrPrintErrorList
    m.write = brstTtrWrite
    m.writeline = brstTtrWriteline

End Sub

Function brstTtrGetDescription(test as object) as string
    if not m.show_descriptions  then
        return test.toString()
    else
        desc = test.shortDescription()
        if desc <> "" then
            return desc
        else
            return test.toString()
        end if
    end if
end Function

Sub brstTtrStartTest(test as object)
    m.startTest=brstTrstartTest
    m.startTest(test)
    m.startTest = brstTtrStartTest
    if m.showAll then
        m.write(m.getDescription(test) + " ... ")
    end if
End Sub

Sub brstTtrAddSuccess(test as object)
    m.addSuccess=brstTrAddSuccess
    m.addSuccess(test)
    m.addSuccess=brstTtrAddSuccess
    if m.showAll then
        m.writeline("ok")
    elseif m.dots then
        m.write( ".")
    end if
end sub

Sub brstTtrAddError(test as object, err as object)
    m.addError=brstTrAddError
    m.addError(test, err)
    m.addError=brstTtrAddError
    if m.showAll then
        m.writeline("ERROR")
    else if m.dots then
        m.write("E")
    end if
End Sub

Sub brstTtrAddFailure(test as object, err as object)
    m.addFailure=brstTrAddFailure
    m.addFailure(test,err)
    m.addFailure=brstTtrAddFailure
    if m.showAll then
        m.writeline("FAIL")
    elseif m.dots then
        m.write(  "F")
    end if
end sub

Sub brstTtrPrintErrors()
    if m.dots or m.showAll then
        m.writeline("")
    End If
    m.printErrorList("ERROR", m.errors)
    m.printErrorList("FAIL", m.failures)
End Sub

Sub brstTtrPrintErrorList(flavour as string, errors as object)
    for each err_item in errors
        test=err_item[0]
        err=err_item[1]
        m.writeline(m.separator1)
        m.writeline(test._fixture.testScriptPath)
        m.writeline(flavour + ": " + m.getDescription(test))
        m.writeline(m.separator2)
        m.writeline(err)
      m.writeline("")
    end for
end sub

Sub brstTtrWrite(item as object)
    brstPrint(item, false)
End Sub

Sub brstTtrWriteline(item as object)
    brstPrint(item)
End Sub
'End Class TextTestResult
'========================




'==========================
'Begin Class TextTestResult
'A class which runs tests and reports their results in a
'textual format to the debug console
Function brstNewTextTestRunner() as object
    new_runner = CreateObject("roAssociativeArray")
    new_runner.init = brstTtrnInit
    new_runner.init(1,1)
    return new_runner
End Function

Sub brstTtrnInit(show_descriptions as integer, verbosity as integer)
    m.show_descriptions = show_descriptions
    m.verbosity = verbosity
    m.makeresult = brstTtrnMakeresult
    m.run = brstTtrnRun
End Sub

Function brstTtrnMakeresult() as object
    return brstNewTextTestResult(m.show_descriptions, m.verbosity)
End Function

Function brstTtrnRun(test as object) as object
    'Run a test case or suite and report their
    'result to the debug console

    'todo: Break this up into individual methods
    result = m.makeResult()
    test.run(result)
    result.printErrors()
    brstPrint(result.separator2)
    testsrun = result.testsRun
    brstPrint("Ran" + Str(testsrun) + " tests" + chr(10))
    if not result.wasSuccessful() then
        brstPrint("FAILED (")
        failed=result.failures.Count()
        errored=result.errors.Count()
        if failed <> 0
            brstPrint("failures=" + Stri(failed))
        end if
        if errored <> 0 then
            if failed <> 0
                brstPrint(", ")
            end if
            brstPrint("errors=" + Stri(errored))
            brstPrint(")")
        else
            brstPrint(")")
        end if
    else:
        brstPrint("OK")
    end if
    brstPrint("")
    return result
End Function
'End Class TextTestResult
'========================


'======================
'Begin Class TestLoader
'Locates test fixtures and loads information about them into
'TestCase objects where are ready to run
Function brstNewTestLoader(TestFilePrefix as string, TestMethodPrefix as string) as Object
    ldr=CreateObject("roAssociativeArray")

    ldr.testFilePrefix = TestFilePrefix
    ldr.testMethodPrefix = TestMethodPrefix
    ldr.NewSuite = brstNewTestSuite
    ldr.NewTestCase = brstNewTestCase

    'Method Attachment
    ldr.fixturesFromScriptContents = brstTlFixturesFromScriptContents
    ldr.findTestScripts = brstTlFindTestScripts
    ldr.ListDir = brstTlListDir
    ldr.recursiveListDir = brstlrecursiveListDir
    ldr.fixturesFromScript = brstTlFixturesFromScript
    ldr.readFile = brstTlReadFile
    ldr.fixturesFromDirectory = brstTlFixturesFromDirectory
    ldr.suiteFromDirectory = brstTlSuiteFromDirectory
    ldr.compileScript = brstTlCompileScript
    return ldr
End Function

Function brstTlSuiteFromDirectory(fromdirectory as String) as object
    'Returns a test suite containing all test fixtures found in
    'the specified path
    cases = CreateObject("roList")
    for each fixture in m.fixturesFromDirectory(fromdirectory)
        case = m.NewTestCase(fixture)
        cases.addtail(case)
    end for
    suite = m.NewSuite(cases)
    return suite
End Function

Function brstTlFixturesFromDirectory(fromdirectory as String) as object
    'Returns an enumerable of TestFixture objects from a
    'a directory containing test files
    ret = CreateObject("roList")
    for each file in m.findTestScripts(fromdirectory)
        for each fixture in m.fixturesFromScript(file)
            ret.addtail(fixture)
        end for
    end for
    return ret
End Function

Function brstlRecursiveListDir(directory as string, files as Object) as Object
    paths = m.ListDir(directory)
    for each path in paths
        if path.instr(".") = -1
            m.recursiveListDir(directory + "/" + path, files)
        else
            files.push({
                name: path
                path: directory
            })
        end if
    end for
    return files
End Function

Function brstTlFindTestScripts(fromdirectory as string) as Object
    'Returns an enumerable of paths to scripts that contain
    'test fixtures based upon the naming convention supplied
    'at object creation time
    ret = CreateObject("roList")
    SrcsDir = "pkg:/source"
    if Left(fromdirectory, len(SrcsDir)) = SrcsDir then
        ShouldCompile = False
    else
        ShouldCompile = True
    end if
    for each f in m.recursiveListDir(fromDirectory, [])
        if Left(UCase(f.name),len(m.testFilePrefix)) = UCase(m.testFilePrefix) then
            'Has the desired prefix
            if Right(Ucase(f.name),4) = ".BRS" then
                'Is a bright script file
                full_path = f.path + "/" + f.name
                if ShouldCompile then
                    if m.compileScript(full_path) then
                        ret.AddTail(full_path)
                    else
                        'print full_path + " failed to compile"
                        'Don't bother as run() seems to expect a main() to be
                        'present, doesn't seem a way to add this feature yet,
                        'but will deal with it in time
                    end if
                else
                    ret.AddTail(full_path)
                end if
            end if
        end if
    end for
    return ret
End Function

Function brstTlCompileScript(scriptpath as string) as boolean
    'Compile a script and return True if the compilation
    'was successful
    Run(scriptpath)
    el=GetLastRunCompileError()
    if el=invalid then
        return True
    else
        return false
    end if
End Function

Function brstTlListDir(fromdirectory as string) as object
    'Redirect over builtin ListDir so it can be
    'overriden.  Mainly used for testing
    return ListDir(fromdirectory)
End Function

Function brstTlFixturesFromScript(scriptpath as string) as Object
    'Returns an enumerable of TestFixture objects from the
    'contents of a script file designated
    code = m.readFile(scriptpath)
    return m.fixturesFromScriptContents(code, scriptpath)
End Function

Function brstTlReadFile(fromfile as string) as string
    'Redirect over the builtin ReadAsciiFile so that
    'it can be overriden.  Mainly for testing.
    return ReadAsciiFile(fromfile)
End Function

Function brstTlFixturesFromScriptContents(scriptstr as string, scriptpath as string) as Object
    'Returns an enumerable of TestFixture objects from the contents
    'of a test script file
    'Assumes that the code file has already been compiled and the
    'functions/subs have been loaded into memory
    code = box(scriptstr)
    fixtures = CreateObject("roList")
    for each line in code.Tokenize(chr(10))
        boxedline = box(UCase(line))
        boxedline.Trim()
        fobj = invalid
        if UCase("Function") = boxedline.Left(8) or UCase("Sub") = boxedline.Left(3) then
            func_def = box(line)
            func_def.Trim()
            tokens = func_def.Tokenize(chr(32))
            fname = tokens[1]
            tokens = fname.Tokenize("(")
            fname = tokens[0]
            if UCase(Left(fname, len(m.testMethodPrefix))) = UCase(m.testMethodPrefix) then
                eval("fobj=" + fname)
                fixt = brstNewTestFixture(fobj, fname, "", scriptpath)
                fixtures.AddTail(fixt)
            end if
        end if
    end for
    return fixtures
End Function
'End Class TestLoader
'====================

Function ErrorMessageFromCode(err_code as integer) as string
    'Translate a BrightScript error code as returned by eval() into a meaningful
    'error message
err_map = CreateObject("roAssociativeArray")
err_map.AddReplace("Use of uninitialized variable (ERR_USE_OF_UNINIT_VAR)",&hE9)
err_map.AddReplace("ERR_DIV_ZERO", &h14)
err_map.AddReplace("Type Mismatch (ERR_TM)", &h18)
err_map.AddReplace("ERR_USE_OF_UNINIT_VAR",  &hE9)
err_map.AddReplace("Member function not found in BrightScript Component or interface (ERR_RO2)", &hF4)
err_map.AddReplace("'Dot' Operator attempted with invalid BrightScript Component or interface reference (ERR_RO4)", &hEC)
err_map.AddReplace("ERR_SYNTAX", 2)
err_map.AddReplace("ERR_NORMAL_END (Not an error)",&hFC)
err_map.AddReplace("ERR_VALUE_RETURN (Not an error)", &hE2)
err_map.AddReplace("Wrong number of function parameters.", &hF1)
err_map.AddReplace("Explicit 'STOP' command encountered", &hF7)
err_map.AddReplace("Function Call Operator ( ) attempted on non-function.", &he0)
    for each e in err_map
        if err_map[e] = err_code then
           return e
        end if
    end for
    return "Unknown Error: " + str(err_code)
End Function

'Have posted to the Roku sdk message board regarding the need for this function,
'retaining for the time being to determine if it's necessary
Function AssocArrayCount(aa as object) as Integer
    'Returns the number of entries in an roAssociativeArray
    i = 0
    for each k in aa
        i = i + 1
    end for
    return i
End Function
