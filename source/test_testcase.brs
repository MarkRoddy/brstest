'Unit tests for the test case class


Sub testTestCase_ToString_EqualToMethodName(t as object)
    'To string should return the test method name
    methodname = "testfoobar"
    fixture = brstNewTestFixture("", methodname, "")
    tc = brstNewTestCase(fixture)
    t.assertEqual(methodname, tc.toString())
End Sub

Sub testTestCase_ShortDescription_EmptyIfNoDescSpecified(t as object)
    'Empty string return if no description specified
    fixture = brstNewTestFixture("", "", "")
    tc = brstNewTestCase(fixture)
    t.assertEqual("", tc.shortDescription())
End Sub

Sub testTestCase_ShortDescription_OnlyFirstLineReturned(t as object)
    'Only the first line of the test description should be returned
    expected_desc = "This is the first line of the test description"
    full_desc = expected_desc + chr(10) + "This is the second line"
    full_desc = full_desc     + chr(10) + "This is the third line"
    fixture = brstNewTestFixture("", "", full_desc)
    tc = brstNewTestCase(fixture)
    t.assertEqual(expected_desc, tc.shortDescription())
End Sub

Sub testTestCase_ShortDescription_SingleLineDescHandled(t as object)
    'Single line description should be returned as itself
    expected_desc = "This is the first line of the test description"
    fixture = brstNewTestFixture("", "", expected_desc)
    tc = brstNewTestCase(fixture)
    t.assertEqual(expected_desc, tc.shortDescription())
End Sub

Sub assertEqualMessageForNotEquals(t as object, val1 as object, val2 as object, ExpectedMessage as object)
    fixture = brstNewTestFixture("", "", "")
    tc = brstNewTestCase(fixture)
    tc.ErrorMessage = ""
    tc.fail = function(msg as string) 
        m.ErrorMessage = msg
    end function
    tc.assertEqual(val1, val2)
    if "" = tc.ErrorMessage then
        t.fail("No error message was set")
    else if ExpectedMessage <> tc.ErrorMessage then
        err_msg = "Expected Msg: " + ExpectedMessage + chr(10)
        err_msg = err_msg + "Actual Msg:   " + tc.ErrorMessage
        t.fail(err_msg)
    end if
End Sub

Sub assertEqualMessageForEquals(t as object, val1 as object, val2 as object)
    fixture = brstNewTestFixture("", "", "")
    tc = brstNewTestCase(fixture)
    tc.ErrorMessage = ""
    tc.fail = function(msg as string) 
        m.ErrorMessage = msg
    end function
    tc.assertEqual(val1, val2)
    if "" <>  tc.ErrorMessage then
        t.fail("Unexpected Error message: " + tc.ErrorMessage)
    end if
End Sub

Sub assertNotEqualMessageForEquals(t as object, val1 as object, val2 as object, ExpectedMessage as string)
    fixture = brstNewTestFixture("", "", "")
    tc = brstNewTestCase(fixture)
    tc.ErrorMessage = ""
    tc.fail = function(msg as string) 
        m.ErrorMessage = msg
    end function
    tc.assertNotEqual(val1, val2)
    if "" = tc.ErrorMessage then
        t.fail("No error message was set")
    else if ExpectedMessage <> tc.ErrorMessage then
        err_msg = "Expected Msg: " + ExpectedMessage + chr(10)
        err_msg = err_msg + "Actual Msg:   " + tc.ErrorMessage
        t.fail(err_msg)
    end if
End Sub

Sub assertNotEqualNoMessageForNotEquals(t as object, val1 as object, val2 as object)
    fixture = brstNewTestFixture("", "", "")
    tc = brstNewTestCase(fixture)
    tc.ErrorMessage = ""
    tc.fail = function(msg as string) 
        m.ErrorMessage = msg
    end function
    tc.assertNotEqual(val1, val2)
    if "" <>  tc.ErrorMessage then
        t.fail("Unexpected Error message: " + tc.ErrorMessage)
    end if
End Sub

Sub testTestCase_assertEqual_TwoStrings_NotEqual(t as object)
    'Error message for two unequal strings yields expected message
    s1 = "This is the first string"
    s2 = "This is the second string"
    expected_msg = Chr(34) + s1 + Chr(34) + " != " + Chr(34) + s2 + Chr(34)
    assertEqualMessageForNotEquals(t, s1, s2, expected_msg)
End Sub

Sub testTestCase_assertEqual_TwoStrings_AreEqual(t as object)
    'No error message for two equal strings
    s1 = "This is the first string"
    s2 = "This is the first string"
    assertEqualMessageForEquals(t, s1, s2)
End Sub

Sub testTestCase_assertNotEqual_TwoStrings_AreEqual(t as object)
    'Equal string values produces expected error message
    s1 = "This is the first string"
    s2 = "This is the first string"
    expected_msg = Chr(34) + s1 + Chr(34) + " == " + Chr(34) + s2 + Chr(34)
    assertNotEqualMessageForEquals(t, s1, s2, expected_msg)
End Sub

Sub testTestCase_assertNotEqual_TwoStrings_NotEqual(t as object)
    'No error message for two different strings
    s1 = "This is the first string"
    s2 = "This is the second string"
    assertNotEqualNoMessageForNotEquals(t, s1, s2)
End Sub

Sub testTestCase_assertEqual_TwoFloats_NotEqual(t as object)
    'Unequal float values produce expected error message
    f1 = 3.14
    f2 = 3.15
    expected_msg = Str(f1) + " != " + Str(f2)
    assertEqualMessageForNotEquals(t, f1, f2, expected_msg)
End Sub

Sub testTestCase_assertEqual_TwoFloats_AreEqual(t as object)
    'No error message for two equal floats
    f1 = 3.14
    f2 = 3.14
    assertEqualMessageForEquals(t, f1, f2)
End Sub

Sub testTestCase_assertNotEqual_TwoFloats_AreEqual(t as object)
    'Equal float values produces expected error message
    f1 = 3.14
    f2 = 3.14
    expected_msg = Str(f1) + " == " + Str(f2)
    assertNotEqualMessageForEquals(t, f1, f2, expected_msg)
End Sub

Sub testTestCase_assertNotEqual_TwoFloats_NotEqual(t as object)
    'No error message for two different floats
    f1 = 3.14
    f2 = 3.15
    assertNotEqualNoMessageForNotEquals(t, f1, f2)
End Sub

Sub testTestCase_assertEqual_TwoInts_NotEqual(t as object)
    'Unequal integer values produce expected error message
    i1 = 3
    i2 = 4
    expected_msg = Stri(i1) + " != " + Stri(i2)
    assertEqualMessageForNotEquals(t, i1, i2, expected_msg)
End Sub

Sub testTestCase_assertEqual_TwoInts_AreEqual(t as object)
    'No error message for two equal integer values
    i1 = 3
    i2 = 3
    assertEqualMessageForEquals(t, i1, i2)
End Sub

Sub testTestCase_assertNotEqual_TwoInts_AreEqual(t as object)
    'Equal integer values produces expected error message
    i1 = 3
    i2 = 3
    expected_msg = Str(i1) + " == " + Str(i2)
    assertNotEqualMessageForEquals(t, i1, i2, expected_msg)
End Sub

Sub testTestCase_assertNotEqual_TwoInts_NotEqual(t as object)
    'No error message for two different integers
    i1 = 3
    i2 = 4
    assertNotEqualNoMessageForNotEquals(t, i1, i2)
End Sub

Sub testTestCase_assertEqual_StrAndFloat(t as object)
    'String and Float values yield expected error message
    v1 = "Foo Bar"
    v2 = 3.14
    expected_msg = Chr(34) + v1 + Chr(34) + " != " + Str(v2)
    assertEqualMessageForNotEquals(t, v1, v2, expected_msg)
End Sub

Sub testTestCase_assertEqual_FloatAndStr(t as object)
    'Float and string values yield expected error message
    v1 = 3.14
    v2 = "Foo Bar"
    expected_msg = Str(v1) + " != " + Chr(34) + v2 + Chr(34) 
    assertEqualMessageForNotEquals(t, v1, v2, expected_msg)
End Sub

Sub testTestCase_assertEqual_FloatAndInt(t as object)
    'Equivalent float and int values should successfully compare
    f = 3.0
    i = 3
    assertEqualMessageForEquals(t, f, i)
End Sub

Sub testTestCase_assertEqual_IntAndFloat(t as object)
    'Equivalent int and float values should successfully compare
    f = 3.0
    i = 3
    assertEqualMessageForEquals(t, i, f)
End Sub
    

Sub testTestCase_assertNotEqual_StrAndFloat(t as object)
    'No error message for string and float value
    'assertNotEqual() should handle two different types
    v1 = "foo bar"
    v2 = 3.14
    assertNotEqualNoMessageForNotEquals(t, v1, v2)
End Sub

Sub testTestCase_assertNotEqual_FloatAndInt(t as object)
    'Equivalent float and int values should cause error
    f = 3.0
    i = 3
    expected_msg = Str(f) + " == " + Str(i)
    assertNotEqualMessageForEquals(t, f, i, expected_msg)
End Sub

Sub testTestCase_assertNotEqual_IntAndFloat(t as object)
    'Equivalent int and float values should cause error
    f = 3.0
    i = 3
    expected_msg = Str(i) + " == " + Str(f)
    assertNotEqualMessageForEquals(t, i, f, expected_msg)
End Sub

Sub testTestCase_ValueTostring_Integer(t as object)
    'Can convert an integer using the ValueToString method
    i = 4
    expected = "4"
    actual = t.ValueToString(i)
    t.assertEqual(expected, actual)
End Sub

Sub testTestCase_ValueTostring_Integer_Negative(t as object)
    'Can convert a negative integer using the ValueToString method
    i = -4
    expected = "-4"
    actual = t.ValueToString(i)
    t.assertEqual(expected, actual)
End Sub

Sub testTestCase_ValueTostring_Float(t as Object)
    'Can convert a float value using ValueToString method
    f = 4.3
    expected = "4.3"
    actual = t.ValueToString(f)
    t.assertEqual(expected, actual)
End Sub

Sub testTestCase_ValueTostring_Float_Negative(t as Object)
    'Can convert a negative float value using ValueToString method
    f = -4.3
    expected = "-4.3"
    actual = t.ValueToString(f)
    t.assertEqual(expected, actual)
End Sub

Sub testTestCase_ValueTostring_String(t as object)
    'Can pass a string to the ValueToString method
    s = "Foo Bar"
    expected = "Foo Bar"
    actual = t.ValueToString(s)
    t.assertEqual(expected, actual)
End Sub

Sub testTestCase_ValueTostring_Bool_True(t as object)
    'Convert a True value w/the ValueToString method
    b = True
    expected = "True"
    actual = t.ValueToString(b)
    t.assertEqual(expected, actual)
End Sub

Sub testTestCase_ValueTostring_Bool_False(t as object)
    'Convert a False value w/the ValueToString method
    b = False
    expected = "False"
    actual = t.ValueToString(b)
    t.assertEqual(expected, actual)
End Sub

Sub testTestCase_ValueTostring_roInvalid(t as Object)
    'Convert the roInvalid constant to a string
    invalid_val = CreateObject("roInvalid")
    expected = "roInvalid"
    actual = t.ValueToString(invalid_val)
    t.assertEqual(expected, actual)
End Sub

Sub testTestCase_ValueTostring_roList_Empty(t as Object)
    'Convert an empty roList to a string w/the ValueToString method
    l = CreateObject("roList")
    expected = "->/"
    actual = t.ValueToString(l)
    t.assertEqual(expected, actual)
End Sub

Sub testTestCase_ValueTostring_roList_Ints(t as Object)
    'Convert roList of ints w/the ValueToString method
    l = CreateObject("roList")
    l.AddTail(1)
    l.AddTail(2)
    l.AddTail(3)
    expected = "1 -> 2 -> 3 -> /"
    actual = t.ValueToString(l)
    t.assertEqual(expected, actual)
End Sub

Sub testTestCase_ValueTostring_roAssociativeArray_Empty(t as object)
    'Appropriate converstion of an empty associative array
    aa = {}
    expected = "{  }"
    actual = t.ValueToString(aa)
    t.assertEqual(expected, actual)
End Sub

Sub testTestCase_ValueTostring_roAssociativeArray_HandlesInts(t as object)
    'Int values in an associative array are converted
    aa = {Foo:1, Bar:2}
    expected = "{ bar : 2, foo : 1 }"
    actual = t.ValueToString(aa)
    t.assertEqual(expected, actual)
End Sub

' Sub testTestCase_ValueTostring_roArray_Empty(t as object) 
'     'Proper conversion of an empty roArray object
'     array = []
'     expected = "[ ]"
'     actual = t.ValueToString(array)
'     t.assertEqual(expected, actual)
' End Sub

' Sub testTestCase_ValueTostring_roArray_Ints(t as object)
'     'Conversion of roArray with int entries
'     array = [1,2,3]
'     expected = "[ 1, 2, 3 ]"
'     actual = t.ValueToString(array)
'     t.assertEqual(expected, actual)
' End Sub

' Sub testTestCase_ValueTostring_roArray_NestedArrays(t as object)
'     'Convert an array which has another array as one of its elements
'     array = [1,[2,3],4]
'     expected = "[ 1, [ 2, 4], 3 ]"
'     actual = t.ValueToString(array)
'     t.assertEqual(expected, actual)
' End Sub

